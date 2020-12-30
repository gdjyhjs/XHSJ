--[[--
-- 猎取
-- @Author:Seven
-- @DateTime:2017-11-21 15:53:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local DestinyTools = require("models.destiny.destinyTools")

local active_interval = 0.08
local max_show_count = 10
local last_hunt_item = 0

local Hunt=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "destiny_draw.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Hunt:on_asset_load(key,asset)
	self.haveGold = self.refer:Get("haveGold")
	self.haveCoin = self.refer:Get("haveCoin")
	local itemRoot = self.refer:Get("itemRoot")
	local childs = LuaHelper.GetAllChild(itemRoot)
	self.itemList = {} -- 展示项列表
	max_show_count = #childs
	for i=1,max_show_count do
		local eff = childs[i]:Find("eff")
		local eff_high = childs[i]:Find("eff_high")
		gf_set_eff_new_texture(eff)
		gf_set_eff_new_texture(eff_high)
		self.itemList[i] = {
			item = childs[i].gameObject,
			bg = childs[i]:Find("bg"):GetComponent(UnityEngine_UI_Image),
			icon = childs[i]:Find("icon"):GetComponent(UnityEngine_UI_Image),
			lv = childs[i]:Find("lv"):GetComponent("UnityEngine.UI.Text"),
			name = childs[i]:Find("name"):GetComponent("UnityEngine.UI.Text"),
			eff = eff.gameObject,
			eff_high = eff_high.gameObject,
		}
	end
	local hbtnRoot = self.refer:Get("btnRoot")
	local childs = LuaHelper.GetAllChild(self.refer:Get("btnRoot"))
	self.hbtnList = {} -- 按钮列表
	for i=1,#childs do
		self.hbtnList[i] = {
			item = childs[i].gameObject,
			bg = childs[i]:Find("bg"):GetComponent(UnityEngine_UI_Image),
			head = childs[i]:Find("head"):GetComponent(UnityEngine_UI_Image),
			filled = childs[i]:Find("filled").gameObject,
			txtMoney = childs[i]:Find("txtMoney"):GetComponent("UnityEngine.UI.Text"),
			btnCall = childs[i]:Find("btnCall").gameObject,
		}
	end
	self:init_ui()
	self.init = true
end

function Hunt:init_ui()
			self:set_base_red()

	self.actives = {count = 0} -- 记录所有行动计划 {count = 0,1 = {},2 = {},3 = {}}
	for i,v in ipairs(self.itemList) do -- 设置天命空白页
		gf_setImageTexture(v.bg,DestinyTools:get_destiny_bg())
		v.item.gameObject:SetActive(false)
	end
	local destiny_need_money_data = ConfigMgr:get_config( "destiny_need_money" )
	for i,v in ipairs(self.hbtnList) do -- 设置按钮列表
		v.filled:SetActive(not self.item_obj:get_btn_active(i))
		v.txtMoney.text = self.item_obj:get_need_money(1,i).need_money
		gf_setImageTexture(v.head,self.item_obj:get_need_money(1,i).head)
	end
end

-- 设置基础资源
function Hunt:set_base_red()
	local game = LuaItemManager:get_item_obejct("game")
	self.haveGold.text = gf_format_count(game:get_money(ServerEnum.BASE_RES.GOLD))
	self.haveCoin.text = gf_format_count(game:get_money(ServerEnum.BASE_RES.COIN))
end

function Hunt:on_receive( msg, id1, id2, sid )
    if id1==Net:get_id1("base") then
		if id2== Net:get_id2("base", "UpdateResR") then -- 更新基础资源
			self:set_base_red()
		end
	elseif id1==Net:get_id1("bag") then
		if id2== Net:get_id2("bag", "DrawDestinyR") then -- 抽取天命(元宝))
			if msg.err == 0 then
				local list = {}
				for i,v in ipairs(msg.destinyDrawInfoArr) do
					list[#list+1] = {
						err = 0,
						destinyDrawInfo = v,
					}
				end
				if #list>0 then
					self.actives[#self.actives+1] = list
					if not self.active_timer then
						print("开启计时器")
						self.active_timer = Schedule( handler(self, self.update_active),0)
					end
					gf_print_table(self.actives,"行程表")
				end
			end
			gf_mask_show(false)
		elseif id2== Net:get_id2("bag", "DrawDestinyCoinR") then -- 抽取天命(铜钱)
			self.actives[#self.actives+1] = msg.destinyDrawResultArr
			if not self.active_timer then
				print("开启计时器")
				self.active_timer = Schedule( handler(self, self.update_active),0)
			end
			gf_print_table(self.actives,"行程表")
			gf_mask_show(false)
		end
	end
end
-- 更新行动
function Hunt:update_active()
	if (self.actives[1] and self.actives.count+#self.actives[1]>max_show_count) then
		-- 显示已满，清空
		self.actives.count = 0
		for i,v in ipairs(self.itemList) do -- 设置天命空白页
			gf_setImageTexture(v.bg,DestinyTools:get_destiny_bg())
			v.item:SetActive(false)
		end
	end
	if #self.actives>0 and #self.actives[1]>0 then
		-- 播放一个获得物品的效果
		local active = self.actives[1][1]
		gf_print_table(active,"执行一个行动")
		if active.err == 0 then
			self.actives.count = self.actives.count + 1
			local item = self.itemList[self.actives.count]
			local data = ConfigMgr:get_config("destiny_level")[active.destinyDrawInfo.destinyId]
			gf_setImageTexture(item.bg,DestinyTools:get_destiny_bg(data.color))
			gf_setImageTexture(item.icon,data.icon)
			item.lv.text = data.level
			item.name.text = data.name

			item.eff_high:SetActive(data.color>=4)
			item.eff:SetActive(data.color<4)
			PLua.Delay(function()
					if self.init then
						(data.color>=4 and item.eff_high or item.eff):SetActive(false)
					end
				end,0.5)
			item.item:SetActive(true)
        	Sound:play(ClientEnum.SOUND_KEY.HUNT_DESTINY) -- 角色、坐骑、武将升级时播放的音效

			if active.newDrawIndex then
				for i,v in ipairs(self.hbtnList) do -- 设置按钮列表
					local pos = bit._rshift(0x80000000,32-i)
					v.filled:SetActive(bit._and(active.newDrawIndex,pos)~=pos)
				end
			end

		else -- 错误码
			gf_message_tips(Net:error_code(active.err))
		end

		table.remove(self.actives[1],1)
	end

	if self.actives[1] and #self.actives[1]==0 then
		table.remove(self.actives,1)
	end

	if #self.actives==0 and self.active_timer then
		print("停止计时器")
		self.active_timer:stop()
		self.active_timer = nil
	elseif self.active_timer then
		print("重设计时时间",active_interval)
		self.active_timer:reset_time(active_interval)
	end
end

function Hunt:on_click(obj,arg)
	print("on_click(DestinyView-Hunt)",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or "" 
	if cmd=="btnOneKeyDraw" then -- 一键 铜币十连抽
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local t = Net:get_server_time_s()
		if t - last_hunt_item > 1 then
			last_hunt_item = t
			self.item_obj:draw_destiny_coin_c2s(2)
			gf_mask_show(true)
		end
	elseif cmd=="head" then -- 铜币单抽
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform.parent:GetSiblingIndex()+1
		self.item_obj:draw_destiny_coin_c2s(1,idx)
		gf_mask_show(true)
	elseif cmd=="btnCall" then -- 元宝抽取
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("summon",self.item_obj)
	elseif cmd=="addMoney" then -- 增加货币
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local money_type = obj.transform.parent:GetSiblingIndex()+1
		gf_open_model(ConfigMgr:get_config("base_res")[money_type].get_way)
	elseif cmd=="btnHelp" then -- 增加货币
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1191)
	end
end

function Hunt:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function Hunt:on_hided()
	if self.active_timer then
		print("停止计时器")
		self.active_timer:stop()
		self.active_timer = nil
	end
	StateManager:remove_register_view( self )
end

-- 释放资源
function Hunt:dispose()
	self:hide()
    self._base.dispose(self)
 end

return Hunt

