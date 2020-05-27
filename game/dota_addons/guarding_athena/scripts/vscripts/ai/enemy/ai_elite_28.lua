require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "elite_28_1" ), fCondition = HealthPercent, args = {80}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "elite_28_2" ), fCondition = AllyCount, args = {1}, fAction = CastNoTarget},
	}

	thisEntity:GameTimer(0, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end

	local hAbilityInfo = GetRandomCastableAbility(thisEntity, tAbility)
	if hAbilityInfo then
		hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility)
	end
	return 1
end
function HealthPercent(hAbility, iPct)
	if thisEntity:GetHealthPercent() <= iPct then
		return true
	end
	return false
end
function AllyCount(hAbility, iCount)
	local tTargets = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if hUnit:GetUnitName() == "wave_28" then
			return true
		end
	end
	return false
end