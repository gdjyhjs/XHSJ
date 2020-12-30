--[[--
-- 我的好友
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 20:44:53
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local socialTools = require("models.social.socialTools")
-- local NormalTipsView = require("common.normalTipsView")

local MyFriends=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "my_friends.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function MyFriends:on_asset_load(key,asset)
	self.friendManage = nil
	self.item_obj:get_friend_list_c2s() --获取好友列表
	self.init = true
end

--一键赠送
function MyFriends:on_key_give_strength()
	for i,v in ipairs(self.item_obj.friendList) do
		if not self.item_obj.strengthGivensList[v.roleId] then
			local obj = LuaHelper.FindChild(self.refer:Get("itemRoot"),"giveStrengthBtn_"..v.roleId)
			if obj then
				self.base_friend:repay_item("MyFriends",obj)
			end
		end
	end
	self.item_obj:give_strength_c2s(0)
end

function MyFriends:set_friend_list()
	local list = self.item_obj.friendList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("MyFriends",item,root)):GetComponent("ReferGameObjects")
		ref.name = "friendObj_"..v.roleId
		ref:Get("on_line_text").text = v.logoutTm==0 and "当前在线" or ("<color=#585858FF>"..socialTools.get_out_line_item_str(v.logoutTm).."</color>")
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("intimacy_text").text = v.intimacy
		ref:Get("level_text").text = v.level
		print("VIP等级",v.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
		ref:Get("giveStrengthBtn").name = "giveStrengthBtn_"..v.roleId
		ref:Get("giveFlowerBtn").name = "giveFlowerBtn_"..v.roleId
		ref:Get("chatBtn").name = "chatBtn_"..v.roleId
		ref:Get("giveStrengthBtn"):SetActive(self.item_obj.strengthGivensList[v.roleId]==nil)
	end
	--设置其他
	self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("MyFriends",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	local not_have_friend = #list==0
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(not_have_friend)
	self.refer:Get("to_recommend_friends"):SetActive(not_have_friend)
	self.refer:Get("oneKeyGiveStrengthBtn"):SetActive(not not_have_friend)
	self.refer:Get("friendManageBtn"):SetActive(not not_have_friend)
	if #list<5 and UnityEngine.PlayerPrefs.GetInt("not_have_friend",0) ~= tonumber(os.date("%Y%m%d")) then
		self.base_friend:show_red_point(2,true)
		UnityEngine.PlayerPrefs.SetInt("not_have_friend",tonumber(os.date("%Y%m%d")))
	end
end

function MyFriends:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"giveFlowerBtn_") and arg then --赠送鲜花
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local id = tonumber(string.split(cmd,"_")[2])
			print("送花给好友 id = ",id)
		gf_print_table(self.item_obj.finendRoleIdList,"好友列表")
		if self.item_obj.finendRoleIdList[id].logoutTm==0 then
			LuaItemManager:get_item_obejct("gift"):show_view(id)
		else
			gf_message_tips("对方不在线")
		end
	elseif string.find(cmd,"giveStrengthBtn_") and arg then --赠送体力 --每天只能送一次
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.base_friend:repay_item("MyFriends",obj)
		self.item_obj:give_strength_c2s(tonumber(string.split(cmd,"_")[2]))
	elseif cmd=="friendManageBtn" then --好友管理
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.friendManage then
			self.friendManage:show()
		else
			self.friendManage = require("models.social.friendManage")(self.item_obj,self.base_friend)
			self:add_child(self.friendManage)
		end
	elseif cmd=="oneKeyGiveStrengthBtn" then --一键赠送
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:on_key_give_strength()
	elseif cmd=="myFriendTipsBtn" then --我的好友tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:my_friend_tips()
	end
end

function MyFriends:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetFriendListR"))then
			-- print("服务器返回：取到好友列表")
			self:set_friend_list()
		elseif id2 == Net:get_id2("friend", "AddFriendR") then
			self:set_friend_list()
		elseif id2 == Net:get_id2("friend", "BlackFriendR") then
			self.item_obj:get_friend_list_c2s() --获取好友列表
		elseif id2 == Net:get_id2("friend", "DeleteFriendR") then
			self:set_friend_list()
		end
	end
end

--显示我的好友 ？ tips
function MyFriends:my_friend_tips()
	gf_show_doubt(1011)

	-- local list = {
	-- 	"1.向好友赠送体力的同时，自身可获得1点体力，每天可获得25点。",
	-- 	"2.每天可领取25点好友赠送的体力。",
	-- 	"3.当好友达到上限时，可在【好友管理】对好友进行批量删除操作。",
	-- }

	-- NormalTipsView(self.item_obj, list)
end

function MyFriends:register()
    StateManager:register_view( self )
end

function MyFriends:cancel_register()
	StateManager:remove_register_view( self )
end

function MyFriends:on_showed()
	self:register()
    if self.init then
		self.item_obj:get_friend_list_c2s() --获取好友列表
	end
end

function MyFriends:on_hided()					
	self:cancel_register()
end

-- 释放资源
function MyFriends:dispose()
	print("MyFriends:dispose")
	self.init = nil
	self:cancel_register()
    self._base.dispose(self)
 end

return MyFriends

