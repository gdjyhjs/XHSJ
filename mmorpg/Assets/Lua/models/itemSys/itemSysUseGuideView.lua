--[[--
-- 快速使用指引
-- @Author:HuangJunShan
-- @DateTime:2017-04-08 13:40:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")


local ItemSysUseGuideView=class(UIBase,function(self,item_obj)
	self.btn_name = gf_localize_string("立即使用")
    UIBase._ctor(self, "item_sys_use_guide.u3d", item_obj) -- 资源名字全部是小写
	print("_ctor",self.init)
end)

-- 资源加载完成
function ItemSysUseGuideView:on_asset_load(key,asset)
	self.load_img_cache = {}
	self.root.name = "testView"
	print("资源加载完成 on_asset_load",self.init)
	--ui初始化
	self.init = true
	self:set_content()
end

-- 设置名称 string
function ItemSysUseGuideView:set_name(value)
	self.name = value
end

--设置图标 string
function ItemSysUseGuideView:set_icon(value)
	self.icon = value
end

--设置背景 string
function ItemSysUseGuideView:set_bg(value)
	self.bg = value
end

--设置数量 number or string
function ItemSysUseGuideView:set_count(value)
	self.count = value
end

--设置战力 number or string
function ItemSysUseGuideView:set_power(value)
	self.power = value
end

--设置特效 string
function ItemSysUseGuideView:set_eff(value)
	self.eff = value
end

--设置行动 function
function ItemSysUseGuideView:set_action(value)
	self.action = value
end

--关闭时是否自动行动 bool
function ItemSysUseGuideView:set_auto(value)
	self.auto = value
end

--按钮名字
function ItemSysUseGuideView:set_btn_name(value)
	self.btn_name = value or gf_localize_string("立即使用")
end

--设置是否使用背景按钮
function ItemSysUseGuideView:set_bg_btn_show(value)
	self.bg_btn_show = value==nil and true or value
end

--设置是否使用关闭按钮
function ItemSysUseGuideView:set_exit_btn_show(value)
	self.exit_btn_show = value==nil and true or value
end

function ItemSysUseGuideView:set_tips_name(value)
	print("set_tips_name",type(value))
	if type(value) == "string" then
		self.tips_name = value
	elseif type(value) == "function" then
		self.tips_name = "self_tips"
		self.tips_fun = value
	end
end

--初始化内容
function ItemSysUseGuideView:set_content()
	print("set_content",self.init)
	if not self.init then
		return
	end
	self.btn_name = self.btn_name or gf_localize_string("立即使用")
	self:setImageTexture(self.refer:Get("icon"),self.icon)
	self:setImageTexture(self.refer:Get("bg"),self.bg)
	self.refer:Get("name").text = self.name
	self.refer:Get("num").text = self.count
	self.refer:Get("num").gameObject:SetActive(self.count~=nil)
	self.refer:Get("power").text = self.power
	self.refer:Get("power").gameObject:SetActive(self.power~=nil)
	self.refer:Get("bg").name = self.tips_name
	self.refer:Get("btnText").text = self.btn_name
	self.refer:Get("bg_btn"):SetActive(self.bg_btn_show)
	self.refer:Get("exit_btn"):SetActive(self.exit_btn_show)
	if self.down_timer then
		self.down_timer:stop()
		self.down_timer = nil
	end
	
	local t = 5
	local cb = function()
		t = t - 1
		if t<0 then
			self:hide()
		else
			if self.auto then
				self.refer:Get("btnText").text = self.btn_name.."("..t..")"
			end
		end
	end
	if self.auto then
		self.refer:Get("btnText").text = self.btn_name.."("..t..")"
	end
	self.down_timer = Schedule(cb,1)

end

function ItemSysUseGuideView:setImageTexture(img,icon)
	-- print("哒哒哒哒哒~~设置图标",img,icon)
	if not self.load_img_cache[img] then
		-- print("哒哒哒哒哒~~img 空闲，直接加载图片",img,icon)
		self.load_img_cache[img] = {}

		gf_setImageTexture(img,icon,function() self:cache_load_texture(img,icon) end)

	else
		-- print("哒哒哒哒哒~~img 忙，缓存待加载图片",img,icon)
		self.load_img_cache[img][#self.load_img_cache[img]+1] = icon
	end

end

function ItemSysUseGuideView:cache_load_texture(img,icon)
	-- print("哒哒哒哒哒~~图片加载完成")
	if #self.load_img_cache[img]>0 then
		local icon = self.load_img_cache[img][1]
		table.remove(self.load_img_cache[img],1)
		-- print("哒哒哒哒哒~~从缓存取出icon进行加载",img,icon)
		gf_setImageTexture(img,icon,function() self:cache_load_texture(img,icon) end)
	else
		-- print("哒哒哒哒哒~~img的所有图片夹在完了 设置闲置",img)
		self.load_img_cache[img] = nil
	end
end

--鼠标点击按钮
function ItemSysUseGuideView:on_click(obj,arg)
	if(obj.name=="cancleBtn")then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
	elseif(obj.name=="useBtn")then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.auto = true
		self:hide()
	elseif obj.name == "self_tips" then
		--隐藏
		self.tips_fun()
	end
end

function ItemSysUseGuideView:use_item()
	self:auto()
end

-- 释放资源
function ItemSysUseGuideView:dispose()
	print("dispose",self.init)
	self:hide()
	self.load_img_cache = nil
	self.init = nil
	self.item_obj.itemSysUseGuideView = nil
    self._base.dispose(self)
end

function ItemSysUseGuideView:on_hided()
	if self.down_timer then
		print("停止计时器",self.down_timer)
		self.down_timer:stop()
		self.down_timer = nil
	end
	if self.is_register then
		self.is_register = nil
		StateManager:remove_register_view( self )
	end
	if self.auto then
		self.auto = nil
		self.action()
	end
end

function ItemSysUseGuideView:on_showed()
	print("on_show",self.init)
	if not self.is_register then
		self.is_register = true
		StateManager:register_view( self )
	end
	self:set_content()
end

return ItemSysUseGuideView

