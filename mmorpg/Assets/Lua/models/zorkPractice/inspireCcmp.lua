--[[--
--
-- @Author:Seven
-- @DateTime:2017-12-13 14:55:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local InspireCcmp=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "zork_practice_inspire.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function InspireCcmp:on_asset_load(key,asset)
	self.init = true
	self:init_ui()
end

function InspireCcmp:init_ui()
	print("初始化鼓舞弹框")
	gf_mask_show(false)
	self:set_inspire()
end

-- 设置鼓舞数值
function InspireCcmp:set_inspire()
	print("设置鼓舞弹框数值")
	if self.init then
		local buff = LuaItemManager:get_item_obejct("buff")
		local buffId = buff:get_buff_id(21) -- 鼓舞buff
		local buffValue = buff:get_buff_value(buffId) or 0
		if buffValue==10000 then
			self:dispose()
		else
			self.refer:Get("effect").text = string.format("当前鼓舞效果：%d%%",buffValue/100)
		end
	end
end

function InspireCcmp:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeInspire" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "sureBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("鼓舞一下")
		LuaItemManager:get_item_obejct("zorkPractice"):deathtrap_inspire_c2s()
	end
end

function InspireCcmp:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("scene"))then
		if(id2== Net:get_id2("scene", "BuffUpdateR"))then -- 返回协议：buff
			self:set_inspire()
		end
	end
end

function InspireCcmp:on_showed()
    StateManager:register_view( self )
    if self.init then
		self:init_ui()
    end
end

function InspireCcmp:on_hided()
	self:dispose()
end

-- 释放资源
function InspireCcmp:dispose()
	StateManager:remove_register_view( self )
	self.init = nil
    self._base.dispose(self)
 end

return InspireCcmp

