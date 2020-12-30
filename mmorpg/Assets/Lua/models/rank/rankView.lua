--[[
	排行榜界面  属性
	create at 17.7.3
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper
local dataUse = require("models.rank.dataUse")
local horse_data_use = require("models.horse.dataUse")
local model_name = "base"
require("models.rank.rankConfig")

local res = 
{
	[1] = "rank_list.u3d",
	[2] = "scroll_table_cell_bg_03_select",
	[3] = "scroll_table_cell_bg_03_normal",
	[4] = "rank_list_top_01",
	[5] = "rank_list_top_02",
	[6] = "rank_list_top_03",
}

local top_res = 
{
	[1] = "rank_1st",
	[2] = "rank_2nd",
	[3] = "rank_3rd",
}

local commom_string = 
{
	[1] = gf_localize_string("我的排名：%d"),
	[2] = gf_localize_string("未加入军团"),
	[3] = gf_localize_string("未上榜"),
	[4] = gf_localize_string("我的军团排名：%d"),
	[5] = gf_localize_string("无"),
	[6] = gf_localize_string("虚位以待"),
	[7] = gf_localize_string("50+"),
}

local rankView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
	self:set_bg_visible(true)
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)

local item_height = 87.5
local scroll_height = 460

--资源加载完成
function rankView:on_asset_load(key,asset)
	self:hide_mainui(true)
	
	self.item_obj:register_event("rank_view_on_click", handler(self, self.on_click))
end

function rankView:init_ui(index)
	self:init_left_view(index)
	if index == -1 then
		return
	end
	self.refer:Get(4).data = {}
	self:show_name()
	self:send_to_get_rank_data(self.type,true)
	self:init_scrollview()
	self.page_index = {}
end

function rankView:init_left_view(index)
	local data = dataUse.get_rank_data_ex(index or -1)
	local pItem = self.refer:Get(1)
	local copyItem1 = self.refer:Get(2)
	local copyItem2 = self.refer:Get(3)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for ii,vv in ipairs(data) do
		local item = LuaHelper.InstantiateLocal(copyItem2.gameObject,pItem.gameObject)
		item.gameObject:SetActive(true)
		--是否被选中
		if self.sindex == ii then
			local image = item.transform:FindChild("secondItem_select1"):GetComponent(UnityEngine_UI_Image)
			self.arg = image
			gf_setImageTexture(image, res[2])
		end 
		item.transform:FindChild("secondItem_select1").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = vv.name
		item.transform:FindChild("secondItem_select1").name = "sitem"..ii
	end
	
end

function rankView:show_name()
	local p_node = self.refer:Get(8)

 	local show_name = dataUse.get_show_name_by_type(self.type)

	for i,v in ipairs(show_name or {}) do
		local title_text = p_node.transform:FindChild("t"..i):GetComponent("UnityEngine.UI.Text")
		title_text.text = v.name
	end
end

--排名显示
function rankView:init_scrollview(viewData)
	local scroll_rect_table = self.refer:Get(4)
 	
	local page = gf_getItemObject("rank"):get_max_page(self.type) - 1
	local is_init = true
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
 		if not next(data_item or {}) then
 			return
 		end
		scroll_rect_item.gameObject:SetActive(true) --显示项
		
		scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p1").gameObject:SetActive(false)
		scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p2").gameObject:SetActive(false)

		local p1 = index <= 3 and scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p1") or scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p2")
		p1.gameObject:SetActive(true)

		if index <= 3 then
			local icon = p1:GetComponent(UnityEngine_UI_Image)
			gf_setImageTexture(icon, top_res[index])
		else
			p1:GetComponent("UnityEngine.UI.Text").text = index
		end

		local vip_node = scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p3").transform:FindChild("vip")
		vip_node.gameObject:SetActive(false)
		
		for i=3,5 do
			local v_node = scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p"..i)
			local value_text= v_node:GetComponent("UnityEngine.UI.Text")
			
			value_text.text = self:get_value(data_item,i - 2)
			local k_name = RANK_PROPERTY[self.type][i - 2]
			if type(k_name) == "string" and k_name == "name" and self.type ~= Enum.RANKING_TYPE.ALLIANCE_LEVEL and data_item.vipLevel > 0  then
				vip_node.gameObject:SetActive(true)
				vip_node.transform:FindChild("lv"):GetComponent("UnityEngine.UI.Text").text = data_item.vipLevel
			end
		end

	end

	scroll_rect_table.onBottom = function(item, index, data)
		self:send_to_get_rank_data(self.type)
	end
	
end

