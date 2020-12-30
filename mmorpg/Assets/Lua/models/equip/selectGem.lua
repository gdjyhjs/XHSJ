--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 17:01:03
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local selectGem=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "gem_select.u3d", item_obj) -- 资源名字全部是小写
    self.select_prop_list = nil
end)

function selectGem:set_data(list,fn,title_name,btn_name,gem_des,nil_text)
	self.select_prop_list = list --{propId=物品id ,des=描述 ,color=品质}
	self.select_prop_fn = fn
	self.btn_name = btn_name
	self.gem_des = gem_des
	self.title_name = title_name
	self.nil_text = nil_text
	self.select_index = nil
	if self.init then
		self:set_list()
	end
end

-- 资源加载完成
function selectGem:on_asset_load(key,asset)
	self.itemRoot = self.refer:Get("itemRoot")
	self.uiTitleTxt = self.refer:Get("uiTitleTxt")
	self:set_list()
	self.init = true
end

function selectGem:set_list()
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
		-- print("设置道具",item)
		local icon = item.transform:Find("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = item.transform:Find("bg"):GetComponent(UnityEngine_UI_Image)
		gf_set_item(v.propId,icon,bg,v.color)
		local have_count = v.count or bag:get_item_count(v,ClientEnum.BAG_TYPE.BAG)
		item.transform:Find("count"):GetComponent("UnityEngine.UI.Text").text = have_count
		item.transform:Find("des"):GetComponent("UnityEngine.UI.Text").text = v.des
		item.name = "objItem"
		item:SetActive(true)
		LuaHelper.eventSystemCurrentSelectedGameObject = item
		item:GetComponent("UnityEngine.UI.Toggle").isOn = i==1
	end
	self.refer:Get("gemDes").text = self.gem_des
	self.refer:Get("btnName").text = self.btn_name or "选择"
	self.refer:Get("qi_e"):SetActive(#self.select_prop_list==0)
	self.refer:Get("null_item_text").text = self.nil_text
	--self.refer:Get("inlayBtn").interactable = not #self.select_prop_list==0
end

function selectGem:on_click(obj,arg)
	print("点击选择宝石")
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd=="objItem" then
		if arg.isOn then
			self.select_index = obj.transform:GetSiblingIndex()+1
		end
	elseif cmd=="inlayBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.select_prop_fn then
			self.select_prop_fn(self.select_prop_list[self.select_index or 1])
		end
	end
end

function selectGem:on_showed()
	print("注册 selectGem")
    StateManager:register_view( self )
    if self.init then
		self:set_list()
    end
end

function selectGem:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function selectGem:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return selectGem

