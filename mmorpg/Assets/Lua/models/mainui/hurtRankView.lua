--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local HurtRankView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mozu")
    UIBase._ctor(self, "mainui_defense.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function HurtRankView:on_asset_load(key,asset)
	self.button = LuaHelper.FindChild(self.root,"btn_fromto")
	self.buttonDirect = 0	--0表示按钮方向向上，1表示向下
	self:set_always_receive(true)
	self.schedule = LuaHelper.FindChild(self.root,"schedule")
	self.damage = LuaHelper.FindChild(self.root,"damage")
	self.defense_mgr = self.refer:Get(11)
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	self.defense_mgr.from = Vector3(-half_w+dx, y, 0)
	self.defense_mgr.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("defense_mgr_rt").anchoredPosition = Vector2(dx, self.refer:Get("defense_mgr_rt").anchoredPosition.y)

	self.my_name_text = self.refer:Get(12)
	self.my_hurt_text = self.refer:Get(13)
	self.my_coin_text = self.refer:Get(14)
	self.combat_warn = self.refer:Get(17)
	self.combat_warn.text = gf_localize_string("魔族统领已降临于主城中央")
	self.build_hurt_blood = nil

	local item_obj = LuaItemManager:get_item_obejct("mozu")
	self.rank_label_txt = {}
	for i = 1,5 do
		local temp = {}
		temp.name = self.refer:Get((i - 1) * 2 + 1)
		temp.hurt = self.refer:Get((i - 1) * 2 + 2)
		if item_obj.rank_list[i] == nil then
			temp.name.text = ""
			temp.hurt.text = ""
		else
			temp.name.text = item_obj.rank_list[i].name
			temp.hurt.text = gf_format_count_kmg(item_obj.rank_list[i].hurt)
		end
		table.insert(self.rank_label_txt,temp)
	end

	self.time_txt = LuaHelper.FindChild(self.schedule,"timeTxt"):GetComponent("UnityEngine.UI.Text")
	--self.round_txt = LuaHelper.FindChild(self.schedule,"roundTxt"):GetComponent("UnityEngine.UI.Text")
	--self.next_round_txt = LuaHelper.FindChild(self.schedule,"nextRoundTxt"):GetComponent("UnityEngine.UI.Text")

	self.btn_fromto_image = LuaHelper.FindChild(self.button,"Image")
	self.btn_fromto_image1 = LuaHelper.FindChild(self.button,"Image (1)")
	self.btn_fromto_image.gameObject:SetActive(false)
	self.btn_fromto_image1.gameObject:SetActive(true)
	if Net:get_server_time_s() < item_obj.boss_apper_time then
		print("skdjfslkdjflsdkjflsdf",item_obj.boss_apper_time)
		self.schedule.gameObject:SetActive(true)
		self.damage.gameObject:SetActive(false)
		self:start_scheduler()
		self.build_hurt_blood = require("models.mainui.buildHurtView")()
		self.combat_warn.gameObject:SetActive(false)
	else
		print("skdjfslkdjflsdkjflsdf",item_obj.boss_apper_time,Net:get_server_time_s())
		self.schedule.gameObject:SetActive(false)
		self.damage.gameObject:SetActive(true)
		local ArrowParent = LuaHelper.Find("Arrow")
		if ArrowParent ~= nil then
			local child_list = LuaHelper.GetAllChild(ArrowParent)
			for i = 1, #child_list do
				child_list[i].gameObject:SetActive(true)
			end
		end
		self:show_warn()
	end
	self.my_name_text.text = item_obj.my_rank.rank .. "." .. LuaItemManager:get_item_obejct("game"):getName()
	self.my_hurt_text.text = gf_format_count_kmg(item_obj.my_rank.hurt)
	self.my_coin_text.text = item_obj.my_rank.coin
end

function HurtRankView:show_warn()
	if self.schedule_id_warn then
		return
	end
	local pass_time = 0
	local update = function(dt)
		pass_time = pass_time + dt
		if 10 < pass_time then
			self.schedule_id_warn:stop()
			self.schedule_id_warn = nil
			self.combat_warn.gameObject:SetActive(false)
		end
	end
	self.schedule_id_warn = Schedule(update, 1)
	self.combat_warn.gameObject:SetActive(true)
end

function HurtRankView:init_ui()
end

function HurtRankView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "BossBornInfoR") then
			local item_obj = LuaItemManager:get_item_obejct("mozu")
			if Net:get_server_time_s() < item_obj.boss_apper_time then
				print("skdjfslkdjflsdkjflsdf2222",item_obj.boss_apper_time)
				if self.schedule_id == nil then
					self:start_scheduler()
				end
				self.schedule.gameObject:SetActive(true)
				self.damage.gameObject:SetActive(false)
				if self.build_hurt_blood == nil then
					self.build_hurt_blood = require("models.mainui.buildHurtView")()
				end
				local ArrowParent = LuaHelper.Find("Arrow")
				if ArrowParent ~= nil then
					local child_list = LuaHelper.GetAllChild(ArrowParent)
					for i = 1, #child_list do
						child_list[i].gameObject:SetActive(false)
					end
				end
				self.combat_warn.gameObject:SetActive(false)
			else
				print("skdjfslkdjflsdkjflsdf3333",item_obj.boss_apper_time,Net:get_server_time_s())
				if self.schedule_id ~= nil then
					self:stop_schedule()
				end
				self.schedule.gameObject:SetActive(false)
				self.damage.gameObject:SetActive(true)
				if self.build_hurt_blood ~= nil then
					self.build_hurt_blood:dispose()
				end
				local ArrowParent = LuaHelper.Find("Arrow")
				if ArrowParent ~= nil then
					local child_list = LuaHelper.GetAllChild(ArrowParent)
					for i = 1, #child_list do
						child_list[i].gameObject:SetActive(true)
					end
				end
				self:show_warn()
			end
			--local str = string.format(gf_localize_string("第%d/%d波"),item_obj.monster_wave,10)
			--self.round_txt.text = str
		elseif id2 == Net:get_id2("copy", "BossHurtListR") then
			local item_obj = LuaItemManager:get_item_obejct("mozu")
			for i,v in ipairs(self.rank_label_txt) do
				if item_obj.rank_list[i] ~= nil then
					local name = i .. "." .. item_obj.rank_list[i].name
					v.name.text = name
					v.hurt.text = gf_format_count_kmg(item_obj.rank_list[i].hurt)
				else
					v.name.text = ""
					v.hurt.text = ""
				end
			end
			self.my_name_text.text = item_obj.my_rank.rank .. "." .. LuaItemManager:get_item_obejct("game"):getName()
			self.my_hurt_text.text = gf_format_count_kmg(item_obj.my_rank.hurt)
			self.my_coin_text.text = item_obj.my_rank.coin
		elseif id2 == Net:get_id2("copy", "ExitCopyR") then
			self:dispose()
			if self.build_hurt_blood ~= nil then
				self.build_hurt_blood:dispose()
			end
			local ArrowParent = LuaHelper.Find("Arrow")
			if ArrowParent ~= nil then
				local child_list = LuaHelper.GetAllChild(ArrowParent)
				for i = 1, #child_list do
					child_list[i].gameObject:SetActive(false)
				end
			end
		end
	end
	--[[if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) ~= true then
			self:dispose()
			if self.build_hurt_blood ~= nil then
				self.build_hurt_blood:dispose()
			end
		end
	end]]
