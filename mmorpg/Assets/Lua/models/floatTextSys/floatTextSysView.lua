--[[--
--飘字系统界面
-- @Author:HuangJunShan
-- @DateTime:2017-04-12 16:00:45
--]]

local LuaHelper = LuaHelper
local Vector2 = UnityEngine.Vector2
local Screen=UnityEngine.Screen
local Time=UnityEngine.Time
local gTween = require("models.floatTextSys.gTween")
local lb_time_interval=0.34	--左下边弹出消息的事件间隔
local sys_tishi_interval=1.5	--相同的系统提示时间间隔
local Enum = require("enum.enum")

local FloatTextSysView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "float_text_sys.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj


	self.leftbottom_message_cache={}
	self.item_cache = {}
	self.epinasty_cache = {}
end)

local a=Vector2(-100,40)
local b=Vector2(0,100)
FloatTextSysView.bft_type =
{
	[Enum.SKILL_RESULT.NORMAL] = "putong",
	[Enum.SKILL_RESULT.CRIT] = "baoji",
	[Enum.SKILL_RESULT.DODGE] = "shanbi",
	[Enum.SKILL_RESULT.BLOCK] ="gedang",
	[5]="wudi",
	[6]="mianyi",
	[7]="shoushang",
	[8]="zhiliao",
	[9]="jingyan",
}

FloatTextSysView.btf_direction = 
{
	["putong"]    = a,
	["baoji"]     = a,
	["shanbi"]    = a,
	["gedang"]    = a,
	["wudi"]      = b,
	["mianyi"]    = b,
	["shoushang"] = a,
	["zhiliao"]   = a,
	["jingyan"]   = b,
}

-- 资源加载完成
function FloatTextSysView:on_asset_load(key,asset)
	--ui初始化
	self:init_ui()
	--初始化gTween
	self.gTween=gTween(self)
	gf_register_update(self) --注册每帧事件
	print("飘字系统初始化完毕")
end
--gTween
-- *对象 *属性名 *从 *到 ~每秒变化值~执行时间 #判断属性名 #延迟时间 #执行次数 #执行间隔 #执行模式

--初始化ui
function FloatTextSysView:init_ui()
	--获取中上飘字文本对象
	self.epinasty={}
	self.epinasty.tf=LuaHelper.FindChild(self.root,"text_epinasty").transform
	self.epinasty.text=LuaHelper.GetComponent(self.epinasty.tf.gameObject,"UnityEngine.UI.Text")
	print(self.epinasty.tf)
	self.epinasty.bg=LuaHelper.GetComponent(self.epinasty.tf.parent.parent.gameObject,"UnityEngine.CanvasGroup")
	self.epinasty.bg.alpha=0
	--获取下面飘字文本对象
	self.bottom_cache={}
	self.bottom_cache.tf=LuaHelper.FindChild(self.root,"text_bottom").transform
	self.bottom_cache.text=LuaHelper.GetComponent(self.bottom_cache.tf.gameObject,"UnityEngine.UI.Text")
	self.bottom_cache.bg=LuaHelper.GetComponent(self.bottom_cache.tf.parent.gameObject,"UnityEngine.CanvasGroup")
	self.bottom_cache.bg.alpha=0
	--飘字缓存初始化
	self.bft_cache={}
	--左下飘字缓存
	self.bft_cache[0]={}
	self.bft_cache[0].template=self.refer:Get("img_item")
	self.bft_cache[0].useing={}
	self.bft_cache[0].can_use={}

	-- 进入战斗状态飘字
	self.bft_cache[100]={}
	self.bft_cache[100].template=self.refer:Get("battle_flag_in_item")
	self.bft_cache[100].useing={}
	self.bft_cache[100].can_use={}

	-- 退出战斗状态飘字
	self.bft_cache[101]={}
	self.bft_cache[101].template=self.refer:Get("battle_flag_out_item")
	self.bft_cache[101].useing={}
	self.bft_cache[101].can_use={}

	--战斗飘字缓存
	for i,v in ipairs(self.bft_type) do
		self.bft_cache[v]={}
		self.bft_cache[v].template=LuaHelper.FindChild(self.root,v)
		self.bft_cache[v].useing={}
		self.bft_cache[v].can_use={}
	end
	--系统提示飘字初始化
	self.bft_cache.tishi={}
	self.bft_cache.tishi.template=LuaHelper.FindChild(self.root,"tishi")
	self.bft_cache.tishi.useing={}
	self.bft_cache.tishi.can_use={}


	self.item_fly_alpha = self.refer:Get("item_fly")
	self.item_fly_tf = self.item_fly_alpha.transform
	self.item_fly_bg = self.item_fly_tf:Find("bg"):GetComponent(UnityEngine_UI_Image)
	self.item_fly_icon = self.item_fly_tf:Find("icon"):GetComponent(UnityEngine_UI_Image)
	self.item_fly_time = 0
	self.item_fly_target = self.item_fly_tf.position
	print(self.item_fly_tf,self.item_fly_alpha,self.item_fly_bg,self.item_fly_icon)

	self.ft_canvas_tf2 = self.refer:Get("ft_canvas_tf2")
