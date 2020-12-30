--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 17:01:03
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ItemList=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "zork_practice_use.u3d", item_obj) -- 资源名字全部是小写
    self.select_prop_list = nil
end)

function ItemList:set_data(list,fn,title,tips)
	self.select_prop_list = list --{propId=物品id ,des=描述 ,color=品质}
	self.select_prop_fn = fn
	self.title_name = title
	self.tips_name = tips
	if self.init then
		self:set_list()
	end
end

-- 资源加载完成
function ItemList:on_asset_load(key,asset)
	self.itemRoot = self.refer:Get("itemRoot")
	self.uiTitleTxt = self.refer:Get("uiTitleTxt")
	self.tipsText = self.refer:Get("tipsText")
	self:set_list()
	self.init = true
end

function ItemList:set_tips(str)
	self.tips_name = str
	if self.init then
		self.tipsText.text = str
	end
end

function ItemList:set_list()
	gf_mask_show(false)
	if not self.select_prop_list or type(self.select_prop_list)~="table" then
		self.select_prop_list = {}
	end
	self.uiTitleTxt.text = self.title_name
	self.tipsText.text = self.tips_name
	local itemRoot = self.itemRoot
	local childCount = itemRoot.childCount
	local item = itemRoot:GetChild(0).gameObject
	local bag = LuaItemManager:get_item_obejct("bag")
	gf_print_table(self.select_prop_list,"所有道具选项")
	self.itemObjs = {}
	for i,v in ipairs(self.select_prop_list) do
		if i > 1 then
			item = i <= childCount and itemRoot:GetChild(i-1).gameObject or LuaHelper.InstantiateLocal(item,itemRoot.gameObject)
		end
		local tf = item.transform
		local icon = tf:Find("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = tf:Find("bg"):GetComponent(UnityEngine_UI_Image)
		local count = tf:Find("count"):GetComponent("UnityEngine.UI.Text")
		local name = tf:Find("name"):GetComponent("UnityEngine.UI.Text")
		local des = tf:Find("des"):GetComponent("UnityEngine.UI.Text")
		local none = tf:Find("none").gameObject
		self.itemObjs[#self.itemObjs+1] = {
			obj = item,
			tf = tf,
			icon = icon,
			bg = bg,
			count = count,
			name = name,
			des = des,
			none = none,
		}
		gf_set_item(v.propId,icon,bg)
		local have_count = v.count or bag:get_item_count(v.propId,ClientEnum.BAG_TYPE.BAG)
		count.text = have_count
		name.text = v.name
		des.text = v.des
		none:SetActive(v.disableBtn or false)
		item:SetActive(true)
	end
end

function ItemList:on_click(obj,arg)
	print("点击列表的按钮",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "zork_practice_use_close" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd=="sureUse" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.select_prop_fn then
			local idx = obj.transform.parent:GetSiblingIndex()+1
			self.select_prop_fn(self.select_prop_list[idx],self.itemObjs[idx])
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
	self:dispose()
end

-- 释放资源
function ItemList:dispose()
	StateManager:remove_register_view( self )
	self.init = nil
    self._base.dispose(self)
 end

return ItemList

