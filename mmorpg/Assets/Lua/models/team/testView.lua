
local testView=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("teamUp")
	self.item_obj = item_obj
    UIBase._ctor(self, "newprefab.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function testView:on_asset_load(key,asset)
	print("load success")
	self:register()
end
--注册
function testView:register()
	print("testView register event")
    --注册点击事件
    self.item_obj:register_event("teamUp_view_on_click", handler(self, self.on_click))
end

function testView:on_click(obj, arg)
	local eventName = obj.name
	
	if eventName == "Image (1)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("testView on click evnetName:",eventName)
		self:dispose()
	end
end
-- 释放资源
function testView:dispose()
	self.item_obj:register_event("teamUp_view_on_click", nil)
    self._base.dispose(self)
 end

return testView