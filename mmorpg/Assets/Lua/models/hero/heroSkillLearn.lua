--[[
	武将技能替换界面  属性
	create at 17.10.16
	by xin
]]
local dataUse = require("models.hero.dataUse")
local skillDataUse = require("models.horse.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_learn_skill.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("替换"),
	[2] = gf_localize_string("学习"),
	[3] = gf_localize_string("确定要以<color=#B01FE5>%s</color>替换掉<color=#B01FE5>%s</color>吗？"),
}


local heroSkillLearn = class(UIBase,function(self,hero_id,skill_id,index)
	self.index = index
	self.hero_id = hero_id
	self.skill_id = skill_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroSkillLearn:on_asset_load(key,asset)
    self:init_ui()
end

function heroSkillLearn:update_button()
	if self.skill_id then
		self.refer:Get(2).text = commom_string[1]
	else
		self.refer:Get(2).text = commom_string[2]
	end
end

function heroSkillLearn:init_ui()

	self:update_button()

	local items = self:get_available_skill_item()

	gf_print_table(items, "wtf items data:") 

	self.scroll_table = self.refer:Get(1)

	self.scroll_table.onItemRender = handler(self,self.update_item)

	self.scroll_table.data = items
	self.scroll_table:Refresh(0 ,-1 ) --显示列表
	
end

function heroSkillLearn:update_item(item,index,data)
	print("self.click_index wtf ",self.click_index,index)
	if self.click_index == index then
		item:Get(1).gameObject:SetActive(true)
	else
		item:Get(1).gameObject:SetActive(false)
	end
	
	local skill = data.data.effect[1]
	item:Get(2).text = skillDataUse.get_skill_name(skill)
	
	SetSkillIcon(skill,item:Get(3),item:Get(4))
	-- gf_setImageTexture(self.refer:Get(3), skillDataUse.get_skill_icon(skill))

	-- local color = skillDataUse.get_skill_color(skill)
	-- gf_set_quality_bg(self.refer:Get(4),color)
end

function heroSkillLearn:get_available_skill_item()
	return gf_getItemObject("hero"):get_available_skill_item(self.hero_id)
end

function heroSkillLearn:learn_replace_click()

	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end

	if self.click_index then
		local item = self:get_available_skill_item()[self.click_index]
		local skill = item.data.effect[1]

		if self.skill_id then
			local skillname1 = skillDataUse.get_skill_name(skill)
			local skillname2 = skillDataUse.get_skill_name(self.skill_id)

			local sure_fun = function()
				self:dispose()
				gf_getItemObject("hero"):sendToUseSkillBook(self.hero_id,item.item.guid,self.index)
			end
			local content = string.format(commom_string[3],skillname1,skillname2)
			gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
			return
		end
		self:dispose()
		gf_getItemObject("hero"):sendToUseSkillBook(self.hero_id,item.item.guid,self.index)
		
	end
	
end


--鼠标单击事件
function heroSkillLearn:on_click( obj, arg)
	local event_name = obj.name
	print("heroSkillLearn click",event_name)
    if event_name == "skill_btn_close" then 
    	self:dispose()


    elseif string.find(event_name,"Item") then
    	
    	arg:Get(1).gameObject:SetActive(true)
    	if self.last_hl and self.click_index ~= arg.index then
    		self.last_hl.gameObject:SetActive(false)
    	end
    	self.last_hl = arg:Get(1)
    	self.click_index = arg.index + 1
    	self.select_id = arg.data.data.effect[1]

    elseif event_name == "learn_replace_btn" then
    	self:learn_replace_click()
    	

    end
end

function heroSkillLearn:on_showed()
	StateManager:register_view(self)
end

function heroSkillLearn:clear()
	StateManager:remove_register_view(self)
end

function heroSkillLearn:on_hided()
	self:clear()
end
-- 释放资源
function heroSkillLearn:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroSkillLearn:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
		end
	end
end

return heroSkillLearn