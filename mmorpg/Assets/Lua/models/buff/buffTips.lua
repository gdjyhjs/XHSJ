--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 16:15:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local BuffTips=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("buff")
	self.item_obj = item_obj
    UIBase._ctor(self, "buff_tip.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function BuffTips:on_asset_load(key,asset)
	self.update_tb ={}
	StateManager:register_view(self)
	self.scroll_table= self.refer:Get(1)
	self.scroll_table.onItemRender = handler(self,self.update_item)
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	self.buff_data = self.item_obj:get_buff_tb(r_id)
	self:refresh(self.buff_data)
	self.update_time_tb = {}
	self.update_time = Schedule(handler(self,self.countdown),1)
	if #self.buff_data<3 then
		local width = 302.25
		local height = 76.5*#self.buff_data+12
		self.refer:Get(2).transform.sizeDelta =Vector2(width ,height)
	end
end

function BuffTips:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function BuffTips:countdown()
	if #self.update_time_tb>0 then
		for k,v in pairs(self.update_time_tb) do
			local nowtime =  math.floor(Net:get_server_time_s())
			local s = v.time-nowtime
			if s<60 then
				if s<0 then
					v.txt.text =gf_localize_string("失效")
				else
					v.txt.text =math.floor(s) .."s"
				end
			elseif s<3600 then
				v.txt.text = gf_convert_time_ms(s)
			else
				v.txt.text = gf_convert_time(s)
			end
		end
	end
end
function BuffTips:on_click(obj, arg)
	if obj.name == "btn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function BuffTips:update_item(item,index,data)
	gf_set_quality_bg(item:Get(1),data.icon_bg)
	gf_setImageTexture(item:Get(2),data.icon)
	item:Get(3).text = data.name
	if	data.effect_cumulate_count ~=0 then
		print("啊啊啊",data.desc)
		print("啊啊啊",data.state_effect[1][3],data.cumulateEffect)
		item:Get(4).text = string.format(data.desc,data.state_effect[1][3]*data.cumulateEffect/100)
	else
		item:Get(4).text = data.desc
		-- item:Get(4).text = "客"..math.floor(Net:get_server_time_s()*10).."\n服"..data.expireTime
	end
	if data.expireTime then
		local x = #self.update_time_tb+1
		self.update_time_tb[x] = {}
		self.update_time_tb[x].txt = item:Get(6) 
		self.update_time_tb[x].time = data.expireTime*0.1
		local nowtime =  math.floor(Net:get_server_time_s()*10)
		local s = (data.expireTime-nowtime)*0.1
		if s<60 then
			if s<0 then
				item:Get(6).text =gf_localize_string("失效")
			else
				item:Get(6).text =math.floor(s) .."s"
			end
		elseif s<3600 then
			item:Get(6).text = gf_convert_time_ms(s)
		else
			item:Get(6).text = gf_convert_time(s)
		end
		item:Get(5):SetActive(false)
		item:Get(6).gameObject:SetActive(true)
	else
		item:Get(5):SetActive(true)
		item:Get(6).gameObject:SetActive(false)
	end
end
-- 释放资源
function BuffTips:dispose()
	if self.update_time then
		self.update_time:stop()
	end
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return BuffTips

