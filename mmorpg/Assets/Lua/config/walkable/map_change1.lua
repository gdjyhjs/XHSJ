

function writefile(path, content, mode)
  mode = mode or "w+"
  local file = io.open(path, mode)
  if file then
    if file:write(content) == nil then return false end
    io.close(file)
    return true
  else
    return false
  end
end

local mapFile = {
	["111101"] = {37, 172},
	["111201"] = {186, 52},
	["111301"] = {207, 104},
	["111401"] = {124, 304},
	["111501"] = {101, 193},
	["111601"] = {83, 107},
	["111701"] = {89, 16},
	["111801"] = {47, 34},
	["120101"] = {8, 80},
	["120102"] = {34, 13},
	["120103"] = {139, 50},
	["120104"] = {104, 169},
	["120105"] = {61, 20},
	["120201"] = {146, 99},
	["120202"] = {67, 83},
	--["120203"] = {53, 28},
	["120401"] = {53, 28},
	["120501"] = {48, 30},
	["120701"] = {23, 4},
	["120801"] = {19, 8},
	["120901"] = {47, 20},
	["121001"] = {12, 2},
	["121101"] = {49, 26},
	["121201"] = {33, 22},
	["140101"] = {63, 32},
	--["140201"] = {8, 37},
	["140301"] = {62, 62},
	["140401"] = {41, 37},
	["150101"] = {142, 78},
	["150201"] = {65, 37},
	["150301"] = {37, 21},
	["160201"] = {38, 18},
}

local count = 0
for file, pos in pairs(mapFile) do
	count = count + 1
	local oldData = require(file)
	local srcX = pos[2]
	local srcY = pos[1]

	local newData = {}
	for i = 1, #oldData do
		for j = 1, #oldData[i] do
			if not newData[i] then
				newData[i] = {}
			end
			newData[i][j] = oldData[i][j]
		end
	end


	local tmpTable = {}
	local tmpIndex = 1
	tmpTable[tmpIndex] = {srcX, srcY}
	tmpIndex = tmpIndex + 1
	local nextKey = nil
	local nextValue = {}
	while next(tmpTable) do
		nextKey, nextValue = next(tmpTable)

		if newData[nextValue[1] + 1] and newData[nextValue[1] + 1][nextValue[2]] == 1 then -- 可行走区域右
			tmpTable[tmpIndex] = {nextValue[1] + 1, nextValue[2]}
			tmpIndex = tmpIndex + 1
		end
		if newData[nextValue[1] - 1] and newData[nextValue[1] - 1][nextValue[2]] == 1 then -- 可行走区域左
			tmpTable[tmpIndex] = {nextValue[1] - 1, nextValue[2]}
			tmpIndex = tmpIndex + 1
		end
		if newData[nextValue[1]] and newData[nextValue[1]][nextValue[2] + 1] == 1 then -- 可行走区域上
			tmpTable[tmpIndex] = {nextValue[1], nextValue[2] + 1}
			tmpIndex = tmpIndex + 1
		end
		if newData[nextValue[1]] and newData[nextValue[1]][nextValue[2] - 1] == 1 then -- 可行走区域下
			tmpTable[tmpIndex] = {nextValue[1], nextValue[2] - 1}
			tmpIndex = tmpIndex + 1
		end
		newData[nextValue[1]][nextValue[2]] = 2
		tmpTable[nextKey] = nil
	end


	local content = "return {\n"
	for i = 1, #newData do
		content = content.."\t{"
		for j = 1, #newData[i] do
			if newData[i][j] == 1 then
				newData[i][j] = 0
			elseif newData[i][j] == 2 then
				newData[i][j] = 1
			end

			content = content..tostring(newData[i][j])
			if j ~= #newData[i] then
				content = content..","
			end
		end

		content = content.."},\n"
	end

	content = content.."}"

	writefile("p_"..file..".lua", content)

	local newData2 = {}

	local index = 1
	for i = 1, #newData do
		index = 1
		for j = 1, #newData[i] do
			if not newData2[i] then
				newData2[i] = {}
			end

			newData2[i][index] = (newData2[i][index] or 0) + math.pow(2, (j - 1) % 32) * newData[i][j]
			if j % 32 == 0 then
				index = index + 1
			end
		end
	end

	content = "return {\n"
	for i = 1, #newData2 do
		content = content.."\t{"
		for j = 1, #newData2[i] do
			content = content..tostring(newData2[i][j])
			if j ~= #newData2[i] then
				content = content..", "
			end
		end

		content = content.."},\n"
	end

	content = content.."}"

	writefile("t_"..file..".lua", content)
	print(count)
end



