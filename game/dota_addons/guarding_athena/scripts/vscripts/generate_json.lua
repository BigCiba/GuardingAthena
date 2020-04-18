json = require("game/dkjson")

function firstToUpper(str)
	return (str:gsub("^%l", string.upper))
end

function KvToJson(sKvName, tTable)
	local filePath = ContentDir..AddonName.."\\panorama\\scripts\\kv\\"..sKvName..".js"
	local file = io.open(filePath, 'w')

	local str = json.encode(tTable)

	str = string.gsub(str, "'", "\\'")

	file:write("const "..sKvName.."_json".." = \'"..str.."\';")
	file:write("\n")
	file:write("const "..sKvName.." = JSON.parse("..sKvName.."_json);")

	file.close()
end