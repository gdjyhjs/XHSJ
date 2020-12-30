--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 17:01:03
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ItemList=class(UIBase,function(self,item_obj,list,fn,name)
    UIBase._ctor(self, "formula_preview.u3d", item_obj) -- 资源名字全部是小写
    print(item_obj,list,fn,name)
	self.select_prop_list = list --{propId=物品id ,des=描述 ,color=品质}
	self.select_prop_fn = fn
	self.title_name = name
end)

function ItemList:set_data(list,fn,name)
	self.select_prop_list = list --{propId=物品id ,des=描述 ,color=品质}
	self.select_prop_fn = fn
	self.title_name = name
	if self.init then
		self:set_list()
	end
end

-- 资源加载完成
function ItemList:on_asset_load(key,asset)
	self.itemRoot = self.refer:Get("itemRoot")
	self.uiTitleTxt = self.refer:Get("uiTitleTxt")
	self:set_list()
	self.init = true
end

function ItemList:set_list()
	if not self.select_prop_list or type(self.select_prop_list)~="table" then
		self.select_prop_list = {}
	end
	self.uiTitleTxt.text = self.title_name or "浏览"
	local itemRoot = self.itemRoot
	local count = itemRoot.childCount
	local item = itemRoot:GetChild(0).gameObject
	local bag = LuaItemManager:get_item_obejct("bag")
	gf_print_table(self.select_prop_list,"所有道具选项")
	for i,v in ipairs(self.select_prop_list) do
		if i > 1 then
			item = i <= count and itemRoot:GetChild(i-1).gameObject or LuaHelper.InstantiateLocal(item,itemRoot.gameObject)
		end
		print("设置道具",item,v.propId,"品质",v.color,"星级",v.star)
		local icon = item.transform:Find("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = item.transform:Find("bg"):GetComponent(UnityEngine_UI_Image)
		gf_set_item(v.propId,icon,bg,v.color,v.star)
		local have_count = v.count or bag:get_item_count(v.propId,ClientEnum.BAG_TYPE.BAG)
		item.transform:Find("count"):GetComponent("UnityEngine.UI.Text").text = have_count
		item.transform:Find("des"):GetComponent("UnityEngine.UI.Text").text = v.des
		item.name = "objItem"
		item:SetActive(true)

	end
end

function ItemList:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd=="objItem" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.select_prop_fn then
			self.select_prop_fn(self.select_prop_list[obj.transform:GetSiblingIndex()+1],obj.transform.position)
		end
	end
end

function ItemList:on_showed()
    StateManager:register_view( self )
    if self.init then
		self:set_list()
    end
end

function ItemList:on_hided()

	StateManager:remove_register_view( self )
end

-- 释放资源
function ItemList:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return ItemList

