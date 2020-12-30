--[[--
--
-- @Author:HuangJunShan legionAct 军团活动
-- @DateTime:2017-05-05 14:29:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Test = LuaItemManager:get_item_obejct("test")
Test.priority = 1000
--UI资源
Test.assets=
{
    View("testView", Test)
}

--点击事件
function Test:on_click(obj,arg)
	self:call_event("test_on_click",false,obj,arg)
	return true
end

function Test:on_press_down(obj,click_pos)
	-- print("按下")
	if obj.name=="debugBtn" then
		self.assets[1].canvas_group.alpha=0.8
	end
	return true
end

function Test:on_press_up(obj,click_pos)
	-- print("弹起")
	if obj.name=="debugBtn" then
		self.assets[1].canvas_group.alpha=self.assets[1].tf_testbtn.eulerAngles.z==180 and 0.05 or 0.8
	end
	return true
end

function Test:on_receive( msg, id1, id2, sid )
    if(id1 == Net:get_id1("task")) then
		if id2 == Net:get_id2("task","GetQuestionInfoR")  then
			if self.auto_question and msg.err==0 then
				for i,v in ipairs( msg.questionList) do
					local d = ConfigMgr:get_config("question")[v]
					local r = (function()
										for k,v in pairs(d) do
											if string.find(k,"answer_") then
												if v == d.right_answer then
													return tonumber(string.split(k,"_")[2])
												end
											end
										end
									end)()
					Net:send({ questionCode = v,chooseCode = r},"task","AnswerQuestion")
				end
			end
		end
	end
end

--每次显示时候调用
function Test:on_showed( ... )
end

--初始化函数只会调用一次
function Test:initialize()
	self.count = 0
end


function Test:new_hand()
	-- 新手一键出门
	local f1 = function()
	local msg = {value=10000,type=10000,cmd="setNewerStep"}
	Net:send(msg,"base","Debug")
	end
	PLua.Delay(f1,0.1)
	local f2 = function()
	local msg = {cmd="openAllFunc"}
	Net:send(msg,"base","Debug")
	end
	local f3 = function()
	local msg = {type=5,value=999999999999,cmd="addRes"}
	Net:send(msg,"base","Debug")
	end
	
	PLua.Delay(f2,0.5)
	PLua.Delay(f3,0.9)
end

function Test:add_item(id,num) -- 添加需要的材料
		local msg = {type=id,value=num,cmd="addBag"}
		Net:send(msg,"base","Debug")
end
function Test:add_res(id,num) -- 添加基础资源
		local msg = {type=id,value=num,cmd="addRes"}
		Net:send(msg,"base","Debug")
end

function Test:on_key_formula()
	-- 自动打造装备
	local EquipUserData = require("models.equip.equipUserData")
	local data = EquipUserData:get_formula_equip_list(1)
	local t = 0
	local f1 = function(id,num) -- 打造装备
		self:add_item(id,num)
	end
	local f2 = function(id) -- 打造装备
		Net:send({formulaId=id},"bag","FormulaEquip")
	end
	for i,v in ipairs(data) do
		-- 添加需要的材料
		PLua.Delay(function() f1(v.need_item[1][1],v.need_item[1][2]) end,t)
		t=t+0.1
		-- 打造装备
		PLua.Delay(function()f2(v.formulaId)end,t)
	end
	-- PLua.Delay(function() print("自动打造装备完成") end,t)
end

function Test:one_key_equip()
	local EquipUserData = require("models.equip.equipUserData")
	local data = EquipUserData:get_formula_equip_list(1)
	local t = 0

	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	for i,v in ipairs(data) do
		itemSys.tips_item = LuaItemManager:get_item_obejct("bag"):get_item_for_protoId(v.code)
		itemSys:tips_btn_fun_use()
		t=t+0.1
	end
	itemSys.tips_item = nil
	-- PLua.Delay(function() print("自动装备完成") end,t)
end

function Test:one_key_get_gem()
	local msg = {slot = 10128}
	Net:send(msg,"bag","UnlockSlot")
	local data = ConfigMgr:get_config("equip_gem_suit")
	local t = 0
	for lv=1,10 do
		for idx=1,3 do
			for i,v in ipairs(data) do
				local gem_type = v.gem_type[1]
				-- 添加需要的材料
				local id = LuaItemManager:get_item_obejct("equip"):get_gem_for_type(gem_type,lv)
				PLua.Delay(function()
					-- print("获得物品",id)
					self:add_item(id,1) end,t)
				t=t+0.02
			end
		end			
	end
	-- PLua.Delay(function() print("自动获取宝石完成") end,t)
end

function Test:one_key_inlay_gem()
	local data = ConfigMgr:get_config("equip_gem_suit")
	local t = 0
	for lv=1,10 do
		for idx=1,3 do
			for i,v in ipairs(data) do
				local gem_type = v.gem_type[1]
				-- 添加需要的材料
				local id = LuaItemManager:get_item_obejct("equip"):get_gem_for_type(gem_type,lv)
				-- 镶嵌宝石
				PLua.Delay(function()
					-- print("镶嵌宝石",id)
					local guid = LuaItemManager:get_item_obejct("bag"):get_item_for_protoId(id).guid
					local msg = {guid=guid,equipType=i,gemIdx=idx}
					Net:send(msg,"bag","InlayGem") end,t)
				t=t+0.02
			end
		end			
	end
	-- PLua.Delay(function() print("自动镶嵌宝石完成") end,t)
end

function Test:one_key_add_gem(gem_type,num)
	local t = 0
	for lv=1,10 do
		-- 添加需要的材料
		local id = LuaItemManager:get_item_obejct("equip"):get_gem_for_type(gem_type,lv)
		PLua.Delay(function()
			-- print("获得物品",id)
			self:add_item(id,num) end,t)
			
		t=t+0.1
	end
	-- PLua.Delay(function() print("一键添加宝石完成") end,t)
end

function Test:one_key_destiny(count)
	local 
	function f()
		local Enum = require("enum.enum")
		local DestinyTools = require("models.destiny.destinyTools")
		local BagEnum = require("models.bag.bagEnum")

		local Destiny = LuaItemManager:get_item_obejct("destiny")



		local list = Destiny:get_items(Enum.DESTINY_CONTIANER_TYPE.DRAW)
				if #list > 1 then
					local duid = list[1].duid
					local eatDuidArr = {}
					for i=2,#list do
						eatDuidArr[#eatDuidArr+1] = list[i].duid
					end
					Destiny:eat_destiny_c2s(duid,eatDuidArr)
				end

		Destiny:draw_destiny_c2s(2,1)

		Destiny:draw_destiny_c2s(2,1)

		Destiny:draw_destiny_c2s(2,1)

		Destiny:draw_destiny_c2s(2,1)
	end
	for i=1,count or 10 do
		PLua.Delay(f,i*0.5)
	end
	-- PLua.Delay(function() print("一键抽取天命完成") end,t)
end

-- 一键封灵
function Test:one_key_fengling(num)
	self:add_item(40200301,num or 9999)
	local msg = {type=40200301,value=9999,cmd="addBag"}
		Net:send(msg,"base","Debug")
	local horse_list = LuaItemManager:get_item_obejct("horse").horse_list or{}
	local t = 0
	for index,v in ipairs(horse_list) do
		local id = v.horseId
		for lv=1,30 do
			for slot=1,5 do
				for idx=1,4 do
					local msg = {}
					msg.horseId = id
					msg.slot = slot
					PLua.Delay(function()
						Net:send(msg,"horse","HorseSlotLevelUp") end,t)
					t = t + 0.2
				end
			end
		end		
	end
	-- PLua.Delay(function() print("一键封灵完成") end,t)
end

-- 一键修炼
function Test:one_key_xiulian(count,x_type)
	self:add_res(1,(count or 88)*(x_type and 1 or 6)*500000)
	self:add_res(6,(count or 88)*(x_type and 1 or 6)*200)
	local t = 0.5
	for _c=1,count or 88 do
		for _t=x_type or 1,x_type or 6 do
			local msg = {}
			msg.type = _t
			msg.times = 10
					PLua.Delay(function()
			Net:send(msg,"alliance","Train") end,t)
					t = t + 0.001
		end
	end
	-- PLua.Delay(function() print("一键修炼完成") end,t)
end

--一键升级武将
function Test:one_key_up_hero()
	local hero = LuaItemManager:get_item_obejct("hero")
	local hero_info = hero:get_fight_hero_info()
	local heroId= hero_info.heroId
	local bag = LuaItemManager:get_item_obejct("bag")
	local list = bag:get_item_for_type(4,11,1)
	local l = {}
	local msg = {heroId = heroId,bookList = l}
	for i,v in ipairs(list) do
		l[#l+1] = {
			count = v.item.num,
			guid = v.item.guid,
		}
	end
	Net:send(msg,"hero","AddHeroExpByBook")
end


--[[

	按钮
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        Sound:play(ClientEnum.SOUND_KEY.BUY_BTN) -- 购买按钮点击音效
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
        Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN) -- 进入副本/挑战按钮点击音效


    效果
        Sound:play(ClientEnum.SOUND_KEY.LEVEL_UP) -- 角色、坐骑、武将升级时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.CHANGE_EQUIP) -- 更换装备时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.USE_PROP) -- 使用血瓶时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.UNLOCK) -- 技能、武将伙伴库、背包仓库等解锁时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.NEW_MESSAGE) -- 友/聊/修/队/团等出现提示音效
        Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS) -- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
        Sound:play(ClientEnum.SOUND_KEY.SIT) -- 下滑打坐或取消打坐时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.MOUNTS) -- 上滑上坐骑或在坐骑界面点击骑乘上坐骑的时候播放的音效，取消坐骑同理
        Sound:play(ClientEnum.SOUND_KEY.PROCESS) -- 背包-合成、副本-过关斩将-圣物强化、锻造-镶嵌播放的音效
        Sound:play(ClientEnum.SOUND_KEY.MACHINING) -- 锻造界面-强化/洗炼/打造
        Sound:play(ClientEnum.SOUND_KEY.READLINE_EVENT) -- 传送/采集/钓鱼等等读条事件的音效
        Sound:play(ClientEnum.SOUND_KEY.DROP_ITEMS) -- 怪物死亡掉落奖励时的音效
        Sound:play(ClientEnum.SOUND_KEY.GET_PARTNER) -- 获得坐骑、武将时的专用音效
        Sound:play(ClientEnum.SOUND_KEY.GET_TASK) -- 领取任务时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.FINISH_TASK) -- 完成任务时播放的音效
        Sound:play(ClientEnum.SOUND_KEY.SORT_BAG) -- 整理背包时播放的音效

]]
function Test:one_key_get_hero()--一键开启所有武将
     local f1 = function(x,y)
     	local msg = {value=999,type="50010"..x.."0"..y,cmd="addBag"}
	  	Net:send(msg,"base","Debug")
	  
	 end
    local list = {}
     
   for x=1,4 do
     for y=1,9 do
      list[#list+1] = {x=x,y=y}
     end
    end
	local t = nil
	local idx = 0
	local cb = function()
		idx = idx + 1
		if list[idx] then
			f1(list[idx].x,list[idx].y)
		else
			t:stop()
			t = nil
		end
	end
	t = Schedule(cb,0.1)
  end

    		
function Test:one_key_get_surface(j)--一键获取外观 传值0：聊天气泡 1：法师外观 2：射手外观 4：战士外观
    local job = j         
    local f1 = function(x,y,z)
    local surfaceType = x-6
    
    if surfaceType <=3 then  
    local msg = surfaceType..job..z.."0"..y.."1"
    LuaItemManager:get_item_obejct("surface"):active_surface_c2s(msg)
    end
    local msg2 = {value=1,type="403"..x..job.."0"..z..y,cmd="addBag"}
	Net:send(msg2,"base","Debug")
	end
    local list = {}   
    for x=5,9 do
     for y=0,9 do
      for z=0,1 do
       list[#list+1] = {x=x,y=y,z=z}
      end
     end
    end
	
	local t = nil
	local idx = 0
	local cb = function()
		idx = idx + 1
		if list[idx] then
			f1(list[idx].x,list[idx].y,list[idx].z)
		else
			t:stop()
			t = nil
		end
	end
	t = Schedule(cb,0.2)
end


function Test:waiguan()
	local BagUserData = require("models.bag.bagUserData")
	local code_list = {}
	local list = {}
	for i=35,41 do
		list[#list+1] = BagUserData:get_item_for_type(4,i)
	end
	for i,l in ipairs(list) do
		for i,v in ipairs(l) do
			local data = v
			if data.career == 0 or data.career == LuaItemManager:get_item_obejct("game"):get_career() then
				code_list[#code_list+1] = v.code
			end
		end
	end
	local t = nil
	local idx = 0
	local cb = function()
		idx = idx + 1
		if code_list[idx] then
			self:add_item(code_list[idx],1)
		else
			t:stop()
			t = nil
		end
	end
	t = Schedule(cb,0.1)
end

function Test:lianji(range)
	if self.lianji_t then
		self.lianji_t:stop()
		self.lianji_t = nil
	end
	local roleid = LuaItemManager:get_item_obejct("game"):getId()
	if range and range<0 then
		return
	elseif range==0 then
		local angle = 0
		local cb = function()
			angle = angle >1000 and 0 or angle+25
			local battle = LuaItemManager:get_item_obejct("battle")
			local character = battle.character
			local pos = character.position
			print(pos)
			local skill_code = LuaItemManager:get_item_obejct("skill"):get_skill_id(ServerEnum.SKILL_POS.NORMAL_3)
			local msg ={posX= pos.x*10,posY= pos.z*10, code = skill_code, dir = angle, caster = roleid, }
			Net:send(msg,"scene","SkillCast")
		end
		self.lianji_t = Schedule(cb,0.1)
		return
	end
	local data = ConfigMgr:get_config("map.mapMonsters")[LuaItemManager:get_item_obejct("map").mapdata.mapId]
	local list = {}
	for i,v in ipairs(data[ServerEnum.MAP_OBJECT_TYPE.CREATURE_CENTER] or {}) do
		list[#list+1] = {x = v.pos.x, y = v.pos.y}
	end
	local offset = {
		{x=25,y=25},
		{x=-25,y=0},
		{x=-25,y=-25},
		{x=25,y=0},
		{x=25,y=-25},
		{x=0,y=25},
		{x=0,y=0},
		{x=0,y=-25},
		{x=-25,y=25},
	}
	local angle = 0
	local pos = 1
	local cb = function()
		local posX = nil
		local posY = nil
		angle = angle+35
		if angle>=720 then

				Net:receive({}, ClientProto.OnStopAutoMove)
			angle = 0
			pos = pos+1
			if pos>#list then
				pos = 1
			end
			if true then
				-- Net:receive(true, ClientProto.AutoAtk)
				local battle = LuaItemManager:get_item_obejct("battle")
				local character = battle.character
				posX = list[pos].x
				posY = list[pos].y
				character:set_position(battle:covert_s2c_position(posX,posY))
				character:reset_camera()
				local msg = {srcX = posX,srcY = posY,dir = angle,mode = true}
				Net:send(msg,"scene","PlayerMove")
			end
		end
		local f = UnityEngine.Random.Range(1,#offset)
		posX = list[pos].x + offset[f].x
		posY = list[pos].y + offset[f].y
		local skill_code = LuaItemManager:get_item_obejct("skill"):get_skill_id(ServerEnum.SKILL_POS.NORMAL_3)
		local msg ={posX= posX,posY= posY, code = skill_code, dir = angle, caster = roleid, }
		Net:send(msg,"scene","SkillCast")
	end

	self.lianji_t = Schedule(cb,0.1)
end

function Test:set_auto_question(value)
	self.auto_question = value
	Net:send({},"task","GetQuestionInfo")
end

function Test:get_dis(a,b)
	if type(a)=="string" then
		a = GameObject.Find(a)
	end
	if type(b)=="string" then
		b = GameObject.Find(b)
	end
	local dis = Vector3.Distance(a.transform.position,b.transform.position)
	print(dis)
	return dis
end