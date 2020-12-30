--[[
	坐骑进阶界面  属性
	create at 17.6.19
	by xin
]]
local dataUse = require("models.horse.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "horse"

local res = 
{
	[1] = "horse_feed.u3d",
}

local commom_string = 
{
	
	[5] = gf_localize_string("%d级解锁"),
}

local page_view = 
{
	[ClientEnum.HORSE_SUB_VIEW.ITEM_FEED] = 2,
	[ClientEnum.HORSE_SUB_VIEW.EQUIP_FEED] = 1,
}

local feed = class(UIBase,function(self,page,arg)
	self.page = page
	self.arg = arg
	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)
feed.level = UIMgr.STACTIC

--资源加载完成
function feed:on_asset_load(key,asset)
    self:init_ui()
end

function feed:init_ui() 

	self:horse_show()
	self:set_property_view()
	self:set_skill_view()
	self:add_end_effect_handel()

	--是否要打开界面 
	if self.page then
		require("models.horse.memoryFeedView")(page_view[self.page])
		self.page = nil
	end
end

function feed:horse_show()
	local data_model = gf_getItemObject("horse")
	local magic_id = data_model:get_magic_id()

	set_model_view(magic_id,self.refer:Get(1),0,-1)

	--名字
	self.refer:Get(3).text = dataUse.getHorseName(magic_id)

	--等级
	local level = data_model:get_feed_level()
	self.refer:Get(4).text = string.format("Lv. %d",level)

	--经验值
	local max_exp = dataUse.get_feed_exp(level)
	local cur_exp = data_model:get_feed_exp()
	self:set_exp_view(cur_exp,max_exp)

end
function feed:add_end_effect_handel()
	local function sOnFinishFn()
		self.refer:Get(12).gameObject:SetActive(false)
	end
	self.refer:Get(12):GetComponent("Delay").onFinishFn = sOnFinishFn
	
end

function feed:show_effect()
	self.refer:Get(12):GetComponent("Delay"):ShowEffect()
	self.refer:Get(12).gameObject:SetActive(false)
	self.refer:Get(12).gameObject:SetActive(true)
end

--设置属性
function feed:set_property_view(level)
	local data_model = gf_getItemObject("horse")
	local panel = self.refer:Get(11)
	--等级
	local level = level or data_model:get_feed_level()
	local max_level = dataUse.get_feed_max_level()

	panel.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = string.format("Lv. %d",level)
	panel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text").text = string.format("Lv. %d",level + 1)
	--如果满级
	if level >= max_level then
		panel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text").text = ""
		panel.transform:FindChild("Image").gameObject:SetActive(false) 
		panel.transform:FindChild("Text").localPosition = Vector3(0,235,0)


		self.refer:Get(9):SetActive(false)
		self.refer:Get(10):SetActive(true)
	end

	local panel = self.refer:Get(7)
 
	local cur_level_data =  dataUse.get_feed_total_property_add(level)
	
	local nxt_level_data = level >= max_level and nil or dataUse.get_feed_data(level + 1)
	for i,v in ipairs(HORSE_PROPERTY_NAME) do
		local p_node = panel.transform:FindChild(v)
		p_node.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = cur_level_data[v]
		if level >= max_level then
			p_node.localPosition = Vector3(-19,p_node.localPosition.y,0)
			p_node.transform:FindChild("nvalue").gameObject:SetActive(false)
		else
			p_node.transform:FindChild("nvalue"):GetComponent("UnityEngine.UI.Text").text = nxt_level_data[v]
		end
	end
end

function feed:set_skill_view()
	local data_model = gf_getItemObject("horse")
	local level = data_model:get_feed_level()
	local max_level = dataUse.get_feed_max_level()

	local max_skill_data = dataUse.get_level_unlock_skill()
	-- local max_skill_data = dataUse.get_feed_skill(max_level)
	local cur_skill_data = dataUse.get_feed_skill(level)

	local p_node = self.refer:Get(8)
	gf_print_table(max_skill_data, "max_skill_data:")
	for i,v in ipairs(max_skill_data or {}) do
		local skill_node = p_node.transform:FindChild("skill"..i)
		local lock_node = skill_node.transform:FindChild("lock")
		local icon = skill_node.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		local bg = skill_node:GetComponent(UnityEngine_UI_Image)
		--icon 
		local icon_res = dataUse.get_skill_icon(v.skill)
		gf_setImageTexture(icon, icon_res)
		--背景框
		local color = dataUse.get_skill_color(v.skill)
		gf_set_quality_bg(bg,color)

		lock_node.gameObject:SetActive(false)
		--如果未解锁
		if not cur_skill_data[i] then
			lock_node.gameObject:SetActive(true)
			lock_node.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = string.format(commom_string[5],v.level)
		end
	end
end


function feed:set_exp_view(cur_exp,max_exp)
	
	local width = 543
	local height = 15
	
	local level = gf_getItemObject("horse"):get_feed_level()
	local max_level = dataUse.get_feed_max_level()
	--如果满级
	if level >= max_level then
		self.refer:Get(5).text = string.format("%s / %d","max",max_exp)
		self.refer:Get(6).transform.sizeDelta = Vector2(width ,height)
		return
	end
	self.refer:Get(5).text = string.format("%d / %d",cur_exp,max_exp)
	self.refer:Get(6).transform.sizeDelta = Vector2(width * cur_exp / max_exp,height)


end

function feed:faq_click()
	gf_show_doubt(1002)
	-- local NormalTipsView = require("common.normalTipsView")
	-- NormalTipsView(self.item_obj, {commom_string[1],commom_string[2],commom_string[3],commom_string[4]})
end

function feed:skill_click(event,skill_button)
	local index = string.gsub(event,"skill","")
	index = tonumber(index)
	if self.last_skill_button then
		self.last_skill_button.transform:FindChild("select").gameObject:SetActive(false)
	end
	self.last_skill_button = skill_button
	self.last_skill_button.transform:FindChild("select").gameObject:SetActive(true)

	local level =  gf_getItemObject("horse"):get_feed_level()
	local max_skill_data = dataUse.get_level_unlock_skill()
	local cur_skill_data = dataUse.get_feed_skill(level)

	local skill_id = cur_skill_data[index] or max_skill_data[index].skill
	print("skill_id:",skill_id)
	gf_getItemObject('itemSys'):skill_tips(skill_id)

end
 
function feed:memory_feed_click()
	require("models.horse.memoryFeedView")(1)
end

function feed:feed_click()
	require("models.horse.memoryFeedView")(2)
end

--鼠标单击事件
function feed:on_click( obj, arg)
    local event_name = obj.name
    if event_name == "btn_help" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:faq_click()

    elseif string.find(event_name,"skill") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:skill_click(event_name,arg)

    elseif event_name == "feed_memory" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:memory_feed_click()

    elseif event_name == "feed_feed" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:feed_click()

    end
end
function feed:on_hided()
	self:stop_schedule()
	if self.last_skill_button then
		self.last_skill_button.transform:FindChild("select").gameObject:SetActive(false)
	end
end
function feed:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end
--刷新经验
function feed:update_exp_view()
	print("update exp loadingbar")
	local cur_total_exp =  self.cur_total_exp --gf_getItemObject("horse"):get_exp()
	local level,cur_exp,max_exp = dataUse.get_level_and_left_exp(cur_total_exp)
	self:set_exp_view(cur_exp,max_exp)
end
function feed:play_exp_anim(exp)
	self:stop_schedule()
	
	local o_exp = exp

	local cur_total_exp =  self.cur_total_exp
	local level,cur_exp_ex,max_exp = dataUse.get_level_and_left_exp(cur_total_exp)
	print("cur_exp_ex,max_exp:",cur_total_exp,exp,cur_exp_ex,max_exp)
	local total_time 	= 1
	local total_count 	= 100

	local add_total_exp = 0

	local function update()
		print("update wtf *******************************************")
		add_total_exp = add_total_exp + exp / total_count

		if add_total_exp > exp then
			self:stop_schedule()
			self.cur_total_exp = self.cur_total_exp + o_exp
			--如果还有累计经验
			if self.anim_exp > 0 then
				print("开始播放累积经验值",self.anim_exp)
				self:play_exp_anim(self.anim_exp)
				self.anim_exp = 0
			else
				self:update_exp_view()
			end
			return
		end

		local cur_exp = cur_exp_ex + add_total_exp
		--如果经验值溢出
		if cur_exp > max_exp then
			--如果满级 停止定时器 如果未满级 获取下一等级最大经验
			level = level + 1
			--播放升星特效
			self:set_property_view(level)

			if dataUse.get_feed_max_level() == level then
				self:stop_schedule()
				self.cur_total_exp = self.cur_total_exp + o_exp
				self:update_exp_view()
				return
			end
			
			exp = exp - (max_exp - cur_exp_ex)
			cur_exp_ex = 0
			max_exp = dataUse.get_feed_exp(level)
			add_total_exp = 0
			return
		end
		self:set_exp_view(cur_exp,max_exp)
	end
	self.schedule_id = Schedule(update, total_time / total_count)
end

-- 释放资源
function feed:dispose()
	self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function feed:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "FeedHorseByMemoryR") then
			if msg.err == 0 then
				self:show_effect()
				self:init_ui()
			end
		
		elseif id2 == Net:get_id2(model_name,"FeedHorseR") then
			self:show_effect()
			if msg.err == 0 then
				self:init_ui()
			end
			

		end
	end
end

return feed