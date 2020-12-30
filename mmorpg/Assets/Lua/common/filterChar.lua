-- local function utf8len(ch)  
--     if not ch then  
--         return -1  
--     end  
--     if ch < 0x80 then  
--         return 1  
--     elseif ch < 0xC0 then  
--         return -1  
--     elseif ch < 0xE0 then  
--         return 2  
--     elseif ch < 0xF0 then  
--         return 3  
--     elseif ch < 0xF8 then  
--         return 4  
--     elseif ch < 0xFC then  
--         return 5  
--     elseif ch < 0xFE then  
--         return 6  
--     else  
--         return -1
--     end  
-- end  
  
-- local function getutf8tbl(input)  
--     if not input then  
--         return nil, nil  
--     end  
--     local tbl = {}  
--     local tbllen = {}  
--     local len = #input  
--     local i = 1  
--     while i <= len do  
--         local j = utf8len(string.byte(string.sub(input, i, i)))  
--         if j <= 0 or i + j - 1 > len then  
--             return nil, nil  
--         end  
--         table.insert(tbl, string.sub(input, i, i + j - 1))  
--         table.insert(tbllen, j)  
--         i = i + j  
--     end  
--     return tbl, tbllen  
-- end  
  
-- local data = {}  
-- local maxlen = 0  
-- local firstword = {}  
-- for i,v in ipairs(ConfigMgr:get_config( "filter_char" )) do
-- -- for i,v in ipairs({}) do
--     local char = v.char
--     local len = string.len(char)  
--     if data[len] == nil then  
--         data[len] = {}  
--     end  
--     data[len][char] = true  
--     if len > maxlen then  
--         maxlen = len  
--     end  
--     local wordlen = utf8len(string.byte(string.sub(char, 1, 1)))  
--     if wordlen > 0 then  
--         firstword[string.sub(char, 1, wordlen)] = true  
--     end  
-- end  
-- -- 检查是否包含屏蔽字
-- function checkChar(str)
--     local tbl, tbllen = getutf8tbl(str)  -- 得到字符
--     if not tbl then  
--         print(str .. " 输入无效")
--         return 
--     end  
--     local count = 0  
--     local len = #tbl  
--     for i = 1, len do  
--         local wordlen = 0  
--         if tbl[i] ~= '*' and firstword[tbl[i]] then
--             for j = 1, len - i + 1 do  
--                 wordlen = wordlen + tbllen[i + j -1]  
--                 if wordlen > maxlen then --optimization  
--                     break
--                 end  
--                 local t = data[wordlen]  
--                 if t then
--                     local word = table.concat(tbl, nil, i, i + j - 1)  
--                     count = count + 1  
--                     if t[word] then 
--                         return true
--                     end  
--                 end  
--             end  
--         end  
--     end
--     return
-- end
-- for i,v in ipairs(table_name) do
--     print(i,v)
-- end
-- -- 屏蔽字自动替换*
-- function filterChar(str)
--     local tbl, tbllen = getutf8tbl(str)  -- 得到字符
--     if not tbl then  
--         print(str .. " 输入无效")
--         return 
--     end  
--     local count = 0  
--     local len = #tbl  
--     for i = 1, len do  
--         local wordlen = 0  
--         if tbl[i] ~= '*' and firstword[tbl[i]] then
--             for j = 1, len - i + 1 do  
--                 wordlen = wordlen + tbllen[i + j -1]  
--                 if wordlen > maxlen then --optimization  
--                     break  
--                 end  
--                 local t = data[wordlen]  
--                 if t then  
--                     local word = table.concat(tbl, nil, i, i + j - 1)  
--                     count = count + 1  
--                     if t[word] then  
--                         for k = i, i + j - 1 do  
--                             tbl[k] = '*'  
--                         end  
--                         break  
--                     end  
--                 end  
--             end  
--         end  
--     end
--     return table.concat(tbl)
-- end

--判断名字是否包含违规符号
function nameHasViolationSymbol(str)
    local char = string.find(str,"[#%%%^%$&%*%(%)%-%+%.%?%{%}%[%]%s%/\226]") -- \226 p
    if char then
        return char
    end
    -- local other_char = string.find(str,"[]") -- "[%z\1-\127\194-\244][\128-\191]*"
    -- if other_char then
    --     return other_char
    -- end
end

-- 屏蔽字自动替换*
function filterChar(str)
    local t = ConfigMgr:get_config("filter_char")
    for i,v in ipairs(t) do
        str = string.gsub(str,v.char,"*")
    end
    return str
end

-- 检查是否包含屏蔽字
function checkChar(str)
    local t = ConfigMgr:get_config("filter_char")
    for i,v in ipairs(t) do
        if string.find(str,v.char) then
            return true
        end
    end
    return nameHasViolationSymbol(str)
end