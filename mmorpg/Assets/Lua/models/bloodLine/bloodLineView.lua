--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-21 15:31:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local SpriteBase = require("common.spriteBase")
local HP = LuaHelper.Find("HP")

local BloodLineView=class(SpriteBase,function(self, url, ...)
    SpriteBase._ctor(self, url, ...) -- 资源名字全部是小写
end)

-- 资源加载完成
function BloodLineView:init()
	if not HP then
		HP = LuaHelper.Find("HP")
	end

	self:set_parent(HP.transform)
	self:init_ui()

	self:set_info(self.name, self.title, self.job)
	self:set_hp(self.hp)
	self:set_vip(5)
end

-- 设置信息
function BloodLineView:set_info( name, title, job )
	self.name = name
	self.title = title
	self.job = job
	if self.is_init then
		self.name_txt.text = name or "玩家名"

		if LuaItemManager:get_item_obejct("rvr"):is_rvr() then -- 战场不显示称号
			return
		end
		local setting = LuaItemManager:get_item_obejct("setting")
		local visible = not setting:get_setting_value(ClientEnum.SETTING.SHIELD_TITLE)

		if title ~= 0 and title ~=nil and title ~="" and visible then
			local title_info = ConfigMgr:get_config("title")[title]
			if title_info.category == ClientEnum.TITLE_SHOW_TYPE.TEXT then
				local color = ConfigMgr:get_config("color")[title_info.color_limit].color
				self.title_txt.text = "<color=".. color ..">"..title_info.name.."</color>"
				self.title_txt.gameObject:SetActive(true)
				self.img_static_title.gameObject:SetActive(false)
			elseif title_info.category == ClientEnum.TITLE_SHOW_TYPE.STATIC then
				gf_setImageTexture(self.img_static_title,title_info.icon)
				self.img_static_title.gameObject:SetActive(true)
				self.title_txt.gameObject:SetActive(false)
			elseif title_info.category == ClientEnum.TITLE_SHOW_TYPE.DYNAMIC then	
			end
			-- self:set_title_visible(visible)
		else
			self:set_title_visible(false)
		end
	end
end

function BloodLineView:set_name( name )
	self.name = name
	self.name_txt.text = name or "玩家名"
end

function BloodLineView:set_title(title)
	if self.title_txt then
		self.title_txt.text = title or ""
	end
end

function BloodLineView:set_hp( hp )
	self.hp = hp
	if self.is_init and self.hp_img then
		self.hp_img.fillAmount = self.hp or 1
	end
end

function BloodLineView:set_vip( vipLv )
	if self.vip_obj then
		if vipLv and vipLv>0 then
			self.vip_obj:SetActive(true)
			self.vip_lv.text = vipLv
		else
			self.vip_obj:SetActive(false)
		end
	end
end

function BloodLineView:show_npc_talk(tf)
	if not self.npc_talk then
		self.npc_talk = self.refer:Get("talk")
	end
	if tf then
		self.npc_talk:SetBool("show", true)
		self.npc_talk:SetBool("hide", false)
	else
		self.npc_talk:SetBool("show", false)
		self.npc_talk:SetBool("hide", true)
	end
end

function BloodLineView:set_monster_talk_text(txt)
	self.refer:Get(7):SetActive(true)
	self.refer:Get(6).text = txt
end

function BloodLineView:hide_npc_talk()
	if not self.npc_talk then
		self.npc_talk = self.refer:Get("talk")
	end
	self.npc_talk:SetBool("show", false)
	self.npc_talk:SetBool("hide", false)
end

function BloodLineView:set_npc_talk_text(txt)
	self.npc_talk_text.text = string.gsub(txt, "\\n", "\n")
end

function BloodLineView:set_local_position( position )
	if not position then
		return
	end
	self.obj.transform.localPosition = position
end

function BloodLineView:set_hp_visible( visible )
	if self.visible == visible then
		return
	end
	
	self.visible = visible or false
	if self.hp_bar then
		self.hp_bar:SetActive(self.visible)
	end
end

