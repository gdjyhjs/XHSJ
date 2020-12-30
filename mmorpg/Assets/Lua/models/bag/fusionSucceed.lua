--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-14 19:49:02
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FusionSucceed=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "fusion_succeed.u3d", item_obj) -- 资源名字全部是小写
    self.protoId = nil
end)

-- 资源加载完成
function FusionSucceed:on_asset_load(key,asset)
	--ui初始化
	self.init = true
	if self.protoId then
		self:set_content(self.protoId,self.count)
	end
end

--初始化内容
function FusionSucceed:set_content(protoId,count)
	self.protoId = protoId or self.protoId
	self.count = count or self.count
	if not self.init then
		return
	end
	if type(protoId) == "table" then
		local item = self.refer:Get("bg").gameObject
		local eff = self.refer:Get("item_eff")
		for i,v in ipairs(self.protoId) do
			local data = ConfigMgr:get_config("item")[v]
			if data then
				local refer = nil
				if i<#self.protoId then
					local obj = LuaHelper.Instantiate(item)
					obj.transform:SetParent(item.transform.parent,false)
					refer = obj:GetComponent("ReferGameObjects")
					local ob = LuaHelper.Instantiate(eff)
					ob.transform:SetParent(eff.transform.parent,false)
				else
					refer = item:GetComponent("ReferGameObjects")
				end
				local bg = refer:Get("bg")
				gf_set_click_prop_tips(bg.gameObject,v)
				gf_set_item(v,refer:Get("icon"),bg)
				refer:Get("binding"):SetActive(LuaItemManager:get_item_obejct("itemSys"):calculate_item_is_bind(v))
				refer:Get("count").text = self.count[i]
				refer:Get("name").text = data.name
			end
		end
	else
		local data = ConfigMgr:get_config("item")[self.protoId]
		if data then
			local bg = self.refer:Get("bg")
			gf_set_click_prop_tips(bg.gameObject,self.protoId)
			gf_set_item(self.protoId,self.refer:Get("icon"),bg)
			self.refer:Get("binding"):SetActive(LuaItemManager:get_item_obejct("itemSys"):calculate_item_is_bind(self.protoId))
			self.refer:Get("count").text = self.count
			self.refer:Get("name").text = data.name
			self.item_eff:SetActive(true)
		end
	end

	self.refer:Get("fusion_succeed"):SetActive(true)
	self.refer:Get("sure_btn"):SetActive(true)
	self.refer:Get("formula_succeed"):SetActive(false)
	self.refer:Get("equip_btn"):SetActive(false)
	self.refer:Get("cancle_btn"):SetActive(false)
end

--鼠标点击按钮
function FusionSucceed:on_click(obj,arg)
	if(obj.name=="sureBtn")then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
		--关闭弹框
		self:hide()
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