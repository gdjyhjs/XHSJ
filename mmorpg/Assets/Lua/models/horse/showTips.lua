--[[
	坐骑武将获取展示界面  
	create at 17.8.15
	by xin
]]
require("models.horse.horsePublic")
require("models.hero.heroPublicFunc")

local Enum = require("enum.enum")
local res = 
{
	[1] = "pet_get.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}

--[[
	tb.COLOR = {
	WHITE  = 0,		--白
	GREEN  = 1,		--绿
	BLUE   = 2,		--蓝
	PURPLE = 3,		--紫
	GOLD   = 4,		--金
	ORANGE = 5,		--橙
	RED    = 6,     --红
}
]]
-- local show_type =
-- {
-- 	hero  = ClientEnum.SHOW_TYPE.HERO,
-- 	horse = ClientEnum.SHOW_TYPE.HORSE,
-- }
local color_res = 
{
	[Enum.COLOR.WHITE] 		=  	"pet_get_bg_05",
	[Enum.COLOR.GREEN] 		=  	"pet_get_bg_05",
	[Enum.COLOR.BLUE] 		= 	"pet_get_bg_04",
	[Enum.COLOR.PURPLE] 	= 	"pet_get_bg_06",
	[Enum.COLOR.GOLD] 		= 	"pet_get_bg_07",
	[Enum.COLOR.ORANGE] 	= 	"pet_get_bg_07",
	[Enum.COLOR.RED] 		= 	"pet_get_bg_07",
}

local bottom_res = 
{
	[1] = "pet_get_bg_02",
	[2] = "pet_get_bg_03",
}


local color = 
{
	[1] = Color(113/255, 235/255, 234/255, 1),
	[2] = Color(132/255, 56/255, 19/255, 1),
}
local color = 
{	
	[Enum.COLOR.WHITE] 		=  	{"<color=#FFFFFF>%s</color>",Color(255/255, 92/255, 72/255, 1),},
	[Enum.COLOR.GREEN] 		=  	{"<color=#83F553>%s</color>",Color(25/255, 85/255, 0/255, 1),},
	[Enum.COLOR.BLUE] 		= 	{"<color=#53F4F5>%s</color>",Color(0/255, 85/255, 85/255, 1),},
	[Enum.COLOR.PURPLE] 	= 	{"<color=#E153F5>%s</color>",Color(75/255, 0/255, 85/255, 1),},
	[Enum.COLOR.GOLD] 		= 	{"<color=#EE2323>%s</color>",Color(65/255, 1/255, 0/255, 1),},
	[Enum.COLOR.ORANGE] 	= 	{"<color=#EE2323>%s</color>",Color(65/255, 1/255, 0/255, 1),},
	[Enum.COLOR.RED] 		= 	{"<color=#EE2323>%s</color>",Color(65/255, 1/255, 0/255, 1),},
}


local showTips = class(UIBase,function(self,type,id)
	print("wtf show tips")
	self.type = type
	gf_getItemObject("horse"):set_get_type(type)
	self.id = id
	self.end_time = Net:get_server_time_s() + 1
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function showTips:on_asset_load(key,asset)
	self.start_time = Net:get_server_time_s() + 1
    self:init_ui()
end

function showTips:init_ui()
	local ccolor = self:get_color()
	--底栏
	self.refer:Get(6):SetActive(self.type == ClientEnum.SHOW_TYPE.HERO)
	self.refer:Get(7):SetActive(not self.type == ClientEnum.SHOW_TYPE.HERO)
	
	--颜色栏
	gf_setImageTexture(self.refer:Get(3), color_res[ccolor])
	--名字颜色
	local name = self:get_name()
	local text = self.refer:Get(1):GetComponent("UnityEngine.UI.Text")
	text.text = string.format(color[ccolor][1],name)
	--描边
	local text = self.refer:Get(1):GetComponent("UnityEngine.UI.Outline")
	text.effectColor = color[ccolor][2]

	--模型
	self:set_model()
end
function showTips:get_name()
	if self.type == ClientEnum.SHOW_TYPE.HERO then
		return require("models.hero.dataUse").getHeroName(self.id)
	end
	return require("models.horse.dataUse").getHorseName(self.id)
end

function showTips:get_color()
	if self.type == ClientEnum.SHOW_TYPE.HERO then
		return require("models.hero.dataUse").getHeroQuality(self.id)
	end
	return require("models.horse.dataUse").get_horse_data(self.id).color
end

function showTips:set_model()
	
	if self.type == ClientEnum.SHOW_TYPE.HERO then
		self.refer:Get(4).gameObject:SetActive(true)
		self.refer:Get(5).gameObject:SetActive(false)
		local model = self.refer:Get(4)
		SetHeroModel(model,self.id,-1,4)
		return
	end
	self.refer:Get(4).gameObject:SetActive(false)
	self.refer:Get(5).gameObject:SetActive(true)
	local model = self.refer:Get(5)

	local scale = gf_get_config_table("horse")[self.id].get_model_scale

	set_model_view(self.id,model,0,-2,scale)
end

--鼠标单击事件
function showTips:on_click( obj, arg)
	local event_name = obj.name
	print("showTips click",event_name)
    if event_name == "close_click" then  
    	if (gf_getItemObject("guide"):get_cur_big_step() == ClientEnum.GUIDE_BIG_STEP.HORSE) or (gf_getItemObject("guide"):get_cur_big_step() == ClientEnum.GUIDE_BIG_STEP.HERO) then
    		return
    	end
    	if not (Net:get_server_time_s() - self.end_time >= 1) then
    		return
    	end
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    	gf_receive_client_prot(msg, ClientProto.HorseShowState)
    	
    end
end

function showTips:on_press_down(obj,data)
	local name = obj.name
	print("wtf on_press_down name:",name)
	if name == "rawImage" then
		self.time = Net:get_server_time_ms()
	end
end

function showTips:on_press_up(obj,data)
	local name = obj.name
	print("wtf on_press_up name:",name)
	if name == "rawImage" then
		if self:is_up() then
			self:dispose()
		end
	end
end
function showTips:on_cancel(obj,data)
	local name = obj.name
	print("wtf on_cancel name:",name)
	if name == "rawImage" then
		if self:is_up() then
			self:dispose()
		end
	end
end

function showTips:is_up()
	if (gf_getItemObject("guide"):get_big_step() == ClientEnum.GUIDE_BIG_STEP.HORSE) or (gf_getItemObject("guide"):get_big_step() == ClientEnum.GUIDE_BIG_STEP.HERO) then
		return
	end
	if not (Net:get_server_time_s() - self.end_time >= 1) then
		return
	end
	if not self.time then
		return
	end
	print("wtf Net:get_server_time_ms() - self.time <= 0.1:",(Net:get_server_time_ms() - self.time) / 1000,0.01)
	return (Net:get_server_time_ms() - self.time) / 1000 <= 0.1
end

function showTips:on_showed()
	StateManager:register_view(self)
end

function showTips:clear()
	StateManager:remove_register_view(self)
end

function showTips:on_hided()
	print("隐藏了1h")
	self:clear()
end
-- 释放资源
function showTips:dispose()
	print("隐藏了2d")
	self:clear()
    self._base.dispose(self)
end

function showTips:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
		end
	end
	if id1 == ClientProto.GuideClose then
		self:dispose()
	end
end

return showTips



-- function showTips:get_model_id() 
-- 	if self.type == show_type.hero then
-- 		return require("models.hero.dataUse").getHeroModel(self.id)
-- 	end
-- 	return require("models.horse.dataUse").getHorseModel(self.id)
-- end

-- function showTips:start_scheduler()
-- 	if self.schedule_id then
-- 		self:stop_schedule()
-- 	end
-- 	local update = function()
-- 		if self.start_time <= Net:get_server_time_s() then
-- 			self:stop_schedule()
-- 			self.is_end = true
-- 		end
-- 	end
-- 	self.schedule_id = Schedule(update, 0.1)

-- end
-- function showTips:stop_schedule()
-- 	print("self stop schedule")
-- 	if self.schedule_id then
-- 		self.schedule_id:stop()
-- 		self.schedule_id = nil
-- 	end
-- end