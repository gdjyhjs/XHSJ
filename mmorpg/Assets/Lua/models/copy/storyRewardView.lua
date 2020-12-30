--[[--
-- 剧情副本奖励领取
-- @Author:Seven
-- @DateTime:2017-06-03 15:47:05
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local StoryRewardView=class(UIBase,function(self, item_obj, config_data, is_get_reward, index,chapter)
	self.config_data = config_data
	-- self.is_get_reward = is_get_reward or false -- 是否领取了奖励
	self.index = index
	self.chapter= chapter
    UIBase._ctor(self, "fuben_award.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function StoryRewardView:on_asset_load(key,asset)
	self:init_ui()
	self:update_ui()
end

function StoryRewardView:find_is_open(idx)
	local getReward = gf_getItemObject("copy"):get_chapter_info(self.chapter)
	local reward = getReward and getReward.getReward or {}
	for i,v in ipairs(reward or {}) do
		if v == idx then
			return true
		end
	end
	return false
end

function StoryRewardView:init_ui()
	self.is_get_reward = self:find_is_open(self.index)

	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.receive_btn = LuaHelper.FindChildComponent(self.root, "receiveBtn", "UnityEngine.UI.Button")
	-- 领取按钮文字
	self.receive_btn_txt = LuaHelper.FindChildComponent(self.root, "receiveBtn","UnityEngine.UI.Text")

	self.reward_txt = LuaHelper.FindChildComponent(self.root, "rewardTxt", "UnityEngine.UI.Text")

	self:refresh()
	self:updata_receive_btn()
end

function StoryRewardView:updata_receive_btn()
	if not self.receive_btn or not self.receive_btn_txt then
		return
	end

	local str
	if self.is_get_reward then
		str = gf_localize_string("已领取")
	else
		str = gf_localize_string("领取")
	end

	self.receive_btn_txt.text = str

	self.receive_btn.interactable = not self.is_get_reward
end

function StoryRewardView:update_ui()
	if self.reward_txt then
		self.reward_txt.text = string.format(gf_localize_string("本章累计%d星可以获得奖励"), self.config_data.max_star_num)
	end
	self:updata_receive_btn()
end

function StoryRewardView:refresh()
	if not self.scroll_table then
		return
	end

	local data = {}
	for i=1,10 do
		local d = self.config_data.reward_data[i]
		if d then
			data[i] = d
		else
			data[i] = {}
		end
	end
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function StoryRewardView:update_item( item, index, data )
	if #data == 0 then
		item:Get(1):SetActive(false)
		item:Get(2):SetActive(false)
		item:Get(3).text = ""
		return
	end
	item:Get(1):SetActive(true)
	item:Get(2):SetActive(true)
	item:Get(3).text = data[2]
	gf_set_item(data[1], item:Get(5), item:Get(4))
end

function StoryRewardView:item_click(arg)
	gf_print_table(arg.data, "wtf data:")
	gf_getItemObject("itemSys"):common_show_item_info(arg.data[1])
end

function StoryRewardView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("cmd :",cmd)
	if cmd == "receiveBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

		local count = gf_getItemObject("copy"):get_chapter_star(self.chapter)

		if count >= self.config_data.max_star_num then
			self.item_obj:get_chapter_box_c2s(self.chapter, self.index)
			self:dispose()
		else
			gf_message_tips(gf_localize_string("尚未达到所需星数"))
		end
	elseif cmd == "rewardCloseBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif string.find(cmd,"box_reward_preItem") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:item_click(arg)

	end
end

function StoryRewardView:on_showed()
	StateManager:register_view( self )
	self:refresh()
	self:update_ui()
end

function StoryRewardView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function StoryRewardView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return StoryRewardView

