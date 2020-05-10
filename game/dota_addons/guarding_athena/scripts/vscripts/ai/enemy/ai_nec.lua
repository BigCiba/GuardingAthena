require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "soulsteal" ), fCondition = EnemyCount, args = {1}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "death_change" ), fCondition = EnemyCount, args = {1}, fAction = CastTarget},
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

function EnemyCount(hAbility, iCount)
	local flCastRange = hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil), hAbility)
	if #tTargets >= iCount then
		return true
	end
	return false
end