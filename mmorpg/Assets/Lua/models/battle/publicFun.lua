--[[
一些公共方法
]]

-- 获取npc事件列表
function gf_get_npc_event( npc_id, status )
	local npc = LuaItemManager:get_item_obejct("battle"):get_npc(npc_id)
	if not npc then
		return {}
	end
	status = status or -1
	
	local game_item = LuaItemManager:get_item_obejct("game")
	local event_list = {}
	local config_data = npc.config_data
	local faction = config_data.faction
	local char_faction = LuaItemManager:get_item_obejct("battle"):get_character():get_faction()
	for i,v in ipairs(config_data.event or {}) do
		local data = ConfigMgr:get_config("npc_event")[v]
		if not data or (faction and faction ~= char_faction) then
			print_error(string.format("配置表npc_event找不到id为%d的数据",v))
			gf_error_tips(string.format("配置表npc_event找不到id为%d的数据",v))

		else
			if data.ty == ClientEnum.NPC_EVNET.LEVEL and data.condition <= game_item:getLevel() then
				event_list[#event_list+1] = data

			elseif data.ty == ClientEnum.NPC_EVNET.TASK_AVAILABLE and status == ServerEnum.TASK_STATUS.AVAILABLE then
				event_list[#event_list+1] = data

			elseif data.ty == ClientEnum.NPC_EVNET.TASK_PROGRESS and status == ServerEnum.TASK_STATUS.PROGRESS then
				event_list[#event_list+1] = data

			elseif data.ty == ClientEnum.NPC_EVNET.TASK_COMPLETE and status == ServerEnum.TASK_STATUS.COMPLETE then
				event_list[#event_list+1] = data

			elseif not data.ty then -- 没有触发条件，有这个npc就会有
				event_list[#event_list+1] = data
			end
		end
	end
	return event_list
end

-- 发送自动攻击协议
function gf_auto_atk( flag )
	Net:receive(flag, ClientProto.AutoAtk)
end

-- 更换材质球图片
__g_material_img_list = {}
function gf_change_material_img( material, img, key )
	print("更换材质球图片",img)
	key = key or "_MainTex"
	if not material then
		gf_error_tips("更换材质球图片：材质球为空")
		return
	end
	if not img then
		gf_error_tips("更换材质球图片：图片找不到：",img)
		return
	end

	if __g_material_img_list[img] and not Seven.PublicFun.IsNull(__g_material_img_list[img]) then
		material:SetTexture(key, __g_material_img_list[img])
		if UI_RGB_A and key == "_AfterTex" then -- 流光
			material:SetTexture("_AfterAlphaTex", __g_material_img_list[img.."_etc_a"])
		end
	else
		local alpha
		if UI_RGB_A and key == "_AfterTex" then -- 流光
			alpha = img.."_etc_a"
			img = img.."_etc_rgb"
			Loader:get_resource(alpha..".u3d",nil,"UnityEngine.Texture",
				function(s)
					__g_material_img_list[alpha] = s.data
					material:SetTexture("_AfterAlphaTex", s.data)
				end,function(s)
					gf_error_tips(string.format("找不到材质球图片：%s",alpha))
				end
			)
		end

		Loader:get_resource(img..".u3d",nil,"UnityEngine.Texture",
			function(s)
				__g_material_img_list[img] = s.data
				material:SetTexture(key, s.data)
			end,function(s)
				gf_error_tips(string.format("找不到材质球图片：%s",img))
			end
		)
	end
end

-- 测试 添加一个怪物
function gf_add_monster( monster_id )
	local battle = LuaItemManager:get_item_obejct("battle")
	local cb = function( monster )
		monster.config_data = ConfigMgr:get_config("creature")[monster_id]
		monster:set_position(battle:get_character().transform.position)
	end
	return battle.pool:get_monster(monster_id, cb)
end