function rankView:get_value(data_item,index)
	local k_name = RANK_PROPERTY[self.type][index]

	if type(k_name) == "string" then
		if not data_item[k_name] then
			return ""
		end
	end
	if type(k_name) == "table" then
		if not data_item[k_name[1]][k_name[2]] then
			return ""
		end
	end

	local kvalue = type(k_name) == "string" and data_item[k_name] or data_item[k_name[1]][k_name[2]]
	if type(kvalue) == "string" and kvalue == "" then
		kvalue = commom_string[5]
	end
	return self:format_normal(k_name,kvalue)
end

function rankView:init_my_rank(rank,index,data)
	index = index and index or 0
	self.refer:Get(20):SetActive(false)
	if not next(data or {}) then
		return
	end

	--没有我的数据时
	if not next(rank or {}) and index <= 0 then
		self.refer:Get(12).text = commom_string[3]
		local is_in = gf_getItemObject("legion"):is_in()
		if self.type == Enum.RANKING_TYPE.ALLIANCE_LEVEL and not is_in then
			self.refer:Get(12).text = commom_string[2]
		end
		return
	end
	self.refer:Get(20):SetActive(true)
	self.refer:Get(13):SetActive(false)
	self.refer:Get(12).text = ""
	
	for i=3,5 do
		self.refer:Get(11 + i).text = ""
	end

	--没有我的排名时
	if index <= 0 then
		self.refer:Get(12).text = commom_string[7]
	end

	self.refer:Get(18):SetActive(false)
	self.refer:Get(19):SetActive(false)

	local p1 = (index > 0 and index <= 3) and self.refer:Get(18) or self.refer:Get(19)
	p1:SetActive(true)
	if index > 3 then
		self.refer:Get(12).text = index
	else
		local icon = p1:GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, top_res[index])
	end

	for i=3,5 do
		local k_name = RANK_PROPERTY[self.type][i-2] 

		--如果数据为空
		local kvalue = ""
		if type(k_name) == "string" then
			if rank[k_name] then
				kvalue = rank[k_name]
			end
		else
			if rank[k_name[1]] and  rank[k_name[1]][k_name[2]] then
				kvalue = rank[k_name[1]][k_name[2]]
			end
		end

		if type(kvalue) == "string" and kvalue == "" then
			kvalue = commom_string[5]
		end
		self.refer:Get(11 + i).text = self:format_normal(k_name,kvalue)
		
		if type(k_name) == "string" and k_name == "name" and self.type ~= Enum.RANKING_TYPE.ALLIANCE_LEVEL and rank.vipLevel > 0 then
			self.refer:Get(13):SetActive(true)
			self.refer:Get(13).transform:FindChild("lv"):GetComponent("UnityEngine.UI.Text").text = rank.vipLevel
		end
	end
end

--数据类型转换 
--name  字段名 可能是table
function rankView:format_normal(name,value)
	
	if type(value) == "string" then
		return value
	end
	if type(name) ~= "string" then
		name = name[2]
	end

	local costTime = function(value)
		return gf_convert_time(value)
	end
	
	local career = function(value)
		return ClientEnum.JOB_NAME[value]
	end

	local get_horse_name = function(value)
		return horse_data_use.getHorseName(value)
	end

	local get_horse_stage = function(value)
		return horse_data_use.get_horse_level_string(value)
	end

	local func = 
	{
		["costTime"] 		= costTime,
		["career"]   		= career,
		["horseCode"]   	= get_horse_name,
		["horseLevel"]   	= get_horse_stage,
	}
	
	if func[name] then
		return func[name](value)
	end
	
	return value
end

function rankView:item_click(event_name)
	print("event_name:",event_name)
	self.arg = nil
	local index = string.gsub(event_name,"bitem","")
	index = tonumber(index)
	if self.index and self.index == index then
		self.index = nil
		self:init_ui(-1)
		return
	end
	self.index = index
	self:init_left_view(index)
end

function rankView:sitem_click(event_name,arg)
	print("sitem_click wtf")

	local index = string.gsub(event_name,"sitem","")
	index = tonumber(index)

	local data = dataUse.get_rank_data_by_index(index)

	if data.type == self.type then
		return
	end

	if self.arg then
		gf_setImageTexture(self.arg, res[3])
	end
	self.arg = arg:Get(1)
	gf_setImageTexture(self.arg, res[2])
	
	self.sindex = index

	local data = dataUse.get_rank_data_by_index(index)
	
	self.refer:Get(4).data = {}

	if data then
		--初始化页签数据
		self.type = data.type
		self:show_name()
		self.refer:Get(20):SetActive(false)
		self:send_to_get_rank_data(self.type,true)
		self.page_index = {}
	end
end

