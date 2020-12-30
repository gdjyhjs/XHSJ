-- 协议接收测试


local tr = {}

function tr:get_chapter_info_r(chapter)
	local msg = {
		copyInfo = {
			[10001] = {copyId = 10001, star = 2, challenge = 2}
		},
		getReward = {1,},
	}

	Net:receive( msg, Net:get_id1("copy"), Net:get_id2("copy", "GetChapterInfoR"), chapter )
end

function tr:open_chapter_box_r()
	Net:receive( {err = 0}, Net:get_id1("copy"), Net:get_id2("copy", "OpenChapterBoxR"), 0 )
end

return tr