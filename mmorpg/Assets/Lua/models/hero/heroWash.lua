--[[
	 武将洗炼
	 create at 17.7.12
	 by xin
]]
require("models.hero.heroConfig")
require("models.hero.heroPublicFunc")
local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local modelName = "hero"

local res = 
{
	[1] = "hero_xilian.u3d",
}

local commom_string = 
{
  [1] = gf_localize_string("材料不足"),
}

local node_t = 
{
    [ServerEnum.HERO_TALENT_TYPE.FORCE]         ="power",
    [ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]      ="strenght",   
    [ServerEnum.HERO_TALENT_TYPE.FLEXABLE]      ="spirite",
    [ServerEnum.HERO_TALENT_TYPE.MULTIPLE]      ="talent",
}

local heroWash = class(UIBase,function(self,hero_id)
    print("hero_id:",hero_id)
    self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)

function heroWash:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroWash:on_asset_load(key,asset)
end

function heroWash:init_ui()
    self.lock_count = 0
    self.skill_list = {}
    self:hero_choose(self.hero_id)

end

function heroWash:hero_choose(hero_id)

    self:init_two_property_view(hero_id)
    self:init_item_view()
end

function heroWash:init_item_view()
    print("need count wtf 1",need_count)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
    if not next(hero_data or {}) then
        return
    end
    local item = dataUse.getHeroPolishItem(self.hero_id)

    local item_id = item[1] or ConfigMgr:get_config("t_misc").hero.polish_code
    local need_count = item[2]

    -- local items = gf_getItemObject("bag"):get_item_for_protoId(item_id,ServerEnum.BAG_TYPE.NORMAL)
    local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.POLISH_HERO,ServerEnum.BAG_TYPE.NORMAL)
    local count = 0
    for i,v in ipairs(items or {}) do
        count = count + v.item.num
    end
    
    self.itemId = item_id
    gf_set_item(item_id,self.refer:Get(5),self.refer:Get(3))
    local str = "<color=%s>%d</color>/%d"
    local color = count >= need_count and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
    self.refer:Get(7).text = string.format(str,color,count,need_count)

    self:update_skill_lock_item_count()
    
end

function heroWash:update_skill_lock_item_count()
    local item_id = ConfigMgr:get_config("t_misc").hero.polish_lock_code
    --技能锁
    local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.POLISH_HERO_LOCK_SKILL,ServerEnum.BAG_TYPE.NORMAL)
    local count = 0
    for i,v in ipairs(items or {}) do
        count = count + v.item.num
    end
    local need_count = self.lock_count
    gf_set_item(item_id,self.refer:Get(6),self.refer:Get(4))
    local str = "<color=%s>%d</color>/%d"
    local color = count >= need_count and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
    self.refer:Get(8).text = string.format(str,color,count,need_count)

end

function heroWash:init_two_property_view(hero_id)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(hero_id)
    --当前属性
    self:init_property_view(hero_data.heroId,self.refer:Get(1),hero_data.talent,hero_data.skill,hero_data.mutate,"item_item")
    self:init_property_view(hero_data.heroId,self.refer:Get(2),hero_data.polishTalent,hero_data.polishSkill,hero_data.polishMutate,"litem_item",hero_data.talent,hero_data.skill)
end

