--[[--
-- 滚动页面
-- @Author:Seven
-- @DateTime:2017-06-01 14:42:19
--]]

local dataUse = require("models.copy.dataUse")

local item_width = 195

local res = 
{
	[1001] = "copy_frame_01",
	[1002] = "copy_frame_02",
	[1003] = "copy_frame_03",
}

local CopyScrollPage = class(function( self, ui )
	print("wtf CopyScrollPage:")
	self.ui = ui
	self.root = ui.root
	self.item_obj = ui.item_obj
	self.refer = self.ui.refer
	
	gf_mask_show(true)

	local temp = {}
	local data = ConfigMgr:get_config("copy_chapter")
	for k,v in pairs(data or {}) do
		table.insert(temp,v)
	end
	table.sort(temp,function(a,b)return a.code < b.code end)

	self.chapter_data = temp

	self:refresh()

	gf_getItemObject("copy"):clera_chapter_info()

	gf_getItemObject("copy"):get_chapter_info_c2s()

	self.slide_page_view = self.refer:Get(4)
	self.slide_page_view.endDragFn = function(page)
		self.page_index = page
		print("wtf end endDragFn",page)
		self:start_scheduler()
		local chatpter_data = self.chapter_data[page]
		self.chapter_id = chatpter_data.code
		self:update_chapter(self.chapter_id)

		--需要跳转
		if self.pre_init then
			print("pre init")
			self.pre_init = false
			local item = self.refer:Get(5).transform:FindChild("bitem"..page)
			local item_refer = item:GetComponent("Hugula.ReferGameObjects")

			local move_index = self.move_index and (self.move_index - 3) or 0
			self.move_index = nil

			move_index = move_index <= 0 and 0 or move_index

			item_refer:Get(1).gameObject.transform.localPosition = Vector3(-262 - item_width * move_index ,390,0)
			
		end
	end

end)

function CopyScrollPage:get_move_index()	
end

function CopyScrollPage:init()
	gf_mask_show(false)
	--清除chapter数据
	
	self.item_list = {}
	self.sitem_list = {}

	local chapterTitle = LuaHelper.FindChild(self.root, "chapterTitle")
	-- 章节标题
	self.titleText = LuaHelper.FindChild(chapterTitle, "titleText"):GetComponent("UnityEngine.UI.Text")
	-- 章节名字
	self.nameText = LuaHelper.FindChild(chapterTitle, "nameText"):GetComponent("UnityEngine.UI.Text")

	-- self.scroll_page = self.root:GetComponentInChildren("Seven.ScrollPage")
	-- self.scroll_page.onItemRender = handler(self, self.on_item_render)
	-- self.scroll_page.onPageChangedFn = handler(self, self.on_page_change)

	local temp = self.chapter_data

	local copyItem = self.refer:Get(8)
	local pItem = self.refer:Get(7)
	
	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
  		go.name = "destroy_item"
		LuaHelper.Destroy(go)
  	end

  	self.chapter_id = temp[1].code

	for i,v in ipairs(temp or {}) do
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.name = "bitem"..i
		item.gameObject:SetActive(true)

		local refer = item:GetComponent("Hugula.ReferGameObjects")

		for ii,vv in ipairs(v.stage or {}) do
			local copy_item = self.refer:Get(9)
			local p_item = refer:Get(1)
		
			local sitem = LuaHelper.InstantiateLocal(copy_item.gameObject,p_item.gameObject)
			sitem.gameObject:SetActive(true)
			sitem.name = "sitem"..ii
			self:on_item_render(sitem,nil,i,vv)

			self.sitem_list[vv] = sitem

		end

		self.item_list[v.code] = item

		self:update_chapter(v.code)
	end

	--补全到3个
	if #self.chapter_data == 2 then
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.name = "bitem"..3
		item.gameObject:SetActive(true)
	end

	self.page_index,self.move_index = self:get_top_page()
	print("self.page_index,self.move_index:",self.page_index,self.move_index)
	self.pre_init = true
	self:start_scheduler()

	local function delayfunc()
		self.slide_page_view:SetPageIndex(self.page_index)
	end
	delay(delayfunc,0.2)
	
end

function CopyScrollPage:get_top_page()
	local copy_id = -1
	local page = -1 
	for i,v in ipairs(self.chapter_data or {}) do
		for ii,vv in ipairs(v.stage) do
			local data = gf_getItemObject("copy"):get_chapter_data(v.code,vv)
			if not data then
				-- 如果条件满足
				if page > 0 then
					local data = dataUse.getStoryCopyData(vv)
					print("wtf level:",data.min_level, gf_getItemObject("game"):getLevel())
					if data.min_level <= gf_getItemObject("game"):getLevel() then
						return i,ii
					else
						return page,ii
					end
				else
					return 1,ii
				end
				
			end
			page = i
		end
	end
	return 1,1
end

function CopyScrollPage:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		self:on_update()
	end
	-- update()
	self.schedule_id = Schedule(update, 0)
end