-- 设置是否显示名字
function BloodLineView:set_name_visible( visible )
	if self.name_txt then
		self.name_txt.gameObject:SetActive(visible)
	end
end
--设置显示称号
function BloodLineView:set_title_visible( visible)
	if self.img_static_title then
		self.img_static_title.gameObject:SetActive(visible)
		self.title_txt.gameObject:SetActive(visible)
	end
end

function BloodLineView:set_target( target )
	self.hp_follow:SetTarget(target)
end

function BloodLineView:set_update( flag )
	self.hp_follow:SetUpdateHp(flag)
end

function BloodLineView:refresh_hp(force)
	if self.hp_follow:IsUpdate() or force then
		self.hp_follow:UpdateHp()
	end
end

function BloodLineView:set_offset( offset )
	self.hp_follow.offset = offset
end

function BloodLineView:set_energy_1( quality )
	quality = quality or 0
	if not LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		quality = 0
	end

	self.energy_1.gameObject:SetActive(quality>0)
	if quality > 0 then
		gf_setImageTexture(self.energy_icon_1, "rvr_power_beads_0"..quality)
	end
end

function BloodLineView:set_energy_2( quality )
	quality = quality or 0
	if not LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		quality = 0
	end

	self.energy_2.gameObject:SetActive(quality>0)
	if quality > 0 then
		gf_setImageTexture(self.energy_icon_2, "rvr_power_beads_0"..quality)
	end
end

function BloodLineView:set_energy_3( quality )
	quality = quality or 0
	if not LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		quality = 0
	end

	self.energy_3.gameObject:SetActive(quality>0)
	if quality > 0 then
		gf_setImageTexture(self.energy_icon_2, "rvr_power_beads_0"..quality)
	end
end

-- 显示掉落归属
function BloodLineView:show_drop( visible )
	local drop = self.refer:Get("drop")
	if drop then
		drop:SetActive(visible)
	end
end

-- 是否有能量珠
function BloodLineView:is_have_energy()
	return self.energy_1.activeSelf or self.energy_2.activeSelf or self.energy_3.activeSelf
end

function BloodLineView:set_faction( faction )
	local is_rvr = LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.FACTION)
	local is_3v3 = LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.TEAM_VS)
	if faction and faction > 0 and (is_rvr == true or is_3v3 == true)then
		self.faction.gameObject:SetActive(true)
		gf_setImageTexture(self.faction, "rvr_realm_0"..faction)
	else
		self.faction.gameObject:SetActive(false)
	end
end

-- 释放资源
function BloodLineView:dispose()
	BloodLineView._base.dispose(self)
end

--初始化Ui
function BloodLineView:init_ui()
	self.refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	self.name_txt = self.refer:Get("name")
	
	self.title_txt = self.refer:Get("title")
	self.img_static_title = self.refer:Get("img_static_title")

	self.hp_bar = self.refer:Get("hp_bar")
	self.hp_img = self.refer:Get("hp")

	self.obj = self.refer:Get("obj")
	self.hp_follow = self.obj:AddComponent("Seven.HpFollow")
	self.hp_follow.hp = self.obj.transform

	self.vip_obj = self.refer:Get("vip_obj")
	if self.vip_obj then
		self.vip_obj:SetActive(false)
	end
	self.vip_lv = self.refer:Get("vip_lv")

	self.npc_talk = self.refer:Get("talk")
	self.npc_talk_text = self.refer:Get("txt_talk")

	-- 能量珠（玩家血条才有）
	self.energy_1 = self.refer:Get("energy_1")
	self.energy_2 = self.refer:Get("energy_2")
	self.energy_3 = self.refer:Get("energy_3")
	self.energy_icon_1 = self.refer:Get("energy_icon_1")
	self.energy_icon_2 = self.refer:Get("energy_icon_2")
	self.energy_icon_3 = self.refer:Get("energy_icon_3")

	-- 阵营
	self.faction = self.refer:Get("rvrIcon")
	if self.faction then
		self.faction.gameObject:SetActive(false)
	end

	self:set_visible(false)
end

return BloodLineView