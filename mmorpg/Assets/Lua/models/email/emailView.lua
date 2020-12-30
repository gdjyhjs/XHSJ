--[[-- 
--
-- @Author:huangjunshan
-- @DateTime:2017-08-17 14:25:28
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local EmailView=class(Asset,function(self,item_obj)
	self:set_bg_visible( true )
    Asset._ctor(self, "email.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function EmailView:on_asset_load(key,asset)
	self.contentTitleText = self.refer:Get("contentTitleText")
	self.contentTimeText = self.refer:Get("contentTimeText")
	self.contentDetailText = self.refer:Get("contentDetailText")
	self.qi_e = self.refer:Get("qi_e")
	self.content = self.refer:Get("content")
	self.scrollRect = self.refer:Get("scrollRect")
	self.emailItem = self.refer:Get("emailItem")
	self.rewardItem = self.refer:Get("rewardItem")
	self.selAllmark = self.refer:Get("selAllmark")

	self.emailItemObjs = {} -- 所有邮件选项
	self.hideEmailItemObjs = {} -- 隐藏的邮件选项

	self.reawrdObjs = {} -- 所有奖励选项

	self.init = true

	self:show()
end

function EmailView:init_email_list()
	gf_mask_show(true)
	self.select_email_list = {} -- 勾选的邮件

	if self.item_obj.left_get_email_count>0 then
		self.item_obj:get_email_list_c2s()
	else
		self.item_obj:check_delete_c2s()
	end
end

-- 添加邮件列表
function EmailView:add_email_list(list)
	gf_print_table(list,"添加邮件列表")
	for i,v in ipairs(list) do
		local item = self.hideEmailItemObjs[1]
		if item then
			table.remove(self.hideEmailItemObjs,1)
		else
			local obj = LuaHelper.Instantiate(self.emailItem)
			local tf = obj.transform
			tf:SetParent(self.emailItem.transform.parent,false)
			item = {
				obj = obj,
				tf = tf,
				sel = tf:Find("sel").gameObject,
				mark = tf:Find("mark").gameObject,
				title = tf:Find("title"):GetComponent("UnityEngine.UI.Text"),
				time = tf:Find("time"):GetComponent("UnityEngine.UI.Text"),
				noread = tf:Find("noread").gameObject,
				read = tf:Find("read").gameObject,
				reward = tf:Find("reward").gameObject,
			}
		end
		table.insert(self.emailItemObjs,i,item)
		item.obj:SetActive(true)
		item.tf:SetSiblingIndex(i)
		item.sel:SetActive(false)
		item.mark:SetActive(false)
		item.title.text = ConfigMgr:get_config("email_list")[v.type].title
		item.time.text = gf_get_time_stamp(v.time)
		item.noread:SetActive(not v.isRead)
		item.read:SetActive(v.isRead)
		item.reward:SetActive(v.reward and not v.isTaken or false)
		item.email = v
	end
	if self.cur_select_idx then
		self.cur_select_idx = self.cur_select_idx + #list
	end
end

-- 选择邮件
function EmailView:select_email(idx)
	if self.cur_select_idx and self.emailItemObjs[self.cur_select_idx] then
		self.emailItemObjs[self.cur_select_idx].sel:SetActive(false)
	end
	if self.emailItemObjs[idx] then
	-- 有邮件
		self.cur_select_idx = idx
		self.emailItemObjs[idx].sel:SetActive(true)
		self.qi_e:SetActive(false)
		self.content:SetActive(true)
		self:set_email_content()
	else
	-- 没有邮件
		self.cur_select_idx = nil
		self.qi_e:SetActive(true)
		self.content:SetActive(false)
	end
end

-- 设置右侧的邮件内容
function EmailView:set_email_content()
	local email = self.emailItemObjs[self.cur_select_idx].email
	--获取邮件配置文件
	local data = ConfigMgr:get_config("email_list")[email.type]
	self.contentTitleText.text = data.title -- 标题
	self.contentTimeText.text = gf_get_time_stamp(email.time) -- 时间
	local parameter = json:decode(email.detail) -- 参数
	gf_print_table(parameter,data.content)
	self.contentDetailText.text = string.format(data.content,unpack(parameter)) -- 正文


	-- 附件
	local haveReward = email.reward and not email.isTaken
	if haveReward then
		for i,v in ipairs(email.reward) do
			local item = self.reawrdObjs[i]
			if not item then
				local obj = LuaHelper.Instantiate(self.rewardItem)
				local tf = obj.transform
				tf:SetParent(self.rewardItem.transform.parent,false)
				item = {
					obj = obj,
					tf = tf,
					bg = tf:GetComponent(UnityEngine_UI_Image),
					icon = tf:Find("icon"):GetComponent(UnityEngine_UI_Image),
					count = tf:Find("count"):GetComponent("UnityEngine.UI.Text"),
					binding = tf:Find("binding").gameObject,
				}
				self.reawrdObjs[i] = item
			end
			print("附件物品",v.code)
			if v.code<ServerEnum.BASE_RES.END then -- 基础资源
				local data = ConfigMgr:get_config("base_res")[v.code]
				item.obj:SetActive(true)
				item.binding:SetActive(false)
				item.count.text = v.num
				gf_set_money_ico(item.icon,v.code,item.bg,true)
			else
				local data = ConfigMgr:get_config("item")[v.code]
				item.obj:SetActive(true)
				item.binding:SetActive(data.bind==1)
				print("附件物品id",v.code,"绑定情况",data.bind,data.name)
				if v.equip then
					item.count.text = nil
					gf_set_equip_icon(v.equip,item.icon,item.bg)
				else
					item.count.text = v.num
					gf_set_item(v.code,item.icon,item.bg)
				end
			end
		end
		for i=#email.reward+1,#self.reawrdObjs do
			self.reawrdObjs[i].obj:SetActive(false)
		end
	else
		for i,v in ipairs(self.reawrdObjs) do
			v.obj:SetActive(false)
		end
	end

	-- 已读
	if not email.isRead then
		self.item_obj:read_amail_c2s(email.guid)
	end
end

function EmailView:on_click(item_obj,obj,arg)
    print("邮件系统",obj,arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "emailItem(Clone)" then -- 选择邮件
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:select_email(obj.transform:GetSiblingIndex())
    elseif cmd == "rewardItem(Clone)" then -- 选择附件
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:select_reward(obj.transform:GetSiblingIndex())
    elseif cmd == "selAll" then -- 点击全选
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:select_all()
    elseif cmd == "delete_email_btn" then -- 删除按钮
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:delete_email()
    elseif cmd == "tanken_email_btn" then -- 领取按钮
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:get_reward()
    elseif cmd == "check" then -- 勾选一封邮件
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:check_email(obj.transform.parent:GetSiblingIndex())
    end
end

-- 选择附件
function EmailView:select_reward(idx)
	local reward = self.emailItemObjs[self.cur_select_idx].email.reward[idx]
	if reward.code<ServerEnum.BASE_RES.END then
		LuaItemManager:get_item_obejct("itemSys"):prop_tips(ConfigMgr:get_config("base_res")[reward.code].item_code)
	else
		if reward.equip then
			LuaItemManager:get_item_obejct("itemSys"):equip_browse(reward.equip)
		else
			LuaItemManager:get_item_obejct("itemSys"):prop_tips(reward.code)
		end
	end
end

-- 点击全选
function EmailView:select_all()
	local is_sel_all = #self.select_email_list == #self.emailItemObjs
	self.selAllmark:SetActive(not is_sel_all)
	self.select_email_list = {}
	for i,v in ipairs(self.emailItemObjs) do
		v.mark:SetActive(not is_sel_all)
		if not is_sel_all then
			self.select_email_list[#self.select_email_list+1] = v.email.guid
		end
	end
end

-- 删除邮件
function EmailView:delete_email()
	local is_have_sel = #self.select_email_list>0
	if is_have_sel then
		local sel_email_key = {}
		for i,v in ipairs(self.select_email_list) do
			print(i,"添加一个选择的键",v)
			sel_email_key[v] = v
		end
		local list = {}
		for i,v in ipairs(self.emailItemObjs) do
			local email = v.email
			if sel_email_key[email.guid] and (not email.reward or email.isTaken) then
				print(i,"添加一个guid到列表",email.guid)
				list[#list+1] = email.guid
			end
		end
		gf_print_table(list,"可删邮件")
		if #list>0 then
			local content = gf_localize_string("确定删除所有已读邮件吗？")
			local fun = function() self.item_obj:delete_email_c2s(list) end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,fun)
		else
			gf_message_tips(gf_localize_string("附件未领取，不可删除该邮件"))
		end
	else
		local email = self.emailItemObjs[self.cur_select_idx].email
		if email.reward and not email.isTaken then
			gf_message_tips(gf_localize_string("附件未领取，不可删除该邮件"))
			return
		end
		local guid = email.guid
		self.item_obj:delete_email_c2s(guid)
	end
end

-- 领取邮件附件
function EmailView:get_reward()
	local is_have_sel = #self.select_email_list>0
	if is_have_sel then
		local sel_email_key = {}
		for i,v in ipairs(self.select_email_list) do
			sel_email_key[v] = v
		end
		local list = {}
		for i,v in ipairs(self.emailItemObjs) do
			local email = v.email
			if sel_email_key[email.guid] and email.reward and not email.isTaken then
				list[#list+1] = email.guid
			end
		end
		self.item_obj:get_email_reward_c2s(list)
	else
		local guid = self.emailItemObjs[self.cur_select_idx].email.guid
		self.item_obj:get_email_reward_c2s(guid)
	end
end

-- 勾选一封邮件
function EmailView:check_email(idx)
	local item = self.emailItemObjs[idx]
	local guid = item.email.guid
	if item.mark.activeSelf then
		-- 取消勾选
		for i,v in ipairs(self.select_email_list) do
			if guid == v then
				table.remove(self.select_email_list,i)
				break
			end
		end
	else
		-- 勾选上
		self.select_email_list[#self.select_email_list+1] = guid
	end
	item.mark:SetActive(not item.mark.activeSelf)
	local is_sel_all = #self.select_email_list == #self.emailItemObjs
	self.selAllmark:SetActive(is_sel_all)
end

function EmailView:on_receive( msg, id1, id2, sid )
	if not self.init then
		return
	end
	if id1==Net:get_id1("email") then
		if(id2== Net:get_id2("email", "GetEmailListR")) or id2== Net:get_id2("email", "CheckDeleteR") then
			print("view 服务器返回：获取邮件协议/自动删除返回")
			self:CheckDeleteR()
		elseif(id2== Net:get_id2("email", "ReadEmailR"))then
			print("view 服务器返回：读取邮件")
			self:ReadEmailR(msg.guid)
		elseif(id2== Net:get_id2("email", "GetEmailRewardR"))then
			print("view 服务器返回：领取邮件奖励")
			self:GetEmailRewardR(msg.results)
		elseif(id2== Net:get_id2("email", "DeleteEmailR"))then
			print("view 服务器返回：删除邮件")
			self:DeleteEmailR(msg.results)
		elseif(id2== Net:get_id2("email", "UpdateNewEmailR"))then
			print("view 服务器返回：新邮件推送")
			self:add_email_list(msg.emailList)
		end
	end
end

function EmailView:CheckDeleteR()
	gf_mask_show(false)
	print("删除邮件项")
	for i,v in ipairs(self.emailItemObjs) do
		print(v.obj)
		v.obj:SetActive(false)
		self.hideEmailItemObjs[#self.hideEmailItemObjs+1] = v
	end
	self.emailItemObjs = {}

	self:add_email_list(self.item_obj.emailList)
	self:select_email(1) -- 默认选择第一封
	self.scrollRect.verticalNormalizedPosition = 1
end

function EmailView:ReadEmailR(guid)
	for i,v in ipairs(self.emailItemObjs) do
		if v.email.guid == guid and v.email.isRead then
			v.read:SetActive(true)
			v.noread:SetActive(false)
		end
	end
end

-- 领取附件
function EmailView:GetEmailRewardR(list)
	local get_list = {}
	for i,v in ipairs(list or {}) do
		if v.err==0 then
	    	get_list[v.guid] = v.err
	    end
	end
	for i,v in ipairs(self.emailItemObjs) do
		if get_list[v.email.guid] and v.email.isTaken then
			v.reward:SetActive(false)
			v.read:SetActive(true)
			v.noread:SetActive(false)
			
			if i == self.cur_select_idx then
				-- 这是正在阅读的邮件
				for i,v in ipairs(self.reawrdObjs) do
					v.obj:SetActive(false)
				end
			end
		end
	end
end

-- 删除邮件
function EmailView:DeleteEmailR(list)
	local get_list = {}
	for i,v in ipairs(list or {}) do
	    get_list[v.guid] = v.err
	end
	for i=#self.select_email_list,1,-1 do -- 删除被删除的选中项
		local guid = self.select_email_list[i]
		if get_list[guid] == 0 then
			print(i,"从选中的邮件移除被删除的邮件",guid)
			table.remove(self.select_email_list,i)
		end
	end
	-- local is_del_cur_sel = false
	for i=#self.emailItemObjs,1,-1 do
		local v = self.emailItemObjs[i]
		if get_list[v.email.guid] and not v.email.type then
			print(i,"隐藏此邮件选项",v.email.guid)
			v.obj:SetActive(false)
			v.tf:SetAsLastSibling()

			self.hideEmailItemObjs[#self.hideEmailItemObjs+1] = v
			table.remove(self.emailItemObjs,i)

			if i<=self.cur_select_idx and self.cur_select_idx>1 then
				-- 这是正在读的邮件 或者在读的邮件之前的邮件
				self.cur_select_idx = self.cur_select_idx - 1
			end
			-- if i == self.cur_select_idx then
			-- 	is_del_cur_sel = true
			-- end
		end
	end
	-- if is_del_cur_sel then
	-- 	self:select_email(1) -- 默认选择第一封
	-- 	self.scrollRect.verticalNormalizedPosition = 1
	-- end
		self:select_email(self.cur_select_idx) -- 默认选择第一封
end

function EmailView:register()
    self.item_obj:register_event("email_on_click", handler(self, self.on_click))
end

function EmailView:cancel_register()
	self.item_obj:register_event("email_on_click", nil)
end

function EmailView:on_showed()
	if self.init then
		self:register()
		self:init_email_list()
		self.item_obj.have_new_email = false
		Net:receive({id=ClientEnum.MAIN_UI_BTN.NEW_EMAIL, visible=self.item_obj.have_new_email,self.item_obj.have_new_email}, ClientProto.ShowOrHideMainuiBtn)
	end
end

function EmailView:on_hided()
	if self.init then
		self.item_obj:check_delete_c2s()
		self:cancel_register()
	    self.item_obj:red_point_change()
	end
end

-- 释放资源
function EmailView:dispose()
	self:hide()
    self.init = nil
    self._base.dispose(self)
 end

return EmailView