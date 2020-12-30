--[[
	组队条件选择
	create at 17.5.18
	by xin
]]


local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local dataUse = require("models.team.dataUse")

local commomString = 
{
	[1] = "匹配中不允许切换目标",
}

local res = 
{
	[1] = "team_scrollview.u3d", 
}

local bg_res = 
{
	[1] = "scroll_table_cell_bg_01_select",
	[2] = "scroll_table_cell_bg_01_normal",
}

local itemHeight,subItemHeight,offHeight,subOffHeight = 48,42,0,0

--@targetId 目标id 
local opinion=class(UIBase,function(self,targetId,callback)
	print("opinion create",targetId)
	self.name = "opinion1"
	self.targetId = targetId
	self.callback = callback
	local item_obj = LuaItemManager:get_item_obejct("team")
	UIBase._ctor(self, res[1], item_obj)
end)


function opinion:dataInit()
	local myLevel = gf_getItemObject("game"):getLevel()
	self.data = dataUse.getTeamTableEx(myLevel)
	self.bType = self:getTag()
end

function opinion:getTag()
	for i,v in ipairs(self.data or {}) do
		for ii,vv in ipairs(v or {}) do
			if vv.code == self.targetId then
				return i
			end
		end
	end
	print("error 没有找到次tag opinion->getTag 44")
	return nil
end

-- 资源加载完成
function opinion:on_asset_load(key,asset)
	
end


function opinion:init_ui(data,isFirst)
	-- local scroll_rect_table = LuaHelper.GetComponentInChildren(self.root,ScrollRectTable) --找到ScrollRectTable控件 
  	
 	-- --创建panel 
 	local refer = self.refer
 	local scroll_rect_table = refer:Get(1)
  	local panel =  refer:Get(2)
 	self.panel = panel
 	
 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		self.panel = scroll_rect_item
		self:updateItem(self.panel,data)
	end
	self:updateItem(panel,data)
  	scroll_rect_table.data = {1,} --data必须是数组
 	scroll_rect_table:Refresh(-1,-1) --刷新数据

end

function opinion:setTarget(target)
	print("setTarget")
	self.targetId = target
	self.bType = self:getTag()
end

