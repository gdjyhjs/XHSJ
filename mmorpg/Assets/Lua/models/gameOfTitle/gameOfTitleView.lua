--[[--
--称号界面
-- @Author:lyj
-- @DateTime:2017-06-20 11:30:16
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GameOfTitleView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "title.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function GameOfTitleView:on_asset_load(key,asset)
	self:init_ui()
	-- self:register()
	StateManager:register_view( self )
	self.property = ConfigMgr:get_config("propertyname") 
	self:all_title_show()
	self.current_page=1--当前页面
	self:select_left_text(self.current_page)
	self.item_obj:title_left_red()
	self:init_red()
end

function GameOfTitleView:init_ui()
	self.content_1_total_title = self.refer:Get("content_1_total_title")
	self.content_2_title_list = self.refer:Get("content_2_title_list").gameObject
	self.scroll_table = self.content_2_title_list:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self,self.update_item)
end
function GameOfTitleView:register()
	print("称号注册点击事件")
	self.item_obj:register_event("gameOfTitle_view_on_click",handler(self,self.on_click))
	-- StateManager:register_view(self)
end

function GameOfTitleView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了",cmd)
	if cmd == "title_item(Clone)"then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:red_point(arg)
		local data = self.item_obj:recently_title_info()
		if data and arg.data.code == data.code then
			self.item_obj:set_recently_title( data.code,false)
			arg:Get("red_point"):SetActive(false)
			self:init_red()
		end
	elseif cmd == "btn_equip" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		self:select_title(arg)
	elseif cmd == "btn_recently_gain" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:take_on_title_c2s(self.item_obj.recently_title_id)
	elseif cmd == "btn_current_title" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:take_on_title_c2s(self.item_obj.equip_title_id)
	elseif cmd == "closeSocialBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "all_title" then --总览
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=1
		self:title_show(true)
		self:all_title_show()
		self:select_left_text(self.current_page)
	elseif cmd == "vip_title" then --vip称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=2
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.VIP)
		self:select_left_text(self.current_page)
	elseif cmd == "ranking_title" then --名人称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=3
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.RANKING)
		self:select_left_text(self.current_page)
	elseif cmd == "achievement_title" then --成就称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=4
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.ACHIEVEMENT)
		self:select_left_text(self.current_page)
	elseif cmd == "activity_title" then --活动称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=5
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.ACTIVITY)
		self:select_left_text(self.current_page)
	elseif cmd == "cut_will_title" then --斩将称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.current_page=6
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.CUT_WILL)
		self:select_left_text(self.current_page)
	elseif cmd == "self_title" then --拥有称号
		self.current_page=7
		self:title_show(false)
		self:title_right(ClientEnum.TITLE_TYPE.SELF)
		self:select_left_text(self.current_page)
	elseif string.find(cmd, "page") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		LuaItemManager:get_item_obejct("player").assets[1]:select_page(arg.transform:GetSiblingIndex()+1)
	elseif cmd == "playerCloseBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		LuaItemManager:get_item_obejct("player").assets[1]:dispose()
	end
end

function GameOfTitleView:select_left_text(num)
	local item = self.refer:Get(7)
	if not self.select_text then
		self.select_text = num
	end
	item:Get(num):SetActive(true)
	if self.select_text ~=num then
		item:Get(self.select_text):SetActive(false)
		self.select_text = num
	end
end

--更新当前页面
function GameOfTitleView:update_title()
	if self.current_page ~=1 then
		if self.select_item.data.red_point == false then
			self.select_item:Get("red_point"):SetActive(false)
		end
		if self.last_select  and self.select_item.data.type == self.last_select.data.type then
			if self.last_select.data then
				if self.last_select.data.title_equip then
					if self.last_select:Get("btn_txt") then
						self.last_select:Get("btn_txt").text = gf_localize_string("卸下")
					end
				else
					if self.last_select:Get("btn_txt") then
						self.last_select:Get("btn_txt").text = gf_localize_string("装备")
					end
				end
			end
		end
		if self.select_item.data.title_equip then
			self.select_item:Get("btn_txt").text = gf_localize_string("卸下")
		else
			self.select_item:Get("btn_txt").text = gf_localize_string("装备")
		end
		-- self:title_right(self.current_page)
		self.last_select = self.select_item
	else
		self:all_title_show()
	end
end

function GameOfTitleView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("scene")) then
		if id2 == Net:get_id2("scene","TakeonTitleR")  then -- 穿戴称号
			if msg.err == 0 then
				-- if self.item_obj.show_get_title then
					self:update_title()
					self:init_red()
				-- end
			end
		end
	end
end

--查看称号
function GameOfTitleView:title_show(tp)
	self.content_1_total_title:SetActive(tp)
	self.content_2_title_list:SetActive(not tp)
	self.item_obj:title_left_red()
	self:init_red()
