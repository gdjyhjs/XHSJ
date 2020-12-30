--[[
	pvp排行榜界面  
	create at 17.8.1
	by xin
]]

-- local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local res = 
{
	[1] = "pvp_rank.u3d",
}

local top_res = 
{
	[1] = "rank_1st",
	[2] = "rank_2nd",
	[3] = "rank_3rd",
	[4] = "rank_list_top_01",
	[5] = "rank_list_top_02",
	[6] = "rank_list_top_03",
}

local commom_string = 
{
	[1] = gf_localize_string("未上榜"),
	[2] = gf_localize_string("我的排名：%d"),
	[3] = gf_localize_string("不能挑战自己"),
	[4] = gf_localize_string("虚位以待"),
}


local rankList = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("pvp")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function rankList:on_asset_load(key,asset)
	self:init_ui()
end

function rankList:init_ui()
	self.page_data = {}
	self:send_to_get_rank_data()
end

function rankList:init_scrollview(viewData)
	local scroll_rect_table = self.refer:Get(2)
 	
	local is_init = true
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		
		scroll_rect_item:Get(7):SetActive(false)
		scroll_rect_item:Get(2):SetActive(false)
		--第一个
		local p1 = index <= 3 and scroll_rect_item:Get(7) or scroll_rect_item:Get(2)
		p1.gameObject:SetActive(true)

		-- local bg = scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("bg")
		-- bg.gameObject:SetActive(false)

		if index <= 3 then
			local icon = p1:GetComponent(UnityEngine_UI_Image)
			gf_setImageTexture(icon, top_res[index])

			-- bg.gameObject:SetActive(true)
			-- gf_setImageTexture(bg:GetComponent(UnityEngine_UI_Image), top_res[3+index])
		else
			p1:GetComponent("UnityEngine.UI.Text").text = index
		end

		
		local pvp_rank_property = 
		{
			"name","level","score","power"
		}
		for i=3,6 do
			local value_text = scroll_rect_item.transform:FindChild("rank_item").transform:FindChild("p"..i):GetComponent("UnityEngine.UI.Text")
			local kvalue = data_item[pvp_rank_property[i-2]]
			value_text.text = kvalue
			-- vip
			if pvp_rank_property[i-2] == "name" then
				local vip_node = value_text.transform:FindChild("vip")
				vip_node.gameObject:SetActive(false)
				if data_item.vipLevel and data_item.vipLevel > 0 then
					vip_node.gameObject:SetActive(true)
					vip_node.gameObject.transform:FindChild("lv"):GetComponent("UnityEngine.UI.Text").text = data_item.vipLevel
				end
			end
		end

	end

	scroll_rect_table.onBottom = function(item, index, data)
		self:send_to_get_rank_data(self.type)
	end

	for i,v in ipairs(viewData) do
        local index = scroll_rect_table:InsertData(v, -1)
        scroll_rect_table:Refresh(index-1, index)
    end


end

function rankList:init_my_view(my_rank)
	my_rank = my_rank and my_rank or 0
	self.refer:Get(3).text = string.format(commom_string[2],my_rank)
	if my_rank <= 0 then
		self.refer:Get(3).text = string.format(commom_string[1])
	end
end


function rankList:challenge_click(arg)
	local item = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem")

	local roleId = item.data.roleId
	local my_role_id = gf_getItemObject("game"):getId()
	if my_role_id == roleId then
		gf_message_tips(commom_string[3])
		return
	end

	gf_getItemObject("copy"):enter_copy_c2s(ConfigMgr:get_config("t_misc").special_copy_code.arena,nil,item.data.roleId,item.data)

end

--鼠标单击事件
function rankList:on_click( obj, arg)
    local event_name = obj.name

    if event_name == "challenge_btn" then
    	 Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:challenge_click(arg)

    end
end

function rankList:send_to_get_rank_data()
	local page = self:get_page_index()
	gf_getItemObject("pvp"):send_to_get_rank_list(page)
end

function rankList:rec_rank_list(msg,sid)
	local page = unpack(Net:get_sid_param(sid))
	if not self.page_data then
		self.page_data = {}
	end

	if page == 1 then
		self:top_init(msg.list)
	end

	self.my_rank = msg.myRank
	self.page_data[page] = msg.list
	self:init_scrollview(msg.list)
	self:init_my_view(self.my_rank)
end

function rankList:top_init(data)
	gf_print_table(data, "wtf top_init data:")
	for i=1,3 do
		local data_ex = data[i]

		if data[i] then
			local item = self.refer:Get("Image (1)").transform:FindChild("item"..i)
			local head = item.transform:FindChild("Image (1)"):GetComponent(UnityEngine_UI_Image)
			gf_set_head_ico(head, data_ex.head)

			local name = item.transform:FindChild("p1"):GetComponent("UnityEngine.UI.Text")
			name.text = data_ex.name

			local power = item.transform:FindChild("p2"):GetComponent("UnityEngine.UI.Text")
			power.text = data_ex.power
			local item = self.refer:Get("Image (1)").transform:FindChild("item"..i)

			item.transform:FindChild("Image (1)").gameObject:SetActive(true)
		else
			item.transform:FindChild("Image (1)").gameObject:SetActive(false)
			local name = item.transform:FindChild("p1"):GetComponent("UnityEngine.UI.Text")
			name.text = commom_string[4]
			local power = item.transform:FindChild("p2"):GetComponent("UnityEngine.UI.Text")
			power.text = ""
		end

	end
end

function rankList:get_page_index()
	return #self.page_data + 1
end

function rankList:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ArenaRankListR") then
			self:rec_rank_list(msg,sid)
		end
	end
end

function rankList:on_showed()
	StateManager:register_view(self)
end

function rankList:on_hided()
	StateManager:remove_register_view(self)
end
-- 释放资源
function rankList:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

return rankList