--[[--
-- 好友申请
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 21:02:01
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FriendsApply=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "friends_apply.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function FriendsApply:on_asset_load(key,asset)
	self.item_obj:get_apply_list_c2s() --获取推荐好友列表
	self.init = true
end

--处理申请添加好友之后的对象隐藏
function FriendsApply:solve_apply_friend(roleId)
	if roleId == 0 then
		local root = self.refer:Get("itemRoot").transform
		for i=root.childCount-1,0,-1 do
			self.base_friend:repay_item("FriendsApply",root:GetChild(i).gameObject)
		end
	else
		obj = obj or LuaHelper.FindChild(self.refer:Get("itemRoot"),"friendObj_"..roleId)
		if obj then
			self.base_friend:repay_item("FriendsApply",obj)
		end
	end
end

--设置列表
function FriendsApply:set_friend_list()
	self.solve_apply_friend_list = {} -- 处理添加好友的列表
	local list = self.item_obj.FriendApplyList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("FriendsApply",item,root)):GetComponent("ReferGameObjects")
		ref.name = "friendObj_"..v.roleId
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("level_text").text = v.level
		ref:Get("consentBtn").name = "consentBtn_"..v.roleId
		print("VIP等级",v.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
	end
	--设置其他
	-- self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("FriendsApply",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	local not_have_friend = #list==0
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(not_have_friend)
	self.refer:Get("to_recommend_friends"):SetActive(not_have_friend)
	self.refer:Get("all_refuse"):SetActive(not not_have_friend)
	self.refer:Get("all_consent"):SetActive(not not_have_friend)
end

function FriendsApply:on_click(obj,arg)
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

function FriendsApply:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetApplyListR"))then
			-- print("服务器返回：申请好友列表")
			self:set_friend_list()
		elseif id2== Net:get_id2("friend", "ApplyFriendNotifyR") then
			-- 有人请求添加好友
			self.item_obj:get_apply_list_c2s() --获取推荐好友列表
		end
	end
end

function FriendsApply:register()
    StateManager:register_view( self )
end

function FriendsApply:cancel_register()
	StateManager:remove_register_view( self )
end

function FriendsApply:on_showed()
	self:register()
    if self.init then
		self.item_obj:get_apply_list_c2s() --获取推荐好友列表
	end
	self.item_obj:have_new_appay_friend_change(false)
end

function FriendsApply:on_hided()
	self:cancel_register()
end
-- 释放资源
function FriendsApply:dispose()
    self._base.dispose(self)
 end

return FriendsApply

