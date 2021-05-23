if Mechanics == nil then
	Mechanics = class({})
end
local public = Mechanics

local mechanics = {
	-- require("mechanics/pet"),
	require("mechanics/asset_modifiers"),
	require("mechanics/hero_demo"),
	require("mechanics/player_data"),
	require("mechanics/projectile_system"),
-- require("mechanics/spawner"),
}

local classes = {
	require("class/pet"),
}

function public:init(bReload)
	-- 初始化类
	for k, v in pairs(classes) do
		_G[k] = v
		if v.init ~= nil then v.init(bReload) end
	end

	-- 初始化系统
	for k, v in pairs(mechanics) do
		_G[k] = v
		if v.init ~= nil then v:init(bReload) end
	end
end

return public