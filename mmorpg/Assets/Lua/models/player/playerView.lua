--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-15 12:24:19
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local NormalTipsView = require("common.normalTipsView")
local UIModel = require("common.UI3dModel")

local PlayerView=class(UIBase,function(self, item_obj, ui)
    self.game_obj = LuaItemManager:get_item_obejct("game")
    self:set_bg_visible(true)
	UIBase._ctor(self, "player_self.u3d", item_obj) -- 资源名字全部是小写

end)

-- 资源加载完成
function PlayerView:on_asset_load(key,asset)
	self.init = true
	self:show()
end

function PlayerView:init_ui()
	self:init_left()
	self:init_right()

end

function PlayerView:switch_type(type)
	if type == 0 then
	self.refer:Get("baseAttri").gameObject:SetActive(true)
    self.refer:Get("speAttri").gameObject:SetActive(false)
	self.refer:Get("speSel").gameObject:SetActive(false)
	self.refer:Get("baseSel").gameObject:SetActive(true)
    
    elseif type == 1 then
    self.refer:Get("baseAttri").gameObject:SetActive(false)
    self.refer:Get("speAttri").gameObject:SetActive(true)
    self.refer:Get("speSel").gameObject:SetActive(true)
	self.refer:Get("baseSel").gameObject:SetActive(false)
   

 end
end

function PlayerView:init_right()

	-- 玩家名字
	self.refer:Get("playerName").text = self.game_obj:getName().." Lv."..self.game_obj:getLevel()

	--玩家头像
	gf_set_head_ico(self.refer:Get("character_icon_img"),LuaItemManager:get_item_obejct("game"):getHead())

	-- 职业
	self.refer:Get("careerTxt").text = ClientEnum.JOB_NAME[self.game_obj:get_career()]

	-- 军团
	-- self.legion.text = self.player_data.guild
	local legion_name = LuaItemManager:get_item_obejct("legion"):get_name()
	if not legion_name or legion_name =="" then
		legion_name =  "暂无"
	end
	self.refer:Get("legionTxt").text = legion_name
	
	-- 伴侣
	-- self.partner.text = self.player_data.spouse
	self.refer:Get("partnerTxt").text = "暂无"

	-- 称号
	self.refer:Get("chenghaoTxt").text =LuaItemManager:get_item_obejct("gameOfTitle"):set_title_name()
	
	-- 攻击
	self.refer:Get("powerTxt").text = self.game_obj:get_atk()
	
	-- 生命
	self.refer:Get("hpTxt").text = self.game_obj:get_hp()

	-- 物理防御
	self.refer:Get("phyDefTxt").text = self.game_obj:get_phy_def()

	-- 法术防御
	self.refer:Get("magicDefTxt").text = self.game_obj:get_magic_def()

	-- 暴击
	self.refer:Get("critTxt").text = self.game_obj:get_crit()

	-- 命中
	self.refer:Get("hitTxt").text = self.game_obj:get_hit()

	-- 穿透
	self.refer:Get("throughTxt").text = self.game_obj:get_through()

	-- 格挡
	self.refer:Get("blockTxt").text = self.game_obj:get_block()

	-- 闪避
	self.refer:Get("dodgeTxt").text = self.game_obj:get_dodge()

	-- 坚韧
	self.refer:Get("tenacityTxt").text = self.game_obj:get_crit_def()

	-- 免伤
	self.refer:Get("notHurtTxt").text = self.game_obj:get_damage_down()

	-- 经验
	self.refer:Get("pro").fillAmount = self.game_obj:get_exp()/self.game_obj:get_max_exp()
	self.refer:Get("proTxt").text = self.game_obj:get_exp().."/"..self.game_obj:get_max_exp()

	--回血
	self.refer:Get("bloodReturnTxt").text = self.game_obj:get_recover()

	-- 伤害加深
	self.refer:Get("dmgDeepenTxt").text = (self.game_obj:get_final_damage_prob()*0.01).."%"

	-- 伤害减免
	self.refer:Get("dmgDerateTxt").text = (self.game_obj:get_damage_down_prob()*0.01).."%"

	-- 暴击率
	self.refer:Get("critRateTxt").text = (self.game_obj:get_crit_prob()*0.01).."%"

	-- 暴击伤害
	self.refer:Get("dmgCritTxt").text = ((self.game_obj:get_crit_hurt_prob()+15000)*0.01).."%"

    -- 命中率
	self.refer:Get("hitRateTxt").text = (self.game_obj:get_hit_prob()*0.01).."%"

    -- 闪避率
	self.refer:Get("dodgeRateTxt").text = (self.game_obj:get_dodge_prob()*0.01).."%"

    -- 穿透率
	self.refer:Get("throughRateTxt").text = (self.game_obj:get_through_prob()*0.01).."%"

    -- 坚韧率
	self.refer:Get("tenacityRateTxt").text = (self.game_obj:get_crit_def_prob()*0.01).."%"
 
    -- 格挡率
	self.refer:Get("blockRateTxt").text = (self.game_obj:get_block_prob()*0.01).."%"

	-- 回血率
	self.refer:Get("bloodReturnRateTxt").text = (self.game_obj:get_recover_prob()*0.01).."%"

end