--@pnode 
--@property 
function heroWash:init_property_view(hero_id,pnode,property,skill,polishMutate,skill_name,before_talent,before_skill)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(hero_id)
    --当前等级的天赋
    local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,property,hero_data.awakenLevel)
    local data3,data4 = dataUse.getHeroTalentIncludeAwake(self.hero_id,before_talent,hero_data.awakenLevel)
    --洗炼后
    SetHeroTalent(pnode,data1,data2,hero_id)
    
    local power = gf_getItemObject("hero"):get_hero_power(hero_id,data1,skill)
    local power2 = gf_getItemObject("hero"):get_hero_power(hero_id,data3,before_skill)
    local power_text = pnode.transform:FindChild("zhangLiBg").transform:FindChild("zhanLiNum"):GetComponent("UnityEngine.UI.Text")
    power_text.text = power

    --如果是下一个天赋显示
    if before_talent then
       
        local pnode1 = pnode.transform:FindChild("zhangLiBg").transform:FindChild("Image (1)")
        local pnode2 = pnode.transform:FindChild("zhangLiBg").transform:FindChild("Image (2)")
        pnode1.gameObject:SetActive(false)
        pnode2.gameObject:SetActive(false)
        --如果有天赋
        if next(property or {}) then
            pnode1.gameObject:SetActive(power > power2)
            pnode2.gameObject:SetActive(power < power2)
            self.refer:Get(10).text = power - power2
            self.refer:Get(11).text = power - power2
        else
             power_text.text = ""
        end
        
    end
    
    --技能
    local skill_node = pnode.transform:FindChild("talent_item_list")
    for i=1,8 do 
        local skill_item = skill_node.transform:FindChild(skill_name..i)
        gf_setImageTexture(skill_item:GetComponent(UnityEngine_UI_Image),"item_color_0")
        skill_item.transform:FindChild("Image").gameObject:SetActive(false)
        skill_item.transform:FindChild("icon").gameObject:SetActive(false)
        skill_item.transform:FindChild("lock").gameObject:SetActive(false)
    end
    for i,v in ipairs(skill or {}) do
        local skill_item = skill_node.transform:FindChild(skill_name..i)
        if dataUse.getOwnSkill(hero_id) == v then  
            skill_item.transform:FindChild("Image").gameObject:SetActive(true)
        end
        
        skill_item.transform:FindChild("icon").gameObject:SetActive(true)
        -- local icon = skill_item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
        -- local icon_res = require("models.horse.dataUse").get_skill_icon(v)
        -- gf_setImageTexture(icon, icon_res)

        gf_set_hero_skill(v,skill_item)

    end

    if before_talent then
        
        for i=1,4 do
            local node1 = pnode.transform:FindChild(node_t[i]).transform:FindChild("Image (1)")
            local node2 = pnode.transform:FindChild(node_t[i]).transform:FindChild("Image (2)")
            node2.gameObject:SetActive(false)
            node1.gameObject:SetActive(false)
        end
        for k,v in pairs(property or {}) do
            if next(property or {}) then
                local node1 = pnode.transform:FindChild(node_t[k]).transform:FindChild("Image (1)")
                local node2 = pnode.transform:FindChild(node_t[k]).transform:FindChild("Image (2)")
                node2.gameObject:SetActive(before_talent[k] > v)
                node1.gameObject:SetActive(before_talent[k] < v)

                local p_t1 = node1.transform:FindChild("up_num"):GetComponent("UnityEngine.UI.Text")
                local p_t2 = node2.transform:FindChild("down_num"):GetComponent("UnityEngine.UI.Text")

                p_t1.text = v - before_talent[k]
                p_t2.text = v - before_talent[k]
            end
        end
    end

end

function heroWash:item_click()
    gf_getItemObject("itemSys"):common_show_item_info(self.itemId,nil,nil)
end

function heroWash:wash_click()
    if self.refer:Get(9).isOn then
        gf_getItemObject("hero"):sendToPolishHero(self.hero_id,self.skill_list,self.refer:Get(9).isOn)
        return
    end
    --判断数量是否足够
    local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.POLISH_HERO_LOCK_SKILL,ServerEnum.BAG_TYPE.NORMAL)
    local count1 = 0
    for i,v in ipairs(items or {}) do
        count1 = count1 + v.item.num
    end
    local need_count1 = self.lock_count

    local need_count2 = dataUse.getHeroPolishItem(self.hero_id)[2]
    local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.POLISH_HERO,ServerEnum.BAG_TYPE.NORMAL)
    local count2 = 0
    for i,v in ipairs(items or {}) do
        count2 = count2 + v.item.num
    end

    if need_count1 > count1 or need_count2 > count2 then
        gf_message_tips(commom_string[1])

        local item1 = ConfigMgr:get_config("t_misc").hero.polish_code
        local item2 = ConfigMgr:get_config("t_misc").hero.polish_lock_code
        gf_create_quick_buys({item1,item2},1)
        return
    end
    gf_getItemObject("hero"):sendToPolishHero(self.hero_id,self.skill_list,self.refer:Get(9).isOn)
    
