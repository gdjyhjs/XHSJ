--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-21 18:35:47
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local inputField = nil
local channel = 1
local init = nil
local on_show = nil
local sel_list = nil
local Emoji=class(UIBase,function(self,item_obj)--,inputField,channel)
	print("emoji UI")
    UIBase._ctor(self, "emoji.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

function Emoji:set_parameter(_inputField,_channel,emojiType)
	print("设置参数",_inputField,_channel,emojiType)
	channel = _channel or self.item_obj.channel
    inputField = _inputField
    self.emojiType = emojiType
end

-- 资源加载完成
function Emoji:on_asset_load(key,asset)
	self:init_ui()
	self:active_function()
	init=true
	print("表情界面加载完毕")
	
	StateManager:register_view(self)
	if not channel then
		self:hide()
	end
end

function Emoji:init_ui()
	-- print("--选择表情消息部分")
	local left_bottom = self.refer:Get("left_bottom")
	self.mark_list = {}
	for i=1,left_bottom.childCount do
		print(i,i,i,i,i,i,i,i)
		self.mark_list[i] = left_bottom:GetChild(i-1):FindChild("mark").gameObject
	end
	self.emoji_btn={}
	self.emoji_btn.root=LuaHelper.FindChild(self.root,"emoji_btn_content")
	self.emoji_btn.sample=self.emoji_btn.root.transform:GetChild(0).gameObject
	self.emoji_btn.img=LuaHelper.FindChildComponent(self.emoji_btn.sample,"icon",UnityEngine_UI_Image)
	self.emoji_btn.bg=LuaHelper.FindChildComponent(self.emoji_btn.sample,"bg",UnityEngine_UI_Image)
	self.emoji_btn.sprite_list = {}
	Loader:get_sprite("emoji_img", "01", function( sprite, sprite_list )
		for i=1,sprite_list.Length do
			local sp = sprite_list[i]
			self.emoji_btn.sprite_list[i] = sp
		end

		self:expression_show()
	end)
end

function Emoji:open(inputField,channel)
	channel = channel or channel
	print("表情的频道",channel)
    inputField = inputField
    self:active_function()
	self:show()
end

--激活的功能
function Emoji:active_function()
	if channel<Enum.CHAT_CHANNEL.END then
    	self.emojiType = ConfigMgr:get_config("chat_channel")[channel].use_function
	else
    	self.emojiType =  self.emojiType or 0
	end
	print("表情类型",self.emojiType)
	local ref = self.refer:Get("emojiBtn")
	local i = 1
	while(ref:Get(i))do
			local b = bit._rshift(0x80000000,32-i)
			ref:Get(i):SetActive(bit._and(self.emojiType,b)==b)
		i=i+1
	end
end

function Emoji:on_click(obj, arg)
	print("点击表情界面",obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="expression" then --关闭表情输入界面
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd=="expression_btn" then --表情界面按钮
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local index = obj.transform:GetSiblingIndex()
		if index ~= sel_list then
			self:expression_refresh(index)
		end
	elseif cmd=="red_packet_btn" then --红包按钮
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("发红包")
		self:hide()
	elseif cmd=="send_position_btn" then --发送位置按钮
	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:send_position_message()
		self:hide()
	elseif string.find(cmd,ClientEnum.CHAT_TYPE.HERO.."_%[.-%]_%d+") then
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cip = string.split(cmd,"_")
		local item = {
				type = tonumber(cip[1]),
				name = cip[2],
				uid = tonumber(cip[3])
			}
		self.item_obj.prop_cache[#self.item_obj.prop_cache+1] = item
		self:add_to_input_field(cip[2])
	elseif string.find(cmd,ClientEnum.CHAT_TYPE.PROP.."_%[.-%]_%d+") then
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("物品",cmd)
		local cip = string.split(cmd,"_")
		local item = {
				type = tonumber(cip[1]),
				name = cip[2],
				slot = tonumber(cip[3])
			}
		self.item_obj.prop_cache[#self.item_obj.prop_cache+1] = item
		self:add_to_input_field(cip[2])
	elseif string.find(cmd,"#") then --选择了表情按钮
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		cmd = "#e"..string.sub(cmd,2,3)
		self:add_to_input_field(cmd)
	end
end

--打开表情界面
function Emoji:expression_show()
		self:expression_refresh(0)
end

--表情界面刷新(0表情 1物品 2武将 3备用)
function Emoji:expression_refresh(index)
	if sel_list then
		self.mark_list[sel_list+1]:SetActive(false)
	end
	sel_list = index
	self.mark_list[sel_list+1]:SetActive(true)

	for i,v in ipairs(self.current_show_list or {}) do
		if v.activeSelf then
			v:SetActive(false)
		end
	end
	if index==0 then
		self:emoji_refresh()
	elseif index==1 then
		self:wupin_refresh()
	elseif index==2 then
		self:wujiang_refresh()
	elseif index==3 then
	end
	for i,v in ipairs(self.current_show_list or {}) do
		if not v.activeSelf then
			v:SetActive(true)
		end
	end
end
--表情选择刷新
function Emoji:emoji_refresh()
	if not self.emoji_objs then
		self.emoji_objs={}
		local sprite_list=self.emoji_btn.sprite_list
		for i=1,#sprite_list do
			local sp = sprite_list[i]
			self.emoji_btn.img.sprite=sp
			local obj = LuaHelper.InstantiateLocal(self.emoji_btn.sample,self.emoji_btn.root)
			obj.name="#"..sp.name
			self.emoji_objs[#self.emoji_objs+1]=obj
		end
	end
	self.current_show_list=self.emoji_objs
end
--物品选择刷新
function Emoji:wupin_refresh()
	-- print("刷新物品选择")
	if not self.expression_can_use_objs then
		self.expression_can_use_objs={}
	end
	for i,v in ipairs(self.expression_useing_objs or {}) do --把所有使用中的放回可用，然后清空
		self.expression_can_use_objs[#self.expression_can_use_objs+1]=v
	end
	self.expression_useing_objs={}

	local bag = LuaItemManager:get_item_obejct("bag")
	self.current_show_list = {}
	for k,v in pairs(bag.items or {}) do
		if math.floor(v.slot/10000)~=Enum.BAG_TYPE.DEPOT then
			if #self.expression_can_use_objs>0 then
				self.expression_useing_objs[#self.expression_useing_objs+1]=self.expression_can_use_objs[1]
				table.remove(self.expression_can_use_objs,1)
			else
				local item = {}
				item.obj = LuaHelper.InstantiateLocal(self.emoji_btn.sample,self.emoji_btn.root)
				item.img = LuaHelper.FindChildComponent(item.obj,"icon",UnityEngine_UI_Image)
				item.bg = LuaHelper.FindChildComponent(item.obj,"bg",UnityEngine_UI_Image)
				item.bg.gameObject:SetActive(true)
				self.expression_useing_objs[#self.expression_useing_objs+1]=item
			end
			local data = ConfigMgr:get_config("item")[v.protoId]
			local item = self.expression_useing_objs[#self.expression_useing_objs]
			item.obj.name=string.format("%d_[%s]_%d",ClientEnum.CHAT_TYPE.PROP,data.name,v.slot)
			self.current_show_list[#self.current_show_list+1]=item.obj
			gf_set_item(v.protoId,item.img,
				item.bg,
				v.color)
		end
	end
end
--武将选择刷新
function Emoji:wujiang_refresh()
	if not self.expression_can_use_objs then
		self.expression_can_use_objs={}
	end
	for i,v in ipairs(self.expression_useing_objs or {}) do --把所有使用中的放回可用，然后清空
		self.expression_can_use_objs[#self.expression_can_use_objs+1]=v
	end
	self.expression_useing_objs={}
	local hero_list = LuaItemManager:get_item_obejct("hero"):get_hero_have()
	self.current_show_list = {}
	for k,v in pairs(hero_list) do
		if #self.expression_can_use_objs>0 then
			self.expression_useing_objs[#self.expression_useing_objs+1]=self.expression_can_use_objs[1]
			table.remove(self.expression_can_use_objs,1)
		else
			local item = {}
			item.obj = LuaHelper.InstantiateLocal(self.emoji_btn.sample,self.emoji_btn.root)
			item.img = LuaHelper.FindChildComponent(item.obj,"icon",UnityEngine_UI_Image)
			item.bg = LuaHelper.FindChildComponent(item.obj,"bg",UnityEngine_UI_Image)
			item.bg.gameObject:SetActive(true)
			self.expression_useing_objs[#self.expression_useing_objs+1]=item
		end
		local data = ConfigMgr:get_config("hero")[v.heroId]
		local item = self.expression_useing_objs[#self.expression_useing_objs]
		item.obj.name=string.format("%d_[%s]_%d",ClientEnum.CHAT_TYPE.HERO,data.name,k)
		self.current_show_list[#self.current_show_list+1]=item.obj
	    gf_setImageTexture(item.img,data.icon)
	    gf_set_quality_bg(item.bg,data.type)
	end
end

function Emoji:on_showed()
	if init then
		self:expression_show()
		StateManager:register_view(self)
	end
end

function Emoji:on_hided()
	self:dispose()
end

function Emoji:add_to_input_field(str)
	if inputField then
		LuaHelper.eventSystemCurrentSelectedGameObject = inputField.gameObject
		inputField.text = inputField.text..str
	end
end

-- 释放资源
function Emoji:dispose()
	init = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return Emoji