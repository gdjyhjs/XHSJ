--[[--
-- 黑名单
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 21:01:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local socialTools = require("models.social.socialTools")
local NormalTipsView = require("common.normalTipsView")


local Blacklist=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "blacklist.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function Blacklist:on_asset_load(key,asset)
	self.item_obj:get_black_list_c2s() --获取好友列表
	self.init = true
end

function Blacklist:set_friend_list()
	local list = self.item_obj.BlackList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("Blacklist",item,root)):GetComponent("ReferGameObjects")
		ref.name = "friendObj_"..v.roleId
		ref:Get("on_line_text").text = v.logoutTm==0 and "当前在线" or ("<color=#585858FF>"..socialTools.get_out_line_item_str(v.logoutTm).."</color>")
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("level_text").text = v.level
		ref:Get("deleteBlackBtn").name = "deleteBlackBtn_"..v.roleId.."_"..v.name
		print("VIP等级",v.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
	end
	--设置其他
	self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("Blacklist",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(#list==0)
end

--处理删除黑名单之后的对象隐藏
function Blacklist:solve_delete_black(roleId)
	local obj = LuaHelper.FindChild(self.refer:Get("itemRoot"),"friendObj_"..roleId)
	if obj then
		self.base_friend:repay_item("Blacklist",obj)
		local friend_count_text = self.refer:Get("friend_count_text")
		friend_count_text.text = (string.split(friend_count_text.text,"/")[1]-1).."/99"
	end
end

function Blacklist:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"deleteBlackBtn_") and arg then --删除黑名单
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cip = string.split(cmd,"_")
		local roleId = tonumber(cip[2])
		local f = function()
			self.item_obj:relieve_black_list_c2s(roleId)
			self:solve_delete_black(roleId)
		end

		local content = string.format("确定将<color=%s>%s</color>移出黑名单？",gf_get_color(ClientEnum.SET_GM_COLOR.NAME_OWN),cip[3])
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,f)

	elseif cmd=="blackListTipsBtn" then --tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:my_friend_tips()
	end
end

function Blacklist:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetBlackListR"))then
			print("服务器返回：取到黑名单")
			self:set_friend_list()
		end
	end
end

--显示我的好友 ？ tips
function Blacklist:my_friend_tips()
	gf_show_doubt(1013)

-- 	local list = {
-- 		"1. 黑名单内的玩家在所有频道的聊天信息均会自动进行屏蔽。",
-- "2. 黑名单内的玩家对你发起的私聊等信息将会自动屏蔽。",
-- 	}

-- 	NormalTipsView(self.item_obj, list)
end

function Blacklist:register()
    StateManager:register_view( self )
end

function Blacklist:cancel_register()
	StateManager:remove_register_view( self )
end

function Blacklist:on_showed()
	self:register()
    if self.init then
		self.item_obj:get_black_list_c2s() --获取好友列表
	end
end

function Blacklist:on_hided()
	self:cancel_register()
end

return Blacklist

