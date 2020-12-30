--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-25 14:13:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local max_floor = gf_get_config_table("t_misc").copy.tower_copy_top_floor 

local effect_pos1,effect_pos2 = -17.22464,-172.32


local commom_string =
{
	[1] = gf_localize_string("第%d层"),
	[2] = gf_localize_string("已通关"),
	[3] = gf_localize_string("通关%d层可获得以下奖励："),
	[4] = gf_localize_string("你已登顶"),
}

local TowerView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "tower.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TowerView:on_asset_load(key,asset)
	self:init_ui()
	
end

function TowerView:init_ui()
	local cur_floor = gf_getItemObject("copy"):get_tower_floor()
	self:init_tower_view(cur_floor)
	self:init_reward(cur_floor)
end

function TowerView:init_reward(cur_floor)
	local copy_id = gf_getItemObject("copy"):get_tower_copy_id()
	--推荐战斗力
	self.refer:Get(5).text = gf_get_config_table("copy")[copy_id] and gf_get_config_table("copy")[copy_id].recommend_power or gf_get_config_table("copy")[copy_id - 1].recommend_power
	--当前战斗力
	self.refer:Get(6).text = gf_getItemObject("game"):getPower()

	--当前层数
	self.refer:Get(7).text = cur_floor > max_floor and max_floor or cur_floor

	cur_floor = cur_floor > max_floor and max_floor or cur_floor

	self.refer:Get(8).text = string.format(commom_string[3],cur_floor)
	
	local reward =  gf_get_config_table("copy_tower")[copy_id] and gf_get_config_table("copy_tower")[copy_id].reward_item or gf_get_config_table("copy_tower")[copy_id - 1].reward_item

	local pnode = self.refer:Get(17)

	for i=1,8 do
		local item = pnode.transform:FindChild("reward"..i)
		item.gameObject:SetActive(false)
		if reward[i] then
			item.gameObject:SetActive(true)

			local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
			local bg = item:GetComponent(UnityEngine_UI_Image)

			gf_set_item(reward[i][1], icon, bg)

			local count = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
			count.text = reward[i][2]
		end
	end

end

function TowerView:init_tower_view(floor)
	self.refer:Get(9):SetActive(false)				--bottom
	self.refer:Get(10):SetActive(true)				--1
	self.refer:Get(11):SetActive(true)				--2
	self.refer:Get(12):SetActive(true)				--3
	self.refer:Get(13):SetActive(true)				--4
	self.refer:Get(14):SetActive(false)				--top

	local cur_floor_item,next_floor_item,last_floor_item,last_floor_item2

	self.refer:Get(16).transform.localPosition = Vector3(13.10643,effect_pos1,0)
	--最底层
	if floor == 1 then
		self.refer:Get(9):SetActive(true)
		cur_floor_item 	= self.refer:Get(11)
		next_floor_item = self.refer:Get(12)
	end
	--正常层
	if floor > 1 and floor < max_floor - 1 then
		next_floor_item = self.refer:Get(12)
		cur_floor_item 	= self.refer:Get(11)
		last_floor_item = self.refer:Get(10)
	end 
	--最高层 
	if floor >= max_floor - 1 then
		self.refer:Get(11):SetActive(false)				--2
		self.refer:Get(12):SetActive(false)				--3
		self.refer:Get(13):SetActive(false)				--4
		self.refer:Get(14):SetActive(true)	
		cur_floor_item 	= self.refer:Get(14)
		last_floor_item = self.refer:Get(10)
	end

	--倒数第二层
	if floor == max_floor - 1 then
		last_floor_item = nil
		next_floor_item = self.refer:Get(14)
		cur_floor_item 	= self.refer:Get(10)
		self.refer:Get(16).transform.localPosition = Vector3(13.10643,effect_pos2,0)
	end

	--已经通关
	if floor > max_floor then

		cur_floor_item 	= nil
		last_floor_item = self.refer:Get(14)
		last_floor_item2 = self.refer:Get(10)
		--当前层特效
		-- self.refer:Get(16):SetActive(true)

		self.refer:Get(15):SetActive(true)
	end

	if last_floor_item then
		last_floor_item.transform:FindChild("floors"):GetComponent("UnityEngine.UI.Text").text = string.format(commom_string[1],floor - 1)
		-- last_floor_item.transform:FindChild("pass"):GetComponent("UnityEngine.UI.Text").text = commom_string[2]
	end
	if cur_floor_item then
		cur_floor_item.transform:FindChild("floors"):GetComponent("UnityEngine.UI.Text").text = string.format(commom_string[1],floor )
	end
	if next_floor_item then
		next_floor_item.transform:FindChild("floors"):GetComponent("UnityEngine.UI.Text").text = string.format(commom_string[1],floor + 1)
	end
	if last_floor_item2 then
		last_floor_item2.transform:FindChild("floors"):GetComponent("UnityEngine.UI.Text").text = string.format(commom_string[1],floor - 2)
		-- last_floor_item2.transform:FindChild("pass"):GetComponent("UnityEngine.UI.Text").text = commom_string[2]
	end
end


-- 进入副本
function TowerView:enter_tower(data)
	Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
	local floor = gf_getItemObject("copy"):get_tower_floor()
	if floor > max_floor then
		gf_message_tips(commom_string[4])
		return
	end
	local copy_id = gf_getItemObject("copy"):get_tower_copy_id()
	self.item_obj:enter_copy_c2s(copy_id)
		
end

function TowerView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "GetTowerInfoR") then -- 获取爬塔副本信息
				
		end
	end
end

function TowerView:item_click(cmd)
	local index = string.gsub(cmd,"reward","")
	index = tonumber(index)

	local copy_id = gf_getItemObject("copy"):get_tower_copy_id()
	local reward = gf_get_config_table("copy_tower")[copy_id] and gf_get_config_table("copy_tower")[copy_id].reward_item or gf_get_config_table("copy_tower")[copy_id - 1].reward_item

	local item_id = reward[index][1]

	gf_getItemObject("itemSys"):common_show_item_info(item_id)
end

function TowerView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "enter_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:enter_tower()

	elseif string.find(cmd,"reward") then
		self:item_click(cmd)

	end
end

function TowerView:register()
	StateManager:register_view(self)
end

function TowerView:cancel_register()
	StateManager:remove_register_view(self)
end

function TowerView:on_showed()
	self:register()
end

function TowerView:on_hided()
	self:cancel_register()
end

-- 释放资源
function TowerView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return TowerView

