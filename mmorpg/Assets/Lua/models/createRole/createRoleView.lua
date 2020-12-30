	--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-14 13:18:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local Effect = require("common.effect")
local UI = LuaHelper.Find("UI")
local XpEffect = require("models.battle.obj.xpEffect")

local CreateRoleView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "create_character.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

local max_name_length = 12

-- 资源加载完成
function CreateRoleView:on_asset_load(key,asset)
	self:register()
	self.item_obj:get_ui(self)
	self:init_ui()
	self.init = true
end

function CreateRoleView:register()
	self.item_obj:register_event("create_role_view_on_click", handler(self, self.on_click))
end

function CreateRoleView:init_ui()

	self.inputField = self.refer:Get("inputName")
	self.inputFieldText = self.inputField.textComponent
	self.random_name = true
	self.inputField.text=""
 	--初始化职业选择 默认选择人数最少的职业
	-- local index = 
	self:get_fewest_job()
	-- self:select_job(index)
end

--获取最少的职业（最少人玩）
function CreateRoleView:get_fewest_job()
	if self.item_obj:is_xp_loaded() then
		LuaItemManager:get_item_obejct("login"):min_career_c2s()
	end
end

function CreateRoleView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("login") then
		if id2 == Net:get_id2("login", "RandomRoleNameR") then -- 返回随机名字
			self.ranname = msg.name
			self:write_name(msg.name)
		elseif id2 == Net:get_id2("login", "MinCareerR") then -- 返回最少人的职业
			gf_print_table(msg, "返回最少人的职业")
			self:select_job(msg.career)
		end
	end
end

--点击
function CreateRoleView:on_click(item_obj,obj,arg)
	print("选人界面点击了按钮",obj)
	local cmd = arg.name
	if(cmd=="exitBtn")then
		--返回按钮
		self:on_click_btn_exit()
	elseif(cmd=="createBtn")then
		--点击进入游戏
		 Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN) -- 通用按钮点击音效
		self:on_click_btn_into_game()
	elseif(cmd=="randomNameBtn")then
		--点击随机名字按钮
		self:get_random_name()
	elseif(string.find(cmd,"selJob_"))then
		--点击选择职业开关按钮
		local job = tonumber(string.split(cmd,"_")[2])
		self:select_job(job)
	elseif cmd == "inputName" then --动过输入框了
		print("值变化"..LuaHelper.GetStringWidth(self.inputField.text,self.inputFieldText))
		while(gf_get_string_length(self.inputField.text)>max_name_length or LuaHelper.GetStringWidth(self.inputField.text,self.inputFieldText)>150)do
			self.inputField.text = string.sub(self.inputField.text,1,-2)
		end
		if self.inputField.text~=self.ranname then
			self.random_name = false
		end
	end
end

--返回按钮
function CreateRoleView:on_click_btn_exit()
	print(self.ui_key)
	-- self.main_ui:hide_ui(self.ui_key)
	-- self.main_ui:load_ui("loginInternalView", self.ui_key)
	StateManager:set_current_state(StateManager.login) -- 切回登录界面	
end

--进入游戏
function CreateRoleView:on_click_btn_into_game()
	local role_name = self.inputField.text

	if checkChar(role_name) then --禁止使用符号 3567890上面的符号等 #%^&*(){}[]
		-- gf_message_tips("您的名字中包含违规内容，请修改!")
		gf_message_tips("您的名字不合法，请修改！")
		return
	end

	if role_name == "" or role_name==nil then
		gf_message_tips("角色名字不能为空!")
		return
	end

	local login = LuaItemManager:get_item_obejct("login")
	local area_id = login.select_area -- 区id
	local carrer = self.cur_select_job -- 职业类型
	login:login_game_c2s(area_id, role_name, carrer)
end

--随机名字按钮
function CreateRoleView:get_random_name()  --1:男 2女
	--self.toggle_insert_symbol.isOn
	self.random_name = true
	local login = LuaItemManager:get_item_obejct("login")
	login:random_role_name_c2s(self.cur_select_job==Enum.CAREER.SOLDER and 1 or 2,UnityEngine.Random.Range(1,100)>49)
end

--写入名字
function CreateRoleView:write_name(name)
	self.inputField.text = name
end

--选择职业
function CreateRoleView:select_job(job_index)
	print("选择职业",self.cur_select_job,job_index)
	if self.cur_select_job == job_index then --重复选择职业不管
		return
	end
	if self.cur_select_job then
		local job_root = self.refer:Get("jobRoot"):FindChild("selJob_"..self.cur_select_job)
		job_root:FindChild("selMark").gameObject:SetActive(false)
		if self.item_obj.xp_list[self.cur_select_job] then
			self.item_obj.xp_list[self.cur_select_job]:hide()
		end
	end
	print("选择的职业",job_index)
	self.cur_select_job = job_index
	--重新起一个随机名字
	if self.random_name then
		self:get_random_name()
	end
    --更新职业名称和描述图片
    gf_setImageTexture(self.refer:Get("jobIcon"),"img_xuanren_name_"..job_index)
    gf_setImageTexture(self.refer:Get("jobDes"),"img_xuanren_des_"..job_index)
    --音效
    Sound:play_fx("show_"..job_index)
    --模型
	local job_root = self.refer:Get("jobRoot"):FindChild("selJob_"..self.cur_select_job)
	job_root:FindChild("selMark").gameObject:SetActive(true)

	local effect = self.item_obj.xp_list[self.cur_select_job]
	effect:show_effect(true)
	UI:SetActive(true)

end

function CreateRoleView:on_showed()
	if self.init then
		self:init_ui()
	end
end

-- 释放资源
function CreateRoleView:dispose()
	self.init = nil
	self.cur_select_job = nil
	self.item_obj:register_event("create_role_view_on_click", nil)
    self._base.dispose(self)
    print("释放资源CreateRoleView")
 end

return CreateRoleView

