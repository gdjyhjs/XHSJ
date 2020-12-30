--[[--
-- 跟随npc
-- @Author:Seven
-- @DateTime:2017-04-20 11:49:39
--]]

local SpriteBase = require("common.spriteBase")

local FollowNPC = class(SpriteBase, function( self, config_data, ... )
	self.config_data = config_data
	SpriteBase._ctor(self, config_data.model..".u3d", ...)
end)

function SpriteBase:pre_init()
	
end

function FollowNPC:init()
	self.root.layer = ClientEnum.Layer.CHARACTER -- Character 不碰撞层
	
	-- LuaHelper.RemoveComponent(self.root, "UnityEngine.AI.NavMeshAgent")
	self.automove  = self.root:AddComponent("Seven.Move.AutoMove")
	-- self.automove.speed = 14 --玩家速度

	self.follow_move = self.root:AddComponent("Seven.Move.FollowMove")
	self.head_node = LuaHelper.FindChild(self.root, "HP")
	self.animator = LuaHelper.GetComponent(self.root, "UnityEngine.Animator") -- 动画控制器
	self.animator:SetBool("idle", true)
end

-- 设置跟随者
function FollowNPC:set_follow_target( target )
	self.follow_target = target
	if not self.is_init or not target then
		return
	end
	self.follow_move:SetTarget(target.root)
end

-- 设置是否跟随
function FollowNPC:set_follow( follow )
	if self.is_follow == follow then
		return
	end

	self.is_follow = follow
	self.follow_move:SetFollow(follow)
end

function FollowNPC:set_speed( speed )
	self.follow_move.speed = speed
	self.automove.speed = speed 
end

function FollowNPC:set_distance( distance )
	self.follow_move:SetFollowDistance( distance)
end


function FollowNPC:set_blood_line( blood_line )
	self.blood_line = blood_line
	self.blood_line:set_target(self.head_node.transform)
	self.blood_line:set_info(self.config_data.name)
	self.blood_line:set_title()
	self.blood_line:set_visible(true)
end

function FollowNPC:dispose()
	if self.blood_line then
		self.blood_line:dispose()
	end
	FollowNPC._base.dispose(self)
end

return FollowNPC