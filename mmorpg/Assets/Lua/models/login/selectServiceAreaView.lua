--[[--
-- 选服界面
-- @Author:HuangJunShan
-- @DateTime:2017-04-01 15:23:14
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
--区列表初始化信息 用来记录这个区初始化了没有

local SelectServiceAreaView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "select_service_area.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SelectServiceAreaView:on_asset_load(key,asset)
	self.main_ui=self.item_obj.assets[1]
	--设置主ui为父物体
	self.root.transform:SetParent(self.main_ui.root.transform,false)
	--初始化ui
	self:init_ui()
	--区服初始化
	self:service_area_init()
	self.init = true

	self:show()
end

--ui初始化
function SelectServiceAreaView:init_ui()
	--获取已有角色为空的企鹅
	self.null_character_icon = LuaHelper.FindChild(self.root,"null_character_icon")
	--获取组件
	--左侧 选择大区开关（组）的变换组件
	self.content_select_big_area_tf=LuaHelper.FindChild(self.root.transform,"content_select_big_area")
	--右侧 区服列表（parent）的变换组件
	self.img_select_area_bg_tf=LuaHelper.FindChild(self.root.transform,"img_select_area_bg")
	if self.img_select_area_bg_tf then
		self.role_scroll_tf=self.img_select_area_bg_tf:GetChild(0)
		self.area_scroll_tf=self.img_select_area_bg_tf:GetChild(1)
		--获取右侧： 已有角色 开关组
		self.role_toggle_group_tf=LuaHelper.FindChild(self.role_scroll_tf,"content_select_area")
		--获取右侧： 区服列表 开关组
		self.area_toggle_group_tf=LuaHelper.FindChild(self.area_scroll_tf,"content_select_area")
	end
	--用来记录列表的初始化信息：数量
	self.icos = {}
end

function SelectServiceAreaView:set_ico(img,ico)
	if self.icos[ico] then
		img.sprite=self.icos[ico]
	else
		Loader:get_resource(ico..".u3d",nil,"UnityEngine.Sprite",
			function(spr)
				self.icos[ico]=spr.data
				img.sprite=spr.data
			end)
	end
end

--区服初始化
function SelectServiceAreaView:service_area_init()
	-- print("区服初始化开始")
	--[[
	创建左侧选择大区按钮
	1. 先复制一个作为推荐区服按钮
	2.获取区服数量 之后每100个区创建一个按钮 不足补1
	3.复制self.content_select_big_area_tf 第1个子物体的游戏对象，更改区服文本 text_toggle_select_service_area_bg
	]]
	--获取样本
	local sample_go = self.content_select_big_area_tf:GetChild(1).gameObject
	--根据区服数量 创建对应数量的按钮
	local area_count = self:get_servicearea_count()
	local each_big_area_count=self:get_big_area_count()
	local btn_count = area_count/each_big_area_count-area_count/each_big_area_count%1+1
	for i=btn_count,1,-1 do
		--创建区服按钮
		local clone_go = LuaHelper.InstantiateLocal(sample_go,self.content_select_big_area_tf.gameObject)
		--获取text组件	更改区服按钮文本 xxx-xxx区
		local mystart,myend=i*each_big_area_count-each_big_area_count+1,i==btn_count and area_count or each_big_area_count*i

		LuaHelper.FindChildComponent(clone_go,"text_select_big_area","UnityEngine.UI.Text").text=
		string.format(gf_localize_string("%d-%d区"),
			mystart,
			myend)
		clone_go.name=sample_go.name
		--记录区服
		clone_go.transform:GetChild(0).name=mystart
		clone_go.transform:GetChild(1).name=myend
	end
	--[[
	代码激活左侧默认激活开关
	1.如果有角色，激活已有角色开关
	2.否则激活推荐区服开关）
	]]
	-- print("区服初始化结束")
end

--每个大区配置几个区服
function SelectServiceAreaView:get_big_area_count()
	return 100
end

--获取区服
function SelectServiceAreaView:get_servicearea_count()
	-- print("获取服务器数量",#self.item_obj.server_list)
	return #self.item_obj.server_list
end

--判断用户是否有角色 获取用户角色
function SelectServiceAreaView:get_user_character_count()
	if not self.item_obj.role_list then return 0 end
	if not self.user_character_list or not self.user_character_count or self.user_character_list~=self.item_obj.role_list then
		self.user_character_list=self.item_obj.role_list
		self.user_character_count=0
		for k,v in pairs(self.user_character_list) do
			self.user_character_count=self.user_character_count+1
		end
		-- print("计算角色数量",self.user_character_count)
		return self:get_user_character_count()
	else
		-- print("获取角色数量",self.user_character_count)
		return self.user_character_count
	end
end

--获取推荐区
function SelectServiceAreaView:get_recommend_area_count()
	-- print("获取推荐服数量",#self.item_obj.recommed_list)
	return #self.item_obj.recommed_list
end

--初始化角色区服
function SelectServiceAreaView:init_character_area()
	-- print("初始化角色区服")
	--获取角色数量
	local charcount=self:get_user_character_count()
	--判断
	for i=0,self.role_toggle_group_tf.childCount-1 do
		self.role_toggle_group_tf:GetChild(i).gameObject:SetActive(true)
	end
	if(self.role_toggle_group_tf.childCount<charcount)then
		--子物体数量，不够补齐
		local sample=self.role_toggle_group_tf:GetChild(0).gameObject
		for i=self.role_toggle_group_tf.childCount+1,charcount do
			LuaHelper.InstantiateLocal(sample,self.role_toggle_group_tf.gameObject).name=sample.name
		end
	elseif(self.role_toggle_group_tf.childCount>charcount)then
		--子物体多了，隐藏
		for i=charcount,self.role_toggle_group_tf.childCount-1 do
			self.role_toggle_group_tf:GetChild(i).gameObject:SetActive(false)
		end
	end
	--循环人物列表 修改
	-- gf_print_table(self.item_obj.role_list,"人物列表")
	local i=0
	-- self.role_toggle_group_tf:GetComponentInParent("UnityEngine.UI.ToggleGroup"):SetAllTogglesOff()
	for k,v in pairs(self.item_obj.role_list) do
		i=i+1
		local obj = self.role_toggle_group_tf:GetChild(i-1).gameObject
		local areaid = v.area
		--将开关的第一个子物体（开关遮罩）改成区服id
		obj.transform:GetChild(0).name=areaid
		--等级
		LuaHelper.FindChildComponent(obj,"text_lv","UnityEngine.UI.Text").text=v.level
		--人物名
		LuaHelper.FindChildComponent(obj,"text_player_name","UnityEngine.UI.Text").text=v.name
		--人物头像
		local img = LuaHelper.FindChildComponent(obj,"img_head",UnityEngine_UI_Image)
		-- gf_print_table(v,"角色信息")
		gf_set_head_ico(img,v.head);
		--区服信息
		-- print(a)
		local area = self.item_obj.server_list[areaid]
		 gf_print_table(area,"区服信息")
		LuaHelper.FindChildComponent(obj,"text_area_name","UnityEngine.UI.Text").text=area.code.."区："..area.name
		local state = area.state
		local img = LuaHelper.FindChildComponent(obj,"img_area_state",UnityEngine_UI_Image)
		self:set_ico(img,"tipbg_0"..state);
		--如果当前是选择的区服，激活
		if tonumber(k) == tonumber(self.item_obj.select_area) then
			LuaHelper.eventSystemCurrentSelectedGameObject = obj
			obj:GetComponent("UnityEngine.UI.Toggle").isOn=true
		end
	end
	self.null_character_icon:SetActive(charcount==0)
end
--大区数据初始化需要更新的内容
--[[
是否新服 area_is_new
]]
--更新区服数据 推荐服
function SelectServiceAreaView:init_recommend_area()
	--获取要本大区区服的数量
	local areacount=#self.item_obj.recommed_list
	--判断
	if(self.area_toggle_group_tf.childCount<areacount)then
		--儿子个数，不够补足
		local sample=self.area_toggle_group_tf:GetChild(0).gameObject
		for i=1,areacount-self.area_toggle_group_tf.childCount do
			LuaHelper.InstantiateLocal(sample,self.area_toggle_group_tf.gameObject).name=sample.name
		end
	elseif(self.area_toggle_group_tf.childCount>areacount)then
		--儿子多了，隐藏多余的
		for i=areacount,self.area_toggle_group_tf.childCount-1 do
			self.area_toggle_group_tf:GetChild(i).gameObject:SetActive(false)
		end
	end
	self.area_toggle_group_tf:GetComponentInParent("UnityEngine.UI.ToggleGroup"):SetAllTogglesOff()
	for i,v in ipairs(self.item_obj.recommed_list) do
		--	更改信息 一个子物体，一个区服信息列表
		local obj = self.area_toggle_group_tf:GetChild(i).gameObject
		self:set_area_btn_info(obj,v)
		local k = v.code
		if k == tonumber(self.item_obj.select_area) then
			obj:GetComponent("UnityEngine.UI.Toggle").isOn=true
		end
	end
end

--更新 区服数据 普通服
function SelectServiceAreaView:init_right_list(arg,index)
	print("--更新 区服数据 普通服",arg,index,arg.transform:GetSiblingIndex())
	local mystart=arg.transform:GetChild(0).name
	local myend=arg.transform:GetChild(1).name
	local areacount=myend-mystart+1

	-- print("--判断儿子个数，不够补足")
	if(self.area_toggle_group_tf.childCount<areacount)then
		for i=1,areacount-self.area_toggle_group_tf.childCount do
			local sample=self.area_toggle_group_tf:GetChild(0).gameObject
			LuaHelper.InstantiateLocal(sample,self.area_toggle_group_tf.gameObject).name=sample.name
		end
	elseif(self.area_toggle_group_tf.childCount>areacount)then
		-- print("--儿子多了，隐藏多余的")
		for i=areacount,self.area_toggle_group_tf.childCount-1 do
			self.area_toggle_group_tf:GetChild(i).gameObject:SetActive(false)
		end
	end

	local k=0
	self.area_toggle_group_tf:GetComponentInParent("UnityEngine.UI.ToggleGroup"):SetAllTogglesOff()
	for i=mystart,myend do
		k=k+1
		local obj = self.area_toggle_group_tf:GetChild(k-1).gameObject
		self:set_area_btn_info(obj,self.item_obj.server_list[i])
		--如果当前是选择的区服，激活，否则不激活开关
		if i == tonumber(self.item_obj.select_area) then
			obj:GetComponent("UnityEngine.UI.Toggle").isOn=true
		end
	end
end

--设置区服按钮信息
function SelectServiceAreaView:set_area_btn_info(obj,info)
	-- gf_print_table(info,"服务器信息")
	print("--将开关的第一个子物体（开关遮罩）改成区服id",info.code)
	obj.transform:GetChild(0).name=info.code
	print("--区服名",info.area)
	LuaHelper.FindChildComponent(obj,"text_area_name","UnityEngine.UI.Text").text=info.name
	print("--是否新服",info.new~=0)
	LuaHelper.FindChild(obj,"img_new_area"):SetActive(info.new~=0)
	-- obj:GetComponent("UnityEngine.UI.Toggle").isOn=info.new~=0	--是否选中
	print("--区服状态",info.state)
	local state = info.state --: integer      #状态，对应enum.SERVER_STATUS
	self:set_ico(LuaHelper.FindChildComponent(obj,"img_area_state",UnityEngine_UI_Image),"tipbg_0"..state);
	local roleinfo=self.item_obj:get_role(info.code)
	local bg = LuaHelper.FindChild(obj,"img_head_bg")
	local img = LuaHelper.FindChildComponent(obj,"img_head",UnityEngine_UI_Image)
	local lv = LuaHelper.FindChildComponent(obj,"text_lv","UnityEngine.UI.Text")
	if(roleinfo)then
		print("--人物等级")
		lv.text=roleinfo.level
		print("--人物头像")
		-- gf_print_table(roleinfo,"人物信息")
		gf_set_head_ico(img,roleinfo.head);
		bg:SetActive(true)
	else
		bg:SetActive(false)
	end
	obj:SetActive(true)	
end

--单击
function SelectServiceAreaView:on_click(item_obj,obj,arg)
	print("单击",obj,obj.transform:GetSiblingIndex(),arg)
	if(self.btn_ing)then return else self.btn_ing=true end
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	local cmm = not Seven.PublicFun.IsNull(arg) and arg.name or nil
	if(cmd=="btn_cancle")then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		--返回登录界面
		self:hide()
	elseif(cmm=="toggle_select_big_area")then
		if cmm == cmd then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		end
		if(arg:GetComponent("UnityEngine.UI.Toggle").isOn)then
			-- print("选择大区开关")
			self:on_click_select_big_area(arg)
		end
	elseif(cmm=="toggle_select_area")then
		if cmm == cmd then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		end
		if(arg:GetComponent("UnityEngine.UI.Toggle").isOn)then
			-- print("选区开关")
			self:on_click_select_area(arg)
		end
	end
	
	self.btn_ing=false
end

--选择大区
function SelectServiceAreaView:on_click_select_big_area(arg)
	local index = type(arg)=="number" and arg or arg.transform:GetSiblingIndex()
	print("选择大区",index)
	if(index==0)then
		-- print("--点击已有角色按钮")
		self.current_select_area=index
		self.role_scroll_tf.gameObject:SetActive(true)
		self.area_scroll_tf.gameObject:SetActive(false)
		self:init_character_area()
	elseif(index==1)then
		-- print("--点击推荐按钮")
			self.current_select_area=index
			self.role_scroll_tf.gameObject:SetActive(false)
			self.area_scroll_tf.gameObject:SetActive(true)
		self:init_recommend_area()
	else
		-- print("--点击普通区服按钮")
			self.current_select_area=index
			self.role_scroll_tf.gameObject:SetActive(false)
			self.area_scroll_tf.gameObject:SetActive(true)
		-- print("初始化列表")
		self:init_right_list(arg,index)	
	end
end

function SelectServiceAreaView:on_click_select_area(arg)
	self.item_obj.select_area = tonumber(arg.transform:GetChild(0).name) --选择的区服
	self.main_ui.ui_array.loginChannelView:set_select_area(self.item_obj.select_area)
	-- print("选择的区服 字段= self.item_obj.select_area 区服=",self.item_obj.select_area)
end

function SelectServiceAreaView:clear()
	self.btn_ing = false
end

 function SelectServiceAreaView:on_showed()
 	if self.init then
		if(self:get_user_character_count()>0)then
			--打开已有角色开关
			local obj = self.content_select_big_area_tf:GetChild(0).gameObject
			LuaHelper.eventSystemCurrentSelectedGameObject = obj
			LuaHelper.GetComponentInChildren(obj,"UnityEngine.UI.Toggle").isOn=true
			self.select_have_character=true--选择已有角色=true
			self.current_select_area=0--当前选择的是已有角色
			self.area_scroll_tf.gameObject:SetActive(false)
			self:on_click_select_big_area(0)
			self:init_character_area()
		else
			--打开推荐开关
			local obj = self.content_select_big_area_tf:GetChild(1).gameObject
			LuaHelper.eventSystemCurrentSelectedGameObject = obj
			LuaHelper.GetComponentInChildren(obj,"UnityEngine.UI.Toggle").isOn=true
			self.select_have_character=false--选择已有角色=false
			self.current_select_area=1--当前选择的是推荐
			self.role_scroll_tf.gameObject:SetActive(false)
			self:on_click_select_big_area(1)
			self:init_recommend_area()
		end
	end
	self.active=true
 end

function SelectServiceAreaView:on_hided()
	self.active=false
end

-- 释放资源
function SelectServiceAreaView:dispose()
	self.init = nil
	self.icos = nil
    self._base.dispose(self)
 end

return SelectServiceAreaView

