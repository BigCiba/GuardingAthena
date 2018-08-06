function CourageMoment( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local cooldown = ability:GetSpecialValueFor("cooldown")
	local chance = ability:GetSpecialValueFor("chance") + (100 - caster:GetHealthPercent()) * 0.4
	if HasExclusive(caster,4) then
		cooldown = cooldown * 0.5
	end
	local unitCount = #FindUnitsInRadius(teamNumber, caster_location, caster, 400, targetTeam, targetType, targetFlag, 0, false)
	chance = chance + unitCount
	if RollPercentage(chance) and ability:IsCooldownReady() then
		if caster:HasModifier("modifier_queen_curse") then
			cooldown = 0.5
			if HasExclusive(caster,4) then
				cooldown = cooldown * 0.5
			end
		end
		ability:StartCooldown(cooldown)
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_courage_moment_buff",nil)
	end
end
function CourageMomentHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.DamageTaken
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local refresh_chance = ability:GetSpecialValueFor("refresh_chance")
	local distance = 500
	if caster:HasModifier("modifier_war_god") then
		distance = 1000
		refresh_chance = refresh_chance * 2
	end
	local unitCount = #FindUnitsInRadius(teamNumber, caster_location, caster, 400, targetTeam, targetType, targetFlag, 0, false)
	refresh_chance = refresh_chance + unitCount
	if RollPercentage(refresh_chance) and not ability:IsCooldownReady() then
		ability:EndCooldown()
    	ability:ApplyDataDrivenModifier(caster,caster,"modifier_courage_moment_buff",nil)
    end	
	local startTime = GameRules:GetGameTime()
    local endTime = startTime + 1
    projVelocity = (target_location - caster_location):Normalized() * 1000
	local projID = ProjectileManager:CreateLinearProjectile( {
			Ability			 	= ability,
			EffectName		  	= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
			vSpawnOrigin		= caster_location,
			fDistance		   	= distance,
			fStartRadius		= 200,
			fEndRadius		  	= 200,
			Source			  	= caster,
			bHasFrontalCone	 	= false,
			bReplaceExisting	= false,
			iUnitTargetTeam	 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType	 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime		 	= endTime,
			bDeleteOnHit		= false,
			vVelocity		   	= projVelocity,
			bProvidesVision	 	= true,
			iVisionRadius	   	= 200,
			iVisionTeamNumber   = caster:GetTeamNumber(),
		} )
	Timers:CreateTimer(5,function (  )
        ProjectileManager:DestroyLinearProjectile(projID)
    end)
end
function CourageMomentDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("base_damage")
	if caster:HasModifier("modifier_war_god") then
		damage = damage * 2
	end
	local heal = keys.heal * 0.01 * damage
	local damageType = ability:GetAbilityDamageType()
	Heal( caster, heal)
	CauseDamage(caster, target, damage, damageType, ability)
end
function AbilityCoolDownSetting( keys )
	local ability = keys.ability
	ability.cooldown_reduce = false
end
function QueenCurseEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local duration = 3
	local radius = ability:GetSpecialValueFor("radius")
	if caster:HasModifier("modifier_war_god") then
		radius = radius * 2
	end
	if HasExclusive(caster,2) then
		duration = 6
	end
	local time = 0
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	Timers:CreateTimer(function (  )
		if time < duration then
			local unitGroup = FindUnitsInRadius(teamNumber, caster_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
			for k,v in pairs(unitGroup) do
				ability:ApplyDataDrivenModifier(caster,v,"modifier_queen_curse_debuff",{duration = 0.1})
			end
			time = time + 0.03
			return 0.03
		end
	end)
	local p1 = CreateParticle("particles/units/queen_curse.vpcf",PATTACH_ABSORIGIN,caster,duration)
	ParticleManager:SetParticleControl( p1, 7, Vector(radius,1,1))
end
function QueenCurse( keys )
	local caster = keys.caster
	local target = keys.target
	target:SetForceAttackTarget(caster)
end
function QueenCurseRemove( keys )
	local caster = keys.caster
	local target = keys.target
	target:SetForceAttackTarget(nil)
end
function WarGod( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local damage = caster:GetAverageTrueAttackDamage(caster)
	local chance = ability:GetSpecialValueFor("chance")
	local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
	if RollPercentage(chance) then
		CauseDamage(caster,target,damage,DAMAGE_TYPE_PHYSICAL,ability)
		local ability_2 = caster:FindAbilityByName("courage_moment")
		local table = {caster = caster,target = target,ability = ability_2,DamageTaken = 0}
		CourageMomentHit(table)
	end
end
function WarGodStr( keys )
	local caster = keys.caster
	local str = caster:GetBaseStrength() * keys.ability:GetSpecialValueFor("str_percent")
	PropertySystem(caster,DOTA_ATTRIBUTE_STRENGTH,str,5)
	if HasExclusive(caster,1) then
		ClearBuff(caster,"debuff")
	end
end
function WarGodKill( keys )
	local caster = keys.caster
	caster:SetBaseStrength(caster:GetBaseStrength() + 0.24)
end
function WarGodActive( keys )
	local caster = keys.caster
	local ability_1 = caster:FindAbilityByName("queen_curse")
	local ability_2 = caster:FindAbilityByName("war_arua")
	ability_1:EndCooldown()
	ability_2:EndCooldown()
	keys.ability:ApplyDataDrivenModifier(caster,caster,"modifier_war_god",nil)
end
function WarAuraActivity( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local unitCount = #FindUnitsInRadius(teamNumber, caster_location, caster, 400, targetTeam, targetType, targetFlag, 0, false)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_war_arua_caster",nil)
	caster:SetModifierStackCount("modifier_war_arua_caster",caster,unitCount)
	local hp_percent = 0.8
    local damagetaken = caster:GetHealth() * hp_percent
	caster:SetHealth(caster:GetHealth() - damagetaken)
	local ability_2 = caster:FindAbilityByName("war_honor")
    local table = {caster=caster,ability=ability_2,DamageTaken=damagetaken}
    WarHonor(table)
end
function WarHonor( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.DamageTaken
	local hp_percent = 0.5
	if caster:HasModifier("modifier_war_god") then
		return
	end
	if HasExclusive(caster,3) then
		hp_percent = 0.3
	end
	if ability.damage then
		ability.damage = ability.damage + damage
		if ability.damage > caster:GetMaxHealth() * hp_percent then
			local ability_2 = caster:FindAbilityByName("war_god")
			if ability_2:GetLevel() >= 1 then
				ability_2:ApplyDataDrivenModifier(caster,caster,"modifier_war_god",nil)
			end
		end
		Timers:CreateTimer(2,function (  )
			ability.damage = ability.damage - damage
		end)
	else
		ability.damage = 0
	end
end