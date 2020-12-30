--[[--
-- 首冲 首充
-- @Author:HuangJunShan
-- @DateTime:2017-09-19 09:34:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local heroShow = require("models.hero.heroShowHeroInfo")
local UIModel = require("common.uiModel")

local init = nil
local on_show = nil

local sel_day = nil

local FirstTopUp=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "first_top_up.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function FirstTopUp:on_asset_load(key,asset)
	init = true
	self.ui_models = {}
	self:init_ui()
	self:select_day(self.item_obj:get_FristTopUpReward(1) and 1 or (self.item_obj:get_FristTopUpReward(2) and 2) or 3)
end

function FirstTopUp:init_ui()
	local normal_list = self.refer:Get("normal_list")
	self.normal_list = {}
	for i=1,normal_list.childCount do
		self.normal_list[i] = normal_list:GetChild(i-1).gameObject
	end
	local hl_list = self.refer:Get("hl_list")
	self.hl_list = {}
	for i=1,hl_list.childCount do
		self.hl_list[i] = hl_list:GetChild(i-1).gameObject
	end
	local item_list = self.refer:Get("item_list")
	self.item_list = {}
	for i=1,item_list.childCount do
		self.item_list[i] = item_list:GetChild(i-1):GetComponent("ReferGameObjects")
	end
end

function FirstTopUp:select_day(day)
	if sel_day then
		self.hl_list[sel_day]:SetActive(false)
	end
	sel_day = day
	self.hl_list[sel_day]:SetActive(true)
	self:set_item_list(day)
	self:set_btn_active()
end

function FirstTopUp:set_item_list(day)
	local reward = ConfigMgr:get_config("first_recharge")[day].reward
	for i,v in ipairs(self.item_list) do
		local data = reward[i]
		if data then -- data[3]
			v.gameObject:SetActive(true)
			gf_set_item(data[1],v:Get("icon"),v:Get("bg"))
			v:Get("count").text = data[2]
			local item_data = ConfigMgr:get_config("item")[data[1]]
			v:Get("binding"):SetActive(item_data.bind==1)
			local hero_data = ((item_data.type == Enum.ITEM_TYPE.PROP -- 大类4
			 		-- 小类17或45
					and (item_data.sub_type == Enum.PROP_TYPE.RAND_GIFT_HERO or item_data.sub_type == Enum.PROP_TYPE.HERO_ITEM))
					or (item_data.type == Enum.ITEM_TYPE.VIRTUAL and item_data.sub_type == Enum.VIRTUAL_TYPE.HERO_CHIP))
					and ConfigMgr:get_config("hero")[item_data.effect[1]]
			-- print("是否武将",hero_data,data[1])
			gf_set_click_prop_tips(v,data[1])
			if i == 1 then
				local model = self.refer:Get("model")
				model:SetActive(hero_data and true or false)
				if hero_data then
					local scale = 1.5
					if self.ui_models.cur_model then
						self.ui_models.cur_model.root:SetActive(false)
					end
					if not self.ui_models[hero_data.hero_id] then
						-- print(hero_data.hero_id) --420002
	    				self.ui_models[hero_data.hero_id] = UIModel(model,Vector3(0,-2,4),false,nil,{model_name = hero_data.hero_id..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale*hero_data.scale_rate1,scale*hero_data.scale_rate1,scale*hero_data.scale_rate1)})
	    				self.ui_models.cur_model = self.ui_models[hero_data.hero_id]
	    			else
	    				self.ui_models[hero_data.hero_id].root:SetActive(true)
	    				self.ui_models[hero_data.hero_id].root.transform.localEulerAngles = Vector3(0,158,0)
	    				self.ui_models[hero_data.hero_id]:on_showed()
	    				self.ui_models.cur_model = self.ui_models[hero_data.hero_id]
	    			end
    			end
			end
		else
			v.gameObject:SetActive(false)
			v.name = nil
		end
	end
end

function FirstTopUp:on_showed()
	if not on_show then
		StateManager:register_view( self )
		on_show = true
	end
end

function FirstTopUp:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "close_frist_top_up" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btn_normal" then
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_day(obj.transform:GetSiblingIndex()+1)
	elseif cmd == "get_reward" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_first_recharge_reward_c2s(sel_day)
	elseif cmd == "to_top_up" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_open_model(ClientEnum.MODULE_TYPE.KRYPTON_GOLD)
	end
end

--服务器返回
function FirstTopUp:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		if id2== Net:get_id2("shop", "UpdateVipLvlR") then
			-- 更新VIP等级
			self:set_btn_name()
		end
	elseif(id1==Net:get_id1("base"))then
		if id2== Net:get_id2("base", "GetFirstRechargeRewardR") then
			-- 更新vip奖励
			self:set_btn_active()
		end
	elseif id2 == Net:get_id2("base", "OnNewDayR") then
		self:set_btn_name()
	end
end

--设置按钮名称
function FirstTopUp:set_btn_name()
	-- 设置领取按钮
    if self.item_obj:get_vip_lv()>0 or self.item_obj:get_cur_exp()>0 then
    	local btn = self.refer:Get("function_btn")
    	btn.name = "get_reward"
    	local n = sel_day - self.item_obj:get_FristTopUpDay()
    	-- print("hjs万岁万岁万万岁选择的",sel_day)
    	-- print("hjs万岁万岁万万岁充值天数",self.item_obj:get_FristTopUpDay())
    	-- print("hjs万岁万岁万万岁还差几天可领",n)
    	-- print("hjs万岁万岁万万岁是否已领取",self.item_obj:get_FristTopUpReward(n))

		if not self.item_obj:get_FristTopUpReward(sel_day) then
			btn:SetActive(false)
			self.refer:Get("function_text"):SetActive(true)
		else
	    	if n ==1 then
	    		self.refer:Get("button_text").text = gf_localize_string("明天可领")
			elseif n == 2 then
				self.refer:Get("button_text").text = gf_localize_string("后天可领")
			else
		    	self.refer:Get("button_text").text = gf_localize_string("领取奖励")
		    end
			btn:SetActive(true)
			self.refer:Get("function_text"):SetActive(false)
		end
    else
    	self.get_reward_btn = nil
    	self.refer:Get("function_btn").name = "to_top_up"
    	self.refer:Get("button_text").text = gf_localize_string("前往充值")
    end
end

--设置按钮激活
function FirstTopUp:set_btn_active()
	if self.get_reward_btn then
		self.get_reward_btn.gameObject:SetActive(self.item_obj:get_FristTopUpReward(sel_day))
	end
	self:set_btn_name()
end

function FirstTopUp:on_hided()
	on_show = nil
	StateManager:remove_register_view( self )
end

-- 释放资源
function FirstTopUp:dispose()
	self:hide()
	init = nil
    self._base.dispose(self)
end

return FirstTopUp