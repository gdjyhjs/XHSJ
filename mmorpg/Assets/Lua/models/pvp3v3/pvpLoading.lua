--[[
	等待界面系统主界面
	create at 17.9.19
	by xin
]]

local model_name = "copy"

local res = 
{
	[1] = "rvr_3v3_loading.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}

local res_bg = 
{	
	[ServerEnum.CAREER.MAGIC] 	= "3v3_111101",
	[ServerEnum.CAREER.BOWMAN] 	= "3v3_112101",
	[ServerEnum.CAREER.SOLDER] 	= "3v3_114101",
} 

local pvpLoading = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	self:set_level(UIMgr.LEVEL_STATIC)
	
end)


--资源加载完成
function pvpLoading:on_asset_load(key,asset)
	self.can_be_dispose = true
    --计时5秒 如果5秒内loading完 第五秒才隐藏此界面
    -- self:hide()
end


function pvpLoading:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		local progress = gf_getItemObject("transform"):get_progress()

		print("loading progress wtf :",progress)

		gf_getItemObject("pvp3v3"):send_to_post_progress(progress * 100)
		if progress >= 1 then
			self:stop_schedule()
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.3)
end

function pvpLoading:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function pvpLoading:dispose_by_scene()
	if self.can_be_dispose then
		self:hide()
	else
		self.need_dispose_self = true
	end
end

function pvpLoading:init_ui(msg)
	if not self:is_visible() then
		return
	end
	self:start_scheduler()
	print("pvp loading init")
	local members = gf_getItemObject("pvp3v3"):get_pvp_tvt_members()
	gf_print_table(members, "wtf loading members:")
	if not next(members or {}) then
		return
	end
	self.text_list = {}
	self.fill_list = {}
	for i,v in ipairs(members or {}) do
		local item = self.refer:Get(1).transform:FindChild("b"..i)
		--名字
		item.transform:FindChild("Text (5)"):GetComponent("UnityEngine.UI.Text").text = v.name
		item.transform:FindChild("Text (6)"):GetComponent("UnityEngine.UI.Text").text = v.level

		local icon = item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, res_bg[v.career])

		--进度
		local fill = item.transform:FindChild("fill"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(fill, res_bg[v.career])
		fill.fillAmount = 0 / 100

		local fill_text = item.transform:FindChild("Text (7)"):GetComponent("UnityEngine.UI.Text")
		fill_text.text = string.format("%d%%",0)

		self.text_list[v.roleId] = fill_text
		self.fill_list[v.roleId] = fill

	end
end



function pvpLoading:on_showed()
	if not gf_getItemObject("copy"):is_pvptvt() then
		self:set_visible(false)
	end
	StateManager:register_view(self)
	self:init_ui()
end

function pvpLoading:clear()
	StateManager:remove_register_view(self)
	self:stop_schedule()
end

function pvpLoading:on_hided()
	self:clear()
end

function pvpLoading:rec_progress_update(msg)
	self.fill_list[msg.roleId].fillAmount = msg.progress / 100
	self.text_list[msg.roleId].text = string.format("%d%%",msg.progress) 

end

function pvpLoading:on_receive(msg, id1, id2)
	
    if id1==Net:get_id1("copy") then
        if id2 == Net:get_id2("copy", "TeamBeginBattleNotifyR") then 
        	self:hide()
        	require("models.pvp3v3.state")()

        elseif id2 == Net:get_id2("copy", "TeamVsCopyLoadProgressNotifyR") then 
        	gf_print_table(msg, "wtf TeamVsCopyLoadProgressNotifyR:")
        	self:rec_progress_update(msg)
        	
        end
    end
end

-- 释放资源
function pvpLoading:dispose()
	self:clear()
    self._base.dispose(self)
end



return pvpLoading