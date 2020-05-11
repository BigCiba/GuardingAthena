require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "hades_1" ), fCondition = EnemyCount, args = {1}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "hades_3" ), fCondition = EnemyCount, args = {1}, fAction = CastTarget},
		{hAbility = thisEntity:FindAbilityByName( "hades_4" ), fCondition = EnemyCount, args = {1}, fAction = CastTarget},
	}

	thisEntity:GameTimer(0, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end

	local hAbilityInfo = GetRandomCastableAbility(thisEntity, tAbility)
	if hAbilityInfo then
		if hAbilityInfo.hAbility:GetAbilityName() == "soulsteal" then
			hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility)
		else
			local hTarget = WeakestEnemyInRange( thisEntity, hAbilityInfo.hAbility:GetCastRange(vec3_invalid, nil) )
			if IsValid(hTarget) then
				hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility, hTarget)
			end
		end
	end
	return 1
end

function EnemyCount(hAbility, iCount)
	local flCastRange = hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), hAbility:GetCastRange(vec3_invalid, nil), hAbility)
	if #tTargets >= iCount then
		return true
	end
	return false
end