--[[--
-- 推荐好友
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 21:02:19
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
-- local socialTools = require("models.social.socialTools")

local RecommendFriends=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "recommend_friends.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function RecommendFriends:on_asset_load(key,asset)
	self.findPlayer = nil
	self.item_obj:get_recommend_list_c2s() --获取推荐好友列表
	self.init = true
end

--申请添加好友
function RecommendFriends:apply_add_friend(roleId,btn)
	self.apply_friend_list[roleId] = roleId
	self.item_obj:apply_friend_c2s(roleId)
	btn = btn or LuaHelper.FindChildComponent(self.refer:Get("itemRoot"),"addFriendBtn_"..roleId,"UnityEngine.UI.Button")
	if btn then
		btn.interactable = false
	end
end

--一键添加推荐好友
function RecommendFriends:one_key_add()
	for i,v in ipairs(self.item_obj.recommendList) do
		if not self.apply_friend_list[v.roleId] then
			self:apply_add_friend(v.roleId)
		end
	end
end

--设置列表
function RecommendFriends:set_friend_list()
	self.apply_friend_list = {} -- 已发送申请添加好友的列表
	local list = self.item_obj.recommendList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("recommendFriends",item,root)):GetComponent("ReferGameObjects")
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
		ref:Get("addFriendBtn").name = "addFriendBtn_"..v.roleId
		ref:Get("addFriendBtn").interactable = true
	end
	--设置其他
	-- self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("recommendFriends",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(#list==0)
end

function RecommendFriends:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"addFriendBtn_") and arg then --申请添加好友
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:apply_add_friend(tonumber(string.split(cmd,"_")[2]),arg)
	elseif cmd=="on_key_add_btn" then --一键添加
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:one_key_add()
	elseif cmd=="change_batch_btn" then --换一批
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_recommend_list_c2s()
	elseif cmd == "find_player_btn" then -- 查找朋友
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj.findName = self.refer:Get("find_player_inputfile").text
		if self.findPlayer then
			self.findPlayer:show()
		else
			self.findPlayer = require("models.social.findPlayer")(self.item_obj,self.base_friend)
			self:add_child(self.findPlayer)
		end
	end
end

function RecommendFriends:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetRecommendListR"))then
			print("服务器返回：推荐好友列表")
			self:set_friend_list()
		end
	end
end

--一键赠送
function RecommendFriends:on_key_give_strength()

end

function RecommendFriends:register()
    StateManager:register_view( self )
end

function RecommendFriends:cancel_register()
	StateManager:remove_register_view( self )
end

function RecommendFriends:on_showed()
	self:register()
    if self.init then
		self.item_obj:get_recommend_list_c2s() --获取推荐好友列表
	end
	self.base_friend:show_red_point(2,false)
end

function RecommendFriends:on_hided()
	self:cancel_register()
end
-- 释放资源
function RecommendFriends:dispose()
    self._base.dispose(self)
 end

return RecommendFriends

