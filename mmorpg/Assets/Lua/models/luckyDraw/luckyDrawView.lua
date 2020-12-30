--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-23 11:47:14
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local ChatTools = require("models.chat.chatTools")
-- local key_count = 0 -- 钥匙数量
local message_type = nil -- 0:区服记录 1:个人记录
local message_max_width = 300 -- 广播消息文本框的宽度 也是最大宽度
local fly_objs = {} -- 用来装飞行道具的缓存
local wait_time = 0 -- 飘出等待时间
local interval_time = 0.03 -- 间隔时间

local LuckyDrawView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "lucky_draw.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function LuckyDrawView:on_asset_load(key,asset)
	self:init_ui()
	self.init = true
	self:show()
end

function LuckyDrawView:init_ui()
	wait_time = 0 -- 初始化等待时间
	self.lottery_config = self.item_obj:get_config()
	if not self.lottery_config then
		gf_message_tips("等级不足,无法秘境寻宝")
		self:dispose()
		return
	end
	self.key_id = self.lottery_config.cost[1][2]
	-- 设置需要的钥匙数量
	self.one_count_key = self.lottery_config.cost[1][3]
	self.ten_count_key = self.lottery_config.cost[2][3]
	self.fifty_count_key = self.lottery_config.cost[3][3]
	self.refer:Get("one_key").text = self.one_count_key
	self.refer:Get("ten_key").text = self.ten_count_key
	self.refer:Get("fifty_key").text = self.fifty_count_key

	--特效
	self.lucky_draw_eff = self.refer:Get("eff")
	-- 钥匙数量
	self.key_count = self.refer:Get("keyTxt")
	-- 元宝数量
	self.gold_count = self.refer:Get("goldTxt")
	-- 寻宝积分
	self.luck_count = self.refer:Get("luckDrawScores")
	-- 物品展示ui
	local item_data = ConfigMgr:get_config("lottery_bonus_pool")
	local root = self.refer:Get("itemRoot")
	for i=1,root.childCount do
		--设置图标
		local ref = root:GetChild(i-1):GetComponent("ReferGameObjects")
		local item = item_data[self.lottery_config.code*1000+i]
		if item then
			local itemId = item.reward[1]
			gf_set_item(itemId,ref:Get("icon"),ref:Get("bg"))
			ref:Get("count").text = item.reward[2]
			gf_set_click_prop_tips(ref,itemId)
		else
			print("<color=red>奖励未配置</color>",self.lottery_config.code*1000+i)
		end
	end
	-- 记录页签
	local root = self.refer:Get("rightModeRoot")
	self.pages_sel = {}
	for i=1,root.childCount do
		self.pages_sel[i-1] = root:GetChild(i-1):FindChild("sel").gameObject
	end
	-- 通知项scroll
	self.messageScroll = self.refer:Get("messageScroll")
	-- 通知项
	self.messageContents = {}
	local root = self.refer:Get("contentRoot")
	self.messageContents.root = root
	self.messageContents.smaple = root:GetChild(0).gameObject
	self.messageContents[1] = self.messageContents.smaple:GetComponent("UnityEngine.UI.Text")
	self:set_text_on_click(self.messageContents[1])

	self:set_key_count()
	self:set_base_res()
	self:switch_title(message_type or 0)

	self.refer:Get("warehouse_red_point"):SetActive(self.item_obj.storehouseReward)
	self.fly_obj_sample = self.refer:Get("flyItem")
end

-- 设置钥匙数量
function LuckyDrawView:set_key_count()
	self.key_count.text = LuaItemManager:get_item_obejct("bag"):get_item_count(self.key_id,ServerEnum.BAG_TYPE.NORMAL)
end

-- 设置基础资源
function LuckyDrawView:set_base_res()
	local game = LuaItemManager:get_item_obejct("game")
	self.gold_count.text = gf_format_count(game:get_money(ServerEnum.BASE_RES.GOLD))
	self.luck_count.text = gf_format_count(game:get_money(ServerEnum.BASE_RES.LOTTERY_POINT))
end

