--[[
	竞技场3v3界面  属性
	create at 17.9.21
	by xin
]]
local model_name = "team"

local res = 
{
	[1] = "rvr_3v3_end.u3d",
	[2] = "battle_end_bg_02",
	[3] = "battle_end_bg_01",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local tvtEnd = class(UIBase,function(self,data)
	self.data = data
	self.time = Net:get_server_time_s()
	local item_obj = LuaItemManager:get_item_obejct("pvp3v3")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function tvtEnd:on_asset_load(key,asset)
    self:init_ui()
end

function tvtEnd:init_ui()
	if not next(self.data or {}) then
		return
	end
	gf_print_table(data, "wtf tvt end:")
	--失败或者胜利
	if self.data.win then
		gf_setImageTexture(self.refer:Get(11), res[2])
	else
		gf_setImageTexture(self.refer:Get(11), res[3])
	end

	--总击杀
	self.refer:Get(9).text = self.data.totalKill[1]
	self.refer:Get(10).text = self.data.totalKill[2]

	local data = self.data.memberInfo

	for i,v in ipairs(data or {}) do
		local pnode = self.refer:Get(i)
		--名字
		pnode.transform:FindChild("txtName"):GetComponent("UnityEngine.UI.Text").text = v.name
		--头像
		local head = pnode.transform:FindChild("head_icon"):GetComponent(UnityEngine_UI_Image)
		gf_set_head_ico(head, v.head)
		--等级
		pnode.transform:FindChild("level_text"):GetComponent("UnityEngine.UI.Text").text = v.level
		--积分
		pnode.transform:FindChild("txtScore"):GetComponent("UnityEngine.UI.Text").text = v.score
		--纹章
		pnode.transform:FindChild("txtHonor"):GetComponent("UnityEngine.UI.Text").text = v.honor
		--战功
		pnode.transform:FindChild("txtExploit"):GetComponent("UnityEngine.UI.Text").text = v.feats
		--击杀
		pnode.transform:FindChild("txtKill"):GetComponent("UnityEngine.UI.Text").text = v.kill
		--死亡
		pnode.transform:FindChild("txtDead"):GetComponent("UnityEngine.UI.Text").text = v.dead
		
		--mvp
		local mvp = pnode.transform:FindChild("mvp")
		mvp.gameObject:SetActive(false)
		if v.mvp then
			mvp.gameObject:SetActive(true)
		end

		--如果是自己
		local self_bg = pnode.transform:FindChild("self")
		self_bg.gameObject:SetActive(false)
		if v.name == gf_getItemObject("game"):getName() then
			self_bg.gameObject:SetActive(true)
		end
	end

end

--鼠标单击事件
function tvtEnd:on_click( obj, arg)
	local event_name = obj.name
	print("tvtEnd click",event_name)
    if event_name == "any_touch" then 
    	--如果小于两秒 不给点击
	    if Net:get_server_time_s() - self.time <= ConfigMgr:get_config("t_misc").copy.pass_wait_time then
	    	return
	    end
	    Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
		self:dispose()
    end
end

function tvtEnd:on_showed()
	StateManager:register_view(self)
end

function tvtEnd:clear()
	StateManager:remove_register_view(self)
end

function tvtEnd:on_hided()
	self:clear()
end
-- 释放资源
function tvtEnd:dispose()
	self:clear()
    self._base.dispose(self)
end

function tvtEnd:on_receive( msg, id1, id2, sid )
	-- if id1 == Net:get_id1(model_name) then
	-- 	if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
	-- 	end
	-- end
	-- if id1 == Net:get_id1("copy") then
	-- 	if id2 == Net:get_id2("copy", "PassCopyR") then
	-- 		self:dispose()
	-- 	end
	-- end

end

return tvtEnd