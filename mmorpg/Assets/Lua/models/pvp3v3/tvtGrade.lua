--[[
	3v3段位信息界面
	create at 17.9.26
	by xin
]]

local model_name = "copy"

local res = 
{
	[1] = "3v3_grade.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("匹配失败"),
	[2] = gf_localize_string("段位：%s"),
	[3] = gf_localize_string("积分：%d"),

}

local dataUse = require("models.pvp3v3.dataUse")

local tvtGrade = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("pvp3v3")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function tvtGrade:on_asset_load(key,asset)
    self:init_ui()

end

function tvtGrade:init_ui()
	self:init_my_info()

	local data = dataUse.get_stage()

	local pItem = self.refer:Get(4)
	local copyItem = self.refer:Get(3)
	
	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local score = gf_getItemObject("pvp3v3"):get_my_score()
	local score_data = dataUse.get_rank_data_by_score(score)

	for i,v in ipairs(data or {}) do
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.gameObject:SetActive(true)
      	
		item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = string.gsub(v[1].name,string.sub(v[1].name,string.len(v[1].name)-3,string.len(v[1].name)),"")

		item.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text").text = string.format("%d-%d",v[1].score_min,v[#v].score_max)

		--icon
		local icon = item.transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, v[#v].icon)

		if v[1].stage_code <= score_data.stage_code and v[#v].stage_code >= score_data.stage_code then
			item.transform:FindChild("select").gameObject:SetActive(true)
		else
			item.transform:FindChild("select").gameObject:SetActive(false)
		end

	end
end

function tvtGrade:init_my_info()
	local score = gf_getItemObject("pvp3v3"):get_my_score()
	local data = dataUse.get_rank_data_by_score(score)
	self.refer:Get(1).text = string.format(commom_string[2],data.name)
	self.refer:Get(2).text = string.format(commom_string[3],score)
end

--鼠标单击事件
function tvtGrade:on_click( obj, arg)
	local event_name = obj.name
	print("tvtGrade click",event_name)
    if event_name == "3v3_grade_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif string.find(event_name,"grade1") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

    end
end

function tvtGrade:on_showed()
	StateManager:register_view(self)
end

function tvtGrade:clear()
	StateManager:remove_register_view(self)
end

function tvtGrade:on_hided()
	self:clear()
end
-- 释放资源
function tvtGrade:dispose()
	self:clear()
    self._base.dispose(self)
end

function tvtGrade:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "") then
		end
	end
end

return tvtGrade