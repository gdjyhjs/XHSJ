--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-17 16:07:35
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local socialTools = require("models.social.socialTools")

local FriendManage=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "friend_manage.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.base_friend = base_friend
end)

-- 资源加载完成
function FriendManage:on_asset_load(key,asset)
	self.init = true
	self:set_friend_list()
end

function FriendManage:set_friend_list()
	self.deleteList = {}
	local list = self.item_obj.friendList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("FriendManage",item,root)):GetComponent("ReferGameObjects")
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
		ref:Get("deleteBtn").name = "deleteBtn_"..v.roleId
		ref:Get("checkDelete"):SetActive(false)
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
	end
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("FriendManage",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(#list==0)
end


function FriendManage:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="closeFriendManageBtn" then -- 关闭
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd=="deleteBatchBtn" then -- 批量删除
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		for k,v in pairs(self.deleteList) do
			self.item_obj:delete_friend_c2s(k)
		end
	elseif string.find(cmd,"deleteBtn_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		arg:SetActive(not arg.activeSelf)
		local isDel = arg.activeSelf
		local roleId = tonumber(string.split(cmd,"_")[2])
		if isDel then
			self.deleteList[roleId] = roleId
		else
			self.deleteList[roleId] = nil
		end
	end
end

function FriendManage:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "DeleteFriendR"))then
			self:set_friend_list()
		end
	end
end

function FriendManage:register()
    StateManager:register_view( self )
end

function FriendManage:cancel_register()
	StateManager:remove_register_view( self )
end

function FriendManage:on_showed()
	self:register()
    if self.init then
		self:set_friend_list()
	end
end

function FriendManage:on_hided()
	self:cancel_register()
end

-- 释放资源
function FriendManage:dispose()
    self._base.dispose(self)
 end

return FriendManage

