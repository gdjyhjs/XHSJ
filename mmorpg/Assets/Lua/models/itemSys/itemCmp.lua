--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-23 17:39:12
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ItemCmp=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "item_sys_cpm.u3d", item_obj) -- 资源名字全部是小写
end)
local max_num = 2
local min_num = 1
local cur_num = 1

local press_timer = 0
local on_press_time = 0.4
local change_time = 0.1


-- 资源加载完成
function ItemCmp:on_asset_load(key,asset)
	self:set_cmp()
	self.init = true
end

function ItemCmp:set_cmp()
	if not self.item_obj.cmp_item then
		print("<color=red>没有物品</color>")
		return
	end

	self.mode = self.item_obj.cmp_mode or 1 -- 1 拆分	2 使用

	self.refer:Get("titleText").text = self.item_obj.cmp_mode==1 and "拆\t分" or "批量使用"
	self.refer:Get("functionName").text = self.item_obj.cmp_mode==1 and "拆分数量：" or "使用数量："
	self.refer:Get("cmpSureBtnText").text = self.item_obj.cmp_mode==1 and "拆分" or "使用"

	local protoId = self.item_obj.cmp_item.protoId
	local data = ConfigMgr:get_config("item")[protoId]
	gf_set_item(protoId,self.refer:Get("icon"),self.refer:Get("bg"))
	gf_set_click_prop_tips(self.refer:Get("bg").gameObject,protoId)
	self.refer:Get("num").text = self.item_obj.cmp_item.num
	self.refer:Get("name").text = data.name
	max_num = self.item_obj.cmp_mode==1 and self.item_obj.cmp_item.num-1 or self.item_obj.cmp_item.num
	cur_num = self.item_obj.cmp_mode==1 and min_num or max_num
	self.refer:Get("numText").text = cur_num
end

function ItemCmp:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "cmpCancleBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd == "cmpNumBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local t = self.refer:Get("numText")
		local surefun = function(value)
			cur_num = (not value or value == "" and cur_num) or value or cur_num
			self.refer:Get("numText").text = cur_num
		end
		LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(t,max_num,min_num,"left","right","rightBottom",nil,surefun)
	elseif cmd == "cmpSureBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.item_obj.cmp_mode==1 then
			-- 拆分
			LuaItemManager:get_item_obejct("bag"):split_item_c2s(self.item_obj.cmp_item.guid,cur_num)
		else
			-- 使用
			LuaItemManager:get_item_obejct("bag"):use_item_c2s(self.item_obj.cmp_item.guid,cur_num,self.item_obj.cmp_item.protoId)
		end
		self:hide()
	end
end

function ItemCmp:on_press_down(obj,click_pos)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if obj.name == "cmpReduceBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_register_update(self) --注册每帧事件
		press_timer = 0
		self.big_btn = self.refer:Get("cmpReduceBtn")
		self.big_btn.localScale = Vector3.one*1.2
		cur_num = cur_num - 1
		cur_num = cur_num <= 0 and max_num or cur_num
		self.refer:Get("numText").text = cur_num

		self.update_fun = function(dt)
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			if cur_num > 1 then
				cur_num = cur_num - 1
				self.refer:Get("numText").text = cur_num
			end
		end

	elseif obj.name == "cmpAddBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_register_update(self) --注册每帧事件
		press_timer = 0
		self.big_btn = self.refer:Get("cmpAddBtn")
		self.big_btn.localScale = Vector3.one*1.2
		cur_num = cur_num + 1
		cur_num = cur_num > max_num and 1 or cur_num
		self.refer:Get("numText").text = cur_num

		self.update_fun = function(dt)
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			if cur_num < max_num then
				cur_num = cur_num + 1
				self.refer:Get("numText").text = cur_num
			end
		end

	end
end

function ItemCmp:on_update(dt)
	press_timer = press_timer + dt
	if press_timer > on_press_time + change_time then
		self.update_fun(dt)
		press_timer = on_press_time
	end
	if Input.GetMouseButtonUp(0) then
		gf_remove_update(self) --注销每帧事件
		if self.big_btn then
			self.big_btn.localScale = Vector3.one
			self.big_btn = nil
		end
	end
end

function ItemCmp:on_showed()
    StateManager:register_view( self )
    if self.init then
		self:set_cmp()
    end
end

function ItemCmp:on_hided()
	self.item_obj.cmp_mode = nil
	self.item_obj.cmp_item = nil

	StateManager:remove_register_view( self )
end

-- 释放资源
function ItemCmp:dispose()
	self:hide()
    self._base.dispose(self)
 end

return ItemCmp