end
--初始化左边红点
function GameOfTitleView:init_red()
	for i=1,5 do
		self:title_left(i,false)
	end
	-- if #self.item_obj.left_tb==0 then
	-- 	return
	-- end
	-- for k,v in pairs(self.item_obj.left_tb) do
	-- 	self:title_left(v,true)
	-- end
	-- self.item_obj.left_tb = {}
	local tb = self.item_obj:recently_title_info()
	if tb and tb.show_area and self.item_obj.title_red_point then
		self:title_left(tb.show_area,true)
	end
end

--左边红点显隐
function GameOfTitleView:title_left(tp,tf)
	local t =  self.refer:Get("title_left_list")
	t:Get(tp):SetActive(tf)
end

--配置4项属性
function GameOfTitleView:show_property(item,data)
	--隐藏
	for i=2,8,2 do
		item:Get(i-1).gameObject:SetActive(false)
	end
	local a = 0
	for i=2,#data.attribute*2,2 do
		a = a+1
		item:Get(i-1).gameObject:SetActive(true)
		item:Get(i-1).text=self.property[data.attribute[a][1]].name
		item:Get(i).text ="+".. data.attribute[a][2]
	end

end
--时间转换
function GameOfTitleView:get_time_stamp(t)
	local now_tiem = Net:get_server_time_s()
	if t-now_tiem <0 then
		return
	end
	local t_tb = gf_time_diff(t,now_tiem)
	if t_tb.day>0 or t_tb.month> 0 or t_tb.year > 0 then
		return  "剩余"..(t_tb.year*365+t_tb.month*30+t_tb.day) .."天"..t_tb.hour .."小时"
	else
		local min =  t_tb.min
		if min == 0 then
			min = 1
		end
		return "剩余"..t_tb.hour.."小时".. min .."分钟"
	end
end
--需要装备或者卸下称号
function GameOfTitleView:select_title(item,tf)
	self.select_item = item
	gf_print_table(item.data,"装备称号信息")
	self.item_obj:take_on_title_c2s(item.data.code) --装备
end
--取消红点
function GameOfTitleView:red_point(item)
	if not item.data.red_point then return end
	print("发送称号红点",item.data.code)
	self.select_item = item
	self.item_obj:cancel_title_red_point_c2s(item.data.code)
end

--------------------------------------配置总览信息------------------------------------------------------
--总览
function GameOfTitleView:all_title_show()
	local item= self.refer:Get("title_down")
	local data = self.item_obj.property_data
	local a = 1
	for k,v in pairs(data or {} ) do
		if v.value > 0 then
			item:Get(a).gameObject:SetActive(true)
		 	item:Get(a).text = v.name
		 	item:Get(a+1).text ="+".. v.value
		 	a = a + 2
		end
	end
	self:recently_gain_title()
	self:current_equip_title()
	--称号数量
	local a,b = self.item_obj:get_title_amount()
	item:Get("title_amount").text =  a .."/".. b
    item:Get("zhanLiNum").text =self.item_obj.title_power or 0
	  --战力
end
--最近获得
function GameOfTitleView:recently_gain_title()
	local item = self.refer:Get("recently_gain")
	local data = self.item_obj:recently_title_info()
	if data == nil then
		item.gameObject:SetActive(false)
	else
		item.gameObject:SetActive(true)
		self:show_property(item,data)
		if data.type == 1 then
			item:Get("recently_gain_time").text = gf_localize_string("永久获得")
		elseif data.type == 2 then
			item:Get("recently_gain_time").text = self:get_time_stamp(data.valid_time)
		else 
			item:Get("recently_gain_time").text = ""
		end
		if data.title_equip then --装备
			item:Get("txt_recently_gain").text = gf_localize_string("卸下")
		else
			item:Get("txt_recently_gain").text = gf_localize_string("装备")
		end
		if data.category == 1 then --显示文字
			item:Get("txt_title").gameObject:SetActive(true)
			item:Get("txt_title").text = "<color=".. ConfigMgr:get_config("color")[data.color_limit].color ..">"..data.name.."</color>"
			item:Get("img_title_icon").gameObject:SetActive(false)
			item:Get("img_titles"):SetActive(false)
		elseif data.category == 2 then --显示静态图片
			gf_setImageTexture(item:Get("img_title_icon"),data.icon)
			item:Get("txt_title").gameObject:SetActive(false)
			item:Get("img_title_icon").gameObject:SetActive(true)
			item:Get("img_titles"):SetActive(false)
		elseif data.category == 3 then --显示动态图片
			item:Get("txt_title").gameObject:SetActive(false)
			item:Get("img_title_icon").gameObject:SetActive(false)
			item:Get("img_titles"):SetActive(true)
		end
	end
