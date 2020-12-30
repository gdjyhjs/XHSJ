--[[--
-- 剧情副本
-- @Author:Seven
-- @DateTime:2017-05-31 15:30:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local CopyScrollPage = require("models.copy.copyScrollPage")
local Enum = require("enum.enum")

local box_res = 
{
	[1] = {"daily_chest_01_opened","daily_chest_01_unopen"},
	[2] = {"daily_chest_02_opened","daily_chest_02_unopen"},
	[3] = {"daily_chest_03_opened","daily_chest_03_unopen"},
}

local StoryView=class(UIBase,function(self,item_obj)
    self.chapter = 1
    UIBase._ctor(self, "story.u3d", item_obj) -- 资源名字全部是小写
end)

local commom_string = 
{
	[1] = gf_localize_string("今日不再提醒"),
	[2] = gf_localize_string("确定要花费<color=#B01FE5>%d</color>元宝购买<color=#B01FE5>%d</color>点体力？今日还可购买<color=#B01FE5>%d</color>次。"),
	[3] = gf_localize_string("奖励已领取"),
	[4] = gf_localize_string("今日购买体力次数已用完，提升VIP等级可增加购买次数！"),

}
local save_key = "%d_story_copy"

-- 资源加载完成
function StoryView:on_asset_load(key,asset)
	self:init_ui()
end

function StoryView:init_ui()
	self.scroll_page = CopyScrollPage(self)

	self.star_count_txt_1 = LuaHelper.FindChildComponent(self.root, "starCountTxt1", "UnityEngine.UI.Text")
	self.star_count_txt_2 = LuaHelper.FindChildComponent(self.root, "starCountTxt2", "UnityEngine.UI.Text")
	self.star_count_txt_3 = LuaHelper.FindChildComponent(self.root, "starCountTxt3", "UnityEngine.UI.Text")

	self:set_strenght()

	self.chaper_data = {} -- 章节表数据

	-- gf_getItemObject("copy"):test_chapter_data()

end

function StoryView:set_strenght()
	-- 体力
	self.strength = LuaHelper.FindChildComponent(self.root, "tiLiTxt", "UnityEngine.UI.Text")
	self.strength.text = LuaItemManager:get_item_obejct("game"):get_strenght().."/"..LuaItemManager:get_item_obejct("game"):get_max_strenght()
end

function StoryView:register()
	StateManager:register_view( self )
end

function StoryView:update_chaper_data(data, chapter)
	self.chaper_data = data
	self.chapter = chapter
	


	if self.chaper_data then
		self.rev_get_reward = self.chaper_data.getReward or {}
	else
		self.rev_get_reward = {}
	end

	self:set_total_start()
end

-- 更新星星数量
function StoryView:update_star_count(count_1, count_2, count_3)
	self.star_count_txt_1.text = count_1
	self.star_count_txt_2.text = count_2
	self.star_count_txt_3.text = count_3
end

function StoryView:set_total_start()
	local chapter_data = gf_getItemObject("copy"):get_chapter_info(self.chapter)
	--副本数量

	--副本通过时间
	local star_count = 0
	if chapter_data then
		for i,v in ipairs(chapter_data.copyInfo or {}) do
			star_count = star_count + v.star
		end
	end
	
	
	local total_count = #self.chaper_data.stage * 3
	-- local cur_count = star_count

	-- self.refer:Get(1).text = string.format("%d/%d",cur_count,total_count)

	local total_width = 527.3

	self.refer:Get(11).transform.sizeDelta = Vector2(total_width * star_count / total_count,12) 

	local posx = -40

	--箱子特效
	local getReward = chapter_data and chapter_data.getReward or {}
	
	-- .star_num_1, data.star_num_2, data.star_num_3
	local data = ConfigMgr:get_config("copy_chapter")[self.chapter]
	for i=1,3 do
		local box = self.refer:Get("baoXiangBtn_"..i)
		local star = self.refer:Get("star"..i)
		--修改宝箱位置 
		box.transform.localPosition = Vector3(posx + total_width * data["star_num_"..i] / total_count,-198.3,0)
		star.transform.localPosition =  Vector3(posx - 20 + total_width * data["star_num_"..i] / total_count,-254.73,0)
		for i=1,box.transform.childCount do
	  		local go = box.transform:GetChild(i - 1).gameObject
			LuaHelper.Destroy(go)
	  	end
		--如果满足开启条件没有开启
		if not self:find_is_open(i) then
			
			gf_setImageTexture(box, box_res[i][2])
			--添加特效
			if data["star_num_"..i] <= star_count then
				local effect_cb = function( effect )
					effect:set_parent(box.transform)
					effect.root.transform.localPosition = Vector3(-8, -8, 0)
					effect.root.transform.localScale = Vector3(1, 1, 1) 
					effect:show()
				end
				local Effect = require("common.effect")
				Effect("41000048.u3d", effect_cb)
			end
		elseif self:find_is_open(i) then
			gf_setImageTexture(self.refer:Get("baoXiangBtn_"..i), box_res[i][1])
		end
	end
	
end

-- 打开宝箱视图
function StoryView:open_box_view( index )
	local cur_star_num = 0
	if self.item_obj.chapter_info[self.chapter] then
		for k,v in pairs(self.item_obj.chapter_info[self.chapter].copyInfo or {}) do
			cur_star_num = cur_star_num+v.star
		end
	end

	local data = {
		reward_data = self.chaper_data["reward_"..index], 
		cur_star_num = cur_star_num,
		max_star_num = self.chaper_data["star_num_"..index]
	}
	require("models.copy.storyRewardView")(self.item_obj, data, self.rev_get_reward[index], index,self.chapter)
end

function StoryView:find_is_open(idx)
	local chapter_data = gf_getItemObject("copy"):get_chapter_info(self.chapter)

	local getReward = chapter_data and chapter_data.getReward or {}
	for i,v in ipairs(getReward or {}) do
		if v == idx then
			return true
		end
	end
	return false
end

function StoryView:box_click(index)
	if self:find_is_open(index) then
		gf_message_tips(commom_string[3])
		return
	end
	self:open_box_view(index)
end

function StoryView:on_click(obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "baoXiangBtn_1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:box_click(1)

	elseif cmd == "baoXiangBtn_2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:box_click(2)

	elseif cmd == "baoXiangBtn_3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:box_click(3)

	elseif cmd == "addTiLiBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- gf_getItemObject("game"):get_strenght_left_count_c2s()
		gf_getItemObject("copy"):power_add()

	elseif cmd == "helpBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1021)

	end

	self.scroll_page:on_click(item_obj, obj, arg)
end


function StoryView:on_receive( msg, id1, id2, sid )
	if self.scroll_page then
		self.scroll_page:on_receive(msg, id1, id2, sid)
	end
    if(id1==Net:get_id1("base"))then
        if id2 == Net:get_id2("base", "StrengthLeftBuyTimesR") then
        	gf_print_table(msg, "StrengthLeftBuyTimesR:")
        	-- self:power_add()
        	-- gf_getItemObject("copy"):power_add()

        elseif id2 == Net:get_id2("base", "UpdateResR") then
        	self:set_strenght()

        end

    end
    if(id1==Net:get_id1("copy"))then
        if id2 == Net:get_id2("copy", "OpenChapterBoxR") then -- 领取宝箱
        	if msg.err == 0 then
        		self:set_total_start()
        	end
        	
        elseif id2 == Net:get_id2("copy", "GetStoryCopyInfoR") then
        	print("wtf you chapter:")

        end

    end
end

function StoryView:on_showed()
	self:register()
	
	if self.scroll_page then
		self.scroll_page:on_showed()
	end
end

function StoryView:on_hided()
	self:clear()
end

function StoryView:clear()
	if self.scroll_page then
		self.scroll_page:dispose()
	end
	StateManager:remove_register_view( self )
end

-- 释放资源
function StoryView:dispose()
	self:clear()
    self._base.dispose(self)
end

return StoryView

--[[

	
function StoryView:power_add()

	local c_date = os.date("%x",Net:get_server_time_s())

	local my_role_id = gf_getItemObject("game"):getId()
	local s_date = PlayerPrefs.GetString(string.format(save_key,my_role_id),os.date("%x",Net:get_server_time_s() - 24 * 60 * 60))
	local left_count = gf_getItemObject("game"):get_strenght_buy_count()

	if c_date == s_date then
		if left_count == 0 then
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(commom_string[4])
			return
		end
		gf_getItemObject("game"):buy_strenght_c2s()
		return
	end

	local save = function()
		PlayerPrefs.SetString(string.format(save_key,my_role_id),c_date)
	end

	local sfunc = function(a,b)
		print("购买体力")
		if b then
			save()
		end
		gf_getItemObject("game"):buy_strenght_c2s()
	end
	local cfunc = function(a,b)
		if b then
			save()
		end
	end
	local constant_info = ConfigMgr:get_config("t_misc")
	local price = constant_info.strength.buy_cost[2]
	local count = constant_info.strength.buy_num
	
	local show_content = string.format(commom_string[2],price,count,left_count)

	if left_count == 0 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message(commom_string[4])
		return
	end

	LuaItemManager:get_item_obejct("cCMP"):toggle_message(show_content,false,commom_string[1],sfunc,cfunc)
end
]]