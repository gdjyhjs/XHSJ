--[[
	武将重命名界面  属性
	create at 17.10.11
	by xin
]]

local res = 
{
	[1] = "hero_rename.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("名字中含有敏感词汇，请重新输入"),
}


local heroRename = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroRename:on_asset_load(key,asset)
    self:init_ui()
end

function heroRename:init_ui()
end

--鼠标单击事件
function heroRename:on_click( obj, arg)
	local event_name = obj.name
	print("heroRename click",event_name)
    if event_name == "rename_cancleBtn" or event_name == "rename_btn_close" then 
    	self:dispose()

    elseif event_name == "rename_sureBtn" then
    	local text = self.refer:Get(1).text or ""
    	if text ~= "" then
			if checkChar(text) then
				gf_message_tips(commom_string[1])
				return
			end

    		gf_getItemObject("hero"):sendToNameHero(self.hero_id,text)
    		-- gf_getItemObject("hero"):test_rename(self.hero_id,text)
    	end

    end
end

function heroRename:on_showed()
	StateManager:register_view(self)
end

function heroRename:clear()
	StateManager:remove_register_view(self)
end

function heroRename:on_hided()
	self:clear()
end
-- 释放资源
function heroRename:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroRename:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("hero"))then
        if id2 == Net:get_id2("hero", "RenameHeroR") then
        	self:dispose()
        end
    end
end

return heroRename