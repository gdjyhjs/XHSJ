--[[--
* 时间通用全局方法类
* 
* @Author:      Seven
* @DateTime:    2017-03-09 21:20:16
]]

--秒数转化为00：00：00格式
function gf_convert_time(num)
    num = num or 0
	local s = num%60
	local m = (math.floor(num/60))%60
	local h = math.floor(num/3600)
    if s == 60 then
        s =0
        m = m+1
    end
	local str = string.format("%02d:%02d:%02d",h,m,s)
	return str
end
--秒数转化为00：00格式
function gf_convert_time_ms(num)
    num = num or 0
    local s = num%60
    local m = (math.floor(num/60))
    if s == 60 then
        s =0
        m = m+1
    end
    local str = string.format("%02d:%02d",m,s)
    return str
end
function gf_convert_time_hm(num)
    num = num or 0
    local m = (math.floor(num/60))%60
    local h = math.floor(num/3600)
    local str = string.format("%02d:%02d",h,m)
    return str
end
--秒数转化为xx分钟xx秒格式
function gf_convert_time_ms_ch(num)
    num = num or 0
    local s = num%60
    local m = math.floor(num/60)
    local str = string.format( gf_localize_string("%d分钟%d秒"),m,s)
    return str
end
-- 分钟、小时、天
--@over_covert  超过7天是否要覆盖
function gf_convert_time_dhm_ch(num,over_covert)
    num = num or 0
    local m = (math.floor(num/60))%60
    local h = (math.floor(num/3600))%24
    local d =  math.floor(num/86400)
    if over_covert then
        d = d > 7 and 7 or d
    end
    local str = d > 0 and string.format(gf_localize_string("%d天前"),d) or h > 0 and string.format(gf_localize_string("%d小时前"),h) or string.format(gf_localize_string("%d分钟前"),m)

    return str
end
--秒数转化为 0d :00：00：00格式 或 00：00：00格式
function gf_convert_timeEx(num) 
    num = num or 0
    if num >= 86400 then
        local s = num%60
        local m = (math.floor(num/60))%60
        local h = (math.floor(num/3600))%24
        local d =  math.floor(num/86400)
        return string.format("%dd %02d:%02d:%02d",d,h,m,s)
    end
    return gf_convert_time(num)
end

-- 通过时间搓获取时间
function gf_get_time_stamp(t)
    return os.date("%Y-%m-%d %H:%M:%S",t)
end

--获取2个时间戳的时间间隔
function gf_time_diff(long_time,short_time)  
    local n_short_time,n_long_time,carry,diff = os.date('*t',short_time),os.date('*t',long_time),false,{}  
    local colMax = {60,60,24,os.date('*t',os.time{year=n_short_time.year,month=n_short_time.month+1,day=0}).day,12,0}  
    n_long_time.hour = n_long_time.hour - (n_long_time.isdst and 1 or 0) + (n_short_time.isdst and 1 or 0)
    for i,v in ipairs({'sec','min','hour','day','month','year'}) do  
        diff[v] = n_long_time[v] - n_short_time[v] + (carry and -1 or 0)  
        carry = diff[v] < 0  
        if carry then  
            diff[v] = diff[v] + colMax[i]  
        end  
    end  
    return diff  
end

--获取服务器零点
function gf_get_server_zero_time()
    local timestamp = Net:get_server_time_s()
    --加一天再减一天 负数windows转出来为负数
    local t1970 = os.time({year = 1970,month = 1,day = 1 + 1,hour = 0,minute = 0,second = 0}) - 24 * 60 * 60
    local left_time = (timestamp - t1970) % (24 * 60 * 60)
    local zero_time = timestamp - left_time
    return zero_time
end