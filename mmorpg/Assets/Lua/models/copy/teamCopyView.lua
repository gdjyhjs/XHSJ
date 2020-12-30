--[[
	组队副本系统主界面
	create at 17.7.17
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

require("models.teamCopy.publicFunc")

local model_name = "team"

local dataUse = require("models.team.dataUse")
local legion_data_use = require("models.legion.dataUse")

local res = 
{
	[1] = "copy_team.u3d",
}


local commom_string = 
{
    [1] = gf_localize_string("经验+%d"),
    [2] = gf_localize_string("金币+%d"),
    [3] = gf_localize_string("%d级开启"),
    [4] = gf_localize_string("你不是队长"),
    [5] = gf_localize_string("等级不足，不能进入"),
    [6] = gf_localize_string("<color=#FEEE00>%d级</color>"),
    [7] = gf_localize_string("<color=#F30804>%d级</color>"),
    [8] = gf_localize_string("你已有队伍"),
    [9] = gf_localize_string("请选择副本"),
    [10] = gf_localize_string("请先创建队伍"),
}

local teamCopyView = class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)

--资源加载完成
function teamCopyView:on_asset_load(key,asset)
	self:init_ui()
end
 

function teamCopyView:init_ui(index)
	self.page_init = {}
	self.scroll_page = self.refer:Get(1)
	self.scroll_page.onItemRender = handler(self, self.on_item_render)
	self.scroll_page.onPageChangedFn = handler(self, self.on_page_change_fn)
	self.scroll_page.OnPageChanged = handler(self, self.on_page_change)

	local teamCopy = dataUse.getTeamPageCopy()
	self.max_page = #teamCopy
	gf_print_table(teamCopy, "wtf teamCopy:")
	self.scroll_page.data = teamCopy
	self.scroll_page:SetPage(#teamCopy)

	self.c_page = 1
	
end

function teamCopyView:on_item_render( item, cur_index, page, data )
	gf_print_table(data, "wtf page item data:")
	local career = gf_getItemObject("game"):get_career()

	local formulaTable = ConfigMgr:get_config("equip_formula")
	

	for i=1,3 do
		local s_item = item:GetComponent("Hugula.ReferGameObjects"):Get(i)
		local refer = s_item:GetComponent("Hugula.ReferGameObjects")
		local copy_data = data[i]
		--名字
		refer:Get(5).text = copy_data.name
		--背景
		gf_setImageTexture(refer:Get(2), copy_data.bg)
		--限制等级
		local level = gf_getItemObject("game"):getLevel()
		refer:Get(4).text = level >= copy_data.level_limit and string.format(commom_string[6],copy_data.level_limit) or string.format(commom_string[7],copy_data.level_limit)

		refer:Get(1).name = "copy_name_"..copy_data.code
		--奖励
		for ii,vv in ipairs(copy_data.item_reward or {}) do
			if ii <= 4 then
				local reward_item = refer:Get(ii+5)
				reward_item:SetActive(true)

				local food_item_id = legion_data_use.getCareerItem(vv[1],career)

				gf_set_click_prop_tips(reward_item.gameObject,food_item_id,vv[2],vv[3])

				reward_item.transform:FindChild("select")

				local icon = reward_item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
				local count = reward_item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
				local bind = reward_item.transform:FindChild("binding")
				local bg = reward_item:GetComponent(UnityEngine_UI_Image)

				gf_set_equip_icon(formulaTable[food_item_id].code, icon, bg,vv[2],vv[3])

				count.text = ""
				local is_bind = gf_get_config_table("item")[vv[1]].bind
				bind.gameObject:SetActive(is_bind == 1)
			end
		end

		for ii=#copy_data.item_reward + 1,4 do
			local reward_item = refer:Get(ii+5)
			reward_item:SetActive(false)
		end

	end

end

function teamCopyView:set_level_limit(pnode,t_copy)
	local my_level = gf_getItemObject("game"):getLevel()
	if my_level < t_copy.level_limit  then
		pnode.gameObject:SetActive(true)
		local level_text = pnode.transform:FindChild("Text (4)"):GetComponent("UnityEngine.UI.Text")
		level_text.text = string.format(commom_string[3],t_copy.level_limit)
	else
		pnode.gameObject:SetActive(false)
	end
end

function teamCopyView:on_page_change(page_count,page)
	
end
function teamCopyView:on_page_change_fn(page)
	local next_page = page + 2 
	print("wtf page on_page_change_fn",page,next_page,self.max_page,self.page_init[next_page])
	if self.max_page >= next_page and not self.page_init[next_page] then
		self.scroll_page:RefreshPage(next_page,false)
	end
	self.page_init[next_page] = true
end

function teamCopyView:page_move(page)
	print("wtf page:",self.c_page,page)
	local c_page = self.c_page
	self.c_page = self.c_page + page
	self.c_page = self.c_page <= 1 and 1 or self.c_page
	self.c_page = self.c_page >= self.max_page and self.max_page or self.c_page
	if c_page == self.c_page then
		return
	end
	print("self.c_page:",self.c_page)
	self.scroll_page:RefreshPage(self.c_page,true)
end


-- function teamCopyView:type_click(arg,event_name)
-- 	local type = string.gsub(event_name,"team_copy_type","")
-- 	type = tonumber(type)
-- 	self.copy_type = type

-- 	local scale = {-1,1}

-- 	local item_type = string.gsub(arg.name,"item","")
-- 	item_type = tonumber(item_type)

-- 	local target = arg.transform:FindChild("Image (2)")
-- 	target.transform.localScale = Vector3(scale[self.copy_type],arg.transform.localScale.y,arg.transform.localScale.z)

-- 	--如果判断是否已经解锁
-- 	local teamCopy = dataUse.get_all_team_copy_ex()
-- 	local c_info = teamCopy[self.c_page]
-- 	if c_info then
-- 		local c_copy = c_info[item_type]
-- 		local t_copy = c_copy[self.copy_type]
-- 		local my_level = gf_getItemObject("game"):getLevel()
-- 		local pnode = arg.transform:FindChild("lock_mask")

-- 		self:set_level_limit(pnode,t_copy)

-- 	end
	
-- end

function teamCopyView:enter_click()

	if not self.select_id then
		gf_message_tips(commom_string[9])
		return
	end
	
	--如果没有组队
	if not gf_getItemObject("team"):is_in_team() then
		gf_message_tips(commom_string[10])
		local target = dataUse.getTargetByCopyId(self.select_id)
		print("target:",target)
		require("models.team.teamEnter")(target,false)
		gf_receive_client_prot({}, ClientProto.CopyViewClose)
		return
	end
	ENTER_TEAM_COPY(self.select_id)
end

function teamCopyView:item_click(event)
	local item_id = string.gsub(event,"item_","")
	item_id = tonumber(item_id)
	gf_getItemObject("itemSys"):common_show_item_info(item_id)

end

function teamCopyView:auto_click()
		
	if not self.select_id then
		gf_message_tips(commom_string[9])
		return
	end

	if gf_getItemObject("team"):is_in_team() and not gf_getItemObject("team"):isLeader() then
		gf_message_tips(commom_string[8])
		return
	end
	gf_receive_client_prot({}, ClientProto.CopyViewClose)

	local target = dataUse.getTargetByCopyId(self.select_id)

	require("models.team.teamEnter")(target,true)
end

function teamCopyView:copy_item_click(arg)
	arg:SetActive(not arg.activeSelf)

	if self.pre_item and self.pre_item ~= arg then
		self.pre_item:SetActive(false)
	end

	if arg.activeSelf then
		local copy_id = string.gsub(arg.name,"copy_name_","")
		copy_id = tonumber(copy_id)
		self.select_id = copy_id
	else
		self.select_id = nil
	end
	self.pre_item = arg

end


--鼠标单击事件
function teamCopyView:on_click(obj, arg)
    local event_name = obj.name
    print("challenge view click:",event_name)
    if event_name == "next_page_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:page_move(1)

    elseif event_name == "last_page_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:page_move(-1)

    elseif string.find(event_name,"team_copy_type") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:type_click(arg,event_name)

    elseif string.find(event_name,"btnEnter") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:enter_click(event_name)
    
    elseif string.find(event_name,"item_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(event_name)

    elseif event_name == "btnAuto" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:auto_click()

    elseif event_name == "copy_item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:copy_item_click(arg)

    elseif string.find(event_name , "itemSysPropClick_" ) then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local sp = string.split(event_name,"_")
        local flexibleId = tonumber(sp[2])
        local itemSys = LuaItemManager:get_item_obejct("itemSys")
        local id = itemSys:get_formulaId_for_id(flexibleId) -- 先判断是不是装备虚拟id 获取到真实的物品id或者打造id
        local data = ConfigMgr:get_config("item")[id]
        if data then -- 物品 是物品
            itemSys:prop_tips(id,nil,obj.transform.position)
        else -- 装备预览 -- 物品表没有，就是打造id
            LuaItemManager:get_item_obejct("equip"):formula_tips(id,sp[3]~="" and sp[3] or nil,sp[4]~="" and sp[4] or nil,obj.transform.position)
        end
    end

end

function teamCopyView:clear()
	StateManager:remove_register_view( self )
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function teamCopyView:dispose()
	self:clear()
    self._base.dispose(self)
end

function teamCopyView:on_showed()
	StateManager:register_view(self)
	gf_getItemObject("challenge"):send_to_get_challenge_data()
end

function teamCopyView:on_hided()
	self:clear()
end


function teamCopyView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "CreateTeamR") then
			print("create team")
			require("models.team.teamEnter")()
		end
	end

end

return teamCopyView





--[[

function teamCopyView:sitem_click(event_name,arg)
	if self.arg then
		gf_setImageTexture(self.arg, res[3])
	end
	self.arg = arg
	gf_setImageTexture(self.arg, res[2])
	local index = string.gsub(event_name,"sitem","")
	index = tonumber(index)
	self.sindex = index
	self.lbindex = self.index
end

function teamCopyView:item_click(event_name)
	self.arg = nil
	self.is_get = false
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

function teamCopyView:init_left_view(index)
	local data = dataUse.get_rank_data_ex(index or -1)
	gf_print_table(data, "data:")
	local pItem = self.refer:Get(1)
	local copyItem1 = self.refer:Get(2)
	local copyItem2 = self.refer:Get(3)
	local copyItem3 = self.refer:Get(4)
	-- local copyItem4 = self.refer:Get(5)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(data or {}) do
		local copyItem = index == i and copyItem1 or copyItem2
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.name = "bitem"..i
		item.gameObject:SetActive(true)
		item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = v[1].sname
		--如果是打开项
		if index == i then
			for ii,vv in ipairs(v) do
				local item = LuaHelper.InstantiateLocal(copyItem3.gameObject,pItem.gameObject)
				item.gameObject:SetActive(true)
				--是否被选中
				if self.lbindex and self.lbindex == i and self.sindex == ii then
					local image = item:GetComponent(UnityEngine_UI_Image)
					self.arg = image
					gf_setImageTexture(image, res[2])
				end 
				item.transform.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = vv.name
				item.transform.name = "sitem"..ii
			end
		end
	end
end]]