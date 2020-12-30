--[[
	武将升级界面界面  属性
	create at 17.10.14
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_upgrade.u3d",
}

local commom_string = 
{	
	[1] = gf_localize_string("经验书不足"),
	[2] = gf_localize_string("%d武将经验"),
}
local exp_item = 
{
	40110201,40110301,40110401
}


local expAdd = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function expAdd:on_asset_load(key,asset)
    self:init_ui()
end

function expAdd:get_count(arg)
	local count = 0
	for i,v in ipairs(arg) do
		count = count + v.item.num
	end
	return count
end

function expAdd:init_ui()
	self.add_items = {}
	local scroll_view = self.refer:Get(1)
	self.count_text = {}

	local str = "<color=%s>%d</color>"

	scroll_view.onItemRender = function(item,index,dataex)
		local data = dataex[1]
		item.name = "item"..index
		gf_set_item(data.item.protoId, item:Get(2), item:Get(1))
		item:Get(3).text = data.data.name
		item:Get(4).text = string.format(commom_string[2], data.data.effect[1])

		local count = self:get_count(dataex)
		local color = count > 0 and gf_get_color(ServerEnum.COLOR.WHITE) or gf_get_color(ServerEnum.COLOR.RED)

		item:Get(5).text = string.format(str,color,count)
		self.count_text[index] = item:Get(5) 
	end
		
		
	local item = gf_getItemObject("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HERO_EXP_BOOK,ServerEnum.BAG_TYPE.NORMAL)

	gf_print_table(item, "wtf item:")

	--合并
	local temp = {}
	for i,v in ipairs(item or {}) do
		if not temp[v.data.effect[1]] then
			temp[v.data.effect[1]] = {}
		end
		table.insert(temp[v.data.effect[1]],v)
	end


	local temp2 = {}

	for i,v in ipairs(exp_item) do
		local effect = gf_getItemObject("itemSys"):get_item_for_id(v).effect[1]
		local data = temp[effect]
		if not next(data or {}) then
			local tb = {}
			local entry = {}
			entry.data = gf_getItemObject("itemSys"):get_item_for_id(v)
			entry.item = {num = 0,protoId = v}
			tb[1] = entry
			table.insert(temp2,tb)
		else
			table.insert(temp2,data)
		end
	end

	self.item_list = self.item_list or gf_deep_copy(temp2)

	scroll_view.data = self.item_list
	scroll_view:Refresh(-1,-1)
end

function expAdd:start_scheduler()
	self.is_press = false
	if self.schedule_id then
		self:stop_schedule()
	end 

	local end_time = self.time
	local total_time = 0
	local update = function()
		total_time = total_time + 0.01
		if total_time >= 0.1 then
			self.is_press = true
			self:send_to_add()
		end
		
	end
	update()
	self.schedule_id = Schedule(update, 0.01)
end

function expAdd:send_to_add()
	--如果满级了
	local hero_info = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	if dataUse.get_hero_level_max() == hero_info.level then
		gf_message_tips("等级已满")
		return
	end

	local item = self.item_list[self.click_index]
	
	if next(item or {}) and self:get_count(item) > 0 then
		local find_index = function(arg)
			for i,v in ipairs(arg) do
				if v.item.num > 0 then
					return i
				end
			end
		end
		self:test_to_send_add_exp(self.hero_id,item[find_index(item)].item.guid,1,item[find_index(item)].data.effect[1])
		return
	end
	gf_message_tips(commom_string[1])
end

--模拟发送增加经验协议
function expAdd:test_to_send_add_exp(hero_id,guid,count,add_exp)
	self.is_test = true
	if not self.add_items[guid] then
		self.add_items[guid] = 0
	end
	self.add_items[guid] = self.add_items[guid] + count

	local hero_info = gf_getItemObject("hero"):getHeroInfo(hero_id)

	local level,exp = dataUse.getHeroCurrentExp(hero_info.level,hero_info.exp, add_exp)

	local msg = {}
	msg.err = 0
	msg.heroId = hero_id
	msg.exp = exp
	msg.level = level

	-- local msg = {}
	-- msg.heroId = heroId
	-- msg.bookList = list
	local temp = {{count=count,guid=guid}}

	local sid = Net:set_sid_param(temp)

	gf_send_and_receive(msg, "hero", "AddHeroExpByBookR",sid)

end


function expAdd:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function expAdd:on_click( obj, arg)
	local event_name = obj.name
	print("expAdd click",event_name)
    if event_name == "group_btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    end
end

function expAdd:on_press_down(obj,data)
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	local name = obj.name
	print("wtf on_press_down name:",name)
	if name  then

		if LuaItemManager:get_item_obejct("setting"):is_lock() then
			return
		end
		local index = string.gsub(name,"item","")
		self.click_index = tonumber(index)
		self:start_scheduler()
	end
end

function expAdd:real_send()
	self.is_test = false
	local temp = {}
	for k,v in pairs(self.add_items or {}) do
		local entry = {}
		entry.count = v
		entry.guid = k
		table.insert(temp,entry)
	end
	gf_getItemObject("hero"):sendToUseHeroExBook(temp,self.hero_id)
	self.add_items = {}
end

function expAdd:on_press_up(obj,data)
	local name = obj.name
	print("wtf on_press_up name:",name)
	if name  then
		if LuaItemManager:get_item_obejct("setting"):is_lock() then
			return
		end
		self:stop_schedule()
		if not self.is_press then
			-- gf_message_tips("发送加一次经验")
			-- local item = self.item_list[self.click_index]
			-- if next(item or {}) then
			-- 	gf_getItemObject("hero"):sendToUseHeroExBook(item[1].item.guid,self.hero_id,1)
			-- end
			self:send_to_add()
			self:real_send()
		else

			self:real_send()
		end
	end
end

function expAdd:on_cancel(obj,data)
	local name = obj.name
	print("wtf on_cancel name:",name)
	if name  then
		self.is_press = true
		self:stop_schedule()
	end
end

function expAdd:on_showed()
	StateManager:register_view(self)
end

function expAdd:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function expAdd:on_hided()
	self:clear()
end
-- 释放资源
function expAdd:dispose()
	self:clear()
    self._base.dispose(self)
end
function expAdd:rec_exp_add_back(msg,sid)
	gf_print_table(msg, "wtf msg =="..msg.err)
	if msg.err == 0 and self.is_test then
		local list = Net:get_sid_param(sid)[1]
		for iii,vvv in ipairs(list or {}) do
			local guid = vvv.guid
			for i,v in ipairs(self.item_list) do
				for ii,vv in ipairs(v or {}) do
					if vv.item.guid == guid then
						gf_print_table(self.count_text, "wtf self.count_text:"..self.click_index.." "..self:get_count(self.item_list[self.click_index]))
						
						self.item_list[i][ii].item.num = self.item_list[i][ii].item.num - 1
						self.count_text[self.click_index].text = self:get_count(self.item_list[self.click_index])
						--如果全部数量小于零
						if self:get_count(self.item_list[self.click_index]) <= 0 then
							self:stop_schedule()
							self:real_send()
						end
						return
					end
				end
			end
		end
		
	elseif msg.err == 0 and not self.is_test then
		self:init_ui()

	end
end

function expAdd:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "AddHeroExpByBookR") then
			self:rec_exp_add_back(msg,sid)
		end
	end
end

return expAdd