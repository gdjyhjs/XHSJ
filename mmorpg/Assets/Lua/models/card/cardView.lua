--[[--
-- 七煞牌局视窗
-- @Author:Seven
-- @DateTime:2017-10-24 12:09:23
胜利 字体 颜色 14D472FF
--]]


local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local CardEnum = require("models.card.cardEnum")
local none_img = "poker_card_bg"
local dowm_card_img = "poker_card_0"
local down_dis = 100 -- 战斗下移
local wait_time = 3 -- 对战结束等待时间



local CardView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "poker.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj   
end)

-- 资源加载完成
function CardView:on_asset_load(key,asset)
	self.score_time = 0
	self.play_card = {}
	self.hand_card = {}
	self.matching_time = 0 -- 匹配时间
	self.count_down_time = 0 -- 出牌时间
	self.battle_down_time = 0 -- 战斗时间倒计时
	self.battle_schedule = 0 -- 战斗进度
	self.now_state = 1 -- 当前状态 models.card.cardEnum
	self.once_set_idle = false -- 第一次进入待机界面
	self.once_set_mine_info = false -- 曾经设置过自己的信息
	self.once_set_enemy_info = false -- 曾经设置过敌人的信息
	self:init_ui()
	self.init = true
	-- 发协议获取自己的牌局信息
	self.item_obj:GetCardsGameInfo_c2s()
end

function CardView:init_ui()
	self.gray_color = self.refer:Get("image_discolor_material").material -- 灰色材质球
	self.enemyLeftCard = self.refer:Get("enemyLeftCard") -- 敌人剩余卡牌
	self.cardDes = self.refer:Get("cardDes") -- 卡牌说明
	self.awardList = self.refer:Get("awardList") -- 奖励浏览
	self.dayWindCount = self.refer:Get("dayWindCount") -- 今日胜场
	self.mineInfo = self.refer:Get("mineInfo") -- 我的信息
	self.enemyInfo = self.refer:Get("enemyInfo") -- 敌人相关信息
	self.minePlay = self.refer:Get("minePlay") -- 我打出的牌
	self.mineHand = self.refer:Get("mineHand") -- 我的手牌
	self.enemyHand = self.refer:Get("enemyHand") -- 敌人的手牌
	self.enemyPlay = self.refer:Get("enemyPlay") -- 敌人打出的牌
	self.enemyCard = self.refer:Get("enemyCard") -- 敌人的卡牌
	self.gameRecord = self.refer:Get("gameRecord") -- 游戏记录
	self.gameCount = self.refer:Get("gameCount") -- 游戏场次
	self.gameCountText = self.gameCount:GetComponentInChildren("UnityEngine.UI.Text") -- 文本
	self.matchingObj = self.refer:Get("matchingObj") -- 匹配中UI
	self.matchingTime = self.refer:Get("matchingTime") -- 匹配时间
	self.countDown = self.refer:Get("countDown") -- 出牌倒计UI
	self.countDownTime = self.refer:Get("countDownTime") --出牌倒计时时间
	self.startMatchBtn = self.refer:Get("startMatchBtn") -- 开始匹配按钮
	self.mineWin = self.refer:Get("mineWin") -- 我的相关UI
	self.mineDefeat = self.refer:Get("mineDefeat") -- 我的相关UI
	self.mineDraw = self.refer:Get("mineDraw") -- 我的相关UI
	self.surePlayBtn = self.refer:Get("surePlayBtn") -- 确认出牌按钮
	self.collisionEff = self.refer:Get("collisionEff") -- 我的相关UI

	self.mine_play_card_def_local_pos = self.minePlay.localPosition
end