function rankView:send_to_get_rank_data(type,need_clear)
	--如果是军团
	if type == Enum.RANKING_TYPE.ALLIANCE_LEVEL  then
		if need_clear then
			gf_getItemObject("rank"):set_rank_list(type, {})
		end
		
		gf_getItemObject("rank"):send_to_get_rank_alliance(type)
		return
	end
	if need_clear then
		gf_getItemObject("rank"):set_rank_list(type, {})
	end
	
	gf_getItemObject("rank"):send_to_get_rank(type)
end

function rankView:rank_item_click(arg)
	local data = arg.data
	if self.type ~= ServerEnum.RANKING_TYPE.ALLIANCE_LEVEL then
		local my_role_id = gf_getItemObject("game"):getId()
		if data.roleId == my_role_id then
			return
		end
		LuaItemManager:get_item_obejct("player"):show_player_tips(data.roleId)
	end
end

--鼠标单击事件
function rankView:on_click(item_obj, obj, arg)
    local event_name = obj.name
    print("rankView click ",event_name)

    if event_name == "rank_commont_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()
    
    elseif string.find(event_name,"bitem") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(event_name,arg)

    elseif string.find(event_name,"sitem") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sitem_click(event_name,arg)

    elseif event_name == "closeSocialBtn" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif  string.find(event_name,"Panel") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:rank_item_click(arg)

    end

end



function rankView:clear()
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function rankView:dispose()
	self:clear()
    self._base.dispose(self)
end

function rankView:on_showed()
	local type = gf_getItemObject("rank"):get_view_param()[1]
	local sindex = dataUse.get_index_by_id(type)
	self.sindex = sindex 
	self.type = type 
	self:init_ui(self.index)
	gf_getItemObject("rank"):set_view_param()
end

function rankView:on_hided()
end


function rankView:rec_rank_data(msg)
	
	if not next(msg.list or {}) then
		if msg.page == 1 then
			self.refer:Get(9).gameObject:SetActive(true)
			self.refer:Get(11).gameObject:SetActive(false)
		end
		return
	end
	
	if msg.page == 1 then
		self.refer:Get(9).gameObject:SetActive(false)
		self.refer:Get(11).gameObject:SetActive(true)
		self:init_top_view(msg.list)
		self:init_my_rank(msg.myInfo,msg.myRank,msg.list)
	end

	local scroll_rect_table = self.refer:Get(4)
	if not self.page_index[msg.page] then
		for i,v in ipairs(msg.list or {}) do
			local tb = type(v) == "table" and v or {}
	        local index = scroll_rect_table:InsertData(tb, -1)
	        scroll_rect_table:Refresh(index-1, index)
	    end
	end
    self.page_index[msg.page] = true
end

function rankView:init_top_view(data)
	for i=1,3 do
		local item = self.refer:Get("Image (1)").transform:FindChild("item"..i)

		local bg = item.transform:FindChild("Image (1)")
		local bg2 = item.transform:FindChild("Image (2)")
		if data[i] then
			local data_ex = data[i]
			
			local head = item.transform:FindChild("Image (1)"):GetComponent(UnityEngine_UI_Image)

			bg.gameObject:SetActive(self.type ~= ServerEnum.RANKING_TYPE.ALLIANCE_LEVEL)
			bg2.gameObject:SetActive(self.type == ServerEnum.RANKING_TYPE.ALLIANCE_LEVEL)
			
			if self.type ~= ServerEnum.RANKING_TYPE.ALLIANCE_LEVEL then
				gf_set_head_ico(head, data_ex.head or 114101)
			end

			local name = item.transform:FindChild("p1"):GetComponent("UnityEngine.UI.Text")
			name.text = data_ex.name

			local power = item.transform:FindChild("p2"):GetComponent("UnityEngine.UI.Text")
			power.text = self:get_value(data_ex,3) --data_ex[RANK_PROPERTY[self.type][3]]--self.type == ServerEnum.RANKING_TYPE.ALLIANCE_LEVEL and data_ex.level or data_ex.power
		else
			bg.gameObject:SetActive(false)
			bg2.gameObject:SetActive(false)
			local name = item.transform:FindChild("p1"):GetComponent("UnityEngine.UI.Text")
			name.text = commom_string[6]
			local power = item.transform:FindChild("p2"):GetComponent("UnityEngine.UI.Text")
			power.text = ""
		end

	end
end

function rankView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetRankInfoR") or id2 == Net:get_id2(model_name, "GetAllianceRankR") then
			gf_print_table(msg, "wtf get rank data")
			if self.type ~= msg.type then
				return
			end
			self:rec_rank_data(msg)

		end
	end
end

return rankView