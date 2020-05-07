require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "pet_22_2" ), fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_3" ), fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_1" ), fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4" ), fAction = CastNoTarget},
	}

	thisEntity:GameTimer(0, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end

	local hAbilityInfo = GetRandomCastableAbility(thisEntity, tAbility)
	if hAbilityInfo then
		hAbilityInfo.fAction(thisEntity, hAbilityInfo.hAbility)
	end
	return 0.5
end