function CardView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("CardDeBug:点击按钮",obj)
	if cmd == "closeCard" then -- 关闭
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
        local cb = function()
			self:dispose()
		end
		if self.now_state == CardEnum.STATE.MATCHING then
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(gf_localize_string("是否取消匹配"),cb)
		else
			self:dispose()
		end
    elseif cmd == "btnHelp" then -- tips
    	print("show tips ?")
    	gf_show_doubt(1141)

	elseif self.now_state == CardEnum.STATE.SELECT_CARD then
		print("DE_BUG:是否锁定出牌",self.item_obj:get_sure_play())
		if cmd == "mineHandCard" then -- 打出了手牌
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        	local i = obj.transform:GetSiblingIndex()+1
        	if self.hand_card[i] and self.hand_card[i]>0 then
        		local k = nil
        		for j=1,5 do
        			if not self.play_card[j] then
        				k= j
        				break
        			end
        		end
        		if k then
        			self.hand_card[i] = self.hand_card[i] - 1
        			self.play_card[k] = i
        		else
        			gf_message_tips(gf_localize_string("出牌已满"))
        		end
        	else
        		gf_message_tips(gf_localize_string("该类卡牌已出完"))
        	end
			self:set_mine_hand_card()
			self:set_mine_play_card()

        elseif cmd == "minePlayCard" then -- 撤回打出的牌
			if self.item_obj:get_sure_play() then
				gf_message_tips("买定离手不能修改哦！")
				return
			end
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        	local i = obj.transform:GetSiblingIndex()+1
        	if not self.play_card[i] then
        		return
        	end
        	self.hand_card[self.play_card[i]] = self.hand_card[self.play_card[i]] + 1
        	self.play_card[i] = nil
			self:set_mine_hand_card()
			self:set_mine_play_card()

		elseif cmd == "surePlayBtn" then -- 确定打出的牌
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        	if #self.hand_card == 5 then
	        	self.item_obj:CardsGameDiscard_c2s(self.play_card)
	    	else
	    		gf_message_tips("请先打出五张牌")
	    	end
        end

    elseif self.now_state == CardEnum.STATE.IDLE or self.now_state == CardEnum.STATE.SETTLEMENT  or self.now_state == CardEnum.STATE.ENEMY_RUN then
    	if cmd == "startMatchBtn" then
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
    		self.item_obj:CardsGameMatch_c2s()
    	end
    elseif self.now_state == CardEnum.STATE.MATCHING then
    	if cmd == "cancleMatching" then -- 取消匹配
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 音效
        	self.item_obj:CardsGameMatchCancel_c2s()
    	end
	end
end

function CardView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("task") then
		if id2== Net:get_id2("task", "GetCardsGameInfoR") then
			-- 打开界面获取需要显示的信息
			self:set_state()
		elseif id2== Net:get_id2("task", "CardsGameMatchR") then
			-- 牌局开始匹配
		elseif id2== Net:get_id2("task", "UpdateCardsGameInfo") then
			-- 更新牌局游戏信息(全部都可缺省,只修改有内容的字段)
			self:set_state()
		elseif id2== Net:get_id2("task", "CardsGameDiscardR") then
			-- 出牌返回
			if self.init and msg.err==0 then
				self.surePlayBtn.gameObject:SetActive(false)
			end
			self:set_mine_play_card()
		end
	end
end

