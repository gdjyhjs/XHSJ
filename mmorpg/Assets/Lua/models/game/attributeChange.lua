--[[--
--
-- @Author:Seven
-- @DateTime:2018-01-20 14:54:34
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local max_ui = ConfigMgr:get_config("t_misc").attribute_change.max_ui -- 最大数量
local item_time = ConfigMgr:get_config("t_misc").attribute_change.item_time -- 多久出来一条
local hide_time = ConfigMgr:get_config("t_misc").attribute_change.hide_time -- 隐藏时间（包括行动时间）

local AttributeChange=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "attribute_change.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function AttributeChange:on_asset_load(key,asset)
	self.attribute_stack = self.item_obj.attribute_change_stack
	self.objs = {}
	self.sample = self.refer:Get("item")
	self.ui_parent = self.sample.transform.parent
	self.idx = 0
	self.item = os.time()

	for i,v in ipairs(self.attribute_stack) do
		print("感受到了属性变化上升：",v.attr,v.value)
	end

	self.timer = Schedule(handler(self, self.on_update),item_time)  -- 计时器
	print("属性变化ui加载完成,变化属性个数",#self.attribute_stack)
end

function AttributeChange:on_update()
	if #self.attribute_stack>0 then
		self.idx = self.idx + 1
		if self.idx > max_ui then
			self.idx = 1
		end
		if not self.objs[self.idx] then
			local item = LuaHelper.Instantiate(self.sample)
			item.transform:SetParent(self.ui_parent,false)
			item:SetActive(true)
			self.objs[self.idx] = {
				item = item,
				attr = item:GetComponentInChildren(UnityEngine_UI_Image),
				num = item:GetComponentInChildren("UnityEngine.UI.Text"),
				tweens = item:GetComponentsInChildren("TweenPosition"),
			}
		elseif self.objs[self.idx].num.gameObject.activeInHierarchy then
			self.idx = self.idx - 1
			return
		end
		local attribute = self.attribute_stack[1]
		-- print(Time.time,"飘出一条属性增加,保存的数量减1","当前保存的数量",#self.attribute_stack)
		table.remove(self.attribute_stack,1)
		local obj = self.objs[self.idx]
		-- print("更新属性变化判断",attribute.attr,attribute.value)
		gf_setImageTexture(obj.attr,"property_font_"..attribute.attr)
		obj.num.text = "+"..attribute.value
		for i=1,#obj.tweens do
			-- obj.tweens[i]:PlayReverse()
			obj.tweens[i]:ResetToBeginning()
  			obj.tweens[i]:Play()
		end
		obj.num.gameObject:SetActive(true)
		PLua.Delay(function() obj.num.gameObject:SetActive(false) end,hide_time)
		self.item = os.time()
	elseif (os.time() - self.item) > (hide_time + 1) then
		self:dispose()
	end
end

-- 释放资源
function AttributeChange:dispose()
	print("销毁属性变化ui")
	if self.timer then
		self.timer:stop()
		self.timer = nil
	end
	self.item_obj.attribute_change_stack = nil
    self._base.dispose(self)
 end

return AttributeChange