--初始化设置通知项内容 t==0全服 t==1个人
function LuckyDrawView:init_message_content(t)
	local msg = t==0 and self.item_obj.serverRecord or self.item_obj.personalRecord
	for i=#msg+1,#self.messageContents do
		self.messageContents[i].gameObject:SetActive(false)
	end
	for i,v in ipairs(msg) do
		if not self.messageContents[i] then
			local go = LuaHelper.Instantiate(self.messageContents.smaple)
			go.transform:SetParent(self.messageContents.root,false)
			self.messageContents[i] = go:GetComponent("UnityEngine.UI.Text")
			self:set_text_on_click(self.messageContents[#self.messageContents])
		end
		self.messageContents[i].gameObject:SetActive(true)
		local content = nil
		if t == 0 then
			-- print(v.broadcastId,v.roleId,v.name,v.code,v.num)
			content = ChatTools:chat_text_modification(ChatTools:marquee_modification(v.broadcastId,{v.roleId,v.name,v.code,v.num}))
		else
			local data = ConfigMgr:get_config("lottery_bonus_pool")[v]
			if data then
				content = ChatTools:chat_text_modification(string.format(gf_localize_string("你在秘境中寻获<902,%d,%d>"),data.reward[1],data.reward[2]))
			else
				print("<color=red>寻宝信息读取不到配置</color>",v)
				return
			end
		end
		-- print(self.messageContents[i],content)
		if content then
			self:set_content(self.messageContents[i],content)
		end
	end
end

--增加一条通知
function LuckyDrawView:add_message_content(t,v)
	if #self.messageContents<self.item_obj.message_max_count then
		local go = LuaHelper.Instantiate(self.messageContents.smaple)
		go.transform:SetParent(self.messageContents.root,false)
		self.messageContents[#self.messageContents+1] = go:GetComponent("UnityEngine.UI.Text")
		self:set_text_on_click(self.messageContents[#self.messageContents])
	else
		local text = self.messageContents[1]
		table.remove(self.messageContents,1)
		table.insert(self.messageContents,text)
		text.transform:SetAsLastSibling()
	end
	self.messageContents[#self.messageContents].gameObject:SetActive(true)
	local content = nil
	if t == 0 then
		content = ChatTools:chat_text_modification(ChatTools:marquee_modification(v.broadcastId,{v.roleId,v.name,v.code,v.num}))
	else
		local data = ConfigMgr:get_config("lottery_bonus_pool")[v]
		content = ChatTools:chat_text_modification(string.format(gf_localize_string("你在秘境中寻获<902,%d,%d>"),data.reward[1],data.reward[2]))
	end
	-- self.messageContents[#self.messageContents].text = content
	self:set_content(self.messageContents[#self.messageContents],content)
end

-- 设置一个点击文本
function LuckyDrawView:set_text_on_click(text)
	text.OnHrefClickFn = function( arg ) ChatTools:text_on_click(arg) end
end

-- 设置一条消息的内容和大小
function LuckyDrawView:set_content(text,content)
	local size = LuaHelper.GetStringSize(gf_remove_rich_text(content),text,message_max_width)
	-- text:GetComponent("UnityEngine.UI.LayoutElement").preferredHeight = size.y
	text.transform.sizeDelta = Vector2(message_max_width,size.y+10)
	text.text = content
	self.messageScroll.verticalNormalizedPosition = 0
end

function LuckyDrawView:switch_title(value)
	if message_type then
		self.pages_sel[message_type]:SetActive(false)
	end
	message_type = value
	self.pages_sel[message_type]:SetActive(true)
	self:init_message_content(value)
end

function LuckyDrawView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了开宝箱ui 按钮 ",obj,arg)
	if cmd == "close_lucky_draw" then -- 关闭
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btnOnceDraw" then -- 单抽
		self:switch_title(1)
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:lottery_draw(self.lottery_config.cost[1])
	elseif cmd == "btnTenConsecutiveDraw" then -- 十连抽
		self:switch_title(1)
		interval_time = 0.05
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:lottery_draw(self.lottery_config.cost[2])
	elseif cmd == "btnFiftyConsecutiveDraw" then -- 五十连抽
		self:switch_title(1)
		interval_time = 0.03
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:lottery_draw(self.lottery_config.cost[3])
	elseif cmd == "btnExchange" then -- 积分兑换
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_open_model(ClientEnum.MODULE_TYPE.MALL,3,4)
	elseif cmd == "btnWarehouse" then -- 寻宝仓库
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("luckyDrawWarehouse", self.item_obj) 
	elseif cmd == "rightMode" then -- 右边广播标题 -- 切换显示内容
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		self:switch_title(obj.transform:GetSiblingIndex())
	elseif cmd == "btnHelp" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1091)
	end
end

function LuckyDrawView:lottery_draw(cost)
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	local key_count = LuaItemManager:get_item_obejct("bag"):get_item_count(cost[2],ServerEnum.BAG_TYPE.NORMAL)
	local need_count = cost[3] - key_count
	if need_count > 0 and self.item_obj.needRemind then
		local ccmp = LuaItemManager:get_item_obejct("cCMP")
		local goods = LuaItemManager:get_item_obejct("mall"):get_goods_for_prodId(cost[2])
		local one_key_money = 1 -- 标 商店加入商品后读取价格
		if goods then
			one_key_money = goods.offer
		else
			print("<color=red>没有配置商品</color>")
		end
		local fn = function(a,b)
			if b and self.item_obj.needRemind then
				self.item_obj.needRemind = false
				self:send_lottery_draw(cost[1],one_key_money*need_count,0)
			else
				self:send_lottery_draw(cost[1],one_key_money*need_count)
			end
		end
		local tips_content = string.format(gf_localize_string("当前道具%s不足\n是否花费<color=#B01FE5>%d</color>元宝立即补充<color=#B01FE5>%d</color>个？"),
			LuaItemManager:get_item_obejct("itemSys"):get_have_color_prop_name(ConfigMgr:get_config("item")[cost[2]]),one_key_money*need_count,need_count)
		local v = ccmp:toggle_message(tips_content,false,gf_localize_string("今日不再提醒"),fn)
	else
		self:send_lottery_draw(cost[1],0)
	end
end

function LuckyDrawView:send_lottery_draw(count,need_money,needRemind)
	if LuaItemManager:get_item_obejct("game"):get_money(2)>=need_money then
		self.item_obj:LotteryDraw_c2s(count,needRemind)
		self.lucky_draw_eff:SetActive(false)
		self.lucky_draw_eff:SetActive(true)
	else
		gf_message_tips("元宝不足")
	end
end

function LuckyDrawView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "ChatR") then -- 接收广播
			-- gf_print_table(msg,"<color=red>接收广播</color>"..message_type)
			if msg.code == 18 and message_type == 0 then
				local info = {
					roleId = msg.args[1],
					name = msg.args[2],
					code = msg.args[3],
					num = msg.args[4],
					broadcastId = msg.code,
				}
				self:add_message_content(message_type,info)
			end
		elseif id2 == Net:get_id2("base", "UpdateLvlR") then -- 等级提升
			local lv = LuaItemManager:get_item_obejct("game"):getLevel()
			if lv < self.lottery_config.level_range[1] or lv > self.lottery_config.level_range[2] then
				self:init_ui()
			end

		elseif id2 == Net:get_id2("base", "LotteryDrawR") then -- 获取秘境寻宝 寻宝结果
			-- gf_message_tips(msg,"寻宝结果")
			if msg.err == 0 then
				for i,v in ipairs(msg.rewardCodeList) do
					if message_type == 1 then
						self:add_message_content(message_type,v)
					end
					self:play_fly_prop(v)
				end
			end
		elseif id2 == Net:get_id2("base", "UpdateResR") then -- 更新资源
			wait_time = 0
			self:set_base_res()
		end
	elseif id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "UpdateItemR") then -- 更新物品
			self:set_key_count()
		end
	elseif id1 == ClientProto.ShowHotPoint then
		if msg.btn_id == ClientEnum.MAIN_UI_BTN.LUCKY_DRAW then
			self.refer:Get("warehouse_red_point"):SetActive(msg.visible)
		end
	end
end

function LuckyDrawView:register() 
	print("寻宝注册时间")
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function LuckyDrawView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

function LuckyDrawView:on_showed()
	print("显示寻宝界面")
	if self.init then
    	self:register()
    end
end

function LuckyDrawView:on_hided()
    self:cancel_register()
end

-- 释放资源
function LuckyDrawView:dispose()
	self.init = nil
	self:hide()
    self._base.dispose(self)
end

-- 播放一个飞行道具
function LuckyDrawView:play_fly_prop(v)
	local data = ConfigMgr:get_config("lottery_bonus_pool")[v]
	local propId,count = data.reward[1],data.reward[2]
	local action = function()
		wait_time = wait_time - interval_time
		local obj = fly_objs[1]
		if not obj then
			local go = LuaHelper.Instantiate(self.fly_obj_sample)
			go.transform:SetParent(self.fly_obj_sample.transform.parent,false)
			local ref = go:GetComponent("ReferGameObjects")
			obj = {}
			obj.go = go
			obj.bg = ref:Get("bg")
			obj.icon = ref:Get("icon")
			obj.count = ref:Get("count")
			obj.tween = {
				go:GetComponent("TweenScale"),
				go:GetComponent("TweenPosition"),
				go:GetComponent("TweenAlpha"),
			}
		else
			table.remove(fly_objs,1)
		end
		obj.go:SetActive(true)
		obj.go.transform:SetAsFirstSibling()
		gf_set_item(propId,obj.icon,obj.bg)
		obj.count.text = count or 1
		for i,v in ipairs(obj.tween) do
			v:ResetToBeginning()
			v:PlayForward()
		end
		local end_fn = function()
			obj.go:SetActive(false)
			fly_objs[#fly_objs+1] = obj
		end
		PLua.Delay(end_fn,1) -- 飞行道具回收延迟时间
	end
	PLua.Delay(action,wait_time) -- 飞行道具回收延迟时间
	wait_time = wait_time + interval_time
end

return LuckyDrawView