-- 获取设置自己的信息
function CardView:set_mine_info()
	if not self.init then
		return
	end
	if not self.once_set_mine_info then
		self.once_set_mine_info = true
		self.mineInfo.gameObject:SetActive(true)
		self.mine_info_ui = {
			name = self.mineInfo:Get("name"),
			weekWinCount = self.mineInfo:Get("weekWinCount"),
			weekWinCountRate = self.mineInfo:Get("weekWinCountRate"),
			score = self.mineInfo:Get("score"),
			scoreText = self.mineInfo:Get("scoreText"),
			head = self.mineInfo:Get("head"),
			win1 = self.mineInfo:Get("win1"),
			win2 = self.mineInfo:Get("win2"),
		}
		self.mine_info_ui.name.text = self.item_obj:get_mine_name()
		gf_set_head_ico(self.mine_info_ui.head,self.item_obj:get_mine_head())
		-- 设置胜利奖励浏览 falg
		self.received_obj = {}
		local root = self.refer:Get("awardList")
		local sample = root:GetChild(0).gameObject
		local tf = nil
		local data = ConfigMgr:get_config("cards_game_daily_reward")
		local count = root.childCount
		for i,v in ipairs(data) do
			local tf = nil
			if  count>= i then
				tf = root:GetChild(i-1)
			else
				tf = LuaHelper.Instantiate(sample).transform
				tf:SetParent(root,false)
			end
			tf.gameObject:SetActive(true)
			local bg = tf:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
			local icon = tf:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
			local count = tf:FindChild("count"):GetComponent("UnityEngine.UI.Text")
			local winCount = tf:FindChild("winCount"):GetComponent("UnityEngine.UI.Text")
			gf_set_item(v.reward[1][1],icon,bg)
			count.text = v.reward[1][2]
			winCount.text = string.format(gf_localize_string("胜%d场<color=#D5D5BBFF>可领</color>"),v.win_count)
			self.received_obj[#self.received_obj+1] = {winCount=winCount,icon=icon,bg=bg}
			gf_set_click_prop_tips(tf,v.reward[1][1])
		end
	end

	self.mine_info_ui.weekWinCount.text = self.item_obj:get_mine_win_week()
	self.mine_info_ui.weekWinCountRate.text = string.format("%d%%",self.item_obj:get_mine_times_week()>0 and (100*self.item_obj:get_mine_win_week()/self.item_obj:get_mine_times_week()) or 0)
	-- self.mine_info_ui.win1:SetActive(self.item_obj:get_mine_round_win_times()>0)
	-- self.mine_info_ui.win2:SetActive(self.item_obj:get_mine_round_win_times()>1)

	-- 如果正在战斗，显示积分 falg
	if self.item_obj:get_card_state() == CardEnum.STATE.BATTLE then
		self.mine_info_ui.score:SetActive(true)
		self.mine_info_ui.scoreText.text = 0
	else
		self.mine_info_ui.score:SetActive(false)
	end
	-- 胜利奖励领取情况 falg
	for i,v in ipairs(self.received_obj) do
		if  self.item_obj:get_daily_rewards(i) then
			v.winCount.text = "已领取"
			v.icon.material = self.gray_color
			v.bg.material = self.gray_color
		end
	end
	self.dayWindCount.text = self.item_obj:get_win_today()
end

-- 设置敌人的信息和对战信息
function CardView:set_enemy_info()
	if not self.init then
		return
	end
	if not self.once_set_enemy_info then
		self.once_set_enemy_info = true
		self.enemyInfo.gameObject:SetActive(true)
		self.enemy_info_ui = {
			name = self.enemyInfo:Get("name"),
			weekWinCount = self.enemyInfo:Get("weekWinCount"),
			weekWinCountRate = self.enemyInfo:Get("weekWinCountRate"),
			score = self.enemyInfo:Get("score"),
			scoreText = self.enemyInfo:Get("scoreText"),
			head = self.enemyInfo:Get("head"),
			win1 = self.enemyInfo:Get("win1"),
			win2 = self.enemyInfo:Get("win2"),
		}

		local data = ConfigMgr:get_config("cards_game")
		-- 初始化设置敌人的手牌
		self.enemy_hand_card_ui = {}
		for i=1,self.enemyCard.childCount do
			local tf = self.enemyCard:GetChild(i-1)
			local icon = tf:GetComponent(UnityEngine_UI_Image)
			local num = tf:GetComponentInChildren("UnityEngine.UI.Text")
			tf.name = "enemyHandCard"
			self.enemy_hand_card_ui[i] = {
				icon = icon,
				num = num,
			}
			if data[i] then
				gf_setImageTexture(icon,data[i].icon)
			end
			num.text = "X3"
		end
		-- 初始化设置我的手牌
		self.mine_hand_card_ui = {}
		for i=1,self.mineHand.childCount do
			local tf = self.mineHand:GetChild(i-1)
			local icon = tf:GetComponent(UnityEngine_UI_Image)
			local num = tf:GetComponentInChildren("UnityEngine.UI.Text")
			tf.name = "mineHandCard"
			self.mine_hand_card_ui[i] = {
				icon = icon,
				num = num,
			}
			if data[i] then
				gf_setImageTexture(icon,data[i].icon)
			end
			num.text = "X3"
		end
		-- 初始化设置我的出牌
		self.mine_play_card_ui = {}
		for i=1,self.minePlay.childCount do
		 	local tf = self.minePlay:GetChild(i-1)
		 	local icon = tf:GetComponent(UnityEngine_UI_Image)
		 	local lock = tf:FindChild("lock").gameObject
		 	local exchange = tf:Find("exchange").gameObject
		 	local wait = tf:Find("wait").gameObject
		 	exchange.name = "0"
		 	wait.name = "0"
		 	self.mine_play_card_ui[i] = {icon = icon,
		 		tf = tf,
		 		def_pos = tf.position,
		 		def_local_pos = tf.localPosition,
		 		lock = lock,
		 		exchange = exchange,
		 		wait = wait,
		 	}
		 	tf.name = "minePlayCard"
		end
		-- 初始化设置敌人出牌
		self.enemy_play_card_ui = {}
		for i=1,self.enemyPlay.childCount do
		 	local tf = self.enemyPlay:GetChild(i-1)
		 	local icon = tf:GetComponent(UnityEngine_UI_Image)
		 	local exchange = tf:Find("exchange").gameObject
		 	exchange.name = "0"
		 	self.enemy_play_card_ui[i] = {icon = icon,
		 		tf = tf,
		 		def_pos = tf.position,
		 		def_local_pos = tf.localPosition,
		 		exchange = exchange,
		 	}
		 	tf.name = "enemyPlayCard"
		end
		self.game_record_ui = {}
		print("--初始化比赛记录ui",self.gameRecord.childCount)
		for i=1,self.gameRecord.childCount do
			local tf = self.gameRecord:GetChild(i-1)
			local score = tf:FindChild("score"):GetComponent("UnityEngine.UI.Text")
			local result = tf:FindChild("result"):GetComponent("UnityEngine.UI.Text")
			print("比赛记录ui",tf,score,result)
			self.game_record_ui[i] = {
				go = tf.gameObject,
				score = score,
				result = result,
			}
		end
		-- 初始化碰撞特效
		self.collision_eff_ui = {}
		for i=1,self.collisionEff.childCount do
			local tf = self.collisionEff:GetChild(i-1)
			local collision = tf:FindChild("collision").gameObject
			local bomb = tf:FindChild("bomb").gameObject
			collision.name = "0"
			bomb.name = "0"
			self.collision_eff_ui[i] = {
				collision = collision,
				bomb = bomb,
			}
		end
	end
	self.enemy_info_ui.name.text = self.item_obj:get_enemy_name()
	gf_set_head_ico(self.enemy_info_ui.head,self.item_obj:get_enemy_head()) -- 头像
	self.enemy_info_ui.weekWinCount.text = self.item_obj:get_enemy_win_week()
	self.enemy_info_ui.weekWinCountRate.text = string.format("%d%%",self.item_obj:get_enemy_times_week()>0 and (100*self.item_obj:get_enemy_win_week()/self.item_obj:get_enemy_times_week()) or 0)

	-- 如果正在战斗，显示积分 falg
	if self.item_obj:get_card_state() == CardEnum.STATE.BATTLE then
		self.enemy_info_ui.score:SetActive(true) 
		self.enemy_info_ui.scoreText.text = 0
	else
		self.enemy_info_ui.score:SetActive(false) 
	end
end

-- 设置描述信息
function CardView:set_card_des()
	if not self.init then
		return
	end
	if not self.once_set_idle then
		self.once_set_idle = true
		-- 设置卡牌说明 falg
		local root = self.cardDes.transform:GetChild(0)
		local sample = root:GetChild(0).gameObject
		local data = ConfigMgr:get_config("cards_game")
		local count = root.childCount
		for i,v in ipairs(data) do
			if v.name then
				local tf = nil
				if  count>= i then
					tf = root:GetChild(i-1)
				else
					tf = LuaHelper.Instantiate(sample).transform
					tf:SetParent(root,false)
				end
				gf_setImageTexture(tf:FindChild("icon"):GetComponent(UnityEngine_UI_Image),v.icon)
				tf:FindChild("name"):GetComponent("UnityEngine.UI.Text").text = v.name
				tf:FindChild("des"):GetComponent("UnityEngine.UI.Text").text = v.des
			end
		end
	end
end

-- 设置敌人剩余手牌
function CardView:set_enemy_left_card()
	if not self.init then
		return
	end
	if self.once_set_enemy_info then
		local CardInfo = self.item_obj:get_enemy_cards_list()
		for i,v in ipairs(self.enemy_hand_card_ui) do
			local num = CardInfo[i] or 0
			v.num.text = string.format("X%d",num)
		end
	end
end

-- 设置我的手牌
function CardView:set_mine_hand_card()
	if not self.init then
		return
	end
	if self.once_set_enemy_info then
		local CardInfo = self.hand_card
		for i,v in ipairs(self.mine_hand_card_ui) do
			local num = CardInfo[i] or 0
			v.num.text = string.format("X%d",num)
			v.icon.material = num==0 and self.gray_color or nil
		end
	end
end

-- 设置敌人出牌 count 对战中才有 现在是对战的第几回合（最多几张牌对比过了分值）
function CardView:set_enemy_play_card(count)
	self:set_play_acrd(self.enemy_play_card_ui,self.item_obj:get_enemy_discard(),self.play_card,count)
end
-- 设置我的出牌 count 对战中才有 现在是对战的第几回合（最多几张牌对比过了分值）
function CardView:set_mine_play_card(count)
	self:set_play_acrd(self.mine_play_card_ui,self.play_card,self.item_obj:get_enemy_discard(),count)
end

-- 设置出牌情况
function CardView:set_play_acrd(ui,setCard,targetCard,count)
	local index = count or 0
	if not self.init then
		return
	end
	if self.now_state == CardEnum.STATE.ENEMY_RUN or self.now_state == CardEnum.STATE.SETTLEMENT then
		index = 5
	end
	if not ui[1].lock then
		print("设置出牌",index,"mark",self.down_mark)
	end
	if self.once_set_enemy_info then
		local data = ConfigMgr:get_config("cards_game")
		local sel = true
		for i,v in ipairs(ui) do
			-- eff start 关闭等待出牌特效
			if v.wait then
				v.wait:SetActive(false)
				-- v.wait.transform.localPosition = Vector2(10000,10000)
			end
			-- eff end
			if setCard[i] then
				if i>index and (self.now_state ~= CardEnum.STATE.SETTLEMENT or self.now_state ~= CardEnum.STATE.ENEMY_RUN) then
					if not v.lock and (i>(self.down_mark or 5)) then
						gf_setImageTexture(v.icon,dowm_card_img)
					else
						gf_setImageTexture(v.icon,setCard[i] and data[setCard[i]].icon or none_img)
						v.tf.localPosition = v.def_local_pos
					end
					v.icon.material = nil
				elseif setCard[i] and targetCard[i] then
					local exchange = data[setCard[i]].effect == "exchange" or data[targetCard[i]].effect == "exchange" -- 是否包含交换牌
					if exchange then -- 交换牌
						local t = setCard
						setCard = targetCard
						targetCard = t
					end
					local enemy_bomb = data[targetCard[i]].effect == "bomb" -- 对方是不是炸弹
					local mine_bomb = data[setCard[i]].effect == "bomb" -- 对方是不是炸弹
					local win = data[setCard[i]].score >= data[targetCard[i]].score
					if mine_bomb then -- 我是炸弹，那么赢
						win = true
					end
					if enemy_bomb then -- 敌人是炸弹，那么输
						win = false
					end
					-- print("设置精灵",v.icon,data[setCard[i]].icon)
					gf_setImageTexture(v.icon,data[setCard[i]].icon)
					if win then -- 胜利
					-- print(count,i,"交换吗",exchange,"被炸吗",bomb,"胜利")v.icon.name = "胜利"
						v.icon.material = nil
					else -- 失败
					-- print(count,i,"交换吗",exchange,"被炸吗",bomb,"失败")v.icon.name = "失败"
						v.icon.material = self.gray_color
					end
					v.tf.localPosition = v.def_local_pos
					if exchange then -- 交换牌
						local t = setCard
						setCard = targetCard
						targetCard = t
					end
				else
					gf_setImageTexture(v.icon,none_img)
					v.icon.material = nil
					v.tf.localPosition = v.def_local_pos
				end
			else
				gf_setImageTexture(v.icon,none_img)
				v.icon.material = nil
				v.tf.localPosition = v.def_local_pos
				-- eff start 打开等待出牌特效
				if v.wait and sel then
					sel = false
					v.wait:SetActive(true)
					-- v.wait.transform.localPosition = Vector2(0,0)
				end
				-- eff end
			end
			if v.lock then
				v.lock:SetActive(self.now_state == CardEnum.STATE.SELECT_CARD and self.item_obj:get_sure_play())
			end
		end
	end
end

	-- 各个阶段的设置
-- 设置状态
function CardView:set_state()
	if not self.init then
		return
	end
	self.battle_schedule = 0
	self.now_state = self.item_obj:get_card_state()
	print("CardDeBug:设置状态",self.now_state)
	self.gameCount:SetActive(false)     -- -- 游戏场次
	self.mineWin:SetActive(false)     --- 我胜利
	self.mineDefeat:SetActive(false)     --- 我失败
	self.mineDraw:SetActive(false)     --- 平局
	self.matchingObj:SetActive(self.now_state == CardEnum.STATE.MATCHING)     ---- 匹配中UI
	if self.now_state == CardEnum.STATE.MATCHING then
		self.matching_time = 0
		self.matchingTime.text = gf_convert_time_ms(self.matching_time)
	end
	-- 我的信息
	self:set_mine_info()
	-- 匹配按钮
	self.startMatchBtn:SetActive(self.now_state == CardEnum.STATE.IDLE)
	-- 是否在待机和匹配界面
	local idle_or_matching = bit._and(self.now_state,CardEnum.STATE.IDLE+CardEnum.STATE.MATCHING)==self.now_state
	if idle_or_matching then
		self:set_card_des()	
	else
		self:set_enemy_left_card()
		self:set_enemy_info()
	end
	self.cardDes:SetActive(idle_or_matching)
	self.enemyLeftCard.gameObject:SetActive(not idle_or_matching)
	self.minePlay.gameObject:SetActive(not idle_or_matching)
	self.enemyPlay.gameObject:SetActive(not idle_or_matching)
	self.enemyInfo.gameObject:SetActive(not idle_or_matching)
	-- 手牌 -- 选牌界面     ---- 选牌中
	local on_select_card = self.now_state == CardEnum.STATE.SELECT_CARD
	if on_select_card then
		self.count_down_time = self.item_obj:get_round_end_time() - Net:get_server_time_s()
		self.countDownTime.text = gf_convert_time_ms(self.count_down_time)
	end
	self.mineHand.gameObject:SetActive(on_select_card)
	self.enemyHand.gameObject:SetActive(on_select_card)
	self.countDown:SetActive(on_select_card)
	-- 对战
	local on_battle = self.now_state == CardEnum.STATE.BATTLE
	-- 选牌或者对战
	if on_select_card or on_battle then
		self.hand_card = self.item_obj:get_mine_cards_list()
		self.play_card = self.item_obj:get_mine_last_discard()
		if on_battle then
			self.down_mark = 0
		end
		self:set_mine_hand_card()
		self:set_mine_play_card()
		self:set_enemy_left_card()
		self:set_enemy_play_card()
	end
	if on_battle then
		self.battle_down_time = self.item_obj:get_round_end_time() - Net:get_server_time_s()
	end
	-- 结算
	if self.now_state == CardEnum.STATE.SETTLEMENT or self.now_state == CardEnum.STATE.ENEMY_RUN then
		View("Settlement", self.item_obj)
	end
	if self.now_state == CardEnum.STATE.SELECT_CARD then
		print("设定位置")
		self.minePlay.localPosition = self.mine_play_card_def_local_pos + Vector3(0,down_dis,0)
	else
		self.minePlay.localPosition = self.mine_play_card_def_local_pos
	end
	self.surePlayBtn.gameObject:SetActive(self.now_state == CardEnum.STATE.SELECT_CARD and not self.item_obj:get_sure_play())

	self:set_red_heart(self.now_state == CardEnum.STATE.BATTLE)
end


function CardView:on_update(dt)
	if not self.init then
		return
	end                                                                                                                                                                                                                                                                    
	if self.now_state == CardEnum.STATE.MATCHING then
		self.matching_time = self.matching_time + dt
		self.matchingTime.text = gf_convert_time_ms(self.matching_time)
	end
	if self.now_state == CardEnum.STATE.SELECT_CARD then
		self.count_down_time = self.count_down_time - dt
		self.countDownTime.text = gf_convert_time_ms(self.count_down_time<0 and 0 or self.count_down_time)
	end
	if self.now_state == CardEnum.STATE.BATTLE then
		self.battle_down_time = self.battle_down_time - dt
		
		-- 设置战斗结果
		local r = 0
		if bit._and(self.battle_schedule,1)~=1 and self.battle_down_time<(wait_time+8) then -- 第1场战斗已结束 并且战斗进度1尚未OK
			self.battle_schedule = bit._or(self.battle_schedule,1)
			r = 1
			self.mine_play_card_ui[r].tf.position = self.mine_play_card_ui[r].def_pos
		end
		if bit._and(self.battle_schedule,2)~=2 and self.battle_down_time<(wait_time+6) then -- 第2场战斗已结束 并且战斗进度2尚未OK
			self.battle_schedule = bit._or(self.battle_schedule,2)
			r = 2
			self.mine_play_card_ui[r].tf.position = self.mine_play_card_ui[r].def_pos
		end
		if bit._and(self.battle_schedule,4)~=4 and self.battle_down_time<(wait_time+4) then -- 第3场战斗已结束 并且战斗进度3尚未OK
			self.battle_schedule = bit._or(self.battle_schedule,4)
			r = 3
			self.mine_play_card_ui[r].tf.position = self.mine_play_card_ui[r].def_pos
		end
		if bit._and(self.battle_schedule,8)~=8 and self.battle_down_time<(wait_time+2) then -- 第4场战斗已结束 并且战斗进度4尚未OK
			self.battle_schedule = bit._or(self.battle_schedule,8)
			r = 4
			self.mine_play_card_ui[r].tf.position = self.mine_play_card_ui[r].def_pos
		end
		if bit._and(self.battle_schedule,16)~=16 and self.battle_down_time<wait_time then -- 第5场战斗已结束 并且战斗进度5尚未OK
			self.battle_schedule = bit._or(self.battle_schedule,16)
			r = 5
			self.mine_play_card_ui[r].tf.position = self.mine_play_card_ui[r].def_pos
		end
		if r > 0 then
			self.down_mark = r+1
			self:set_mine_play_card(r)
			self:set_enemy_play_card(r)
			local m_score = 0
			local e_score = 0
			local data = ConfigMgr:get_config("cards_game")
			for i=1,r do
				local mine_discard = self.play_card
				local enemy_discard = self.item_obj:get_enemy_discard()
				if mine_discard[i] and enemy_discard[i] then
					local exchange = data[mine_discard[i]].effect == "exchange" or data[enemy_discard[i]].effect == "exchange"
					if exchange then -- 交换牌
						print("得分交换")
						local t = mine_discard
						mine_discard = enemy_discard
						enemy_discard = t
					end

					if mine_discard[i] and enemy_discard[i] then
						if data[enemy_discard[i]].effect ~= "bomb" then
							print(i,"我得分",data[mine_discard[i]].score)
							m_score = m_score + data[mine_discard[i]].score
						end
						if data[mine_discard[i]].effect ~= "bomb" then
							print(i,"敌方得分",data[enemy_discard[i]].score)
							e_score = e_score + data[enemy_discard[i]].score
						end
					end
					if exchange then -- 交换牌
						local t = mine_discard
						mine_discard = enemy_discard
						enemy_discard = t
					end
				end
			end
			print("设置单场战斗结果,场次：",r,"我得分",self.mine_info_ui.scoreText.text,m_score,"对方得分",self.enemy_info_ui.scoreText,e_score)
			self.mine_info_ui.scoreText.text = m_score
			self.enemy_info_ui.scoreText.text = e_score
		end
		-- 播放战斗
		if self.battle_down_time>wait_time then -- 播放战斗
			local data = ConfigMgr:get_config("cards_game")
			local idx = math.ceil((self.battle_down_time - wait_time)/2) -- 当前战斗的是第几张牌
			local schedule = 2 - (self.battle_down_time - wait_time - (idx - 1) * 2) -- 战斗进度时间点
			if idx>5 then
				return
			end
			idx = 6 - idx
			if self.down_mark then
				self.down_mark = idx
				self:set_mine_play_card(idx - 1)
				self:set_enemy_play_card(idx - 1)
				self.down_mark = nil
			end
			-- print("第几张牌",idx)
			local mine_card = self.mine_play_card_ui[idx] -- 我的战斗卡牌
			local enemy_card = self.enemy_play_card_ui[idx] -- 敌方战斗卡牌
			-- 0.1-0.5秒如果是交换牌，播放交换
			local mine_discard = self.play_card
			local enemy_discard = self.item_obj:get_enemy_discard()
			-- print("CardDeBug:对战的牌，我：对方",mine_discard[idx],enemy_discard[idx])
			local mine_eff = mine_discard[idx] and data[mine_discard[idx]] and data[mine_discard[idx]].effect
			local enemy_eff = enemy_discard[idx] and data[enemy_discard[idx]] and data[enemy_discard[idx]].effect
			local is_exchange = (mine_eff == "exchange") or (enemy_eff == "exchange")

			if schedule>=0.1 and schedule<=0.5 then
				if is_exchange then
					-- eff start 交换特效
					local mine_exchange = mine_eff == "exchange" and enemy_card.exchange or nil
					local enemey_exchange = enemy_eff == "exchange" and mine_card.exchange or nil
					if mine_exchange and mine_exchange.name == "0" then
						mine_exchange.name = "1"
						mine_exchange:SetActive(true)
						-- mine_exchange.transform.localPosition = Vector2(0,0)
					end
					if enemey_exchange and enemey_exchange.name == "0" then
						enemey_exchange.name = "1"
						enemey_exchange:SetActive(true)
						-- enemey_exchange.transform.localPosition = Vector2(0,0)
					end
					-- eff end

					local sd = (schedule-0.1)/0.4
					mine_card.tf.position = mine_card.def_pos + (enemy_card.def_pos-mine_card.def_pos)*sd
					enemy_card.tf.position = enemy_card.def_pos + (mine_card.def_pos-enemy_card.def_pos)*sd
				end
			else
				-- eff start 关闭交换特效
				local mine_exchange = mine_eff == "exchange" and enemy_card.exchange or nil
				local enemey_exchange = enemy_eff == "exchange" and mine_card.exchange or nil
				if mine_exchange and mine_exchange.name == "1" then
					mine_exchange.name = "0"
					mine_exchange:SetActive(false)
					-- mine_exchange.transform.localPosition = Vector2(10000,10000)
				end
				if enemey_exchange and enemey_exchange.name == "1" then
					enemey_exchange.name = "0"
					enemey_exchange:SetActive(false)
					-- enemey_exchange.transform.localPosition = Vector2(10000,10000)
				end
				-- eff end
			end

			-- 0.6-2秒 播放战斗 0.6-1.2靠近 1.4-2.0离开
			if schedule>=0.6 and schedule<=2.0 then
				local mine_target = mine_card.def_pos + (enemy_card.def_pos-mine_card.def_pos)*0.4
				local enemy_target = mine_card.def_pos + (enemy_card.def_pos-mine_card.def_pos)*0.6
				if schedule<=1.2 then -- 靠近
					local sd = (schedule-0.6)/0.6
					local mine_target_pos = mine_card.def_pos + (mine_target-mine_card.def_pos)*sd
					local enemy_target_pos = enemy_card.def_pos + (enemy_target-enemy_card.def_pos)*sd
					mine_card.tf.position = is_exchange and enemy_target_pos or mine_target_pos
					enemy_card.tf.position = is_exchange and mine_target_pos or enemy_target_pos
				elseif schedule>=1.4 then --离开
					local sd = 1 - (schedule-1.4)/0.6
					local mine_target_pos = mine_card.def_pos + (mine_target-mine_card.def_pos)*sd
					local enemy_target_pos = enemy_card.def_pos + (enemy_target-enemy_card.def_pos)*sd
					mine_card.tf.position = is_exchange and enemy_target_pos or mine_target_pos
					enemy_card.tf.position = is_exchange and mine_target_pos or enemy_target_pos
					-- eff start 关闭对碰特效
					if self.once_set_enemy_info then
						local eff = (mine_eff == "bomb" or enemy_eff == "bomb") and self.collision_eff_ui[idx].bomb or self.collision_eff_ui[idx].collision
						if eff.name == "1" then
							print("关闭对碰特效")
							eff.name = "0"
							eff:SetActive(false)
							-- eff.transform.localPosition = Vector2(0,0)
						end
					end
					-- eff end
				else
					-- eff start 对碰特效
					if self.once_set_enemy_info then
						local eff = (mine_eff == "bomb" or enemy_eff == "bomb") and self.collision_eff_ui[idx].bomb or self.collision_eff_ui[idx].collision
						if eff.name == "0" then
							print("对碰特效")
							eff.name = "1"
							eff:SetActive(true)
							-- eff.transform.localPosition = Vector2(10000,10000)
						end
					end
					-- eff end
				end
			end
			if self.score_time ~= 1 then
				-- print("战斗胜场小结")
				self.score_time = 1
				-- 双方胜利次数红心桃
				self:set_red_heart(true)
			end
		elseif bit._and(self.battle_schedule,32)~=32 then -- 需要设置显示战斗结果
			self.battle_schedule = bit._or(self.battle_schedule,32)
			self.gameCount:SetActive(true)     -- -- 游戏场次
			local count = #self.item_obj:get_score_list()
			print("CardDeBug:比赛场次",count,"得分",self.item_obj:get_score_list()[count] and self.item_obj:get_score_list()[count].myScore,self.item_obj:get_score_list()[count].hisScore)
			self.gameCountText.text = gf_localize_string((count==3 and"第三局") or (count==2 and"第二局") or "第一局")
			if self.item_obj:get_score_list()[count] and self.item_obj:get_score_list()[count].myScore > self.item_obj:get_score_list()[count].hisScore then
				self.mineWin:SetActive(true)     --- 我胜利
			elseif self.item_obj:get_score_list()[count] and self.item_obj:get_score_list()[count].myScore < self.item_obj:get_score_list()[count].hisScore then
				self.mineDefeat:SetActive(true)     --- 我失败
			else
				self.mineDraw:SetActive(true)     --- 平局
			end
			if self.score_time ~= 2 then
				self.score_time = 2
				-- 双方胜利次数红心桃
				self:set_red_heart()
			end
		end
	end
end

-- 设置红心 playing 是否战斗播放中
function CardView:set_red_heart(playing)
	local m1 = self.item_obj:get_mine_round_win_times()>0
	local m2 = self.item_obj:get_mine_round_win_times()>1
	local e1 = self.item_obj:get_enemy_round_win_times()>0
	local e2 = self.item_obj:get_enemy_round_win_times()>1
	if playing then
		local score_list = self.item_obj:get_score_list()
		local score = score_list[#score_list]
		if score.myScore>score.hisScore then
			m1 = self.item_obj:get_mine_round_win_times()>1
			m2 = self.item_obj:get_mine_round_win_times()>2
		elseif score.myScore<score.hisScore then
			e1 = self.item_obj:get_enemy_round_win_times()>1
			e2 = self.item_obj:get_enemy_round_win_times()>2
		end
	end
	if self.once_set_mine_info then
		if self.mine_info_ui.win1.activeSelf ~= (m1) then
			self.mine_info_ui.win1:SetActive(m1)
		end
		if self.mine_info_ui.win2.activeSelf ~= (m2) then
			self.mine_info_ui.win2:SetActive(m2)
		end
	end
	print("设置红心 playing",playing,m1,m2,e1,e2)
	print("对战记录")
	if self.once_set_enemy_info and not playing then
		if self.enemy_info_ui.win1.activeSelf ~= (e1) then
			self.enemy_info_ui.win1:SetActive(e1)
		end
		if self.enemy_info_ui.win2.activeSelf ~= (e2) then
			self.enemy_info_ui.win2:SetActive(e2)
		end
		for i,v in ipairs(self.game_record_ui) do
			print("游戏记录",i,v)
			if self.item_obj:get_score_list()[i] then
				v.score.text = string.format("%dVs%d",self.item_obj:get_score_list()[i].myScore,self.item_obj:get_score_list()[i].hisScore)
				local win = self.item_obj:get_score_list()[i].myScore>self.item_obj:get_score_list()[i].hisScore
				local defeat = self.item_obj:get_score_list()[i].myScore<self.item_obj:get_score_list()[i].hisScore
				v.result.text = (win and gf_localize_string("胜")) or (defeat and "<color=#FD4D4DFF>"..gf_localize_string("负").."</color>") or "<color=#FD4D4DFF>"..gf_localize_string("平").."</color>"
				v.go:SetActive(true)
			else
				v.go:SetActive(false)
			end
		end
	end
end

function CardView:register()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
	gf_register_update(self) --注册每帧事件
end

function CardView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
	gf_remove_update(self) --注销每帧事件
end

function CardView:on_showed()
	self:register()
end

-- 释放资源
function CardView:dispose()
	--self.item_obj
    if self.now_state == CardEnum.STATE.MATCHING then
    	self.item_obj:CardsGameMatchCancel_c2s()
	end
	self.init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return CardView