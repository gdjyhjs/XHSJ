--[[--
-- 战场统计
-- @Author:Seven
-- @DateTime:2017-09-05 10:16:36
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local RvrStatisticsView=class(UIBase,function(self,item_obj,cb)
	self.cb = cb
	self:set_level(UIMgr.LEVEL_STATIC)
	
    UIBase._ctor(self, "rvr_statistics.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function RvrStatisticsView:on_asset_load(key,asset)
	self:init_ui()
	self:update_ui()
end

function RvrStatisticsView:init_ui()
	self.scroll_table = self.refer:Get("scroll_table")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.item_obj:faction_rank_c2s()

	self.our_score = self.refer:Get("our_score") -- 我的积分
	self.enemy_score = self.refer:Get("enemy_score") -- 我的击杀数量

	self.refer:Get("exit_batttle_btn"):SetActive(false)

	if self.cb then
		self.cb(self)
	end
end

function RvrStatisticsView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function RvrStatisticsView:update_item( item, index, data )
	item:Get(2).text = index -- 排名
	item:Get(3).text = data.name -- 名字
	item:Get(5).text = data.power -- 战力
	item:Get(4).text = data.kill -- 击败
	item:Get(6).text = data.assist -- 助攻
	item:Get(7).text = data.honor -- 荣誉

	if data.win ~= nil then
		item:Get(8):SetActive(data.win)
		item:Get(9):SetActive(not data.win)
	else
		item:Get(8):SetActive(false)
		item:Get(9):SetActive(false)
	end

end

-- 设置高亮
function RvrStatisticsView:set_hl( item )
	if self.last_select_item then
		self.last_select_item:Get(1):SetActive(false)
	end
	item:Get(1):SetActive(true)
	self.last_select_item = item
end

-- 更新玩家自己的积分，击杀，死亡
function RvrStatisticsView:update_ui()
	self.our_score.text = self.item_obj:get_our_score()
	self.enemy_score.text = self.item_obj:get_enemy_score()
end

--显示离开按钮
function RvrStatisticsView:show_exit_btn()
	self.is_exit = true
	self.refer:Get("exit_batttle_btn"):SetActive(true)
end

function RvrStatisticsView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "preItem(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_hl(arg)

	elseif cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		if self.is_exit then
			LuaItemManager:get_item_obejct("copy"):exit()
		end
		self:dispose()

	elseif cmd == "exit_batttle_btn" then -- 离开战场
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("copy"):exit()
		self:dispose()

	elseif cmd == "help_btn" then -- 帮助
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1061)
	end
end

function RvrStatisticsView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "FactionRankR") then --排行榜
			self:refresh(self.item_obj:get_rank_list())
			self:update_ui()
		end
	end
end

function RvrStatisticsView:register()
	StateManager:register_view( self )
end

function RvrStatisticsView:cancel_register()
	StateManager:remove_register_view( self )
end

function RvrStatisticsView:on_showed()
	-- self.item_obj:faction_rank_c2s()
	self:register()
end

function RvrStatisticsView:on_hided()
	self:cancel_register()
end

-- 释放资源
function RvrStatisticsView:dispose()
	self.is_exit = false
	self:cancel_register()
    self._base.dispose(self)
end

return RvrStatisticsView

