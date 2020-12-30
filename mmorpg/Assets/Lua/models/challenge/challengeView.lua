--[[
	过关斩将系统主界面
	create at 17.7.17
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "challenge.u3d",
}


local commom_string = 
{
}


local challengeView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)


--资源加载完成
function challengeView:on_asset_load(key,asset)
	self.item_obj:register_event("challenge_view_on_click", handler(self, self.on_click))
end

--鼠标单击事件
function challengeView:on_click(item_obj, obj, arg)

end

function challengeView:clear()
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function challengeView:dispose()
	self:clear()
    self._base.dispose(self)
end

function challengeView:on_showed()
end

function challengeView:on_hided()
end


function challengeView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetHolyCopyInfoR") then
		end
	end
end

return challengeView


