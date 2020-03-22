function Spawn( entityKeyValues )
	if IsServer() then
		PrintTable(entityKeyValues)
		if thisEntity == nil then
			return
		end
		thisEntity:SetContextThink( "AiThink", AiThink, 1 )
	end
end


function AiThink()
	if GameRules:IsGamePaused() == true then
		return 1
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 then
		return 1
	end
end