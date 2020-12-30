--[[--
-- 镶嵌
-- @Author:Seven
-- @DateTime:2017-11-21 15:50:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local DestinyTools = require("models.destiny.destinyTools")
local Player = LuaItemManager:get_item_obejct("player")

local Inlay=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "destiny_inlay.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Inlay:on_asset_load(key,asset)
	self.init = true
	local childs = LuaHelper.GetAllChild(self.refer:Get("bodyItemRoot"))
	self.bodyList = {}
	for i=1,#childs do
		local parent = childs[i]
		self.bodyList[i] = {
			bg = parent:Find("bg"):GetComponent(UnityEngine_UI_Image),
			icon = parent:Find("icon"):GetComponent(UnityEngine_UI_Image),
			lock = parent:Find("lock").gameObject,
			sel = parent:Find("sel").gameObject,
			lv = parent:Find("lv"):GetComponent("UnityEngine.UI.Text"),
			add = parent:Find("add").gameObject,
			red_point = parent:Find("red_point").gameObject,
		}
	end

	local childs = LuaHelper.GetAllChild(self.refer:Get("attrRoot"))
	self.attrList = {}
	for i=1,#childs do
		self.attrList[i] = childs[i]:GetComponent("UnityEngine.UI.Text")
	end
	local item = self.refer:Get("item")
	self.item = {
		name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
		bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image),
		icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
		lv = item:Find("lv"):GetComponent("UnityEngine.UI.Text"),
	}
	local current_lv = self.refer:Get("current_lv")
	self.current_lv = {
		lv = current_lv:Find("lv"):GetComponent("UnityEngine.UI.Text"),
		baseAttr = current_lv:Find("baseAttr"):GetComponent("UnityEngine.UI.Text"),
		exAttrName = current_lv:Find("exAttrName").gameObject,
		exAttr = current_lv:Find("exAttr"):GetComponent("UnityEngine.UI.Text"),
	}
	local next_lv = self.refer:Get("next_lv")
	self.next_lv = {
		root = next_lv.gameObject,
		lv = next_lv:Find("lv"):GetComponent("UnityEngine.UI.Text"),
		baseAttr = next_lv:Find("baseAttr"):GetComponent("UnityEngine.UI.Text"),
		exAttrName = next_lv:Find("exAttrName").gameObject,
		exAttr = next_lv:Find("exAttr"):GetComponent("UnityEngine.UI.Text"),
	}
	self.upgradeCost = self.refer:Get("upgradeCost")
	self.right = self.refer:Get("right")
	self.qi_e = self.refer:Get("qi_e")
	self.arrow = self.refer:Get("arrow")

	self:init_ui()

end

-- 初始化界面设置
function Inlay:init_ui()
	self.select_destiny = Player.page3 or 1
	Player.page3 = 1

	
	self:set_body_destiny()
	self:update_red_point() -- 初始化显示红点
end

-- 设置身上的天命
function Inlay:set_body_destiny()
	local destiny_slot_data = ConfigMgr:get_config("destiny_slot")
	local game = LuaItemManager:get_item_obejct("game")
	local role_level = game:getLevel()
	local attrs = {}
	for i,v in ipairs(self.bodyList) do
		if role_level < destiny_slot_data[i].player_level then
			-- 锁
			gf_setImageTexture(v.bg,DestinyTools:get_destiny_bg())
			v.icon.gameObject:SetActive(false)
			v.lock:SetActive(true)
			v.lv.gameObject:SetActive(false)
			v.add:SetActive(false)
		else
			-- 开
			local d = self.item_obj:get_destiny_on_body(i)
			if d then
				local data = ConfigMgr:get_config("destiny_level")[d.destinyId]
				gf_setImageTexture(v.bg,DestinyTools:get_destiny_bg(data.color))
				v.icon.gameObject:SetActive(true)
				gf_setImageTexture(v.icon,data.icon)
				v.lock:SetActive(false)
				v.lv.gameObject:SetActive(true)
				v.lv.text = data.level
				v.add:SetActive(false)
			else
				gf_setImageTexture(v.bg,DestinyTools:get_destiny_bg())
				v.icon.gameObject:SetActive(false)
				v.lock:SetActive(false)
				v.lv.gameObject:SetActive(false)
				v.add:SetActive(true)
			end
		end
		v.sel:SetActive(false)
	end
	-- 属性
	local attr_arry = {}
	for i,v in ipairs(self.item_obj:get_items(ServerEnum.DESTINY_CONTIANER_TYPE.BODY)) do
		local data = ConfigMgr:get_config("destiny_level")[v.destinyId]
		--基础属性
		if not attr_arry[data.level_attr[1]] then
			attr_arry[data.level_attr[1]] = 0
		end
		attr_arry[data.level_attr[1]] = data.level_attr[2] + attr_arry[data.level_attr[1]]
		--突破属性
		if data.break_attr[1] then
			if not attr_arry[data.break_attr[1]] then
				attr_arry[data.break_attr[1]] = 0
			end
			attr_arry[data.break_attr[1]] = data.break_attr[2] + attr_arry[data.break_attr[1]]
		end
	end
	local attr_list = ConfigMgr:get_config("destiny_attr_list")
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	for i,v in ipairs(self.attrList) do
		if attr_list[i] then
			local attr_type = attr_list[i].attr
			v.text = itemSys:get_combat_attr_name(attr_type,attr_arry[attr_type] or 0)
		else
			v.text = nil
		end
	end
	self:select_body()
end

-- 选择身上的槽
function Inlay:select_body()
	if self.last_select_destiny then
		self.bodyList[self.last_select_destiny].sel:SetActive(false)
	end
	self:set_select_attr()
	self.last_select_destiny = self.select_destiny
	self.bodyList[self.select_destiny].sel:SetActive(true)
end

	-- 设置选中的天命的属性
function Inlay:set_select_attr()
	local d = self.item_obj:get_destiny_on_body(self.select_destiny)
	if d then
		self.right:SetActive(true)
		self.qi_e:SetActive(false)
		-- 设置属性
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local left_data = ConfigMgr:get_config("destiny_level")[d.destinyId]
		self.item.name.text = left_data.name
		self.item.lv.text = left_data.level
		gf_setImageTexture(self.item.bg,DestinyTools:get_destiny_bg(left_data.color))
		gf_setImageTexture(self.item.icon,left_data.icon)
		-- 左属性
		self.current_lv.lv.text = left_data.level
		self.current_lv.baseAttr.text = itemSys:get_combat_attr_name(left_data.level_attr[1],left_data.level_attr[2])
		if #left_data.break_attr>0 then
			self.current_lv.exAttrName.gameObject:SetActive(true)
			self.current_lv.exAttr.gameObject:SetActive(true)
			self.current_lv.exAttr.text = itemSys:get_combat_attr_name(left_data.break_attr[1],left_data.break_attr[2])
		else
			self.current_lv.exAttrName.gameObject:SetActive(false)
			self.current_lv.exAttr.gameObject:SetActive(false)
		end
		-- 右属性
		local right_data = ConfigMgr:get_config("destiny_level")[d.destinyId+1]
		local is_full_level = not right_data or right_data.type~=left_data.type or right_data.color~=left_data.color
		if is_full_level then
			self.next_lv.root:SetActive(false)
			self.arrow:SetActive(false)
		else
			self.next_lv.root:SetActive(true)
			self.arrow:SetActive(true)
			self.next_lv.lv.text = right_data.level
			self.next_lv.baseAttr.text = itemSys:get_combat_attr_name(right_data.level_attr[1],right_data.level_attr[2])
			if #right_data.break_attr>0 then
				self.next_lv.exAttrName.gameObject:SetActive(true)
				self.next_lv.exAttr.gameObject:SetActive(true)
				self.next_lv.exAttr.text = itemSys:get_combat_attr_name(right_data.break_attr[1],right_data.break_attr[2])
			else
				self.next_lv.exAttrName.gameObject:SetActive(false)
				self.next_lv.exAttr.gameObject:SetActive(false)
			end
		end
		-- 资源
		local have_res = LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.SPIRIT)
		local need_res = left_data.exp
		if need_res~=0 then
			print(have_res,type(have_res),need_res,type(need_res))
			if have_res>=need_res then
				self.upgradeCost.text = string.format("%s/%s",gf_format_count(have_res),need_res)
			else
				self.upgradeCost.text = string.format("<color=#d01212>%s</color>/%s",gf_format_count(have_res),need_res)
			end
		else
			self.upgradeCost.text = string.format("%s/%s",gf_format_count(have_res),"满级")
		end
	else
		-- 企鹅
		self.right:SetActive(false)
		self.qi_e:SetActive(true)
		if self.last_select_destiny then
			-- 跳转到选择天命界面
			self:inlay_destiny()
		end
	end
