--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local buildHurtView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mozu")
    UIBase._ctor(self, "blood_line_build.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function buildHurtView:on_asset_load(key,asset)
	self.hp1 = self.refer:Get(1)
	self.name = self.refer:Get(2)
	self.hp = self.refer:Get(3)
	self.value = self.refer:Get(4)
	self.value.text = "100%"
	self.name.text = gf_localize_string("城池建筑")
	self.bg = self.refer.transform:FindChild("bg")
	--local p = self.bg.transform.localPosition
	--self.bg.transform.localPosition = Vector3(p.x,p.y - 100,p.z)
	self.hp.gameObject:SetActive(false)
	self.total_hurt = ConfigMgr:get_config("t_misc").protect_city.building_target_damage
	local hurt = LuaItemManager:get_item_obejct("mozu").build_hurt
	local percent = math.max(self.total_hurt - hurt,0) / self.total_hurt
	self.hp1.fillAmount = percent
end

function buildHurtView:init_ui()
end

function buildHurtView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "BuildingHurtR") then
			self.hp1.fillAmount = math.max(self.total_hurt - msg.hurt , 0 )/self.total_hurt
		    self.value.text =math.floor(self.hp1.fillAmount*100).."%"
		end
	end
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) ~= true then
		--	self:dispose()
		end
	end
end

function buildHurtView:on_click( obj, arg )
end

function buildHurtView:register()
	StateManager:register_view( self )
end

function buildHurtView:cancel_register()
	StateManager:remove_register_view( self )
end

function buildHurtView:on_showed()
	self:register()
end

function buildHurtView:on_hided()
end

-- 释放资源
function buildHurtView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return buildHurtView

