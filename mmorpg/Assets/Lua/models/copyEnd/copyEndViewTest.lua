--[[--
-- 副本结算
-- @Author:Seven
-- @DateTime:2017-06-03 12:05:24
--]]
local dataUse = require("models.copy.dataUse")

local copyEndBase = require("models.copyEnd.copyEndBase")

local CopyEndView=class(copyEndBase,function(self,item_obj,msg,copy_id)
	self.msg = msg
	self.copy_id = copy_id
    copyEndBase._ctor(self, "fuben_end.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CopyEndView:on_asset_load(key,asset)
	self:get_data()
	self:init_ui()
end

function CopyEndView:init_ui()
	self.exp_txt = self.refer:Get("expTxt")
	self.gold_txt = self.refer:Get("goldTxt")
	self.yao_txt = self.refer:Get("yaoTxt")
	self.vip_txt = self.refer:Get("vipTxt")
	self.cross_time_txt = self.refer:Get("crossTimeTxt")
	--设置背景职业
	local career = LuaItemManager:get_item_obejct("game").role_info.career
	gf_win_icon(self.refer:Get("img_career"),career)

	self.scroll_table = self.refer:Get("scroll_table")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.star_list = {
		[1] = LuaHelper.FindChild(self.root, "star1"),
		[2] = LuaHelper.FindChild(self.root, "star2"),
		[3] = LuaHelper.FindChild(self.root, "star3"),
	}

	for i,v in ipairs(self.star_list) do
		--除了剧情副本 其他副本隐藏星星
		if dataUse.getCopyType(self.copy_id) == ServerEnum.COPY_TYPE.STORY then
			v.gameObject:SetActive(true)
			if i > self.star_num then
				v:GetComponent(UnityEngine_UI_Image).material = self.refer:Get(9)
			else
				v:GetComponent(UnityEngine_UI_Image).material = nil
			end
		else
			v.gameObject:SetActive(false)
		end
		
	end

	self:refresh(self.item_list)
	self:update_txt()
end

-- function CopyEndView:get_config_data()
-- 	self.config_data = config_data
-- end

function CopyEndView:get_data()
	self.exp  			= self.msg.exp
	self.coin 			= self.msg.coin
	self.vip_add 		= 0
	self.medicine_add 	= 0
	--剧情结算
	local copy_data = gf_getItemObject("copy")

	

	if dataUse.getCopyType(self.copy_id) == ServerEnum.COPY_TYPE.STORY then
		local story_copy_data = dataUse.getStoryCopyData(self.copy_id)
		self.star_num = self:get_star_num(self.msg.costTime)
		self.exp = story_copy_data.exp_reward
		self.coin = story_copy_data.coin_reward
	end
	--材料副本
	-- if dataUse.getCopyType(self.copy_id) == ServerEnum.COPY_TYPE.MATERIAL then
	-- 	local my_level = gf_getItemObject("game"):getLevel()
	-- 	local material_copy_data = dataUse.getLevelMaterialCopy(self.copy_id,my_level)
	-- 	self.exp = material_copy_data.exp
	-- end
	--爬塔
	print("is tower",dataUse.getCopyType(self.copy_id) , ServerEnum.COPY_TYPE.TOWER)
	if dataUse.getCopyType(self.copy_id) == ServerEnum.COPY_TYPE.TOWER then

		local data = gf_get_config_table("copy_tower")[self.copy_id]
		gf_print_table(data, "wtf data:"..self.copy_id)
		if next(data) then 
			self.exp = data.reward_exp
			self.coin = data.reward_coin
		end

	end

	if dataUse.getCopyType(self.copy_id) == ServerEnum.COPY_TYPE.TEAM then
		local reward = gf_get_config_table("team_copy")[self.copy_id]

		local count = #gf_getItemObject("team"):getTeamData().members
		gf_print_table(reward, "wtf reward")
		self.exp = reward.exp_reward[count]
		self.coin = reward.coin_reward[count]
	end
	
	self.cross_time = self.msg.costTime or 0
	self.item_list = self.msg.itemDrops or {}
	
end

function CopyEndView:get_star_num(time)
	local copy_data = ConfigMgr:get_config("story_copy")[self.copy_id]
	if time <= copy_data.star3_time then
		return 3
	end

	if time <= copy_data.star2_time then
		return 2
	end

	return 1
end

function CopyEndView:update_txt()
	self.exp_txt.text = gf_localize_string(string.format("获得经验： <color=#ffc61e>%d</color>",self.exp or 0))
	self.gold_txt.text = gf_localize_string(string.format("获得铜钱： <color=#ffc61e>%d</color>",self.coin or 0))
	self.yao_txt.text = gf_localize_string(string.format("丹药加成： <color=#ffc61e>%d%%</color>",self.medicine_add))
	self.vip_txt.text = gf_localize_string(string.format("VIP加成： <color=#ffc61e>%d%%</color>",self.vip_add))
	self.cross_time_txt.text = gf_localize_string(string.format("通关时间： <color=#ffc61e>%ds</color>",self.cross_time or 0))
end

function CopyEndView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function CopyEndView:update_item( item, index, data )
	--如果是装备 读取打造表id
	local bt,st = gf_getItemObject("bag"):get_type_for_protoId(data.code)--gf_get_config_table("item")[data.code].type,gf_get_config_table("item")[data.code].sub_type
	if bt == ServerEnum.ITEM_TYPE.VIRTUAL then
		local legion_data_use = require("models.legion.dataUse")
		local career = gf_getItemObject("game"):get_career()
		local formulaTable = ConfigMgr:get_config("equip_formula")
		local food_item_id = legion_data_use.getCareerItem(data.code,career)
		gf_set_item(formulaTable[food_item_id].code, item:Get(1), item:Get(2))
	else
		gf_set_item(data.code, item:Get(1), item:Get(2))
	end
	
	item:Get(3).text = data.num
end

function CopyEndView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
		--如果小于两秒 不给点击
	   	if not self:is_can_exit() then
	   		return
	   	end
	    Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function CopyEndView:on_receive(msg, id1, id2, sid)
	CopyEndView._base.on_receive(self,msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "ExitCopyR") then -- 取章节信息
			-- LuaItemManager:get_item_obejct("battle"):change_scene(msg.mapId)
			self:dispose()
		end
	end
end

function CopyEndView:on_showed()
	CopyEndView._base.on_showed(self)
end

function CopyEndView:on_hided()
	CopyEndView._base.on_hided(self)
end

-- 释放资源
function CopyEndView:dispose()
    CopyEndView._base.dispose(self)
end

return CopyEndView

