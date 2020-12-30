--[[--
-- 扫荡
-- @Author:Seven
-- @DateTime:2017-06-03 16:38:17
--]]

local dataUse = require("models.copy.dataUse")

local LocalString = 
{
	[1] = gf_localize_string("一"),
	[2] = gf_localize_string("二"),
	[3] = gf_localize_string("三"),
	[4] = gf_localize_string("四"),
	[5] = gf_localize_string("五"),
	[6] = gf_localize_string("六"),
	[7] = gf_localize_string("七"),
	[8] = gf_localize_string("八"),
	[9] = gf_localize_string("九"),
	[10] = gf_localize_string("十"),
	[11] = gf_localize_string("再扫%d次"),
	[12] = gf_localize_string("重置"),
	[100] = gf_localize_string("一百"),
}

local pos = {-95.89999,0}

local sweep_type = 
{
	one  	= 1,
	motil 	= 5,
}

local view_type = 
{
	story = 1,
	tower = 2,
}

local m_height = 181.2
local move_x = 48.6

local SweepView=class(UIBase,function(self, item_obj, copy_data, count,view_type)
	self.count = count
	self.copy_data = copy_data
	self.view_type = view_type
    UIBase._ctor(self, "fuben_saodang.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SweepView:on_asset_load(key,asset)
	
	self:init_ui()
end

function SweepView:init_ui()
	print("SweepView:")
	self:update_button_state()
end

function SweepView:refresh( data )
	-- gf_print_table(data,"wtf sweep 开始执行:")
	if not data then
		return
	end
	self.data = data
	local pItem = self.refer:Get(2)
	self.scroll_view = pItem
	local copyItem = self.refer:Get(1)
	
	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
  		go.name = "item_destroy"
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(data or {}) do
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.name = "bitem"..i
		-- item.gameObject:SetActive(true)

		local refer = item:GetComponent("Hugula.ReferGameObjects")

		
		self:set_title_text(refer,i)

		for ii,vv in ipairs(v.itemLs) do
			if ii <= 4 then
				local item = refer:Get(ii + 3)
				-- item.gameObject:SetActive(true)
				item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text").text = vv.num

				local bg = item:GetComponent(UnityEngine_UI_Image)
				local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
				gf_set_item(vv.code, icon, bg)
			end
		end
	end

	self.is_playing = true
	self:animation_play(data)
	self:play_move()
end

function SweepView:set_title_text(refer,i)
	local vip_add 		= gf_getItemObject("vipPrivileged"):get_battle_exp() / 10000
	local medicine_add 	= gf_getItemObject("buff"):get_exp_add() 
	if self.view_type == view_type.tower then
		local tower_data = dataUse.getTowerData(self.copy_data.code,i)
		refer:Get(1).text = string.format(gf_localize_string("第%s层扫荡"),self:get_ch_num(i))-- 标题
		refer:Get(2).text = tower_data.reward_exp * (vip_add + medicine_add + 1)-- 经验
		refer:Get(3).text = tower_data.reward_coin -- 金币
	elseif self.view_type == view_type.story then
		refer:Get(1).text = string.format(gf_localize_string("第%s次扫荡"),LocalString[i])-- 标题
		refer:Get(2).text = self.copy_data.story.exp_reward  * (vip_add + medicine_add + 1) -- 经验
		refer:Get(3).text = self.copy_data.story.coin_reward -- 金币
	end
	
	
end

function SweepView:get_ch_num(floor)
	if floor <= 10 then
		return LocalString[floor]
	elseif floor == 100 then
		return LocalString[100]
	else
		local num = math.floor(floor / 10)		
		num = num <= 1 and "" or LocalString[num]
		local num2 = floor % 10 
		num2 = num2 == 0 and "" or LocalString[num2]
		return  num..LocalString[10]..num2
	end
end

--播放动画
function SweepView:animation_play(data)
	self.anim_data = self:get_anim_data(data) 

end

function SweepView:play_move()
	--执行定时器移动高度. 移动完执行播放材料动画
	self.refer:Get(4):SetActive(true)
	if not next(self.anim_data or {}) then
		self.refer:Get(4):SetActive(false)
		--停止定时器
		self:stop_schedule()
		self:stop_schedule_item()
		self.is_playing = false
		return
	end
	local run_data = self.anim_data[1]
	table.remove(self.anim_data,1)
	--开始执行
	self:start_scheduler(run_data)
end

function SweepView:start_scheduler_item(xindex)
	print("wtf index:",xindex)
	--总执行时间
	local duration,scale_speed = 0.01,-0.06
	
	if self.schedule_id_item then
		self:stop_schedule_item()
	end
	
	local pitem = self.scroll_view.transform:FindChild("bitem"..xindex).transform:FindChild("item")
	pitem.gameObject:SetActive(true)
	pitem = pitem.transform:FindChild("GameObject")

	local index = 1
	local item 

	local total_scale = 0
	local ori_scale = 1.5

	local function get_item()
		-- print("wtf sweep get_item")
		total_scale = 0
		ori_scale = 1.5 
		item = pitem.transform:FindChild(string.format("item (%d)",index))
		if Seven.PublicFun.IsNull(item) then
			return
		end
		local data = self.data[xindex].itemLs[index]
		if not data then
			self:stop_schedule_item()
			self:play_move()
			return
		end
		item.localScale = Vector3(1.5,1.5,1.5)
		item.gameObject:SetActive(true)
		index = index + 1
	end

	
	local update = function()
		if not item then
			get_item()
		end
		-- print("wtf sweep item:",item)
		if Seven.PublicFun.IsNull(item) then
			return
		end
		total_scale = total_scale + scale_speed
		--执行缩放
		if total_scale <= -0.58 then
			item.localScale = Vector3(0.92,0.92,0.92)
			--执行下一个
			-- get_item()
			item = nil
		else
			item.localScale = Vector3(ori_scale + total_scale,ori_scale + total_scale,ori_scale + total_scale)
		end
	end
	self.schedule_id_item = Schedule(update,duration)
end

function SweepView:stop_schedule_item()
	if self.schedule_id_item then
		self.schedule_id_item:stop()
		self.schedule_id_item = nil
	end
end

function SweepView:start_scheduler(run_data)
	local move_height = run_data.count * m_height
	--总执行时间
	-- local time = 1
	local duration = 0.01
	local speed = 20
	
	if self.schedule_id then
		self:stop_schedule()
	end
	local total_height = 0

	local o_py = self.scroll_view.transform.localPosition.y

	local update = function()
		total_height = total_height + speed
		if total_height >= move_height then
			--到达终点 开始执行道具获得动画
			self.scroll_view.transform.localPosition = Vector3(0,o_py + move_height,0)
			self:stop_schedule()
			self:start_scheduler_item(run_data.index)
		else
			self.scroll_view.transform.localPosition = Vector3(0,o_py + total_height,0)
		end
		
	end
	self.schedule_id = Schedule(update,duration)
end

function SweepView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--根据数据获取动作
function SweepView:get_anim_data(data)
	local anim_data = {}
	for i,v in ipairs(data or {}) do
		local temp = {}
		temp.index = i
		--前面三个不需要移动
		local anim_fragment = {}
		if i <= 2 then
			temp.count = 0
			table.insert(anim_data,temp)
		else
			--如果后面还有两个数据 则移动2 如果1个 移动1 0个 移动0
			local left_count = #data - i
			if left_count >= 1 then
				temp.count = 1
				table.insert(anim_data,temp)
			else
				temp.count = 1
				table.insert(anim_data,temp)
			end
		end
		
	end
	return anim_data
end

function SweepView:update_button_state()
	self.refer:Get(5).transform.localPosition = Vector3(pos[self.view_type],-203.2,0)

	if self.view_type == view_type.tower then
		self.refer:Get(6):SetActive(false)

	elseif self.view_type == view_type.story then
		self.refer:Get(6):SetActive(true)
		local challenge = gf_getItemObject("copy"):get_challege_count(self.copy_data.code)
		if challenge < self.copy_data.story.reward_times then
			if self.count == sweep_type.motil then
				self.refer:Get(3).text = string.format(LocalString[11],self.copy_data.story.reward_times - challenge)
			else
				self.refer:Get(3).text = string.format(LocalString[11],1)
			end
			
			return
		end
		self.refer:Get(3).text = LocalString[12]

	end
	
end

function SweepView:update_item( item, index, data )
end

function SweepView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "saoDangCloseBtn" or cmd == "stopBtn" then
		 Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
	elseif cmd == "smallBtn" then -- 重置
		print("wtf playing:",self.is_playing,self.is_get)
		if self.is_get then
			return
		end
		if self.is_playing then
			return
		end
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		if self.schedule_id_item or self.schedule_id then
			return
		end

		local challenge = gf_getItemObject("copy"):get_challege_count(self.copy_data.code)
		if challenge < self.copy_data.story.reward_times then
			self.item_obj:sweep_copy_c2s(self.copy_data.code, self.count)
			return
		end
		
		-- self.item_obj:reset_copy_c2s(self.copy_data.code)
		gf_getItemObject("copy"):reset_copy(self.copy_data.code)
		-- self:dispose()
	end
end

function SweepView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "SweepCopyR") then -- 扫荡
			gf_print_table(msg, "SweepCopyR:")
			if msg.err == 0 then
				self:refresh(msg.itemDrops)
				self:update_button_state()
			end

		elseif id2 == Net:get_id2("copy", "ResetCopyR") then
			self:update_button_state()

		end
	end
end

function SweepView:on_showed()
	StateManager:register_view( self )
	if self.view_type == view_type.story then
		self.item_obj:sweep_copy_c2s(self.copy_data.code, self.count)

	elseif self.view_type == view_type.tower then
		self.item_obj:sweep_copy_c2s(self.copy_data.code, self.count)
		-- self.sweep_view = require("models.copy.sweepView")(self.item_obj,self.copy_data.code, 1)
	end
	

	-- local item = 
	-- {
	-- 	code = math.random(0,1) == 1 and 20010101 or 20010408,
	-- 	num = 99,
	-- }
	-- local items = 
	-- {
	-- 	itemLs = {item,item,item,item},
	-- }

	-- local sweep_data = 
	-- {
	-- 	err       =0,
	-- 	itemDrops ={items,items,items,items,items},
	-- 	challenge =0,
	-- 	expDrops  =10000,
	-- 	coinDrops =9999,
	-- }

	-- gf_send_and_receive(sweep_data, "copy","SweepCopyR")

end

function SweepView:clear()
	StateManager:remove_register_view( self )
	self:stop_schedule()
	self:stop_schedule_item()
end

function SweepView:on_hided()
	self:clear()
end

-- 释放资源
function SweepView:dispose()
	self:clear()
    self._base.dispose(self)
end

return SweepView

