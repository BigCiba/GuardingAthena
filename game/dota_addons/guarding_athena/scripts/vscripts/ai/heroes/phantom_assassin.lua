function Spawn(entityKeyValues)
	if not IsServer() then return end
	if thisEntity == nil then return end
end
--------------------------------------------------------------------------------
function Precache(context)
	if PrecacheResource == nil then return end
	local sUnitName = thisEntity:GetUnitName()
	local tSkinName = {
		"phantom_assassin_gold"
	}
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_"..string.sub(sUnitName, 15, string.len(sUnitName)), context )
	for i, sSkinName in ipairs(tSkinName) do
		PrecacheResource( "particle_folder", "particles/units/heroes/hero_"..string.sub(sUnitName, 15, string.len(sUnitName)).."/"..sSkinName, context )
	end
end