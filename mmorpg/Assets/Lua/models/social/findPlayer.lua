--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-17 15:22:21
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FindPlayer=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "find_player.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.base_friend = base_friend
end)

-- 资源加载完成
function FindPlayer:on_asset_load(key,asset)
	self.init = true
	self.refer:Get("find_role_name_input_field").text = self.item_obj.findName
	self.item_obj:friend_player_c2s(self.item_obj.findName)
end

function FindPlayer:set_friend_list()
	local list = self.item_obj.findList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("FindPlayer",item,root)):GetComponent("ReferGameObjects")
		ref.name = "friendObj_"..v.roleId
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("level_text").text = v.level
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
		if self.item_obj.finendRoleIdList[v.roleId] then
			ref:Get("addFriendBtn"):SetActive(false)
			ref:Get("is_friend_text"):SetActive(true)
		else
			ref:Get("is_friend_text"):SetActive(false)
			local btnObj = ref:Get("addFriendBtn")
			btnObj:SetActive(true)
			btnObj.name = "addFriendBtn_"..v.roleId
			btnObj:GetComponent("UnityEngine.UI.Button").interactable = true
		end
	end
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("FindPlayer",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(#list==0)
end


function FindPlayer:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="closeFindPlayerBtn" then -- 关闭
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd=="again_find_player_btn" then -- 查找玩家
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj.findName = self.refer:Get("find_role_name_input_field").text
		self.item_obj:friend_player_c2s(self.item_obj.findName)
	end
end

function FindPlayer:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "FindPlayerR"))then
			print("服务器返回：推荐好友列表")
			self:set_friend_list()
		end
	end
end




function FindPlayer:register()
    StateManager:register_view( self )
end

function FindPlayer:cancel_register()
	StateManager:remove_register_view( self )
end

function FindPlayer:on_showed()
	self:register()
    if self.init then
    	self.refer:Get("find_role_name_input_field").text = self.item_obj.findName
		self.item_obj:friend_player_c2s(self.item_obj.findName)
	end
end

function FindPlayer:on_hided()
	self:cancel_register()
end

-- 释放资源
function FindPlayer:dispose()
    self._base.dispose(self)
 end

return FindPlayer

