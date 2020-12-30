local socialTools={}

socialTools.isReadIco = "img_mail_opened" --已读的邮件图标
socialTools.notReadIco = "img_mail_unopened" --未读的邮件图标
socialTools.isTakenIco = "img_mail_received" --已领取的附件图标
socialTools.notTakenIco = "img_mail_unreceive" --未领取的附件图标
socialTools.modeBtnBg = "btn_mian_fram_page" --模块按钮背景
socialTools.modeSelectBtnBg = "btn_mian_fram_page_select" --模块按钮选中背景
socialTools.frientItemBtnBg = "btn_12" --好友项按钮背景
socialTools.frientItemBtnSelectBg = "btn_13" --好友项选中按钮背景
socialTools.emailItemBtnBg = "scroll_table_cell_bg_02_normal" --邮件项按钮背景
socialTools.emailItemBtnSelectBg = "scroll_table_cell_bg_02_select" --邮件项选中按钮背景

function socialTools.get_out_line_item_str(logoutTm) --传离线时间
	local out_line_time = Net:get_server_time_s() - logoutTm --算出离线了多少秒
	if out_line_time<60 then --1分钟内
		return string.format("1分钟前在线")
	elseif out_line_time<3600 then --以分为单位计算
		return string.format("%d分钟前在线",out_line_time/60)
	elseif out_line_time<86400 then --以时为单位计算
		return string.format("%d小时前在线",out_line_time/3600)
	elseif out_line_time<604800 then --以天为单位计算
		return string.format("%d天前在线",out_line_time/86400)
	else --超过7天，都提示 
		return "离线7天以上"
	end
end

function socialTools.get_recent_content_time(tm)
	local t = Net:get_server_time_s() - tm
	if t<3600 then --以分为单位计算
		return string.format("%d分前",t/60)
	elseif t<86400 then --以时为单位计算
		return string.format("%d小时前",t/3600)
	elseif t<604800 then --以天为单位计算
		return string.format("%d天前",t/86400)
	end
end

function socialTools.get_array_on_table(tab,key)
	local array={}
	for k,v in pairs(tab) do
		array[#array+1] = v[key]
	end
	return array
end

function socialTools.is_value_in_table(tab,key,value)
	for k,v in pairs(tab) do
		if v[key]==value then
			return true
		end
	end
end

--好友排序 在线>离线；亲密度高>战力高>等级高
function socialTools.friend_sort(list)
	table.sort(list,function(a,b)
			if a.logoutTm ~= b.logoutTm then
				if a.logoutTm==0 then
					return true
				elseif b.logoutTm==0 then
					return false
				else
					return a.logoutTm>b.logoutTm
				end
			elseif a.intimacy and b.intimacy and a.intimacy~=b.intimacy then
				return a.intimacy>b.intimacy
			elseif a.power~=b.power then
				return a.power>b.power
			else 
				return a.level>b.level
			end
		end)
	return list
end

--仇人排序 在线>离线；亲密度高>战力低>等级低
function socialTools.enemy_sort(list)
	table.sort(list,function(a,b)
			if a.logoutTm ~= b.logoutTm then
				if a.logoutTm==0 then
					return true
				elseif b.logoutTm==0 then
					return false
				else
					return a.logoutTm>b.logoutTm
				end
			elseif a.animosity~=b.animosity then
				return a.animosity>b.animosity
			elseif a.power~=b.power then
				return a.power<b.power
			else 
				return a.level<b.level
			end
		end)
	return list
end


return socialTools