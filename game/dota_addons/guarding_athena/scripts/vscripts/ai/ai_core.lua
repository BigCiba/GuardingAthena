function RandomEnemyInRange( hUnit, flRadius )
	local tTargets = FindUnitsInRadius(hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, flRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #tTargets > 0 then
		local index = RandomInt( 1, #tTargets )
		return tTargets[index]
	else
		return nil
	end
end
function ClosestEnemyInRange( entity, range )
	local tTargets = FindUnitsInRadius( DOTA_TEAM_BADGUYS, entity:GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	return IsValid(tTargets[1]) and tTargets[1] or nil
end
function WeakestEnemyInRange( entity, range )
	local tTargets = FindUnitsInRadius(hUnit:GetTeamNumber(), hUnit:GetAbsOrigin(), nil, flRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	if #tTargets > 0 then
		table.sort(tTargets, function(a, b)
			return a:GetHealth() < b:GetHealth()
		end)
		return tTargets[1]
	else
		return nil
	end
end

function AdvancedRandomVector( MaxLength, MinLength, vAwayFromVec, vAwayFromDist )
	local vCandidate = nil
	repeat
		vCandidate = RandomVector(1):Normalized()*RandomFloat(MinLength,MaxLength)
	until (vAwayFromVec == nil or vAwayFromDist == nil) or ( (vAwayFromVec - vCandidate):Length2D() > vAwayFromDist )
	return vCandidate
end

function CastPosition(hUnit, hAbility, vPosition)
	ExecuteOrder(hUnit, DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, vPosition)
end
function CastTarget(hUnit, hAbility, hTarget)
	ExecuteOrder(hUnit, DOTA_UNIT_ORDER_CAST_TARGET, hTarget, hAbility)
end
function CastNoTarget(hUnit, hAbility)
	ExecuteOrder(hUnit, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAbility)
end
function MoveOrder( hUnit, vPosition )
	ExecuteOrder(hUnit, DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, vPosition)
end
function IsFullyCastable(hUnit, hAbility)
	local bCastable = true
	if not hAbility:IsFullyCastable() or hUnit:IsChanneling() then
		bCastable = false
	end
	return bCastable
end
function CreateAIAbilityInfo(hAbility, tCondition, fAction)
	return {
		hAbility = hAbility,
		tCondition = tCondition,
		fAction = fAction
	}
end
function GetRandomCastableAbility(hUnit, tAbility)
	local tCastableAbility = {}
	for i, v in ipairs(tAbility) do
		if IsFullyCastable(hUnit, v.hAbility) then
			local bCondition = true
			for sCondition, iThreshold in pairs(v.tCondition) do
				if sCondition == "iTarget" then
					local tTargets = FindUnitsInRadiusWithAbility(hUnit, hUnit:GetAbsOrigin(), hUnit:GetAcquisitionRange(), v.hAbility)
					if #tTargets < iThreshold then
						bCondition = false
						break
					end
				elseif sCondition == "iHealth" then
					if hUnit:GetHealthPercent() > iThreshold then
						bCondition = false
						break
					end
				end
			end
			if bCondition then
				table.insert(tCastableAbility, v)
			end
		end
	end
	if #tCastableAbility > 0 then
		return GetRandomElement(tCastableAbility)
	end
	return false
end