function CopyScrollPage:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end
function CopyScrollPage:on_update()
	local page = self.refer:Get(4):GetCurPage()
	if page then
		local page_item = page:GetComponent("Hugula.ReferGameObjects"):Get(2)
		if page_item.horizontalNormalizedPosition >= 1.5 then
			--获取下一页
			local max_page = #self.chapter_data
			if self.page_index + 1 <= max_page then
				self.page_index = self.page_index + 1
				self:stop_schedule()
				self.slide_page_view:SetPageIndex(self.page_index)
			end
			
		elseif page_item.horizontalNormalizedPosition <= -0.5 then
			if self.page_index - 1 >= 1 then
				self.page_index = self.page_index - 1
				self:stop_schedule()
				self.slide_page_view:SetPageIndex(self.page_index)
			end

		end
	end
	
end

function CopyScrollPage:update_chapter(chapter)
	print("update_chapter:",chapter)
	local item = self.item_list[chapter]
	local data = ConfigMgr:get_config("copy_chapter")[chapter]
	if not data and not item then
		return
	end
	local refer = item:GetComponent("Hugula.ReferGameObjects")

	refer:Get(3).text = data.chapter
	refer:Get(4).text = data.name

	if self.chapter_id == chapter then
		self.ui:update_star_count(data.star_num_1, data.star_num_2, data.star_num_3)
		self.ui:update_chaper_data(data, chapter)
	end
	
end

function CopyScrollPage:refresh()
	local data = ConfigMgr:get_config("copy_chapter")

	local sub_data = {}
	for k,v in pairs(data or {}) do
		if v.type == 1 then -- 1剧情副本
			sub_data[#sub_data+1] = v
		end
	end

	self.config_data = sub_data
	local d = {}
	local code
	for i,v in ipairs(sub_data) do
		if not code then
			code = v.code
		end
		for j,p in ipairs(v.stage) do
			local _d = ConfigMgr:get_config("copy")[p]
			_d.story = ConfigMgr:get_config("story_copy")[p]
			d[p] = _d
		end
	end
	self.sub_chapter_data = d
	-- self.scroll_page.data = d
	-- self.scroll_page:SetPage(#sub_data)

end



function CopyScrollPage:on_item_render( item, cur_index, page, copy_id )
	local data = self.sub_chapter_data[copy_id]
	if not data then
		item.gameObject:SetActive(false)
		return
	end

	local msg = gf_getItemObject("copy"):get_chapter_data_byid(copy_id)

	gf_print_table(msg, "wtf sub chapter info")

	local refer = item:GetComponent("Hugula.ReferGameObjects")

	local star_num = msg.star or 0
	local challenge = msg.challenge or 0
	
	refer:Get(5).text = data.name
	gf_setImageTexture(refer:Get(7), data.bg_code)
	refer:Get(6).text = (data.story.reward_times - challenge).."/"..data.story.reward_times
	refer:Get(4).text = data.recommend_power

	print("wtf name:",self.chapter_id,res[self.chapter_id])

	gf_setImageTexture(refer:Get(9), "copy_frame_0"..page)

	for i=1,3 do
		refer:Get(i):SetActive(i <= star_num)
	end
	refer:Get(8).text = data.code
	
end

function CopyScrollPage:is_per_copy_finish( pre_copy )
	if not pre_copy then
		return true
	end
	local data = gf_getItemObject("copy"):get_chapter_data_byid(pre_copy)
	if not next(data or {}) then
		return false
	end
	return true
end

-- 打开副本进入视图
function CopyScrollPage:open_enter_view(arg)
	-- 判断是否可以打开,前置副本是否已经打了
	local value = arg:GetComponent("Hugula.ReferGameObjects"):Get(8).text
	value = tonumber(value) or -1

	local data = self.sub_chapter_data[value]
	local pre_copy = data.story.pre_copy
	if self:is_per_copy_finish(pre_copy) then
		require("models.copy.copyTipView")(self.item_obj, data)

	else
		gf_message_tips(gf_localize_string("请先通关上一副本"))

	end
end

function CopyScrollPage:rec_chapter_info(msg)
	self:init()
end

function CopyScrollPage:on_showed()
	self:start_scheduler()
	self:update_chapter(self.chapter_id)
end

function CopyScrollPage:dispose()
	self:stop_schedule()
end

function CopyScrollPage:on_receive( msg, id1, id2, sid )
	
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "GetStoryCopyInfoR") then -- 取章节信息
			gf_print_table(msg, "GetStoryCopyInfoR:")
			self:rec_chapter_info(msg)			

		elseif id2 == Net:get_id2("copy", "ResetCopyR") or  id2 == Net:get_id2("copy", "SweepCopyR")  then
			if msg.err == 0 then
				self:update_chapter(self.cur_chapter)
				local copy_id,count = Net:get_sid_param(sid)[1],Net:get_sid_param(sid)[2]
				local s_item = self.sitem_list[copy_id]
				if Seven.PublicFun.IsNull(s_item) then
					return
				end
				self:on_item_render( s_item, cur_index, self.page_index, copy_id )

			end
		end
	end
end

function CopyScrollPage:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd, "item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- require("models.copy.copyTipView")(self.item_obj, arg.data)
		self:open_enter_view(arg)
	end
end

return CopyScrollPage