function opinion:updateItem(panel)
	--移除所有孩子
	for i=1,panel.transform.childCount do
  		local go = panel.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	-- local openButton = self.root.transform:FindChild("panel").transform:FindChild("openButton")
 -- 	local closeButton = self.root.transform:FindChild("panel").transform:FindChild("closeButton")
 -- 	local subButton = self.root.transform:FindChild("panel").transform:FindChild("subButton")
 -- 	local normalButton = self.root.transform:FindChild("panel").transform:FindChild("normalButton")

	local openButton = self.refer:Get("openButton")
 	local closeButton = self.refer:Get("closeButton")
 	local subButton = self.refer:Get("subButton")
 	local normalButton = self.refer:Get("normalButton")

	local bCount = #self.data
	local sCount = 0
	local height = itemHeight *bCount +  (bCount - 1) * offHeight
	--展开此项
	print("self.bType：",self.bType)
	if self.bType then
		sCount = #self.data[self.bType]
		height = height + sCount * subItemHeight + (sCount - 1) * subOffHeight 
	end
	--重设panel高度
  	panel.transform.sizeDelta = Vector2(242,height)
  	panel.transform.localPosition = Vector3(242 / 2+2,-height / 2,0) 

  	local offset = -height / 2 + itemHeight / 2 - 4
  	local subOffset = sCount > 0 and sCount * subItemHeight + (sCount - 1)* subOffHeight  or 0
  	for i,v in ipairs(self.data or {}) do
  		if i == 1 then 
			local normalButton1 = LuaHelper.InstantiateLocal(normalButton.gameObject,panel.gameObject)
  			normalButton1.transform.localPosition = Vector3(0,offset + (bCount - i) * (itemHeight + offHeight) + subOffset - 3,0) 
  			normalButton1.name = "team_list_normalButton"
  			LuaHelper.FindChildComponent(normalButton1,"Text","UnityEngine.UI.Text").text = v[1].name
  			
  			if self.bType == i then
  				normalButton1.transform:FindChild("Image").gameObject:SetActive(true)

  			end

  		--如果有展开项
  		elseif self.bType == i and i~=1 then
  			local py = offset + (bCount - i) * (itemHeight + offHeight)
  			local openButton1 = LuaHelper.InstantiateLocal(openButton.gameObject,panel.gameObject)
  			openButton1.transform.localPosition = Vector3(0,py + subOffset - 2,0) 
  			openButton1.name = "team_list_closeButton"..i
  			LuaHelper.FindChildComponent(openButton1,"Text","UnityEngine.UI.Text").text = v[1].name
  			subOffset = 0
  			for ii=1,sCount do
  				local sData = v[ii]
  				local subButton1 = LuaHelper.InstantiateLocal(subButton.gameObject,panel.gameObject)
  				subButton1.transform.localPosition = Vector3(0,py + (sCount - ii) * subItemHeight - 5 + (sCount - ii - 1) * subOffHeight,0) 
  				subButton1.name = "team_list_subButton"..sData.code
  				
  				local checkImageButton = subButton1.transform:FindChild("subButton1")
  				checkImageButton.name = "team_list_subButton"..sData.code

  				LuaHelper.FindChildComponent(subButton1,"Text","UnityEngine.UI.Text").text = sData.sname
  				if self.targetId == sData.code then
  					local checkImage = LuaHelper.FindChild(subButton1,"Image")
  					checkImage.gameObject:SetActive(true)
  					self.checkImage = checkImage
  				end
  			end

  		else
  			local closeButton1 = LuaHelper.InstantiateLocal(closeButton.gameObject,panel.gameObject)
  			closeButton1.transform.localPosition = Vector3(0,offset + (bCount - i) * (itemHeight + offHeight) - 1 + subOffset ,0) 
  			closeButton1.name = "team_list_closeButton"..i
  			LuaHelper.FindChildComponent(closeButton1,"Text","UnityEngine.UI.Text").text = v[1].name
  		end
  	end
end

--点击
function opinion:on_click(obj,arg)
	print("wtf you :opinion click")
	if string.find(obj.name,"team_list_closeButton") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.checkImage = nil
		print("opinion closeButton click")
		local nType = string.gsub(obj.name,"team_list_closeButton","")
		local bType = tonumber(nType)
		if self.bType == bType then
			self.bType = nil
		else
			self.bType = bType
		end
		self:updateItem(self.panel)
	elseif string.find(obj.name,"team_list_subButton") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("opinion subButton click",obj.name)

		local matching = gf_getItemObject("team"):get_matching_state()
		if matching then
			gf_message_tips(commomString[1])
			return
		end

		local nType = string.gsub(obj.name,"team_list_subButton","")
		local sType = tonumber(nType)

		if self.checkImage and self.checkImage ~= arg then
			print("setFalse")
			self.checkImage.gameObject:SetActive(false)
		end
		local visible = arg.gameObject.activeSelf
		print("wtf visible:",visible)
		arg.gameObject:SetActive(not visible)	
		self.checkImage = arg
		--选中
		local cbArg = 0
		if not visible then
			cbArg = sType
		end
		if self.callback then
			self.callback(cbArg)
		end

	elseif string.find(obj.name,"team_list_normalButton") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

		local matching = gf_getItemObject("team"):get_matching_state()
		if matching then
			gf_message_tips(commomString[1])
			return
		end

		self.bType = 1
		self.checkImage = nil

		if self.callback then
			self.callback(1)
		end
		self:updateItem(self.panel)
	end
end

function opinion:clear()
	StateManager:remove_register_view(self)
end

function opinion:on_showed()
	self:dataInit()
	self:init_ui(self.data,true)
	StateManager:register_view(self)
end

function opinion:on_hided()
	print("opinion hide")
	self:clear()
end

-- 释放资源
function opinion:dispose()
	print("opinion dispose")
	self:clear()
    self._base.dispose(self)
 end

return opinion