end

--设置偏上方广播(content内容string,interval间隔number,count次数integer,all_time(如果没有count，有 all_time，会自动计算count))
function FloatTextSysView:set_epinasty_broadcast(content,count,interval,delay,all_time)
	--判断是否做行动中
	if(self.epinasty.activating)then
		self.epinasty_cache[#self.epinasty_cache+1] = {content=content,count=count,interval=interval,delay=delay,all_time=all_time}
		return
	end
	local function is_get_to()
		return self.epinasty.tf.offsetMin.x<-Screen.width-self.epinasty.tf.sizeDelta.x
	end
	local function epinasty_end_fun()
		self.epinasty.tf.offsetMin=Vector2(0,-15)	--初始化位置
		self.epinasty.activating=nil
		self.epinasty.bg.alpha=0	--隐藏背景
		if self.epinasty_cache and #self.epinasty_cache>1 then
			local data = self.epinasty_cache[1]
			table.remove(self.epinasty_cache,1)
			self:set_epinasty_broadcast(data.content,data.count,data.interval,data.delay,data.all_time)
		end
	end
	content = content or ""
	self.epinasty.text.text=content or "" --设置文本内容
	local width = LuaHelper.GetStringWidth(gf_remove_rich_text(content),self.epinasty.text)
	print("内容宽度",width)
	interval = interval or 0
	delay = delay or 0
	if not count and all_time then
		count = math.ceil(all_time/(width/80+interval))
	elseif not count then
		count = 1
	end
	self.epinasty.activating=true
	self.epinasty.bg.alpha=1	--显示背景
	self.gTween:add_action(self.epinasty.tf	--对象
		,"offsetMin"	--变化的属性
		,Vector2(0,-15)	--从哪个属性开始
		,Vector2(-800-width ,-15)	--变化到哪个属性
		,Vector2(-80,0)	--每秒变化的值
		,nil		--一次运行几秒
		,"x"	--判断值属性
		,delay	--延迟时间
		,count		--次数
		,interval		--间隔时间
		,1		--模式
		,is_get_to	--条件方法
		,epinasty_end_fun	--结束方法
		)
end

--设置下面的广播
function FloatTextSysView:set_bottom_broadcast(content,interval,delay)
	local function is_get_to()
		return self.bottom_cache.tf.localPosition.y>15
	end
	--判断这个对象有没有在行为表里
	local function bottom_end_fun()
		self.bottom_cache.tf.localPosition=Vector2(0,-15)	--初始化位置
		self.bottom_cache.activating=nil
		self.bottom_cache.bg.alpha=0	--隐藏背景
	end
	if(self.bottom_cache.activating)then
		return
	end
	self.bottom_cache.text.text=content or ""
	interval=interval or 4
	delay=delay or 0
	self.bottom_cache.activating=true
	self.bottom_cache.bg.alpha=1	--显示背景
	self.gTween:add_action(self.bottom_cache.tf
		,"localPosition"
		,Vector2(0,-15)
		,Vector2(0,15)
		,Vector2(0,60)
		,nil
		,"y"
		,delay		--延迟时间
		,2		--次数
		,interval	--间隔时间
		,1		--模式
		,nil
		,bottom_end_fun
		)
end

--添加左下的广播
function FloatTextSysView:add_leftbottom_broadcast(content, ty)
	ty = ty or 0 -- 默认是普通飘字
	self.leftbottom_message_cache[#self.leftbottom_message_cache+1]= {content = content, ty = ty}
end

--设置左下边的广播
function FloatTextSysView:set_leftbottom_broadcast(data)
	--获取可用的模板
	local ty = data.ty
	local item = self:get_battle_float_text_template(ty)
	item.text.text= data.content or ""
	item.alpha.alpha=1
	--print("~~~~~~~~~%%%%%%%%%",item.tf,item.text)
	local function lb_end_fun()
		if(self.bft_cache[ty].useing[1])then
			self.bft_cache[ty].can_use[#self.bft_cache[ty].can_use+1]=self.bft_cache[ty].useing[1]
			table.remove(self.bft_cache[ty].useing,1)
			item.alpha.alpha=0
		end
	end
	self.gTween:add_action(item.tf
		,"localPosition"
		,Vector2(0,-100)
		,Vector2(0,200)
		,Vector2(0,100)
		,nil
		,"y"
		,nil
		,nil
		,nil
		,nil
		,nil
		,lb_end_fun
		)
	self.gTween:add_action(item.alpha
		,"alpha"
		,1
		,0
		,-2
		,nil
		,nil
		,1
		)
end

--每帧事件
function FloatTextSysView:on_update(dt)
	if(#self.leftbottom_message_cache>0)then
		if(not self.leftbottom_message_cache.last_time or self.leftbottom_message_cache.last_time<UnityEngine.Time.time-lb_time_interval)then
			--通知发出消息
			self.leftbottom_message_cache.last_time=UnityEngine.Time.time --记录时间点
			--发出消息
			self:set_leftbottom_broadcast(self.leftbottom_message_cache[1])
			--删除消息缓存
			table.remove(self.leftbottom_message_cache,1)
		end
	end
	if #self.item_cache>0 then
		if UnityEngine.Time.time-self.item_fly_time>0.5 then
			self.item_fly_time = UnityEngine.Time.time
			self:fly_item()
		end
	end

	if self.gTween.enabled then
		self.gTween.on_update(self.gTween,dt)
	end
end

--设置自由飘字	内容，从哪，到哪
function FloatTextSysView:set_freedom_float_text(obj,att,from,to,change,time,judge,delay,count,interval,mode,condition_fun,end_fun)
	self.gTween:add_action(obj,att,from,to,change,time,judge,delay,count,interval,mode,condition_fun,end_fun)
end

--战斗飘字 int FloatTextSysView.bft_type Vector2
function FloatTextSysView:battle_float_text(target_tf,btf_type,number)
	print("传入飘字类型",target_tf,btf_type,number)
	if btf_type==nil then
		print("--------------注意，传入了空的战斗飘字类型，已默认设为普通",target_tf,number,btf_type)
		btf_type=self.bft_type[Enum.SKILL_RESULT.NORMAL]
	elseif type(btf_type)=="number" then
		btf_type=self.bft_type[btf_type]
	end
	print("飘字类型",btf_type,"数值",number)
	local dir=self.btf_direction[btf_type]
	local item = self:get_battle_float_text_template(btf_type)	--获取模板
	if not item then print("没有战斗飘字模板") return end --要有模板才可以
	if(number and btf_type~="shanbi" and btf_type~="wudi" and btf_type~="mianyi")then
		item.text.text="+"..number	--设置数值
	end

	item.float_text.target = target_tf
	item.float_text.end_fun = function() 
			if(self.bft_cache[btf_type].useing[1])then
				self.bft_cache[btf_type].can_use[#self.bft_cache[btf_type].can_use+1]=self.bft_cache[btf_type].useing[1]
				table.remove(self.bft_cache[btf_type].useing,1)
			end
		end
	item.obj:SetActive(true)

	
	--item.point=Vector2(math.random(-35,35),math.random(-35,35)) --飘字起始位置需要做一个随机值 即x，y值均随机+-15个像素
	--item.tf.localPosition=item.point--设置初始位置
	-- item.alpha.alpha=1	--设置透明度
	-- item.speed=dir.x==0 and dir or Vector2(dir.x,dir.y*10)
	-- item.time=Time.time
	-- local pos= target_tf and target_tf.position or Vector3(-10000,-10000,0)
	-- local function bft_change_value_fun(dt,action)
	-- 	pos = ((not tostring(target_tf)=="null") or (not target_tf==nil)) and target_tf.position or pos
	-- 	local mainCamera = UnityEngine.Camera.main
	-- 	local p=mainCamera and mainCamera:WorldToScreenPoint(pos+Vector3(0,3.5,0))/(UnityEngine.Screen.height/720) or Vector3(-10000,-10000,0)
	-- 	item.speed=dir.x==0 and item.speed or Vector2(item.speed.x,item.speed.y-dir.y*dt*15)
	-- 	item.point=item.point+item.speed*dt
	-- 	item.tf.localPosition=item.point+Vector2(p.x,p.y)
	-- 	item.tf.localPosition=p
	-- 	local value = -1/1*dt
	-- 	if value>0 then value=value+0.5 end
	-- 	return value
	-- end

	-- local function bft_ok_fun()
	-- 	return item.tf.localPosition.x<=end_point.x and item.tf.localPosition.y>=end_point.y
	-- end

	-- local function bft_end_fun()
	-- 	if(self.bft_cache[btf_type].useing[1])then
	-- 		self.bft_cache[btf_type].can_use[#self.bft_cache[btf_type].can_use+1]=self.bft_cache[btf_type].useing[1]
	-- 		table.remove(self.bft_cache[btf_type].useing,1)
	-- 	end
	-- end
	-- self.gTween:add_action(item.alpha
	-- 	,"alpha"
	-- 	,1
	-- 	,0
	-- 	,bft_change_value_fun
	-- 	,nil
	-- 	,nil
	-- 	,0
	-- 	,nil
	-- 	,nil
	-- 	,nil
	-- 	,nil
	-- 	,bft_end_fun	--结束方法
	-- 	)
end

--系统提示
function FloatTextSysView:sys_tishi(content,point)
	if not self.bft_cache then return end
	local function tishi_end_fun()
		if(self.bft_cache.tishi.useing[1])then
			self.bft_cache.tishi.can_use[#self.bft_cache.tishi.can_use+1]=self.bft_cache.tishi.useing[1]
			table.remove(self.bft_cache.tishi.useing,1)
		end
	end
	if(self.last_content and self.last_content==content and self.last_time and self.last_time+sys_tishi_interval>Time.time)then
		return
	end
	self.last_time=Time.time
	self.last_content=content
	--获取可用的模板
	local item = self:get_battle_float_text_template("tishi")
	item.text.text=content or ""
	item.alpha.alpha=1
	item.tf.localPosition=point
	self.gTween:add_action(item.tf
		,"localPosition"
		,point
		,point+Vector2(0,300)
		,nil
		,4
		,"y"
		,nil
		,nil
		,nil
		,nil
		,nil
		,tishi_end_fun
		)
	self.gTween:add_action(
		item.alpha,
		"alpha",
		1,
		0,
		nil,
		4,
		nil,
		0.2
		)
end

--获取战斗飘字模板
function FloatTextSysView:get_battle_float_text_template(t)
	-- print("获取战斗模板",t)
	if not self.bft_cache then return end
	if not self.bft_cache[t] then return end
	if not self.bft_cache[t].can_use then return end
	if(#(self.bft_cache[t].can_use)>0)then
		-- print("有可用的，直接给予")
		self.bft_cache[t].useing[#self.bft_cache[t].useing+1]=self.bft_cache[t].can_use[#self.bft_cache[t].can_use]
		table.remove(self.bft_cache[t].can_use,#self.bft_cache[t].can_use)
		self.bft_cache[t].useing[#self.bft_cache[t].useing].tf:SetAsLastSibling()
		return self.bft_cache[t].useing[#self.bft_cache[t].useing]
	end
	-- print("没有可用的。创建可用的。然后给予,样本：",self.bft_cache[t].template)
	local item = {}
	local obj = LuaHelper.InstantiateLocal(self.bft_cache[t].template,self.bft_cache[t].template.transform.parent.gameObject)
	item.obj = obj
	item.tf = obj.transform
	item.text =LuaHelper.GetComponentInChildren(obj,"UnityEngine.UI.Text")
	item.alpha = LuaHelper.GetComponentInChildren(obj,"UnityEngine.CanvasGroup")
	item.float_text = LuaHelper.GetComponentInChildren(obj,"Seven.FloatText")
	self.bft_cache[t].useing[#self.bft_cache[t].useing+1] = item
	return item
end

-- 添加一个获得物品飘飞
function FloatTextSysView:add_get_item(protoId,Vector3_pos,color)
	print("添加一个获得物品飘飞",self.item_fly_alpha)
	if not Vector3_pos then
		local size = self.ft_canvas_tf2.sizeDelta
		Vector3_pos = Vector3(size.x/2*self.ft_canvas_tf2.localScale.x,size.y/2*self.ft_canvas_tf2.localScale.y,0)
	end
	self.item_cache[#self.item_cache+1] = {protoId=protoId,pos=Vector3_pos,color =color}
end

-- 飘飞一个物品
function FloatTextSysView:fly_item()
	print("飘飞一个物品",self.item_fly_alpha)
	local fly_data = self.item_cache[1]
	table.remove(self.item_cache,1)
	self.item_fly_tf.position = fly_data.pos
	gf_set_item(fly_data.protoId,self.item_fly_icon,self.item_fly_bg,fly_data.color)

	local fun = function(data)
		gf_print_table(data,"变")
		self.item_fly_tf.position = fly_data.pos + (self.item_fly_target-fly_data.pos)*(1-self.item_fly_alpha.alpha)
		-- return self.item_fly_alpha<=0
	end
	self.gTween:add_action(self.item_fly_alpha
		,"alpha"
		,1
		,0
		,nil
		,0.5
		,nil
		,nil
		,nil
		,nil
		,nil
		,fun -- 条件方法
		)
end

function FloatTextSysView:on_showed()
	if not self.bft_cache then
		self:init_ui()
	end
end

-- 释放资源
function FloatTextSysView:dispose()
	if self.gTween then
		self.gTween:dispose()
		self.gTween = nil
	end
	gf_remove_update(self) --注销每帧事件
    self._base.dispose(self)

 end

return FloatTextSysView