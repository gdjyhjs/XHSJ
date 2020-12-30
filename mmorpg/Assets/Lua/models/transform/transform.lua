------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
local Transform = LuaItemManager:get_item_obejct("transform")
Transform.priority = -100
Transform.log_enable = false
-- transform.async = false -- 同步加载
Transform.assets=
{
  Asset("loading.u3d", nil, UIMgr.LEVEL_STATIC)
}

local tips = gf_localize_string("正在初始化游戏数据，请稍后...")

function Transform:on_focus()
    if self:check_assets_loaded() then 
        self:show()
        self:on_showed()  
    else
        self.asset_loader:load(self.assets)  
    end

    if not self.pvp_loading_view and gf_getItemObject("copy"):is_pvptvt() then
    	self.pvp_loading_view = require("models.pvp3v3.pvpLoading")()
    end
end

function Transform:dispose() --override dispose need't dispose on reload

end

function Transform:on_asset_load(key,asset)

	self:hide()
	self.slider = asset.refer:Get(1)
	self.tips = asset.refer:Get(2)
	self.current_complete_count = 0

	self.game = LuaItemManager:get_item_obejct("game")

	self.is_init = true
	-- Loader:set_onprogress_fn(handler(self, self.update_progress))
end

function Transform:init_tips_data()
	local level = self.game:getLevel()
	if not level or level == self.level then
		return
	end
	self.tips_data = {}

	for k,v in pairs(ConfigMgr:get_config("loading_tips")) do
		if level >= v.min_level and level <= v.max_level then
			self.tips_data[#self.tips_data+1] = v
		end
	end
	self.level = level
	gf_print_table(self.tips_data, "加载提示列表")
end

function Transform:on_showed()
	self.tips.text = tips
	self.slider.value = 0
	self.current_complete_count = 0
	self.is_can_hide = false
	self.finish = false
	self.progress = 0
	self.change_tips_time = 0 -- 更换tips时间间隔
	self:init_tips_data()

	--注册update
    gf_register_update(self)

    --如果是3v3竞技场 展示这个loading界面
    if gf_getItemObject("copy"):is_pvptvt() and self.pvp_loading_view then
    	self.pvp_loading_view:show()
    end
end

function Transform:on_hided()
	gf_remove_update(self) --注销每帧事件
end

function Transform:can_hide()
	self.is_can_hide = true
end

function Transform:update_progress( arg )
	if not self.is_init then
		return
	end

	local cur = self.current_complete_count/StateManager:get_current_state().loading_count
	local pro = 1/StateManager:get_current_state().loading_count *arg.progress
	
	local progress = cur + pro
	if progress > 1 then
		progress = 1
	end

	self.progress = progress

	self.tips.text = tips..string.format("(%0.0f%%)",progress*100)
	self.slider.value = progress
end

function Transform:get_progress()
	return self.progress
end

function Transform:on_complete()
	if not self.is_init then
		-- 测试
		local fristView = LuaHelper.Find("regeng")
		if fristView then LuaHelper.Destroy(fristView) end
		return
	end
	self.current_complete_count = self.current_complete_count + 1
	
	local progress = self.current_complete_count/StateManager:get_current_state().loading_count
	if progress < self.progress then
		progress = self.progress
	end

	if progress > 1 then
		progress = 1
	end

	self.progress = progress

	self.tips.text = tips..string.format("(%0.0f%%)",progress*100)
	self.slider.value = progress
	self.progress = progress
	if self.current_complete_count == StateManager:get_current_state().loading_count then
		self.finish = true
		Net:receive({},ClientProto.AllLoaderFinish)  --全部加载完发送协议
		if StateManager:get_current_state() == StateManager.login or
		   StateManager:get_current_state() == StateManager.create_role or
		   self.test_stage_list[StateManager:get_current_state()] then
			self.is_can_hide = true
		end
	end
	-- print("加载完成:",StateManager:get_current_state().loading_count, self.current_complete_count)
end

function Transform:on_update( dt )
	if self.is_can_hide and self.finish then
		StateManager:check_hide_transform()
	end

	if not self.is_init then
		return
	end

	self.change_tips_time = self.change_tips_time - dt
	if self.change_tips_time <= 0 and self.tips_data then
		local len = #self.tips_data
		if len > 0 then
			local tips_d = self.tips_data[math.random(1, #self.tips_data)]
			tips = tips_d.content
			self.change_tips_time = tips_d.time
		end
	end

	self.progress = self.progress + 0.0005
	if self.progress > 1 then
		self.progress = 1
	end
	self.tips.text = tips..string.format("(%0.0f%%)",self.progress*100)
	self.slider.value = self.progress
end

function Transform:add_test_stage( stage )
	if not self.test_stage_list then
		self.test_stage_list = {}
	end

	self.test_stage_list[stage] = stage
end

--服务器返回
function Transform:on_receive( msg, id1, id2, sid )
    if id1 == ClientProto.PlayerLoaderFinish then
    	self:on_complete()
    	self:can_hide()

    elseif id1 == ClientProto.PoolFinishLoadedOne then
    	self:on_complete()

    elseif id1 == Net:get_id1("base") then
    	if id2 == Net:get_id2("base", "UpdateLvlR") then
    		self:init_tips_data()
    	end
    end
end
