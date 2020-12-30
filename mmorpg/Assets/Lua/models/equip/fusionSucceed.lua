--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-14 19:49:02
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FusionSucceed=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "fusion_succeed.u3d", item_obj) -- 资源名字全部是小写
    self.equip = nil
end)

function FusionSucceed:set_equip(equip)
	self.equip = equip
	if self.init then
		self:set_content()
	end
end

-- 资源加载完成
function FusionSucceed:on_asset_load(key,asset)
	--ui初始化
	self:set_content()
	self.init = true
end

--初始化内容
function FusionSucceed:set_content()
	if not self.equip then
		return
	end
	self.protoId = self.equip.protoId
	local data = ConfigMgr:get_config("item")[self.protoId]
	if data then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local bg = self.refer:Get("bg")
		bg.name = "equip_tips"
		gf_set_equip_icon(self.equip,self.refer:Get("icon"),bg)

		self.refer:Get("binding"):SetActive(itemSys:calculate_item_is_bind(self.protoId))
		self.refer:Get("count").text = ""
		self.refer:Get("name").text = itemSys:get_equip_prefix_name(self.equip.prefix)..data.name
		self.refer:Get("fusion_succeed"):SetActive(false)
		self.refer:Get("formula_succeed"):SetActive(true)

		local bag = LuaItemManager:get_item_obejct("bag")
		local my_equip = bag:get_bag_item()[ServerEnum.BAG_TYPE.EQUIP*10000+data.sub_type]
		my_equip = my_equip and my_equip.num>0 and self.equip.guid~=my_equip.guid and my_equip or nil
		local is_use = my_equip==nil
		if not is_use then
			local my_base_power = self.item_obj:calculate_equip_fighting_capacity(my_equip)
			local equip_power = self.item_obj:calculate_equip_fighting_capacity(self.equip)
			is_use = equip_power>my_base_power
		end

		self.refer:Get("sure_btn"):SetActive(not is_use)
		self.refer:Get("equip_btn"):SetActive(is_use)
		self.refer:Get("cancle_btn"):SetActive(is_use)
		self.refer:Get("up"):SetActive(is_use)
	end
end

--鼠标点击按钮
function FusionSucceed:on_click(obj,arg)
	if(obj.name=="sureBtn")then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
		--关闭弹框
		self:hide()
	elseif(obj.name=="useBtn")then -- 穿戴
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        local bag = LuaItemManager:get_item_obejct("bag")
        bag:swap_item_c2s(self.equip.slot,ConfigMgr:get_config("item")[self.equip.protoId].sub_type+20000)
		self:hide()        
	elseif(obj.name=="equip_tips")then -- tips
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        local itemSys = LuaItemManager:get_item_obejct("itemSys")
        itemSys:equip_browse(self.equip)
	end
end


-- 释放资源
function FusionSucceed:dispose()
    self:cancel_register()
    self._base.dispose(self)
end

function FusionSucceed:show_tips(guid)
	self.item = LuaItemManager:get_item_obejct("bag"):get_item_for_guid(guid)
	if self.item then
		self.guid = guid
		self.data = ConfigMgr:get_config( "item" )[self.item.protoId]
		self:show()
		print("快速使用物品")
		gf_print_table(self.item)
	else
		print("没有找到快速使用的物品？")
	end
end
function FusionSucceed:register()
	StateManager:register_view( self )
end

function FusionSucceed:cancel_register()
	StateManager:remove_register_view( self )
end

function FusionSucceed:on_showed()
	self:register()
end

function FusionSucceed:on_hided()
    self:dispose()
end

-- 释放资源
function FusionSucceed:dispose()
    self._base.dispose(self)
 end

return FusionSucceed