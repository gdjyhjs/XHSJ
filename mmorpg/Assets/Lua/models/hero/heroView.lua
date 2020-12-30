--[[
	武将系统主界面
	create at 17.8.1
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local dataUse = require("models.hero.dataUse")

local res = 
{
	[1] = "hero_common.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
	[10] = gf_localize_string("100级开启"),
	[11] = gf_localize_string("觉醒1级开启"),
	[12] = gf_localize_string("觉醒2级开启"),
	[15] = gf_localize_string("无可用技能书"),
}


local tag_texture =   
{  
	[1] = {"wujiang_page_01_select","wujiang_page_01_normal"},
	[2] = {"wujiang_page_02_select","wujiang_page_02_normal"},
	[3] = {"wujiang_page_03_select","wujiang_page_03_normal"},
	[4] = {"wujiang_page_04_select","wujiang_page_04_normal"},
}

local func = 
{
	[1] = "heroProperty",
	[2] = "heroIllustration",
	[3] = "heroFront",
}

-- local heroView = class(UIBase,function(self)
-- 	local item_obj = LuaItemManager:get_item_obejct("hero")
-- 	self.item_obj = item_obj

-- 	self.item_obj:register_event("hero_view_on_click", handler(self, self.on_click))

-- 	UIBase._ctor(self, res[1], item_obj)
-- end)

local heroView=class(Asset,function(self,item_obj)
	print("wtf  ffff heroView:")
	self.item_obj = item_obj
    self:uiLoad()
    self:set_bg_visible(true)
	self:hide_mainui(true)
end)

function heroView:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroView:on_asset_load(key,asset)
	gf_set_to_top_layer(self.root)
	self.item_obj:register_event("hero_view_on_click", handler(self, self.on_click))
end


function heroView:init_ui()
	local index = unpack(gf_getItemObject("hero"):get_param()) or 1
	self:page_click("page"..index, self.refer:Get(index))
end


function heroView:page_click(event_name,button)
	local index = string.gsub(event_name,"page","")
	
	index = tonumber(index)

	if self.last_view then
		self.last_view:dispose()
	end
	if self.last_button then 
		self.last_button.interactable = true
		local icon = self.last_button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, tag_texture[self.last_index][2])
	end

	button.interactable = false
	local icon = button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon, tag_texture[index][1])

	self.last_button = button
	self.last_index = index

	self:func_call(index)
		
end

function heroView:func_call(index)
	print("wtf index:",index)
	local func_name = func[index]

	local param = gf_getItemObject("hero"):get_param()
	local arg1,arg2,arg3,arg4 = param[1],param[2],param[3],param[4]
	
	gf_getItemObject("hero"):set_param()
	self.last_view = require("models.hero."..func_name)(arg2,arg3,arg4)--self:create_sub_view("models.hero."..func_name)
	self:add_child(self.last_view)
end


function heroView:skillClick(index,sButton,horse_id)
	if heroId then
		return
	end
	local skill_data = gf_getItemObject("hero"):get_hero_skill_slot(horse_id)

	local skill = skill_data[index]

	local skill_data2 = gf_getItemObject("hero"):get_available_skill_item(horse_id)

	if skill.type == 0 then
		
		--专属技能
		if skill.skill == dataUse.getOwnSkill(horse_id) then
			gf_getItemObject('itemSys'):skill_tips(skill.skill)
		else
			local callback = function()
				if not next(skill_data2 or {}) then
					gf_message_tips(commom_string[15])
					return
				end
				require("models.hero.heroSkillLearn")(horse_id,skill.skill,index)
			end
			local button_state = 
			{
				{name=gf_localize_string("替换"),func = callback}
			}
			gf_getItemObject('itemSys'):skill_tips(skill.skill,nil,button_state)
		end
		-- require("models.hero.heroSkillLearn")(self.heroId,skill.skill,index)
	elseif skill.type == -1 then
		if not next(skill_data2 or {}) then
			gf_message_tips(commom_string[15])
			return
		end
		require("models.hero.heroSkillLearn")(horse_id,nil,index)
	elseif skill.type == 1 then
		gf_message_tips(commom_string[10])
	elseif skill.type == 2 then
		gf_message_tips(commom_string[11])
	elseif skill.type == 3 then
		gf_message_tips(commom_string[12])
	end
	
end


--鼠标单击事件
function heroView:on_click(item_obj, obj, arg)
    local event_name = obj.name
    if event_name == "hero_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif string.find(event_name,"page") then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:page_click(event_name, arg)

   elseif string.find(event_name,"hero_skill") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local splits = string.split(event_name,"_")
   		local index = tonumber(splits[3])
   		local horse_id= tonumber(splits[4])
   		print("wtf ffff index:",index,horse_id)
    	self:skillClick(index, arg ,horse_id)


    end

end

function heroView:clear()
	self.last_view = nil
	self.last_button = nil
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function heroView:dispose()
	print("dispose() wtf")
	self:clear()
    self._base.dispose(self)
end

function heroView:on_showed()
	self:init_ui()
end

function heroView:on_hided()
	print("test view heroView hide")
end


function heroView:on_receive( msg, id1, id2, sid )
end

return heroView