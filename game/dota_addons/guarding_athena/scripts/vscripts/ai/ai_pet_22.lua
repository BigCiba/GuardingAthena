require( "ai/ai_core" )

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	tAbility = {
		{hAbility = thisEntity:FindAbilityByName( "pet_22_1" ), tCondition = {iTarget = 1}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_2" ), tCondition = {}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_3" ), tCondition = {iTarget = 10}, fAction = CastNoTarget},
		{hAbility = thisEntity:FindAbilityByName( "pet_22_4" ), tCondition = {iTarget = 1}, fAction = CastNoTarget},
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