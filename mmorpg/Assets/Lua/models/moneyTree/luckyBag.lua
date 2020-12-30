--[[--
--福袋界面
-- @Author:Seven
-- @DateTime:2017-07-03 11:57:40
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LuckyBag=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "money_tree_lucky_bag.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function LuckyBag:on_asset_load(key,asset)
	self:init_ui()
end
function LuckyBag:init_ui()
	-- self.scroll = self.refer:Get("Scroll View")
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self:refresh(self.item_obj.money_tree_award)
	StateManager:register_view( self )
	-- if self.item_obj.lucky_bag_num <= #self.item_obj.money_tree_award * 0.5 then
	-- 	self.scroll.verticalNormalizedPosition = 1
	-- else
	-- 	self.scroll.verticalNormalizedPosition = 0
	-- end
	self.scroll_table:ScrollTo(self.item_obj.lucky_bag_num-1)
	
end

function LuckyBag:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0, - 1) --显示列表
end

function LuckyBag:update_item(item,index,data)
	local color1 =  gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN)
	local color2 =  gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
	if self.item_obj.treetime >= data.times then
		item:Get("txt_times").text = "摇钱 <color="..color2..">".. data.times .."</color> 次 <color="..color2..">("..self.item_obj.treetime.."/"..data.times..")</color>" 
	else
		item:Get("txt_times").text = "摇钱 <color="..color1..">".. data.times .."</color> 次 <color="..color1..">("..self.item_obj.treetime.."/"..data.times..")</color>" 
	end
	item:Get("txt_money").text = data.award_coin
	if data.state ~= nil then
		item:Get("img_get").gameObject:SetActive(true)
		if data.state then
			gf_setImageTexture(item:Get("img_get"),"money_tree_icon_02")
		else
			gf_setImageTexture(item:Get("img_get"),"money_tree_icon_01")
		end
	else
		item:Get("img_get").gameObject:SetActive(false)
	end
	gf_set_item(data.item,item:Get("icon"),item:Get("item"))
end

function LuckyBag:on_click(obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_bag(arg)
	elseif cmd =="closebagBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj.lucky_Bag = nil
		self:dispose()
	end
end

function LuckyBag:select_bag(item,tf)
	if item.data.state then
		self.item_obj:moneytree_award_c2s(item.data.times)
	end
end

function LuckyBag:update_view()
	gf_print_table(self.item_obj.money_tree_award,"摇钱树1")
	self:refresh(self.item_obj.money_tree_award)
end

-- 释放资源
function LuckyBag:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return LuckyBag

