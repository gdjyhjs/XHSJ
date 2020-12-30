--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-23 16:07:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LuckyDrawWarehouse=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "lucky_draw_warehouse.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LuckyDrawWarehouse:on_asset_load(key,asset)
	self.item_list = {}
	self.item_obj:GetLotteryStorehouseInfo_c2s()
	StateManager:register_view( self )
	self:init_ui()
end

function LuckyDrawWarehouse:init_ui()
	self.itemRoot = self.refer:Get("itemRoot")
	local tf = self.itemRoot:GetChild(0)
	self.line_sample = tf.gameObject
	self.line_count = tf.childCount
	self.item_ref = {}
	for i=1,self.itemRoot.childCount do
		local line = self.itemRoot:GetChild(i-1)
		self.item_ref[i] = {}
		for k=1,self.line_count do
			local ref = line:GetChild(k-1):GetComponent("ReferGameObjects")
			self.item_ref[i][k] = ref
			ref.name = "takeItem_"..((i-1)*self.line_count+k)
		end
	end
end

function LuckyDrawWarehouse:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "close_lucky_draw_warehouse" then -- 关闭
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btnFinishing" then -- 一键取出
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:GetLotteryStorehouse_c2s(0)
	elseif string.find(cmd,"takeItem_") then -- 取出物品
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local index = tonumber(string.split(cmd,"_")[2])
		if self.item_list[index] then
			self.item_obj:GetLotteryStorehouse_c2s(index)
		end
	end
end

function LuckyDrawWarehouse:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "GetLotteryStorehouseR") then -- 取出抽奖仓库物品
			self:GetLotteryStorehouseR_s2c(msg)
		elseif id2 == Net:get_id2("base", "GetLotteryStorehouseInfoR") then -- 获取抽奖仓库物品列表
			self:GetLotteryStorehouseInfoR_s2c(msg)
		end
	end
end

-- 取出抽奖仓库物品
function LuckyDrawWarehouse:GetLotteryStorehouseR_s2c(msg)
	if msg.err == 0 then
		if msg.pos == 0 then
			self:take_all_item()
		else
			self:take_one_item(msg.pos)
		end
	end
end

-- 获取抽奖仓库物品列表
function LuckyDrawWarehouse:GetLotteryStorehouseInfoR_s2c(msg)
	--初始化列表
	self.item_list = msg.storehouse
	self:set_list()
end

-- 初始化 设置页 物品列表
function LuckyDrawWarehouse:set_list()
	-- 保证行数足够
	local need_line = math.ceil(#self.item_list/self.line_count)
	while(need_line>self.itemRoot.childCount)do
		local obj = LuaHelper.Instantiate(self.line_sample)
		obj.transform:SetParent(self.itemRoot,false)
		self.item_ref[self.itemRoot.childCount] = {}
		for i=1,self.line_count do
			local ref = obj.transform:GetChild(i-1):GetComponent("ReferGameObjects")
			self.item_ref[self.itemRoot.childCount][i] = ref
			ref.name = "takeItem_"..((self.itemRoot.childCount-1)*self.line_count+i)
		end
	end
	-- 设置物品
	for i,v in ipairs(self.item_list) do
		local on_line = math.ceil(i/self.line_count)
		local on_index = (i-1)%self.line_count+1
		print("设置物品位置",on_line,on_index)
		local ref = self.item_ref[on_line][on_index]
		local icon = ref:Get("icon")
		gf_set_item(v.code,icon,ref:Get("bg"))
		icon.gameObject:SetActive(true)
		local count = ref:Get("count")
		count.text = v.num
		count.gameObject:SetActive(true)
	end
end

--取出某件物品
function LuckyDrawWarehouse:take_one_item(index)
	for i=index,#self.item_list do
		local v = self.item_list[i+1]
		local on_line = math.ceil(i/self.line_count)
		local on_index = (i-1)%self.line_count+1
		local ref = self.item_ref[on_line][on_index]
		local icon = ref:Get("icon")
		local count = ref:Get("count")
		if v then
			gf_set_item(v.code,icon,ref:Get("bg"))
			icon.gameObject:SetActive(true)
			count.text = v.num
			count.gameObject:SetActive(true)
		else
			icon.gameObject:SetActive(false)
			gf_setImageTexture(ref:Get("bg"),"item_color_0")
			count.gameObject:SetActive(false)
		end
	end
	table.remove(self.item_list,index)
	if #self.item_list<=0 then
		self.item_obj:set_red_point(false)
	end
end

--取出所有物品
function LuckyDrawWarehouse:take_all_item()
	for i,v in ipairs(self.item_list) do
		local on_line = math.ceil(i/self.line_count)
		local on_index = (i-1)%self.line_count+1
		local ref = self.item_ref[on_line][on_index]
		local icon = ref:Get("icon")
		icon.gameObject:SetActive(false)
		gf_setImageTexture(ref:Get("bg"),"item_color_0")
		local count = ref:Get("count")
		count.gameObject:SetActive(false)
	end
	self.item_obj:set_red_point(false)
end

-- 释放资源
function LuckyDrawWarehouse:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return LuckyDrawWarehouse