end

function HurtRankView:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "btn_fromto" then
		if self.button ~= nil then
			if self.buttonDirect == 0 then
				self.buttonDirect = 1
				self.defense_mgr:PlayForward()
				self.btn_fromto_image.gameObject:SetActive(true)
				self.btn_fromto_image1.gameObject:SetActive(false)
			else
				self.buttonDirect = 0
				self.defense_mgr:PlayReverse()
				self.btn_fromto_image.gameObject:SetActive(false)
				self.btn_fromto_image1.gameObject:SetActive(true)
			end
		end
	end
end

function HurtRankView:register()
	StateManager:register_view( self )
end

function HurtRankView:cancel_register()
	StateManager:remove_register_view( self )
end

function HurtRankView:on_showed()
	self:register()
end

function HurtRankView:on_hided()
end

-- 释放资源
function HurtRankView:dispose()
	self:cancel_register()
	self:stop_schedule()
	if self.schedule_id_warn then
		self.schedule_id_warn:stop()
		self.schedule_id_warn = nil
	end
    self._base.dispose(self)
end

function HurtRankView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	
	local update = function()
		local item_obj = LuaItemManager:get_item_obejct("mozu")
		if item_obj.boss_apper_time <= Net:get_server_time_s() then
			self:stop_schedule()
			self.schedule.gameObject:SetActive(false)
			self.damage.gameObject:SetActive(true)
			if self.build_hurt_blood ~= nil then
				self.build_hurt_blood:dispose()
			end
			local ArrowParent = LuaHelper.Find("Arrow")
			if ArrowParent ~= nil then
				local child_list = LuaHelper.GetAllChild(ArrowParent)
				for i = 1, #child_list do
					child_list[i].gameObject:SetActive(true)
				end
			end
			self:show_warn()
		else
			local left_time = item_obj.boss_apper_time - Net:get_server_time_s()
			self.time_txt.text = gf_convert_time_ms(math.floor(left_time))

			--[[left_time = item_obj.next_refresh_time - Net:get_server_time_s()
			self.next_round_txt.text = gf_convert_time_ms(left_time)]]
		end		
	end
	self.schedule_id = Schedule(update, 0.1)
end

function HurtRankView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

return HurtRankView

