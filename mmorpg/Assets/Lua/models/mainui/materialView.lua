--[[
	module:任务栏  材料副本
	at 2017.9.6
	by xin
]]


local dataUse = require("models.copy.dataUse")

local commomString = 
{
	[1] = "",
}

local res = 
{
	[1] = "mainui_copy_materials.u3d", 
}

local material=class(UIBase,function(self, item_obj)
	UIBase._ctor(self, res[1], item_obj)
end)


function material:dataInit()
	self:referInit()

end

-- 资源加载完成
function material:on_asset_load(key,asset)
	StateManager:register_view(self)
	self:set_always_receive(true)
	self:dataInit()
	self:hide()
end

function material:referInit()
	self.action = self.refer:Get(3)
    self.action.from = self.action.transform.localPosition
    self.action.to = self.action.transform.localPosition+Vector3(-265,0,0)
end

function material:init_ui()
	local copy_id = gf_getItemObject("copy"):get_copy_id()
	local my_level = gf_getItemObject("game"):getLevel()
	local data = dataUse.getLevelMaterialCopy(copy_id,my_level)

	local scroll_view = self.refer:Get(2)
	self.scroll_table = scroll_view
	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		--	
		gf_set_item(data_item[1], scroll_rect_item:Get(2), scroll_rect_item:Get(1))
		scroll_rect_item:Get(3).text = data_item[2]
	end
	
	scroll_view.data = {}
	scroll_view:Refresh(-1,-1)

end

--isShow  是否显示出来
function material:showAction(isShow)
	if not self.action then
		return
	end
	if not isShow then
		self.action:PlayForward()
	else
		self.action:PlayReverse()
	end
end


--点击
function material:on_click(obj,arg)
	local eventName = obj.name
	if obj.name == "team_goto_button_mainui" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	end
end

function material:on_receive(msg, id1, id2, sid)
	if id1 == ClientProto.FinishScene then
		if gf_getItemObject("copy"):is_copy_type(ServerEnum.COPY_TYPE.MATERIAL) then
			self:init_ui()
		end
	end
end
-- 释放资源
function material:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return material