function PlayerView:init_left()
	-- 战力
	self.refer:Get("atkTxt").text = self.game_obj:getPower()

	--加载人物模型
	if not self.ui_model then
	    self.ui_model = UIModel(LuaHelper.FindChild(self.root, "model"))
	end
    self.ui_model:set_player(true)
	self.ui_model:set_career()
	self.ui_model:set_local_position(Vector3(0,-1.5,3))
	self.ui_model:set_model()
	self.ui_model:set_weapon()
	self.ui_model:set_wing()
	self.ui_model:set_surround()
	self.ui_model:load_model()
end

-- 显示基础属性提示
function PlayerView:show_base_attribute_tips()
	local config = ConfigMgr:get_config("roleTips")
	local data = {}

	local list = {
		Enum.GEM_TYPE.ATTACK,
		Enum.GEM_TYPE.HP,
		Enum.GEM_TYPE.PHY_DEF,
		Enum.GEM_TYPE.MAGIC_DEF
	}

	for i,v in ipairs(list) do
		local d = config[v]
		data[#data+1] = d.property.."："..d.content
	end

	NormalTipsView(self.item_obj, data)
end

-- 显示特殊属性提示
function PlayerView:show_special_attribute_tips()
	local config = ConfigMgr:get_config("roleTips")
	local data = {}

	local list = {
		Enum.COMBAT_ATTR.CRIT,
		Enum.COMBAT_ATTR.RECOVER,
		Enum.COMBAT_ATTR.HIT,
		Enum.COMBAT_ATTR.DODGE,
		Enum.COMBAT_ATTR.THROUGH,
		Enum.COMBAT_ATTR.CRIT_DEF,
		Enum.COMBAT_ATTR.DAMAGE_DOWN,
		Enum.COMBAT_ATTR.BLOCK,
		Enum.COMBAT_ATTR.CRIT_HURT_PROB,
	}

	for i,v in ipairs(list) do
		local d = config[v]
		data[#data+1] = d.property.."："..d.content
	end

	NormalTipsView(self.item_obj, data)
end

--鼠标单击事件
function PlayerView:on_click(obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "chengHaoinput" then -- 称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- gf_create_model_view("gameOfTitle")
		LuaItemManager:get_item_obejct("player").assets[1]:select_page(5)
	elseif cmd == "upLevelBtn" then -- 显示升级信息
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

	elseif cmd == "changeIconBtn" then -- 更换头像
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

	elseif cmd == "baseAttributeBtn" then -- 显示基本属性信息tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:show_base_attribute_tips()
		gf_show_doubt(1171)
	elseif cmd == "specialAttributeBtn" then -- 显示特殊属性信息tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:show_special_attribute_tips()
		gf_show_doubt(1172)
	
    elseif cmd == "speAttriSwitchBtn" then -- 显示特殊属性信息
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:switch_type(1)
    elseif cmd == "baseAttriSwitchBtn" then --显示特殊属性信息
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:switch_type(0)
    
	elseif cmd == "btnreformName" then --改名字
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local bag = LuaItemManager:get_item_obejct("bag")
		local tb = bag:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.NAME_CHANGE_CARD,ServerEnum.BAG_TYPE.NORMAL)
		gf_print_table(tb,"改名字")
		if #tb ~= 0 then
		 	for k,v in pairs(tb) do
		 		if v.data.color == 3 then
		 			self.item_obj:change_name_tip()
		 			return
		 		end
		 	end
		end
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("您没有改名卡，是否前往商城购买?",
			function() 
			local Mall = LuaItemManager:get_item_obejct("mall")
			for k,v in pairs( ConfigMgr:get_config("goods")) do
			 	if v.shop_type == ClientEnum.SHOP_TYPE.NAME_CHANGE_CARD  then
			 		if  ConfigMgr:get_config("item")[v.item_code].color == 3 then 
			 			self.item_obj.assets[1]:dispose()
			 			Mall:set_model(1,2,v.goods_id)
						Mall:add_to_state()
					end
			 	end
			end
			end,function()  end,"是","否")
		-- self.item_obj.assets[1]:dispose()
		-- LuaItemManager:get_item_obejct("mall"):add_to_state()
    elseif cmd == "baseAttriSwitchBtn" then -- 显示特殊属性信息
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:show_special_attribute_tips()
		gf_show_doubt(1172)  

	end
end


function PlayerView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.TitleChange  then
		self:change_title(msg)
	elseif id1 == ClientProto.refreshPlayerName then--刷新玩家名字
		self.refer:Get("playerName").text = self.game_obj:getName().." Lv."..self.game_obj:getLevel()
	end
end

function PlayerView:change_title(msg)
	if msg.title_id == 0 then
		self.refer:Get("chenghaoTxt").text ="暂无"
	else
		local data =  ConfigMgr:get_config("title")[msg.title_id]
		self.refer:Get("chenghaoTxt").text = data.name
	end
	gf_print_table(msg,"称号更改")
	
end

function PlayerView:on_hided()
	StateManager:remove_register_view( self )
end

function PlayerView:on_showed()
	if self.init then
		StateManager:register_view( self )
		if self.ui_model then
			self.ui_model:on_showed()
		end
		self:init_ui()
	end
end

-- 释放资源
function PlayerView:dispose()
	if self.ui_model then
		self.ui_model:dispose()
		self.ui_model = nil
	end
	self.init = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return PlayerView

