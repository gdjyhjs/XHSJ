--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-08 10:18:31
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignOnlineTips=class(UIBase,function(self,data,num)
	self.num = num
	self.item_obj = LuaItemManager:get_item_obejct("sign")
    UIBase._ctor(self, "welfare_online_tip.u3d", self.item_obj) -- 资源名字全部是小写
    self.data = data
end)

local tip_x = {
	[1] = -290,
	[2] = -98,
	[3] = 91,
	[4] = 275,
	[5] = 404,
}

-- 资源加载完成
function SignOnlineTips:on_asset_load(key,asset)
	self:init_ui()
	StateManager:register_view(self)
	self:refresh(self.data)
	self.is_init = true
end

function SignOnlineTips:init_ui()
	print("111111a11111111111",self.num)
	self.refer:Get(2).transform.localPosition = Vector3(tip_x[self.num],self.refer:Get(2).transform.localPosition.y,0) 
	self.scroll_table = self.refer:Get(1)
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self:adjustment_view()
    -- print(string.format("数组数目=%s ,数组数目=%s",self.data.count,self.data))
end

function SignOnlineTips:adjustment_view()
	local paddingX = 27
	local width = (83.45+paddingX)*#self.data+30
	local height = 179.02
	self.refer:Get(2).transform.sizeDelta =Vector2(width ,height)
end

function SignOnlineTips:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function SignOnlineTips:on_click(obj,arg)
	if obj.name == "tip_bg" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function SignOnlineTips:update_item(item,index,data)
	item:Get(3).text = data[3]
	gf_set_item(data[2],item:Get(1),item:Get(2))
	gf_set_press_prop_tips(item:Get(2).gameObject,data[2])
	item:Get(4).text = ConfigMgr:get_config("item")[data[2]].name
	local tb = ConfigMgr:get_config("item")
	if tb[data[2]].bind == 1 then
		item:Get("binding"):SetActive(true)
	else
		item:Get("binding"):SetActive(false)
	end
end

-- function SignOnlineTips:on_showed()
-- 	if	self.is_init then
-- 		self:adjustment_view()
-- 		self:refresh(self.data)
-- 	end
-- end

-- 释放资源
function SignOnlineTips:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SignOnlineTips

