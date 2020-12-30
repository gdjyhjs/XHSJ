--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-25 11:46:58
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MarketRecord=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "market_trading_record.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function MarketRecord:on_asset_load(key,asset)
	self.ItemRoot = self.refer:Get("ItemRoot")
	self.Item = self.refer:Get("Item")
	self.qi_e = self.refer:Get("qi_e")
	self.top = self.refer:Get("top")
	self.scrollView = self.refer:Get("scrollView")
	self.objs = {}

	self:init_ui()
	self.init = true
end

function MarketRecord:init_ui()
	local list = self.item_obj.historys
	gf_print_table(list,"交易记录")
	local is_not_null = #list>0
	self.top:SetActive(is_not_null)
	self.qi_e:SetActive(not is_not_null)

	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	for i,v in ipairs(list) do
		if not self.objs[i] then
			local obj = LuaHelper.Instantiate(self.Item)
			local item = obj.transform
			item:SetParent(self.ItemRoot,false)
			self.objs[i] = {
				obj = obj,
				bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image),
				icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
				count = item:Find("count"):GetComponent("UnityEngine.UI.Text"),
				name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
				level = item:Find("level"):GetComponent("UnityEngine.UI.Text"),
				type = item:Find("type"):GetComponent("UnityEngine.UI.Text"),
				time = item:Find("time"):GetComponent("UnityEngine.UI.Text"),
				tax = item:Find("tax"):GetComponent("UnityEngine.UI.Text"),
				money = item:Find("money"):GetComponent("UnityEngine.UI.Text"),
			}
		end
		local item = self.objs[i]
		local item_data = ConfigMgr:get_config("item")[v.protoId]
		if item_data.type == ServerEnum.ITEM_TYPE.EQUIP then
			gf_set_equip_icon(v.protoId,item.icon,item.bg,v.color)
			local prefix = itemSys:get_equip_prefix_name(v.prefix)
			item.name.text = string.format("%s%s",prefix,item_data.name)
		else
			gf_set_item(v.protoId,item.icon,item.bg)
			item.name.text = item_data.name
		end
		item.count.text = v.num and v.num>1 and v.num or nil
		item.level.text = string.format(gf_localize_string("等级:%d"),item_data.item_level)
		local price = v.price or 0
		item.type.text = price>0 and gf_localize_string("出售") or gf_localize_string("购买")
		item.time.text = gf_get_time_stamp(v.timestamp)
		local tax = v.tax or 0
		item.tax.text = tax
		item.money.text = string.format("<color=%s>%d</color>",price>0 and "#604942" or "#d01212",price>0 and (price - tax) or price)

		item.obj:SetActive(true)
	end
	for i=#list+1,#self.objs do
		self.objs[i].obj:SetActive(false)
	end
	self.scrollView.verticalNormalizedPosition = 1

end

function MarketRecord:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "" then
	end
end

--服务器返回
function MarketRecord:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		-- 出售
		if id2== Net:get_id2("shop", "") then
		end
	end
end

function MarketRecord:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function MarketRecord:on_hide()
	StateManager:remove_register_view( self )

end

-- 释放资源
function MarketRecord:dispose()
	self:hide()
    self._base.dispose(self)
 end

return MarketRecord

