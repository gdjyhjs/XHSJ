--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-03 11:34:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string = 
{
	[1] = gf_localize_string("三星通关才能进行扫荡"),
	[2] = gf_localize_string("今日挑战次数已用完"),
	[3] = gf_localize_string("重置"),
	[4] = gf_localize_string("扫荡%d次"),
	[5] = gf_localize_string("体力不足"),
	[6] = gf_localize_string("等级不足，无法挑战"),
}

local CopyTipView=class(UIBase,function(self,item_obj,config_data)
	gf_print_table(config_data, "config_data:")
    self.config_data = config_data
    UIBase._ctor(self, "fuben_tip.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CopyTipView:on_asset_load(key,asset)
	-- self:set_bg_visible(true)
	self:hide_mainui()
	self:init_ui()
end

function CopyTipView:init_ui()
	print("update tip view")

	local data = gf_getItemObject("copy"):get_chapter_data_byid(self.config_data.code)

	self:update_button_state()
	-- 推荐战力
	self.power_txt = LuaHelper.FindChildComponent(self.root,"powerTxt","UnityEngine.UI.Text")
	self.power_txt.text = self.config_data.recommend_power

	gf_print_table(self.config_data, "self.config_data:")

	--副本名字
	self.refer:Get(3).text = self.config_data.name
	-- 进入等级
	self.level_txt = LuaHelper.FindChildComponent(self.root,"levelTxt","UnityEngine.UI.Text")
	self.level_txt.text = self.config_data.story.min_level

	-- 体力消耗
	self.tili_txt = LuaHelper.FindChildComponent(self.root,"tiLiTxt","UnityEngine.UI.Text")
	self.tili_txt.text = self.config_data.story.strength

	-- 挑战次数
	local challenge = gf_getItemObject("copy"):get_challege_count(self.config_data.code)
	self.atk_count_txt = LuaHelper.FindChildComponent(self.root,"atkCountTxt","UnityEngine.UI.Text")
	self.atk_count_txt.text = (self.config_data.story.reward_times - challenge).."/"..self.config_data.story.reward_times

	--背景
	local bg = self.config_data.sweep_bg
	gf_setImageTexture(self.refer:Get(2), bg)

	self.star_list = {
		[1] = LuaHelper.FindChild(self.root, "star1"),
		[2] = LuaHelper.FindChild(self.root, "star2"),
		[3] = LuaHelper.FindChild(self.root, "star3"),
	}

	gf_print_table(data, "wtf data star:")
	for i,v in ipairs(self.star_list) do
		if i > (data.star or 0) then
			v:GetComponent(UnityEngine_UI_Image).material = self.refer:Get(4).material
		else
			v:GetComponent(UnityEngine_UI_Image).material = nil
		end
	end

	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
	self.scroll_table.data = self.config_data.story.loot_show
	self.scroll_table:Refresh(-1, -1)
end

function CopyTipView:update_item( item, index, data )
	gf_set_item(data, item:Get(1), item:Get(2))
end

function CopyTipView:update_button_state()
	local challenge = gf_getItemObject("copy"):get_challege_count(self.config_data.code)
	print("challenge count:",challenge)
	if challenge >= self.config_data.story.reward_times then
		self.refer:Get(1).text = commom_string[3]
		return
	end
	self.refer:Get(1).text = string.format(commom_string[4], self.config_data.story.reward_times - challenge)
end


function CopyTipView:check_state(is_sweep,is_five)
	--等级检测
	local level = gf_getItemObject("game"):getLevel()
	if self.config_data.story.min_level > level  then
		gf_message_tips(commom_string[6])
		return true
	end
	--体力检测
	if self.config_data.story.strength > LuaItemManager:get_item_obejct("game"):get_strenght() then
		gf_message_tips(commom_string[5])
		return true
	end
	--剩余次数检测
	if not is_five then
		local challenge = gf_getItemObject("copy"):get_challege_count(self.config_data.code)
		print("wtf :count",challenge , self.config_data.story.reward_times)
		if challenge >= self.config_data.story.reward_times then
			gf_message_tips(commom_string[2])
			return true
		end
	end
	if is_sweep then
		if not gf_getItemObject("copy"):get_is_pass(self.config_data.code) then
			gf_message_tips(commom_string[1])
			return true
		end
	end
	return false
end

function CopyTipView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("CopyTipView:",cmd)
	if cmd == "copyTipCloseBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "atkBtn" then -- 挑战
		-- Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self:check_state() then
			return
		end
		Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
		self.item_obj:set_cur_copy_data(self.config_data)
		self.item_obj:set_story_data(self.config_data.story)
		self.item_obj:enter_copy_c2s(self.config_data.code)

	elseif cmd == "3StarAtkBtn" then -- 3星扫荡,扫荡一次
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self:check_state(true) then
			return
		end
		self:hide()
		self.sweep_view = require("models.copy.sweepView")(self.item_obj, self.config_data, 1,1)
		
	elseif cmd == "shaoDangBtn" then -- 扫荡5次
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		
		local challenge = gf_getItemObject("copy"):get_challege_count(self.config_data.code)
		--重置
		if challenge >= self.config_data.story.reward_times then
			-- self.item_obj:reset_copy_c2s(self.config_data.code)
			gf_getItemObject("copy"):reset_copy(self.config_data.code)
			return
		end
		if self:check_state(true,true) then
			return
		end
		self:hide()
		self.sweep_view = require("models.copy.sweepView")(self.item_obj, self.config_data, 5,1)
 
	elseif string.find(cmd,"fuben_tip_preItem") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:item_click(arg)

	end
end

function CopyTipView:item_click(arg)

	gf_getItemObject("itemSys"):common_show_item_info(arg.data)
end

function CopyTipView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "EnterCopyR") then -- 进入副本
			self:enter_copy_s2c(msg)

		elseif id2 == Net:get_id2("copy", "ResetCopyR") or  id2 == Net:get_id2("copy", "SweepCopyR")  then
			if msg.err == 0 then
				self:init_ui()
			end

		end
	end

	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			if msg.err ~= 0 then
				self.item_obj:set_cur_copy_data(nil)
			else
				self:dispose()
			end
		end
	end
end

function CopyTipView:enter_copy_s2c( msg )
	if msg.err == 0 then
	end
end

function CopyTipView:on_showed()
	StateManager:register_view( self )
end

function CopyTipView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function CopyTipView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return CopyTipView

