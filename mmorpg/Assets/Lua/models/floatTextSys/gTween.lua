--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-20 09:08:10
--]]

local GTween = class(function(self)
	self:init()
	end)

--初始化
function GTween:init()
	--初始不启用
	self.enabled=false
end
--[[	{	对象=obj
	属性名=obj_attribute	从=from	到=to ← 不可空
	每秒变化值=change_value/时间=time	←可选（必选一）
	判断属性名=judge_attribute	推迟的秒数=delay	次数=count	间隔=interval	模式=mode	← 可空
	条件方法=condition_fun	结束方法=end_fun	← 可空
	当前等待时间=cur_delay	当前值=cur_value	当前次数=cur_count	←	空（自动）
		}		]]
GTween.action_mode = { once=1, loop=2, pingpong=3, offAndOn=4}	--行为模式 枚举 1单次 2循环 3兵乓 4断续

-- 增加行为 *对象 *属性名 *从 *到 ~每秒变化值~执行时间 #判断属性名 #延迟时间 #执行次数 #执行间隔 #执行模式 #自定义条件方法 #结束方法
function GTween:add_action(obj,att,from,to,change,time,judge,delay,count,interval,mode,condition_fun,end_fun)
	--如果每秒变化值为空，根据时间计算出来
	change=change or self:calculate_changevalue_with_time(from,to,time,judge)
	if(obj and att and from and to and change)then
		delay=delay or 0
		interval=interval or 0
		mode=mode or 1
		--初始化行为
		local item={
		obj=obj,
		obj_attribute=att,
		from=from,
		to=to,
		change_value=change,
		time=time,
		judge_attribute=judge,
		delay=delay,
		count=count,
		interval=interval,
		mode=mode,
		cur_delay=0,
		cur_value=from,
		cur_count=0,
		condition_fun=condition_fun,
		end_fun=end_fun
		}
		--如果脚本未启用，则启用
		if(not self.enabled)then
			self.enabled=true
			self.timer=0
			-- print("gTween注册每帧事件")
			--行为表
			self.action_table={}
		end
		--将行为插入行为表
		self.action_table[#self.action_table+1]=item
		--重设位置
		self:init_action(#self.action_table)
		--print("添加一个行为，当前行为数量：",#self.action_table)
	end
end

--根据持续时间计算每秒变化值
function GTween:calculate_changevalue_with_time(from,to,time,judge)
	if(time)then
		return (to-from)/time
	end
end

--每帧事件
function GTween:on_update(dt)
	if #self.action_table >0 then
		self:action_update(dt)
	end
end

--行为更新
function GTween:action_update(dt)
	--print("行为更新")
	for i=#self.action_table,1,-1 do
		local v = self.action_table[i]
		if(self.action_table[i] and self.action_table[i].obj)then --对象必须存在 否则清除行为
		--判断是否到达
			if( self.action_table[i].condition_fun and self.action_table[i].condition_fun() or self:is_get_to(i))then --自定义条件优先判断
				--到达
				self:get_to_action_with_mode(i)
			else
				--未到达
				if(self.action_table[i].cur_delay>=self.action_table[i].delay)then	--判断延迟时间
					--执行行为
					self:on_action(dt,i)
				else
					--累加时间
					self.action_table[i].cur_delay=self.action_table[i].cur_delay+dt
				end
			end
		else
			self:remove_action(i)
		end
	end
end

--到达 根据模式 行动
function GTween:get_to_action_with_mode(i)
	--print("到达 根据模式 行动")
	if(self.action_table[i] and self.action_table[i].count)then --有规定次数
		self.action_table[i].cur_count=self.action_table[i].cur_count+1 --当前次数+1
		if(self.action_table[i].cur_count>=self.action_table[i].count)then --如果次数大于等于规定值，删除此项
			self:remove_action(i)
			return
		end
	end
	--判断模式
	if(self.action_table[i] and self.action_table[i].mode==self.action_mode.loop)then
		--循环：初始化当前值
		--print("循环模式")
		self.action_table[i].cur_value=self.action_table[i].from -- 当前值=从
	elseif(self.action_table[i] and self.action_table[i].mode==self.action_mode.pingpong)then
		--来回：调换from to
		--print("乒乓模式")
		self.action_table[i].to,self.action_table[i].from=self.action_table[i].from,self.action_table[i].to
		self.action_table[i].change_value=-self.action_table[i].change_value
		self.action_table[i].cur_value=self.action_table[i].from -- 当前值=从
	elseif(self.action_table[i] and self.action_table[i].mode==self.action_mode.offAndOn)then
		--断断续续：from,to=to,to+to-from
		--print("断续模式")
		local dis=self.action_table[i].to-self.action_table[i].from,to
		self.action_table[i].from,self.action_table[i].to=self.action_table[i].to,self.action_table[i].to+dis
		self.action_table[i].cur_value=self.action_table[i].from -- 当前值=从
	elseif(self.action_table[i] and self.action_table[i].mode==self.action_mode.once)then
		--单次：判断次数
		--print("单次模式")
		if(not self.action_table[i].count)then --没有规定次数，直接删除本条
			self:remove_action(i)
			return
		else
			self.action_table[i].cur_value=self.action_table[i].from -- 当前值=从
		end
	end
	--重置初始属性
	if(self.action_table[i] and self.action_table[i].interval)then	--有间隔时间
		self.action_table[i].cur_delay=0	--当前等待时间归零
		self.action_table[i].delay=self.action_table[i].interval	--设置等待时间
	end
	if(self.action_table[i])then	--如果不为空，恢复初始位置
		--重设位置
		self:init_action(i)
	end
end

--删除行为
function GTween:remove_action(index)
	--print("删除行为")
	if(self.action_table[index])then
		--print("结束方法：",self.action_table[index].end_fun)
		if(self.action_table[index].end_fun)then
			self.action_table[index].end_fun()
			--print("执行结束方法")
		end
		table.remove(self.action_table,index) 
	end
end

--判断是否到达
function GTween:is_get_to(i)
	--print("判断抵达")
	local jud_att=self.action_table[i].judge_attribute	--自定义对比属性
	if(jud_att)then --有自定义对比属性的
		if((self.action_table[i].cur_value[jud_att]>self.action_table[i].to[jud_att] and self.action_table[i].cur_value[jud_att]>self.action_table[i].from[jud_att]) or 
			(self.action_table[i].cur_value[jud_att]<self.action_table[i].to[jud_att] and self.action_table[i].cur_value[jud_att]<self.action_table[i].from[jud_att]))then
			--print("判定到达了")
			return true
		end
	else --没自定义对比属性的
		if(self.action_table[i].cur_value>self.action_table[i].to and self.action_table[i].cur_value>self.action_table[i].from or
			self.action_table[i].cur_value<self.action_table[i].to and self.action_table[i].cur_value<self.action_table[i].from)then
			--print("判定到达了")
			return true
		end
	end
end

--行动	执行行为
function GTween:on_action(dt,i)
	--print("执行行为")
	local change_value=0
	--print(type(self.action_table[i].change_value))
	if(type(self.action_table[i].change_value)=="function")then
		--print("使用自定义方法计算变化值")
		change_value=self.action_table[i].change_value(dt,self.action_table[i])
		--print(change_value,type(change_value))
	else
		change_value=self.action_table[i].change_value
		change_value=change_value*dt
	end
	--print("这一帧变化值",change_value)
	self.action_table[i].cur_value=self.action_table[i].cur_value+change_value	--计算当前值
	self.action_table[i].obj[self.action_table[i].obj_attribute]=self.action_table[i].cur_value	--设置obj
end

-- 初始化行动
function GTween:init_action(i)
	--print("初始化行动")
	self.action_table[i].cur_value=self.action_table[i].from --设置初始值
	self.action_table[i].obj[self.action_table[i].obj_attribute]=self.action_table[i].cur_value --设置obj
end

function GTween:dispose()
	if self.enabled then
		self.enabled=nil
		self.timer=nil
		self.action_table=nil
	end
end

return GTween
