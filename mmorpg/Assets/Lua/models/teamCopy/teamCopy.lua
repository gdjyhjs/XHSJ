--[[
	组队副本数据模块 废
	create at 17.8.21
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local teamCopy = LuaItemManager:get_item_obejct("teamCopy")

local model_name = "team"
--UI资源
teamCopy.assets=
{
    View("teamCopyView", teamCopy) ,
}

--点击事件
function teamCopy:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("teamCopy_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function teamCopy:initialize()
	print("teamCopy initialize")
end



--get ***********************************************************************************



--set ***********************************************************************************






--rec ***********************************************************************************


--服务器返回
function teamCopy:on_receive( msg, id1, id2, sid )
    -- if(id1==Net:get_id1(model_name))then
    --     if id2 == Net:get_id2(model_name, "TeamCopyReadNotifyR") then
    --     	CHECK_MEMBER_WAIT_ENTER_TEAM_COPY()
    --     elseif id2 == Net:get_id2(model_name, "TeamCopyAgreeR") then
    --     	CHECK_WAIT_ENTER_TEAM()

    --     end
    -- end
end