end

-- 替换 -- 跳转到选择天命界面
function Inlay:inlay_destiny()
	local d = self.item_obj:get_destiny_on_body(self.select_destiny)
	local list_view = nil
	local destiny_t = self.item_obj:get_items(ServerEnum.DESTINY_CONTIANER_TYPE.BAG)
	local inlay_type_list = {[0]=0}
	local data = ConfigMgr:get_config("destiny_level")


	for i,v in ipairs(self.item_obj:get_items(ServerEnum.DESTINY_CONTIANER_TYPE.BODY)) do
		if not d or data[v.destinyId].type ~= data[d.destinyId].type then
			inlay_type_list[data[v.destinyId].type] = v
		end
	end

	local sure_fn = function(d)
		if d then
			self.item_obj:set_destiny_to_slot_c2s(d.duid,self.select_destiny)
			list_view:dispose()
		elseif #destiny_t>0 then
			gf_message_tips("请选择要镶嵌的天命。")
		else
			list_view:dispose()
		end
	end

	local destiny_list = {}
	local t2 = {}
	for i,v in ipairs(destiny_t) do
		local d = data[v.destinyId]
		if inlay_type_list[d.type] then
			if d.type~=0 then -- 2017年12月25号义正的新需求，仓库界面不显示精粹
				t2[#t2+1] = v
			end
		else
			destiny_list[#destiny_list+1] = v
		end
	end
	for i,v in ipairs(t2) do
		destiny_list[#destiny_list+1] = v
	end

	list_view = View("depot",self.item_obj)
	list_view:set_data(destiny_list,sure_fn,inlay_type_list)
end

-- 升级
function Inlay:upgrade_destiny()
	self.item_obj:upgrade_destiny_c2s(self.select_destiny)
end

function Inlay:on_receive( msg, id1, id2, sid )
    if id1==Net:get_id1("bag") then
		if id2== Net:get_id2("bag", "UplevelDestinyR") then -- 升级
			if msg.err==0 then
				self:set_body_destiny()
			end
		elseif  id2== Net:get_id2("bag", "SetDestinyToSlotR") then -- 将某个天命装到身上的某个槽上
			if msg.err==0 then
				self:set_body_destiny()
			end
		end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
		print("天命收到了红点协议",msg.module,ClientEnum.MODULE_TYPE.PLAYER_INFO)
        if msg.module == ClientEnum.MODULE_TYPE.PLAYER_INFO then
            self:update_red_point()
        end
	end
end

function Inlay:update_red_point()
	if not self.init then return end
	-- print("更新天命红点")
	local red_pos = LuaItemManager:get_item_obejct("player").red_pos
    for i,obj in ipairs(self.bodyList or {}) do
        local show = (function()
                    for k,v in pairs(red_pos) do
                        if v and tonumber(string.sub(k,1,2)) == 31 and tonumber(string.sub(k,3,3)) == i then
                        	-- print("需要显示天命红点",v,k)
                            return true
                        -- elseif v and tonumber(string.sub(k,1,2)) == 31 then
                    		-- print("天命红点判断隐藏",v,k)
                        end
                    end
                end)()
        obj.red_point:SetActive(show or false)
    end
end

function Inlay:on_click(obj,arg)
	print("on_click(DestinyView-Inlay)",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="btnReplace" then -- 替换
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:inlay_destiny()
	elseif cmd=="add" then -- 添加
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.select_destiny = obj.transform.parent:GetSiblingIndex()+1
		self:select_body()
	elseif cmd=="btnUpgrade" then -- 升级
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:upgrade_destiny()
	elseif cmd=="lock" then -- 未解锁
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform.parent:GetSiblingIndex()+1
		gf_message_tips(string.format("%d级解锁",ConfigMgr:get_config("destiny_slot")[idx].player_level))
	elseif cmd == "bodyItem" then -- 身上槽
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.select_destiny = obj.transform:GetSiblingIndex()+1
		self:select_body()
	elseif cmd == "bodyItem_1" then -- 身上槽
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.select_destiny = 1
		self:select_body()
	end                 
end

function Inlay:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function Inlay:on_hided()
	self.last_select_destiny = nil
	StateManager:remove_register_view( self )
end

-- 释放资源
function Inlay:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return Inlay

