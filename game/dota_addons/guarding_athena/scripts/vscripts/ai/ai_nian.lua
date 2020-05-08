require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4_2" ), fCondition = EnemyCountInRange, args = {1}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4_3" ), fCondition = EnemyCount, args = {1}, fAction = CastPosition},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4_4" ), fCondition = EnemyCount, args = {1}, fAction = CastPosition},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4_5" ), fCondition = EnemyCountInRange, args = {1}, fAction = CastPosition},
	}

	thisEntity:GameTimer(0, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end

	local hAbilityInfo = GetRandomCastableAbility(thisEntity, tAbility)
	if hAbilityInfo then
		if hAbilityInfo.hAbility:GetAbilityName() == "pet_22_4_2" then
			hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility)
		elseif hAbilityInfo.hAbility:GetAbilityName() == "pet_22_4_5" then
			local tTarget = RandomEnemyInRange( thisEntity, hAbilityInfo.hAbility:GetSpecialValueFor("radius") )
			if IsValid(tTarget) then
				hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility, tTarget:GetAbsOrigin())
			end
		else
			local tTarget = RandomEnemyInRange( thisEntity, hAbilityInfo.hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil) )
			if IsValid(tTarget) then
				hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility, tTarget:GetAbsOrigin())
			end
		end
	end
	return 1
end

function EnemyCount(hAbility, iCount)
	local flCastRange = hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), flCastRange, hAbility)
	if #tTargets > iCount then
		return true
	end
	return false
end

function EnemyCountInRange(hAbility, iCount)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), hAbility:GetSpecialValueFor("radius"), hAbility)
	if #tTargets > iCount then
		return true
	end
	return false
end