--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-25 21:19:40
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TowerSweepWarehouse=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "copy_warehouse.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TowerSweepWarehouse:on_asset_load(key,asset)
	self:init_ui()
end

function TowerSweepWarehouse:init_ui()
	self.scroll_page = self.refer:Get("scroll_page")
	self.scroll_page.onItemRender = handler(self, self.on_item_render)

	gf_print_table(self.item_obj:get_tower_sweep_storehouse(),"get_tower_sweep_storehouse")
	self.scroll_page.data = self.item_obj:get_tower_sweep_storehouse()
	self.scroll_page:RefreshPage(1,true)
end

function TowerSweepWarehouse:on_item_render( item, cur_index, page, data )
	print("index =",cur_index,data)
	if data then
		item:Get("icon"):SetActive(true)
		item:Get("count"):SetActive(true)

		if not item.UserData then
			local refer = LuaHelper.GetComponent(item.gameObject,"Hugula.ReferGameObjects") 
			item.UserData = {
				icon_img = refer:Get("icon"),
				bg_img = refer:Get("bg"),
				count = refer:Get("count"),
			}
		end

		gf_set_item(data.code, item.UserData.icon_img, item.UserData.bg_img)
		item.UserData.count.text = data.num
	else
		item:Get("icon"):SetActive(false)
		item:Get("count"):SetActive(false)
	end
end

function TowerSweepWarehouse:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "GetTowerSweepRewardR") then
			if msg.err == 0 then
				self:dispose()
			end
		end
	end
end

function TowerSweepWarehouse:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "feed_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "btn_b_heBing" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_tower_sweep_reward_c2s()
	end
end

function TowerSweepWarehouse:register()
	StateManager:register_view(self)
end

function TowerSweepWarehouse:cancel_register()
	StateManager:remove_register_view(self)
end

function TowerSweepWarehouse:on_showed()
	self:register()
end

function TowerSweepWarehouse:on_hided()
	self:cancel_register()
end

-- 释放资源
function TowerSweepWarehouse:dispose()
    self._base.dispose(self)
end

return TowerSweepWarehouse