end
--当前装备
function GameOfTitleView:current_equip_title()
	local item = self.refer:Get("current_title")
	local data = self.item_obj:equip_title_info()
	if data == nil then
		item.gameObject:SetActive(false)
	else
		item.gameObject:SetActive(true)
		self:show_property(item,data)
		if data.type == 1 then
			item:Get("current_title_time").text = gf_localize_string("永久获得")
		elseif data.type == 2 then
			item:Get("current_title_time").text = self:get_time_stamp(data.valid_time)
		else
			item:Get("current_title_time").text =""
		end
		if data.title_equip then --装备
			item:Get("txt_current_title").text = gf_localize_string("卸下")
		else
			item:Get("txt_current_title").text = gf_localize_string("装备")
		end
		if data.category == 1 then --显示文字
			item:Get("txt_title").gameObject:SetActive(true)
			item:Get("txt_title").text = "<color=".. ConfigMgr:get_config("color")[data.color_limit].color ..">"..data.name.."</color>"
			item:Get("img_title_icon").gameObject:SetActive(false)
			item:Get("img_titles"):SetActive(false)
		elseif data.category == 2 then --显示静态图片
			gf_setImageTexture(item:Get("img_title_icon"),data.icon)
			item:Get("txt_title").gameObject:SetActive(false)
			item:Get("img_title_icon").gameObject:SetActive(true)
			item:Get("img_titles"):SetActive(false)
		elseif data.category == 3 then --显示动态图片
			item:Get("txt_title").gameObject:SetActive(false)
			item:Get("img_title_icon").gameObject:SetActive(false)
			item:Get("img_titles"):SetActive(true)
		end
	end
end
--------------------------------------配置称号分类右边信息--------------------------------------------------
--配置右边称号信息
function GameOfTitleView:title_right(tp)
	local tb = self.item_obj:classify_title(tp)
	if self.last_title_tp and tp == self.last_title_tp then
		return
	end
	self:refresh(tb)
	self.last_title_tp = tp
	-- if self.item_obj.red_first ~= nil  then
	-- 	print("称号位置1",self.item_obj.red_first)
	-- 	self.scroll_table:ScrollTo(self.item_obj.red_first-1)
	-- 	self.item_obj.red_first = nil
	-- else
	-- 	print("称号位置1",self.item_obj.red_first)
	-- 	self.scroll_table:ScrollTo(0)
	-- end
end

function GameOfTitleView:refresh(data)
	-- for i,v in ipairs(data) do
 --        local index = self.scroll_table:InsertData(v, -1)
 --        self.scroll_table:Refresh(index-1, index)
 --    end
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1 ,- 1) --显示列表
end

function GameOfTitleView:update_item(item,index,data)
	--配置属性
	self:show_property(item,data)
	--配置装备和时间信息
	item:Get("is_have"):SetActive(false)
	item:Get("overdue"):SetActive(false)
	if data.title_gain then --获得
		if data.show_area == ClientEnum.TITLE_TYPE.CUT_WILL and self.item_obj.cur_killwill ~= data.code then
			item:Get("title_time").gameObject:SetActive(false)
			item:Get("btn_equip"):SetActive(false)
			item:Get("is_have"):SetActive(true)
		else
			item:Get("title_time").gameObject:SetActive(true)
			item:Get("btn_equip"):SetActive(true)
		end
		item:Get("not_get").gameObject:SetActive(false)
		if data.type == 1 then --称号时限
			item:Get("title_time").text=gf_localize_string("永久获得")
		elseif data.type == 2 then
			local t = self:get_time_stamp(data.valid_time)
			if t then
				item:Get("title_time").text= t
			else
				item:Get("title_time").gameObject:SetActive(false)
				item:Get("btn_equip"):SetActive(false)
				item:Get("overdue"):SetActive(true)
			end
		else
			item:Get("title_time").text=""
		end
	else
		item:Get("title_time").gameObject:SetActive(false)
		item:Get("btn_equip"):SetActive(false)
		item:Get("not_get").gameObject:SetActive(true)
	end
	if data.title_equip then --装备
		item:Get("btn_txt").text = gf_localize_string("卸下")
		self.last_select = item
	else
		item:Get("btn_txt").text = gf_localize_string("装备")
	end
	if data.category == 1 then --显示文字
		item:Get("txt_title").gameObject:SetActive(true)
		item:Get("txt_title").text = "<color=".. ConfigMgr:get_config("color")[data.color_limit].color ..">"..data.name.."</color>"
		item:Get("img_title").gameObject:SetActive(false)
		item:Get("img_titles"):SetActive(false)
	elseif data.category == 2 then --显示静态图片
		gf_setImageTexture(item:Get("img_title"),data.icon)
		item:Get("img_title").gameObject:SetActive(true)
		item:Get("txt_title").gameObject:SetActive(false)
		item:Get("img_titles"):SetActive(false)
	elseif data.category == 3 then --显示动态图片
		item:Get("img_titles"):SetActive(true)
		item:Get("txt_title").gameObject:SetActive(false)
		item:Get("img_title").gameObject:SetActive(false)
	end
	local cur = self.item_obj:recently_title_info()
	if cur and data.code == cur.code and self.item_obj.title_red_point then
		item:Get("red_point"):SetActive(true)
	else
		item:Get("red_point"):SetActive(false)
	end
		item:Get("txt_condition").text = data.condition
end




--------------------------------------------end---------------------------------------------


-- 释放资源
function GameOfTitleView:dispose()
	self.last_title_tp = nil
	-- self.item_obj:register_event("gameOfTitle_view_on_click",nil)
	StateManager:remove_register_view( self )
	-- StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return GameOfTitleView