end


function heroWash:hero_click(eventName,arg)
    local index = string.gsub(eventName,"hero_item_fight","")
    index = tonumber(index)

    self:hero_choose(index)

end

function heroWash:skill_click(eventName,arg)
    local index = string.gsub(eventName,"skill","")
    index = tonumber(index)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
    local skill_id = hero_data.skill[index]
    if skill_id then
        gf_getItemObject('itemSys'):skill_tips(skill_id,arg.transform.position.x)
    end
end
function heroWash:nskill_click(eventName,arg)
    local index = string.gsub(eventName,"nskill","")
    index = tonumber(index)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
    gf_print_table(hero_data, "wtf hero_data:")
    local skill_id = hero_data.polishSkill[index]
    if skill_id then
        gf_getItemObject('itemSys'):skill_tips(skill_id)
    end
end 

function heroWash:skill_touch(arg,eventName)
    local index = string.gsub(eventName,"item_item","")
    index = tonumber(index)
    local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
    if not hero_data.skill[index] then
        return
    end

    if arg.activeSelf then
        self.lock_count = self.lock_count - 1
        for i,v in ipairs(self.skill_list) do
            if v == hero_data.skill[index] then
                table.remove(self.skill_list,i)
            end
        end
    else
        self.lock_count = self.lock_count + 1
        table.insert(self.skill_list,hero_data.skill[index])
    end
    arg:SetActive(not arg.activeSelf)
        
    self:update_skill_lock_item_count()

end

--鼠标单击事件
function heroWash:on_click( obj, arg)
    local eventName = obj.name
    print("heroWash click",eventName)
    
    
    if eventName == "hero_store" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
         -- self:create_sub_view("models.hero.heroStoreView")
        require("models.hero.heroStoreView")()

    elseif eventName == "wash_item" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:item_click()  

    elseif eventName == "lock_item" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        gf_getItemObject("itemSys"):common_show_item_info(ConfigMgr:get_config("t_misc").hero.polish_lock_code,nil,nil)

    elseif eventName == "btnSave" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        gf_getItemObject("hero"):sendToSaveWash(self.hero_id)

    elseif eventName == "btnXilian" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:wash_click()
    
    elseif string.find(eventName,"hero_item_fight") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:hero_click(eventName,arg)
    
    elseif string.find(eventName,"nskill") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:nskill_click(eventName,arg)

    elseif string.find(eventName,"skill") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:skill_click(eventName,arg)

    elseif eventName == "wash_btn_close" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:dispose()

    elseif string.find(eventName,"item_item") then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:skill_touch(arg,eventName)

    elseif eventName == "hero_train_help" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        gf_show_doubt(1082)

    elseif eventName == "togglleAutoBuy" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

    end
end

function heroWash:on_showed()
    StateManager:register_view(self)
    self:init_ui()
end

-- 释放资源
function heroWash:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroWash:rec_wash_back(msg)
    gf_print_table(msg,"wtf PolishHeroR")
    if msg.err == 0 then
        -- self:init_two_property_view(msg.hero_id)
        local hero_data = gf_getItemObject("hero"):getHeroInfo(msg.heroId)

        self:init_property_view(hero_data.heroId,self.refer:Get(2),hero_data.polishTalent,hero_data.polishSkill,hero_data.polishMutate,"litem_item",hero_data.talent)

        self:init_item_view()
    end
end

function heroWash:on_hided()
    StateManager:remove_register_view(self)
end

function heroWash:on_receive( msg, id1, id2, sid )
	 if id1 == Net:get_id1(modelName) then 
		if id2 == Net:get_id2(modelName,"PolishHeroR")   then
			self:rec_wash_back(msg)

        elseif id2 == Net:get_id2(modelName,"SavePolishHeroR") then
            self:init_ui()
		      
        end
	end
    if id1==Net:get_id1("shop") then
        if id2== Net:get_id2("shop", "BuyR") then
            self:init_item_view()
        end
    end
end

return heroWash