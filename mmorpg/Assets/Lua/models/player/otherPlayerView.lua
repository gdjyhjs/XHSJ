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

local OtherPlayerView=class(UIBase,function(self, item_obj, player_data)
    self.game_obj = LuaItemManager:get_item_obejct("game")
    self.player_data = player_data
    gf_print_table(self.player_data,"查看的玩家数据")
    self:set_bg_visible(true)
    UIBase._ctor(self, "player_other_ui.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function OtherPlayerView:on_asset_load(key,asset)
	
	self:hide_mainui()
	self.career_name = {
		[Enum.CAREER.SOLDER] = gf_localize_string("修罗"),
		[Enum.CAREER.MAGIC] = gf_localize_string("阎姬"),
		[Enum.CAREER.BOWMAN] = gf_localize_string("夜狩")
	}
	
	self:init_ui()
end

function OtherPlayerView:on_showed()
	StateManager:register_view( self )
	if self.ui_model then
		self.ui_model:on_showed()
	end
end

function OtherPlayerView:on_hided()
	StateManager:remove_register_view( self )
end

function OtherPlayerView:init_ui()
	self.ui = self.root

	self:init_left()

	self:set_info(self.player_data)

	local career = self.player_data.career
	local model_id
	local weapon_id
	if not self.player_data.helmetProtoId or self.player_data.helmetProtoId == 0 then
		model_id = ConfigMgr:get_config("career_default_model")[career].model_id
	else
		model_id = ConfigMgr:get_config("item")[self.player_data.helmetProtoId].effect_ex[1]
	end
	if not self.player_data.weaponProtoId or self.player_data.weaponProtoId == 0 then
		weapon_id = ConfigMgr:get_config("career_default_weapon")[career].model_id
	else
		weapon_id = ConfigMgr:get_config("item")[self.player_data.weaponProtoId].effect_ex[1]
	end
	
	--加载人物模型
    self.ui_model = UIModel(self.refer:Get("model"))
    self.ui_model:set_player(true)
	self.ui_model:set_career(career)
	self.ui_model:set_local_position(Vector3(0,-1.5,3))
	if model_id then
		self.ui_model:set_model(model_id)
	end
	if weapon_id then
		self.ui_model:set_weapon(weapon_id)
	end

	for k,v in pairs(self.player_data.wearSurfaceIds or {}) do
		if v > 0 then
			local data = ConfigMgr:get_config("surface")[v]
			local model = data.model
			local model_img = data.model_img
			local flow_img = data.flow_img
			local flow_color = data.flow_color
			local flow_speed = data.flow_speed
			local effect = data.effect
			if k == ServerEnum.SURFACE_TYPE.CLOTHES then
				self.ui_model:set_model(model)

			elseif k == ServerEnum.SURFACE_TYPE.WEAPON then
				self.ui_model:set_weapon(model)
				if model_img then
					self.ui_model:set_weapon_img(model_img)
				end
				if flow_img then
					self.ui_model:set_weapon_flow_img(flow_img,flow_color,flow_speed)
				end
				if effect then
					self.ui_model:set_weapon_effect(effect)
				end

			elseif k == ServerEnum.SURFACE_TYPE.CARRY_ON_BACK then
				self.ui_model:set_wing(model)

			elseif k == ServerEnum.SURFACE_TYPE.SURROUND then
				self.ui_model:set_surround(model)

			end
		end
	end

	self.ui_model:load_model()

    self:show_character(true)
    self.is_init = true
end

function OtherPlayerView:switch_type(type)
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

function OtherPlayerView:init_left()
	-- 战力
	self.atk = LuaHelper.FindChildComponent(self.root, "atkTxt", "UnityEngine.UI.Text")

end

function OtherPlayerView:set_info(info)
	if self.player_data==info and self.is_init then
		return
	else
		self.player_data=info
	end
	-- 玩家名字
	self.refer:Get("playerName").text = self.player_data.name.." Lv."..self.player_data.level

	--玩家头像
	gf_set_head_ico(self.refer:Get("character_icon_img"),self.player_data.head)

	-- 职业
	self.refer:Get("careerTxt").text = self.career_name[self.player_data.career]

	-- 军团
	self.refer:Get("legionTxt").text =  self.player_data.allianceName or "暂无"

	-- 伴侣
	self.refer:Get("partnerTxt").text = "暂无"

	-- 称号
	self.refer:Get("chenghaoTxt").text= self:get_title_name() or "暂无"

	-- 攻击
	self.refer:Get("powerTxt").text  = self.player_data.combatAttr[ServerEnum.COMBAT_ATTR.ATTACK]

	-- 生命
	self.refer:Get("hpTxt").text = self.player_data.combatAttr[ServerEnum.COMBAT_ATTR.HP]

	-- 物理防御
	self.refer:Get("phyDefTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.PHY_DEF]

	-- 法术防御
	self.refer:Get("magicDefTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.MAGIC_DEF]

	-- 暴击
	self.refer:Get("critTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT]

	-- 命中
	self.refer:Get("hitTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.HIT]

	-- 穿透
	self.refer:Get("throughTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.THROUGH]

	-- 格挡
	self.refer:Get("blockTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.BLOCK]

	-- 闪避
	self.refer:Get("dodgeTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.DODGE]

	-- 坚韧
	self.refer:Get("tenacityTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT_DEF]

	-- 免伤
	self.refer:Get("notHurtTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.DAMAGE_DOWN]

	-- 战力
	self.refer:Get("atkTxt").text = self.player_data.power

	--回血
	self.refer:Get("bloodReturnTxt").text = self.player_data.combatAttr[Enum.COMBAT_ATTR.RECOVER] or 0

    --伤害加深
	self.refer:Get("dmgDeepenTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT_PROB]*0.01).."%" or 0

	-- 伤害减免
	self.refer:Get("dmgDerateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.DAMAGE_DOWN_PROB]*0.01).."%"

	-- 暴击率
	self.refer:Get("critRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT_PROB]*0.01).."%"

	-- 暴击伤害
	self.refer:Get("dmgCritTxt").text = ((self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT_HURT_PROB]+15000)*0.01).."%"

    -- 命中率
	self.refer:Get("hitRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.HIT_PROB]*0.01).."%"

    -- 闪避率
	self.refer:Get("dodgeRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.DODGE_PROB]*0.01).."%"

    -- 穿透率
	self.refer:Get("throughRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.THROUGH_PROB]*0.01).."%"

    -- 坚韧率
	self.refer:Get("tenacityRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.CRIT_DEF_PROB]*0.01).."%"
 
    -- 格挡率
	self.refer:Get("blockRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.BLOCK_PROB]*0.01).."%"

	-- 回血率
	self.refer:Get("bloodReturnRateTxt").text = (self.player_data.combatAttr[Enum.COMBAT_ATTR.RECOVER_PROB]*0.01).."%"



end


function OtherPlayerView:get_title_name()
	local data = ConfigMgr:get_config("title")[self.player_data.title]
	if data then
		return data.name
	end
end

-- 显示基础属性提示
function OtherPlayerView:show_base_attribute_tips()
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
function OtherPlayerView:show_special_attribute_tips()
	local config = ConfigMgr:get_config("roleTips")
	local data = {}

	local list = {
		Enum.GEM_TYPE.CRIT,
		Enum.COMBAT_ATTR.RECOVER,
		Enum.GEM_TYPE.HIT,
		Enum.GEM_TYPE.DODGE,
		Enum.GEM_TYPE.THROUGH,
		Enum.GEM_TYPE.CRIT_DEF,
		Enum.GEM_TYPE.DAMAGE_DOWN,
		Enum.GEM_TYPE.BLOCK,
		Enum.GEM_TYPE.CRIT_HURT,
	}

	for i,v in ipairs(list) do
		local d = config[v]
		data[#data+1] = d.property.."："..d.content
	end

	NormalTipsView(self.item_obj, data)
end

-- 显示角色或装备
function OtherPlayerView:show_character( visible )
	self.refer:Get("charactar"):SetActive(visible)
	self.refer:Get("equipment"):SetActive(not visible)
	if not visible then
		self.item_obj:other_player_simple_equip(self.player_data.roleId)
	end

	if self.ui_model then
		self.ui_model:on_showed()
	end
end

--设置其他玩家装备信息
function OtherPlayerView:set_equip(equipList)
	local set_list = {}
	local root = self.refer:Get("equipListTF")
	print(root)
	for i,v in ipairs(equipList) do
		local data = ConfigMgr:get_config("item")[v.protoId]
		local child = root:GetChild(data.sub_type-1)
		local icon = child:FindChild("icon").gameObject
		gf_set_item(v.protoId,icon:GetComponent(UnityEngine_UI_Image),child:GetComponent(UnityEngine_UI_Image),v.color,v.star)
		icon:SetActive(true)
		set_list[data.sub_type] = 1
		child.name = "otherEquip_"..v.guid
	end
	for i=1,10 do
		if not set_list[i] then
			local child = root:GetChild(i-1)
			if child then
				child:FindChild("icon").gameObject:SetActive(false)
				gf_setImageTexture(child:GetComponent(UnityEngine_UI_Image),"item_color_0")
				child.name = nil
			else
				return
			end
		end
	end
end

--鼠标单击事件
function OtherPlayerView:on_click(obj, arg)
	print("其他玩家信息界面点击",obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "playerCloseBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "chengHaoBtn" then -- 称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
		LuaItemManager:get_item_obejct("gameOfTitle"):add_to_state()
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
	elseif cmd == "baseAttriSwitchBtn" then --显示特殊属性信息
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:switch_type(0)
	elseif cmd == "speAttriSwitchBtn" then -- 显示特殊属性信息
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:switch_type(1)
	elseif cmd == "characterToggle" then -- 角色
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_character(true)

	elseif cmd == "equipmentToggle" then -- 装备
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_character(false)

	elseif cmd == "chatBtn" then -- 私聊
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
		LuaItemManager:get_item_obejct("chat"):open_private_chat_ui(self.player_data.roleId)

	elseif cmd == "friendBtn" then -- 添加好友
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("social"):apply_friend_c2s(self.player_data.roleId)

	elseif cmd == "compareBtn" then -- 对比
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_message_tips("此功能暂未开放")

	elseif cmd == "flowerBtn" then -- 赠送鲜花
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
		LuaItemManager:get_item_obejct("gift"):show_view(self.player_data)
	elseif string.find(cmd,"otherEquip_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local equip_guid = tonumber(string.split(cmd,"_")[2])
		print(equip_guid)
		LuaItemManager:get_item_obejct("itemSys"):remote_equip_tips(equip_guid,self.player_data.roleId,obj.transform.position)
	end
end

function OtherPlayerView:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("bag"))then
        if(id2== Net:get_id2("bag", "OtherPlayerSimpleEquipR"))then
			print("其他玩家简略装备信息 msg, id1, id2, sid   ",msg, id1, id2, sid)
            self:set_equip(msg.list or {})
        end
    end
end

-- 释放资源
function OtherPlayerView:dispose()
	StateManager:remove_register_view( self )
	
    self._base.dispose(self)
end

return OtherPlayerView

