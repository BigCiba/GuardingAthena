require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "poison_sting" ), fCondition = EnemyCount, args = {1}, fAction = CastTarget},
	}

	thisEntity:GameTimer(0, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end

	local hAbilityInfo = GetRandomCastableAbility(thisEntity, tAbility)
	if hAbilityInfo then
		local hTarget = RandomEnemyInRange( thisEntity, hAbilityInfo.hAbility:GetCastRange(vec3_invalid, nil) )
		if IsValid(hTarget) then
			hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility, hTarget)
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