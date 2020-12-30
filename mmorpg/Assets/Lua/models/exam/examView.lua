--[[--
--答题
-- @Author:Seven
-- @DateTime:2017-07-31 09:14:21
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ExamView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "exam.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function ExamView:on_asset_load(key,asset)
	local r_id = LuaItemManager:get_item_obejct("game").role_id
	if r_id ~= self.item_obj.player_id then
		self.item_obj:init()
	end
	self:register()
	self.answer_over=true--当前题目完成
	if self.item_obj.exam_id ~=0 then
		self:init_ui()
	else
		LuaItemManager:get_item_obejct("exam"):get_question_info_c2s()
	end
end

function ExamView:init_ui()
	if self.item_obj.exam_over then
		self:finish_exam()
		return
	end
	self:exam_add_time()
	self:set_exam_txt(self.item_obj.exam_id)
	self:get_exam_resource()
	self:answer_true_num(self.item_obj.answer_true)
end

function ExamView:register()
	self.item_obj:register_event("Exam_view_on_click",handler(self,self.on_click))
end

function ExamView:on_click(item_obj,obj,arg)
	local  cmd = obj.name
	print("答题cmd",cmd)
	if cmd == "answer1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_answer(1)
	elseif cmd == "answer2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_answer(2)
	elseif cmd == "answer3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_answer(3)
	elseif cmd == "answer4" then	
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_answer(4)	
	elseif cmd == "btn_ranking" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_create_model_view("rank",ServerEnum.RANKING_TYPE.QUESTION_DAILY)
	elseif cmd == "btn_exam_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end
--选择的题目
function ExamView:select_answer(num)
	if self.answer_over then
		self.answer_over=false
	else
		return
	end
	self.item_obj:answer_question_c2s(self.item_obj.exam_id,self.answer_tb[num])
	self.current_select_num = num
end

function ExamView:exam_add_time()
	local now_time = Net:get_server_time_s()
	local s = now_time-self.item_obj.start_time
	print("答题啊",s)
	if s<0 then
		s=0
	end

	self.refer:Get("txt_time").text = gf_convert_time(s)
	if not self.math_time_exam then
		self.math_time_exam = Schedule(handler(self,self.exam_math_time),1)
	end
end
function ExamView:exam_math_time()
	local now_time = Net:get_server_time_s()
	local s = now_time-self.item_obj.start_time
	if s<0 then
		s=0
	end
	if self.item_obj.exam_over then
		self.math_time_exam:stop()
		self.math_time_exam = nil
	end
	self.refer:Get("txt_time").text = gf_convert_time(s)
end

--设置当前题目内容
function ExamView:set_exam_txt(e_id)
	self.answer_tb = {}
	local data_t = ConfigMgr:get_config("question")[e_id]
	self.refer:Get("txt_item_content").text = data_t.content
	self:answer_exam_num(self.item_obj.answer_num)
	self.answer_tb = self:getNRandom(1,4,4,{})
	local answer_select = {data_t.answer_1,data_t.answer_2,data_t.answer_3,data_t.answer_4}
	self.refer:Get("txt_answer_1").text = answer_select[self.answer_tb[1]]
	self.refer:Get("txt_answer_2").text = answer_select[self.answer_tb[2]]
	self.refer:Get("txt_answer_3").text = answer_select[self.answer_tb[3]]
	self.refer:Get("txt_answer_4").text = answer_select[self.answer_tb[4]]
end

--获得金钱和经验
function ExamView:get_exam_resource()
	self.refer:Get("txt_money").text =  self.item_obj.current_get_money
	self.refer:Get("txt_exp").text = self.item_obj.current_get_exp
	self.refer:Get("txt_fame").text = self.item_obj.current_get_fame
end

--答了几题
function ExamView:answer_exam_num(num)
	self.refer:Get("txt_number").text ="第 " .. num .."/" ..self.item_obj.exam_all_num .. " 题"
end

--答对几题
function ExamView:answer_true_num(num)
	self.refer:Get("txt_count").text  = num.."/"..self.item_obj.exam_all_num
end
--显示是否正确
function ExamView:show_exam(tf)
	local item = self.refer:Get("exam")
	local num = 0
	if tf then
		item:Get("img_answer_"..self.current_select_num):SetActive(true)
		item:Get("answer_t"..self.current_select_num):SetActive(true)
	else
		for k,v in pairs(self.answer_tb) do
		 	if v == self.item_obj.current_true_choose then
		 		num=k
		 		item:Get("img_answer_"..k):SetActive(true)
		 		item:Get("answer_f"..self.current_select_num):SetActive(true)
		 	end
		end
	end
	self.schedule_next = Schedule(handler(self, function()
		self.schedule_next:stop()
		if tf then
			item:Get("img_answer_"..self.current_select_num):SetActive(false)
			item:Get("answer_t"..self.current_select_num):SetActive(false)
		else
			item:Get("img_answer_"..num):SetActive(false)
		 	item:Get("answer_f"..self.current_select_num):SetActive(false)
		end
		if self.item_obj.exam_over then
			self:finish_exam()
			return
		end
		self:set_exam_txt(self.item_obj.exam_id)
		self.answer_over=true
	end), 1)
end

function ExamView:finish_exam()
	self.refer:Get("exam").gameObject:SetActive(false)
	self.refer:Get("exam_result"):SetActive(true)
	local data = ConfigMgr:get_config("question_tips") 
	if self.item_obj.cost_time then
		self.refer:Get("txt_time").text = gf_convert_time(self.item_obj.cost_time)
	end
	self:answer_true_num(self.item_obj.answer_true)
	self:get_exam_resource()
	for k,v in pairs(data) do
		if	v.right_count == self.item_obj.answer_true then
			self.refer:Get("txt_award_say").text = v.tips
			return
		end
	end
end

-- 释放资源
function ExamView:dispose()
	self.item_obj:register_event("Exam_view_on_click",nil)
	if self.math_time_exam then
		self.math_time_exam:stop()
		self.math_time_exam = nil
	end
    self._base.dispose(self)
 end

function ExamView:getNRandom(startNum, endNum, number, exceptTable) -- 一个产生不重复随机数的方法
    math.randomseed(tostring(os.time()):reverse():sub(1, 7))
    local cha = endNum - startNum + 1
    if cha< number then
        print("产生的个数已经超过了，检查你的随机数范围和个数是否合理")
        return
    end
    local numberTabel = {}
    local num = 0
    local isExist = false -- 用这个判断是否已经存在这个数了
    local i = 0
    while (i < number) do 
        isExist = false
        local randomNum = math.random(startNum, endNum)
        print("产生的随机数为：", randomNum)
        local function isExisting() -- 检测数组里面是否已经存在了这个随机数了，有就返回true
            if #numberTabel ~= 0 then
                for k, v in pairs(numberTabel) do 
                    if randomNum == v then
                        print("发现产生了一个相同的随机数，所以不能再加到那里面去了")
                        return true
                    end
                end
            end
            if #exceptTable ~= 0 then
                for k, v in pairs(exceptTable) do
                    if randomNum == v then
                        print("发现产生了一个已经点过的随机数，要除开，不能要")
                        return true
                    end
                end
            end 
        end
        isExist = isExisting()
        if isExist then  -- 如果已经存在了这个数，那么久返回，并且要把i-1


        else
            table.insert(numberTabel, randomNum)
            i = i + 1
        end


    end
    return numberTabel

end

return ExamView

