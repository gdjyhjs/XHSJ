--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-29 14:54:53
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WifgetTimeCellSignalView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "wifget_time_cell_signal.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function WifgetTimeCellSignalView:on_asset_load(key,asset)
	self:init_ui()
end

--初始化
function WifgetTimeCellSignalView:init_ui()
	local refer = self.refer
	--时间text
	self.text_time=refer:Get(1)
	--电池slider
	self.slider_cell=refer:Get(2)
	--信号img
	self.img_signal=refer:Get(3)
	--网络模式text
	self.text_network=refer:Get(4)
	--计时器
	self.timer=1
	--注册更新
	gf_register_update(self)
end

function WifgetTimeCellSignalView:on_update(dt)
	self.timer=self.timer+dt
	--每秒更新一次
	if self.timer>1 then
		--归零，以待下次计时
		self.timer=0
		--设置时间
		self.text_time.text=os.date("%H:%M", os.time())
		--设置电池slider
		self.slider_cell.value=0.5
		--设置信号img
		--self.img_signal
		--设置网络模式text
		self.text_network.text="3G"
	end
end

-- 释放资源
function WifgetTimeCellSignalView:dispose()
	gf_remove_update(self)
    self._base.dispose(self)
 end

return WifgetTimeCellSignalView