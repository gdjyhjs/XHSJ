--[[--
-- 新手引导遮罩
-- @Author:Seven
-- @DateTime:2017-05-31 10:59:21
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FontSize = 25

local GuideMask=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "guide.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function GuideMask:on_asset_load(key,asset)
	self:init_ui()
	self.item_obj:register_event("guide_on_click", handler(self, self.on_click))
end

function GuideMask:on_showed()
	self:init_ui()
	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(false)
	local guide_data = self.item_obj:get_data()
	self.ty = guide_data.btn_place
	self.refer:Get("mask"):SetActive(true)
	-- self.schedule_click = Schedule(handler(self, function()
	-- 	self.schedule_click:stop()
	-- 	self.schedule_click = nil
	-- 	self.refer:Get("mask"):SetActive(false)
	-- end), 1)
	self:init_guide_pos()
	if self.ty ~= 3 then
 		self:set_content(guide_data.disc)
 	end
	self.oc_time = 0
end

function GuideMask:on_hided()
	-- self.refer:Get("mask"):SetActive(true)
end

function GuideMask:on_click(item_obj,obj,arg)
	if  self.item_obj.current_guide and string.find(obj.name, self.item_obj.guide_name) then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- if self.schedule_click then return end
		if obj.name == "gd_background" then return end
		self.item_obj.current_guide = false
		self.item_obj:cancel_hightlight(obj)
	end
end

function GuideMask:init_ui()
	if self.is_init then
		return
	end
	self.is_init = true
	self.refer:Get("mask"):SetActive(true)
	self.left = self.refer:Get("left")
	self.right = self.refer:Get("right")
	self.up = self.refer:Get("up")
	self.left_content = self.refer:Get("left_content")
	self.right_content = self.refer:Get("right_content")

	self.left_rt = self.refer:Get("left_rt")
	self.right_rt = self.refer:Get("right_rt")

	self.left_arrows = self.refer:Get("left_arrows")
	self.right_arrows = self.refer:Get("right_arrows")

	self.btn_background = self.refer:Get("btn_background")
	self.gd_background = self.refer:Get("gd_background")

	self.left_width = 347   -- 原始宽度
	self.right_width = 347 -- 原始宽度

	self.content_left_width = 143   -- 原始宽度
	self.content_right_width = 143 -- 原始宽度
	-- self.touch = self.refer:Get("touch_up")
	-- self.touch.onFingerMoveUpFn = handler(self, self.on_finger_move_up)
end

-- 初始指引位置
function GuideMask:init_guide_pos()
	local ty = self.ty
	local guide_data = self.item_obj:get_data()
	local pos = self.item_obj:get_canvas_pos()
	-- print("Canvas坐标",pos)
	if ty == 1 then     -- 左边
		self.right:SetActive(false)
		self.left:SetActive(true)
		self.up:SetActive(false)
		self.left_rt.anchoredPosition = pos
		self.left_arrows.localRotation=Quaternion.Euler(0,0,guide_data.guide_r) 

	elseif ty == 2 then -- 右边
		self.left:SetActive(false)
		self.right:SetActive(true)
		self.up:SetActive(false)
		self.right_rt.anchoredPosition = pos
		self.right_arrows.localRotation=Quaternion.Euler(0,0,guide_data.guide_r)
	elseif ty == 3 then
	 	self.left:SetActive(false)
		self.right:SetActive(false)
		self.up:SetActive(true)
	end
	
	if guide_data.view_ty == 1 then --视图类型
		self.gd_background:SetActive(false)
		self.btn_background:SetActive(true)
	elseif guide_data.view_ty == 2 then
		self.gd_background:SetActive(true)
		self.btn_background:SetActive(true)
	elseif guide_data.view_ty == 3 then --视图类型
		self.gd_background:SetActive(false)
		self.btn_background:SetActive(false)
	else
		self.btn_background:SetActive(false)
		self.gd_background:SetActive(true)
	end
end

function GuideMask:set_content( content )
	print("set_content",content,self.ty)

	local t1,t2 = self:get_guide_txt(content)
	self:auto_fit(t1)

	local ty = self.ty
	local txt = t1..t2
	if ty == 1 then     -- 左边
		self.left_content.text = txt or ""

	elseif ty == 2 then -- 右边
		self.right_content.text = txt or ""
	end
	
end


-- 自动适配宽度
function GuideMask:auto_fit( content, ty )
	local _,_,len = gf_string_to_chars(content, FontSize)
	local tr
	local o_width
	local content_rt
	local o_content_w
	local pos

	if self.ty == 1 then
		tr = self.left_rt
		o_width = self.left_width
		o_content_w = self.content_left_width

		content_rt = self.refer:Get("left_content_rt")

	elseif self.ty == 2 then
		
		tr = self.right_rt
		o_width = self.right_width
		o_content_w = self.content_right_width
		content_rt = self.refer:Get("right_content_rt")

	end

	local dw = 0
	if len > 8 then -- 原始的最多是4个字符
		dw = (len-8)*FontSize*0.5
		
		tr.sizeDelta = Vector2(o_width+dw, tr.rect.height)
		content_rt.sizeDelta = Vector2(o_content_w+dw, content_rt.rect.height)

	else
		dw = o_width - tr.rect.width
		tr.sizeDelta = Vector2(o_width, tr.rect.height)
		content_rt.sizeDelta = Vector2(o_content_w, content_rt.rect.height)
	end

	if self.ty == 1 then
		pos = tr.anchoredPosition
		pos.x = pos.x + (tr.rect.width*0.5+180)
	elseif self.ty == 2 then
		pos = tr.anchoredPosition
		pos.x = pos.x - (tr.rect.width*0.5+160)
	end

	tr.anchoredPosition = pos
end

--提示对话框文字长度分配文字
function GuideMask:get_guide_txt(txt)
    local _, count = string.gsub(txt, "[^\128-\193]", "")
    print("提示对话框文字长度",count)
    if count>12 then
		local isdouble =count % 2
		print("提示对话框文字isdouble",isdouble)
		local txt1 = ""
		local txt2 = ""
		if isdouble == 0 then
			txt1 = self:SubStringUTF8(txt,1,count*0.5)
			txt2 = self:SubStringUTF8(txt,count*0.5+1)
		else
			local a = (count-1)*0.5
			txt1 = self:SubStringUTF8(txt,1,a+1)
			txt2 = self:SubStringUTF8(txt,a+2)
		end
		return txt1,txt2
	else
		return txt,""
	end
end

--截取中英混合的UTF8字符串，endIndex可缺省
function GuideMask:SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex =self:SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = self:SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, self:SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, self:SubStringGetTrueIndex(str, startIndex), self:SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end

--获取中英混合UTF8字符串的真实字符数量
function GuideMask:SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = self:SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function GuideMask:SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = self:SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function GuideMask:SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end


-- 释放资源
function GuideMask:dispose()
    self._base.dispose(self)
    self.item_obj:register_event("guide_on_click", nil)
 end

return GuideMask

