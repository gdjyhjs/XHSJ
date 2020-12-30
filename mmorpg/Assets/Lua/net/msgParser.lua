--[[--
* 网络数据格式处理
* 
* @Author:      Seven
* @DateTime:    2017-03-09 21:20:16
]]


--客户端协议
local sproto = require "sproto.core"
local packId = require "sproto.export.package_id"

local tbl = {}
local idMap = {}	--id与协议的影射表
local regFunc = {}	--注册协议函数
local protoMap = {}	--newproto 生成的对象与id的map
local printProt = {} --需要显示的协议
local function myRequire( fileName )
	--注册自动生成的lua脚本,邦定pb名与id
	local pbId = require("sproto.export."..fileName.."_id")
	local fid = packId[fileName]
	assert(idMap[fid] == nil)
	assert(idMap[fileName] == nil)
	idMap[fid] = pbId
	idMap[fileName] = pbId
	--注册 协议 文件
	local sp = require("sproto."..fileName)
	local sObj = sproto.newproto(sp)

	assert(sObj, string.format("perse file error:%s",fileName))
	protoMap[fileName] = sObj
	protoMap[fid] = sObj
end

--include 所有协议文件	[一级消息id]
for k, v in pairs(packId) do
	if type(k) == "string" then
		myRequire(k)
	end
end


local ID_SIZE = 256

function tbl.getId(package, message)
	local id1 = packId[package]
	local pb = idMap[id1]
	local id2 = pb[message]
	return id1, id2
end

function tbl.getId1( package )
	return packId[package]
end

function tbl.registFunc(id1, id2, func)
	if type(id1) == "string" then
		id1, id2 = tbl.getId(id1, id2)
	end
	local id = id1 * ID_SIZE + id2
	regFunc[id] = func
end

function tbl.registFuncTbl(id1, funcTbl)
	if type(id1) == "string" then
		id1 = packId[id1]
	end
	local pbId = idMap[id1]
	assert(pbId)
	for k, v in pairs(funcTbl) do
		if type(v) == "function" then
			local id2 = pbId[k]
			tbl.registFunc(id1, id2, v)
		end
	end
end

function tbl.getFunc(id1, id2)
	local id = id1 * ID_SIZE + id2
	return regFunc[id]
end

--打包成可以发到socket的流
function tbl.pack(msg, id1, id2, sid)
	assert(msg, "发送协议体为nil,请检查！id1 = ", id1, " id2 = ", id2)
	local pbName
	if type(id1) == "string" then
		pbName = id2
		id1, id2 = tbl.getId(id1, id2)
	else
		pbName = idMap[id1][id2]
	end
	local sObj = protoMap[id1]
	local st = sproto.querytype(sObj, pbName)
	local strBuf = sproto.pack(sproto.encode(st, msg))
	local size = 3 + #strBuf
	--local buf = string.pack(">I2>I1>I1>I1", size, id1, id2, sid or 0)..strBuf
	local sz1 = math.floor(size / 256)
	local sz2 = size % 256
	local buf = string.char(sz1, sz2, id1, id2, sid or 1)..strBuf

	if printProt[id1] ~= nil then
		print("send message:", packId[id1], idMap[id1][id2])
		gf_print_table(msg)
	end

	return buf, size
end

local unpack = string.unpack
function tbl.unpack( msgBuf, sz )
	--1字节一级id,1字节二级id,剩下的为pb数据流
	--local id1, id2, sid pbBuf = unpack(">I1>I1>I1c"..(sz-3), msgBuf)
	local id1, id2, sid = msgBuf:ReadByte(),msgBuf:ReadByte(),msgBuf:ReadByte()
	-- print("收到协议:",id1,id2,sid)
	local pbBuf = msgBuf:ReadBffer(msgBuf.Length - 3)
	local sObj = protoMap[id1]
	local pbName = idMap[id1][id2]
	assert(sObj and pbName, string.format("unknow protocol:%d, %d", id1, id2))
	local st = sproto.querytype(sObj, pbName)
	local msg = sproto.decode(st, sproto.unpack(pbBuf))

	--打印消息方便调试
	if printProt[id1] ~= nil then
		print("recv message:", packId[id1], idMap[id1][id2])
		gf_print_table(msg)
	end

	return msg, id1, id2, sid
end

function tbl.dispatch(msgBuf, sz )
	local msg, id1, id2, sid = tbl.unpack( msgBuf, sz )
	local func = tbl.getFunc(id1, id2)
	if func then
		func(msg)
	else
		print(string.format("dispatch invalid protocol: %d,%d : ", id1, id2)..packId[id1]..","..idMap[id1][id2])
	end
end

--如果设置了，只显示设置的协议, 默认全部显示
function tbl.printProt(id1)

	if type(id1) == "string" then
		id1 = packId[id1]
	end
	printProt[id1] = 1
	-- print(type(id1), id1)
end

return tbl
