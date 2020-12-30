--[[--
--
-- @Author:Seven
-- @DateTime:2018-01-16 15:55:19
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Guide_text_tip=class(UIBase,function(self)
	self.item_obj =  LuaItemManager:get_item_obejct("functionUnlock")
    UIBase._ctor(self, "guide_text_tip.u3d", self.item_obj ) -- 资源名字全部是小写
end)

-- 资源加载完成
function Guide_text_tip:on_asset_load(key,asset)
-- LuaHelper.Instantiate(obj)
	StateManager:register_view(self)
	self.view_tb = {}
	local data =  self.item_obj:get_feeble_guide()
	for k,v in pairs(data) do
		self:create_tip_view(v)
	end
	self.time = 0 
	if not self.update_time then
		self.update_time = Schedule(handler(self,self.countdown),1)
	end
end
function Guide_text_tip:countdown()
	self.time = self.time + 1
	for k,v in pairs(self.view_tb) do
		if v.time < self.time then
			Net:receive({code =v.name ,type = 1 },ClientProto.GuideFeebleClose)
		end
	end
end
function Guide_text_tip:create_tip_view(data)
	for k,v in pairs(self.view_tb or {}) do
		if v.name == data.code then
			return
		end
	end
	local index = #self.view_tb +1
	local obj = self.refer:Get(data.dir)
	self.view_tb[index] = {}
	self.view_tb[index].obj = LuaHelper.Instantiate(obj)
	self.view_tb[index].obj.name = data.code
	self.view_tb[index].name = data.code  
	self.view_tb[index].time = data.time
	self.view_tb[index].obj.transform:SetParent(self.root.transform,false)
	self.view_tb[index].obj.transform.position = data.tf_pos
	self.view_tb[index].txt = LuaHelper.FindChildComponent(self.view_tb[index].obj, "Text", "UnityEngine.UI.Text")
	self.view_tb[index].txt.text = data.content
	self.view_tb[index].txt.transform.sizeDelta = Vector2(data.width,self.view_tb[index].txt.transform.sizeDelta.y)
	self.view_tb[index].obj:SetActive(true)
	local pos  =self.view_tb[index].obj.transform.localPosition
	self.view_tb[index].obj.transform.localPosition = Vector3(pos.x+data.pos[1],pos.y+data.pos[2],0)
	self.view_tb[index].tween=LuaHelper.GetComponent(self.view_tb[index].obj,"TweenPosition")
	local pos  =self.view_tb[index].obj.transform.localPosition
    self.view_tb[index].tween.from =pos
    if data.dir == 1 or data.dir == 2 then
    	self.view_tb[index].tween.to = Vector3(pos.x,pos.y-data.range,0)
    elseif data.dir == 3 or data.dir == 4 then
    	self.view_tb[index].tween.to = Vector3(pos.x-data.range,pos.y,0)
    elseif data.dir == 5 or data.dir == 6 then
    	self.view_tb[index].tween.to = Vector3(pos.x,pos.y+data.range,0)
    elseif data.dir == 7 or data.dir == 8 then
    	self.view_tb[index].tween.to = Vector3(pos.x+data.range,pos.y,0)
    end
    self.view_tb[index].tween:Play()
	local canvas = self.view_tb[index].obj:AddComponent("UnityEngine.Canvas")
	canvas.overrideSorting = true
	canvas.sortingOrder = data.order
end

function Guide_text_tip:on_receive(msg,id1,id2,sid)
	if id1 == ClientProto.GuideFeebleClose then
		local index = nil
		for k,v in pairs(self.view_tb) do
		 	if v.name == msg.code then
		 		LuaHelper.Destroy(self.root.transform:FindChild(v.name).gameObject)
		 		index = k
		 	end
		end
		if index then
			table.remove( self.view_tb, index )
		end
		if #self.view_tb == 0 then
			self:dispose()
		end
	end
end
-- 释放资源
function Guide_text_tip:dispose()

	self.time = 0
	if self.update_time then
		self.update_time:stop()
		self.update_time = nil
	end
    self._base.dispose(self)
    StateManager:remove_register_view( self )
    self.item_obj.guide_feeble_view = nil
end

return Guide_text_tip

