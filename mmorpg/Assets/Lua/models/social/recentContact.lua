--[[--
-- 最近联系
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 21:02:15
--]] -- LuaItemManager:get_item_obejct("chat").chatRecord.get_local_recent_contact()
local chatRecord = require("models.chat.chatRecord")
local socialTools = require("models.social.socialTools")

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local RecentContact=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "recent_contact.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function RecentContact:on_asset_load(key,asset)
	self:get_friend_list() --获取最近联系人列表
	self.init = true
end

-- 获取最近联系人信息
function RecentContact:get_friend_list()
	local list = chatRecord:load_recent_contact()
	local t = {}
	for i,v in ipairs(list) do
		t[#t+1] = v.roleId
	end
	if #t>0 then
		LuaItemManager:get_item_obejct("chat"):get_friend_list_c2s(t,2)
	else
		self:set_friend_list({}) --获取朋友列表
	end
end

--处理申请添加好友之后的对象隐藏
function RecentContact:solve_apply_friend(roleId)
	if roleId == 0 then
		local root = self.refer:Get("itemRoot").transform
		for i=root.childCount-1,0,-1 do
			self.base_friend:repay_item("RecentContact",root:GetChild(i).gameObject)
		end
	else
		obj = obj or LuaHelper.FindChild(self.refer:Get("itemRoot"),"friendObj_"..roleId)
		if obj then
			self.base_friend:repay_item("RecentContact",obj)
		end
	end
end

--设置列表
function RecentContact:set_friend_list(list)
print("设置最近联系人列表")
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("RecentContact",item,root)):GetComponent("ReferGameObjects")
		ref:Get("recent_contact_time_text").text = v.logoutTm==0 and "当前在线" or ("<color=#585858FF>"..socialTools.get_out_line_item_str(v.logoutTm).."</color>")

		ref.name = "friendObj_"..v.roleId
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("level_text").text = v.level
		print("VIP等级",v.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
		ref:Get("chatBtn").name = "chatBtn_"..v.roleId
	end
	--设置其他
	-- self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("RecentContact",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	local not_have_friend = #list==0
	print("最近联系人数量",#list,"企鹅",not_have_friend,"按钮",not not_have_friend)
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(not_have_friend)
	self.refer:Get("chatBtn_"):SetActive(not not_have_friend)
end

function RecentContact:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"consentBtn_") and arg then -- 同意添加好友
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local roleId = tonumber(string.split(cmd,"_")[2])
		self.item_obj:reply_apply_c2s(roleId)
		self:solve_apply_friend(roleId)
	elseif cmd=="all_refuse" then -- 全部拒绝
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:reply_apply_c2s(nil,0)
		self:solve_apply_friend(0)
	elseif cmd=="all_consent" then -- 全部同意
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:reply_apply_c2s(0)
		self:solve_apply_friend(0)
	end
end

function RecentContact:on_receive( msg, id1, id2, sid )
	print("最近联系人接收协议")
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if id2== Net:get_id2("friend", "GetFriendInfoR") and sid == 2 then
			self:set_friend_list(msg.list or {}) --获取朋友列表
		end
	end
end

function RecentContact:register()
    StateManager:register_view( self )
end

function RecentContact:cancel_register()
	StateManager:remove_register_view( self )
end

function RecentContact:on_showed()
	self:register()
    if self.init then
    	self:get_friend_list() --获取最近联系人列表
	end
end

function RecentContact:on_hided()
	self:cancel_register()
end
-- 释放资源
function RecentContact:dispose()
    self._base.dispose(self)
 end

return RecentContact

