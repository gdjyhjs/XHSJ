--[[--
-- ui管理器,自动管理ui资源的释放
-- @Author:Seven
-- @DateTime:2017-06-23 10:01:31
--]]

UIMgr = {}

UIMgr.LEVEL_0       = 0  -- 关闭后10s后立即释放 由于延迟加载的机制 10秒后再删除 避免一些空指针问题
UIMgr.LEVEL_5       = 1  -- 关闭后5分钟释放
UIMgr.LEVEL_10      = 2  -- 关闭后10分钟释放
UIMgr.LEVEL_STATIC 	= 3  -- 不会被释放

function UIMgr:create()
	self.asset_list = {}
	self.schedule = Schedule(handler(self, self.on_update), 5)
end

function UIMgr:add_asset( asset )
	self.asset_list[asset.asset_name] = asset
	-- table.insert(self.asset_list, asset)
end

function UIMgr:remove_asset( asset, dispose, index )
	if dispose then
		asset:dispose()
	end
	self.asset_list[asset.asset_name] = nil
	-- table.remove(self.asset_list, index)
end

function UIMgr:on_update( dt )
	

	--需要在登陆进游戏之后才进行回收
	local is_load = gf_getItemObject("battle").pool:is_loaded()
    if not is_load then
        return
    end

    print("检查是否有需要释放的UI")

	local function get_parent_visible(view)
		--仅支持10深度查找
		for i=1,10 do
			--只有父亲显示时才返回true
			if view.parent then
				if view.parent:is_visible() then
					return true
				end
				view = view.parent
			else
				return false
			end
		end
	end

	for k,v in pairs(self.asset_list) do
		if not v:is_visible() and not get_parent_visible(v) and v._is_loaded then
			local time = Net:get_server_time_s() - v.hide_time
			if v.level == UIMgr.LEVEL_0 and time > 10  then   --
				self:remove_asset(v, true, k)

			elseif v.level == UIMgr.LEVEL_5 and time >= 300 then
				self:remove_asset(v, true, k)

			elseif v.level == UIMgr.LEVEL_10 and time >= 600 then
				self:remove_asset(v, true, k)

			end
		end

	end
end

UIMgr:create()
