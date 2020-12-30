--[[--
-- 我的敌人
-- @Author:my_enemy
-- @DateTime:2017-08-16 21:02:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local socialTools = require("models.social.socialTools")
-- local NormalTipsView = require("common.normalTipsView")

local MyEnemy=class(UIBase,function(self,item_obj,base_friend)
    UIBase._ctor(self, "my_enemy.u3d", item_obj) -- 资源名字全部是小写
    self.base_friend = base_friend
end)

-- 资源加载完成
function MyEnemy:on_asset_load(key,asset)
	self.item_obj:get_enemy_list_c2s() --获取仇人列表
	self.init = true
end
--处理申请添加好友之后的对象隐藏
function MyEnemy:solve_apply_friend(roleId)
	obj = obj or LuaHelper.FindChild(self.refer:Get("itemRoot"),"friendObj_"..roleId)
	if obj then
		self.base_friend:repay_item("MyEnemy",obj)
	end
	local friend_count_text = self.refer:Get("friend_count_text")
	friend_count_text.text = (string.split(friend_count_text.text,"/")[1]-1).."/99"
end

function MyEnemy:set_friend_list()
	local list = self.item_obj.EnemyList
	local root = self.refer:Get("itemRoot")
	local item = self.refer:Get("item")
	local count = root.transform.childCount
	--设置每一项
	for i,v in ipairs(list) do
		local ref = (i<=count and root.transform:GetChild(i-1) or self.base_friend:get_item("MyEnemy",item,root)):GetComponent("ReferGameObjects")
		ref.name = "friendObj_"..v.roleId
		ref:Get("on_line_text").text = v.logoutTm==0 and "当前在线" or ("<color=#585858FF>"..socialTools.get_out_line_item_str(v.logoutTm).."</color>")
		local head_icon =  ref:Get("head_icon")
		gf_set_head_ico(head_icon,v.head)
		ref:Get("social_mask"):SetActive(v.logoutTm~=0)
		head_icon.name = "friendTips_"..v.roleId
		ref:Get("role_name").text = v.name
		ref:Get("power_text").text = v.power
		ref:Get("intimacy_text").text = v.animosity
		ref:Get("level_text").text = v.level
		ref:Get("deleteEnemyBtn").name = "deleteEnemyBtn_"..v.roleId.."_"..v.name
		ref:Get("chatBtn").name = "chatBtn_"..v.roleId
		print("VIP等级",v.vipLevel,ref:Get("vipText"),ref:Get("vipLvBg"))
		if v.vipLevel>0 then
			ref:Get("vipText").text = v.vipLevel
			ref:Get("vipLvBg"):SetActive(true)
		else
			ref:Get("vipLvBg"):SetActive(false)
		end
	end
	--设置其他
	self.refer:Get("friend_count_text").text = #list.."/99"
	--删除多余ui
	for i=1,count-#list do
		self.base_friend:repay_item("MyEnemy",root.transform:GetChild(root.transform.childCount-1).gameObject)
	end
	--如果没有好友，显示企鹅
	self.refer:Get("qi_e"):SetActive(#list==0)
end

function MyEnemy:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"deleteEnemyBtn_") and arg then -- 删除仇人 确定将仇人玩家名移出仇人列表？移出后仇恨度将会清空。
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local cip = string.split(cmd,"_")
		local roleId = tonumber(cip[2])
		local f = function()
			self.item_obj:delete_enemy_c2s(roleId)
			self:solve_apply_friend(roleId)
		end

		local content = string.format("确定将仇人<color=%s>%s</color>移出仇人列表？移出后仇恨度将会清空。",gf_get_color(ClientEnum.SET_GM_COLOR.NAME_OWN),cip[3])
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,f)

	elseif cmd=="myEnemyTipsBtn" then --tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:my_friend_tips()
	end
end

function MyEnemy:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetEnemyListR"))then
			-- print("服务器返回：取到仇人列表")
			self:set_friend_list()
		end
	end
end

--显示我的好友 ？ tips
function MyEnemy:my_friend_tips()
	gf_show_doubt(1012)

-- 	local list = {
-- 		"1.在野外地图被别的玩家重伤，即会自动成为你的仇人。",
-- "2.每被重伤一次，仇恨度+1；每重伤仇人1次，仇恨度-1。",
-- "3.仇恨度为0之后，则该玩家不再是你的仇人。",
-- 	}

-- 	NormalTipsView(self.item_obj, list)
end
function MyEnemy:register()
    StateManager:register_view( self )
end

function MyEnemy:cancel_register()
	StateManager:remove_register_view( self )
end

function MyEnemy:on_showed()
	self:register()
    if self.init then
		self.item_obj:get_enemy_list_c2s() --获取仇人列表
	end
end

function MyEnemy:on_hided()
	self:cancel_register()
end
-- 释放资源
function MyEnemy:dispose()
    self._base.dispose(self)
 end

return MyEnemy

