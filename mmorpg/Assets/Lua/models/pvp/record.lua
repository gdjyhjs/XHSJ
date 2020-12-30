--[[
	pvp排行榜界面  
	create at 17.8.1
	by xin
]]

-- local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "pvp"

local res = 
{
	[1] = "pvp_record.u3d",
	[2] = "arena_icon_01",
	[3] = "arena_icon_02",
}

local commom_string = 
{
	[1] = gf_localize_string("排名：%d"),
	[2] = gf_localize_string("积分：%d"),
	[3] = gf_localize_string("剩余次数：%d"),
	[4] = gf_localize_string("连胜次数：%d"),
	[5] = "<color=#53A43DFF>+%d</color>",
	[6] = "<color=#C03E3EFF>+%d</color>",
}


local record = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("pvp")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function record:on_asset_load(key,asset)
    self:init_ui()
end

function record:init_ui()
	self:init_my_view()
	self:init_scrollview({1,2,1,1,1,1,1,1,1,1})
end


--初始化我的排名数据
function record:init_my_view()
	local rank_num = 10
	local num = 100
	local left_count = 10
	local win_count = 2
	local refresh_time = Net:get_server_time_s() + 1000
	--排名icon

	--排名
	self.refer:Get(2).text = string.format(commom_string[1],rank_num)
	--积分
	self.refer:Get(3).text = string.format(commom_string[2],num) 
	--挑战次数
	self.refer:Get(4).text = string.format(commom_string[3],left_count)  
	--连胜次数
	self.refer:Get(5).text = string.format(commom_string[4],win_count)   

	--奖励发放时间
	self:set_refresh_time(refresh_time)

end

function record:init_scrollview(viewData)
	local scroll_rect_table = self.refer:Get(11)
 	
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		
		local level = 99
		local interval = 100
		local num = 1000			--积分
		local name = "测试1"
		--胜负状态 
		scroll_rect_item:Get(1).text = "胜利"
		--头像
		scroll_rect_item:Get(2)
		--等级
		scroll_rect_item:Get(3).text = level
		--积分差值
		scroll_rect_item:Get(4).text = interval > 0 and string.format(commom_string[5],interval) or string.format(commom_string[6],interval)
		--积分
		scroll_rect_item:Get(8).text = num
		--防守或者攻击状态
		gf_setImageTexture(scroll_rect_item:Get(5), res[3])
		if true then
			gf_setImageTexture(scroll_rect_item:Get(5), res[2])
		end
		scroll_rect_item:Get(5)
		--name
		scroll_rect_item:Get(6).text = name
		--时间
		scroll_rect_item:Get(7).text = "55分钟前"
	end

	for i,v in ipairs(viewData) do
        local index = scroll_rect_table:InsertData(v, -1)
        scroll_rect_table:Refresh(index-1, index)
    end
end

function record:set_refresh_time(refresh_time)
	if refresh_time >=0 then
		self:start_scheduler(refresh_time)
	end
end
function record:start_scheduler(refresh_time)
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		local left_time = refresh_time - Net:get_server_time_s()
		self.refer:Get(10).text = gf_convert_time(left_time)
		if left_time <= 0 then
			self:stop_schedule()
		end
	end
	self.schedule_id = Schedule(update, 0.5)
end
function record:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function record:on_click( obj, arg)
    local event_name = obj.name
    if event_name == "" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    end
end

-- 释放资源
function record:dispose()
	self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function record:on_hided()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function record:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "") then
		end
	end
end

return record