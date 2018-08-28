function FracturedSoul( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local cooldown = 1
	if HasExclusive(caster,2) then
		cooldown = 0.5
	end
	if caster:HasModifier("modifier_fractured_soul_buff") then
		local stackcount = caster:GetModifierStackCount("modifier_fractured_soul_buff", caster) + 1
		if stackcount <= caster:GetBaseStrength() then
			caster:SetModifierStackCount("modifier_fractured_soul_buff", caster, stackcount)
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_fractured_soul_buff", nil)
		caster:SetModifierStackCount("modifier_fractured_soul_buff", caster, 1)
	end
	if not ability:IsCooldownReady() then return end
	local target_location = target:GetAbsOrigin()
	local damage = caster:GetStrength() * 5
	local damageType = ability:GetAbilityDamageType()
	local radius = 250
	local unitGroup = GetUnitsInRadius(caster,ability,target_location,radius)
	ability:StartCooldown(cooldown)
	CauseDamage(caster, unitGroup, damage, damageType,ability)
	local p1 = CreateParticle( "particles/heroes/tartarus/fractured_soul.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, target_location )
	EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
end
function OnAttackLanded( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	if HasExclusive(caster,2) then
		FracturedSoul({caster=caster,unit=target,ability=ability})
	end
end
function HellField( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local damage = keys.Damage * 0.2 * caster:GetStrength() + ability:GetSpecialValueFor("base_damage")
	local damageType = ability:GetAbilityDamageType()
	local damageDeep = ability:GetSpecialValueFor("bonus_damage_percent")
	local radius = 900
	local time = 0
	local p2 = CreateParticle( "particles/skills/hell_field_hellborn.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p2, 0, caster_location )
	ParticleManager:SetParticleControl( p2, 1, Vector(900, 2, 5) )
	Timers:CreateTimer(function()
		if time <= 80 then
			for i=1,2 do
				local p3 = CreateParticle( "particles/skills/hell_field_hand.vpcf", PATTACH_ABSORIGIN, caster )
				randompoint = GetRandomPoint(caster_location,0,800)
				ParticleManager:SetParticleControl( p3, 0, randompoint )
				ParticleManager:SetParticleControl( p3, 1, randompoint )
			end
			local point = caster:GetAbsOrigin()
			local length = (point - caster_location):Length2D()
			if length <= 900 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_hell_field_buff", nil)
			end
			local unitGroup = GetUnitsInRadius(caster,ability,caster_location,radius)
			for k, v in pairs( unitGroup ) do
				ability:ApplyDataDrivenModifier(caster, v, "modifier_hell_field_debuff", nil)
				SetUnitIncomingDamageDeepen(v,damageDeep,0.2)
				CauseDamage(caster, v, damage, damageType, ability)
			end
			time = time + 1
			return 0.2
		else		
			ParticleManager:DestroyParticle(p2,false)
		end
	end)
end
function DestoryHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local direction = caster:GetForwardVector()
	local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength() + ability:GetSpecialValueFor("base_damage")
	local duration = ability:GetSpecialValueFor("duration")
	local damageReduce = -ability:GetSpecialValueFor("reduce_damage")
	local damageType = ability:GetAbilityDamageType()
	local radius = 300
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local point = caster_location + direction * 300
	local time = 0
	Timers:CreateTimer(function()
		if time < 3 then
			local p1 = CreateParticle( "particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( p1, 0, point )
			local point_1 = point
			Timers:CreateTimer(0.8,function()
				local p2 = CreateParticle( "particles/heroes/tartarus/destory_hit.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( p2, 0, point_1 )
				local unitGroup = FindUnitsInRadius(teamNumber, point_1, caster, radius, targetTeam, targetType, targetFlag, 0, false)
				for k, v in pairs( unitGroup ) do
					CauseDamage(caster, v, damage, damageType, ability)
					if v:HasModifier("modifier_destory_hit") then
						local stackcount = v:GetModifierStackCount("modifier_destory_hit", caster)
						ability:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 3})
						v:SetModifierStackCount("modifier_destory_hit", caster, stackcount + 1)
						SetUnitDamagePercent(v,damageReduce,duration-0.1)
					else
						ability:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 3})
						v:SetModifierStackCount("modifier_destory_hit", caster, 1)
						SetUnitDamagePercent(v,damageReduce,duration-0.1)
					end
				end
				EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
			end)
			point = point + direction * 300
			time = time + 1
			return 0.2
		end
	end)
end
function DestoryHitUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local direction = caster:GetForwardVector()
	local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength() + ability:GetSpecialValueFor("base_damage")
	local duration = ability:GetSpecialValueFor("duration")
	local damageReduce = -ability:GetSpecialValueFor("reduce_damage")
	local damageType = ability:GetAbilityDamageType()
	local radius = 300
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local point = caster_location + direction * 300
	local time = 0
	local p1 = CreateParticle( "particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, point )
	Timers:CreateTimer(0.8,function()
		if time < 9 then
			local point_circle = GetRandomPoint(point, 0, 300)
			local p2 = CreateParticle( "particles/heroes/tartarus/destory_hit.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControl( p2, 0, point_circle )
			local unitGroup = FindUnitsInRadius(teamNumber, point_circle, caster, radius, targetTeam, targetType, targetFlag, 0, false)
			for k, v in pairs( unitGroup ) do
				CauseDamage(caster, v, damage, damageType, ability)
				if v:HasModifier("modifier_destory_hit") then
					local stackcount = v:GetModifierStackCount("modifier_destory_hit", caster)
					ability:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 3})
					v:SetModifierStackCount("modifier_destory_hit", caster, stackcount + 1)
					SetUnitDamagePercent(v,damageReduce,duration)
				else
					ability:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 3})
					v:SetModifierStackCount("modifier_destory_hit", caster, 1)
					SetUnitDamagePercent(v,damageReduce,duration)
				end
			end
			EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
			time = time + 1
			return 0.1
		end
	end)
end
function OnToggleOn( t )
	local caster= t.caster
	local ability = t.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_infernal_fire_magic", nil)
	if not HasExclusive(caster,1) then
		caster:RemoveModifierByName("modifier_infernal_fire_physics")
		caster:RemoveModifierByName("modifier_infernal_fire_physics_buff")
	end
end
function OnToggleOff( t )
	local caster= t.caster
	local ability = t.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_infernal_fire_physics", nil)
	caster:RemoveModifierByName("modifier_infernal_fire_magic")
end
function InfernalFirePhysics( keys )	
	local caster = keys.caster
	local ability = keys.ability
	local attack = ability:GetSpecialValueFor("attack")
	if not caster:HasModifier("modifier_fractured_soul_buff") then
		return
	end
	caster:SetRangedProjectileName("particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation.vpcf")
	local buffcount = caster:GetStrength()
	if caster:HasModifier("modifier_infernal_fire_physics_buff") then
		caster:SetModifierStackCount("modifier_infernal_fire_physics_buff", caster, buffcount * attack)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_infernal_fire_physics_buff", nil)
		caster:SetModifierStackCount("modifier_infernal_fire_physics_buff", caster, buffcount * attack)
	end
end
function InfernalFireMagic( keys )	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damageType = ability:GetAbilityDamageType()
	local attack = ability:GetSpecialValueFor("attack") * 2
	if not caster:HasModifier("modifier_fractured_soul_buff") then
		return
	end
	caster:SetRangedProjectileName("particles/heroes/tartarus/infernal_fire_desolator.vpcf")
	local buffcount = caster:GetStrength()
	local damage = buffcount * attack
	CauseDamage(caster, target, damage, damageType, ability)
end
function SoulRequiemChannel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local radius = 1200
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local unitGroup = FindUnitsInRadius(teamNumber, caster_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
	local p1 = CreateParticle( "particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", PATTACH_ABSORIGIN, caster )
	local times = 0
	Timers:CreateTimer(function()
		if times < 20 then
			for _,unit in ipairs(unitGroup) do
		        local unit_location = unit:GetAbsOrigin()
		        local vector_distance = caster_location - unit_location
		        local distance = (vector_distance):Length2D()
		        local direction = (vector_distance):Normalized()
		        local speed = distance / 30
				unit:SetAbsOrigin(unit_location + direction * speed)
				unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_soul_requiem_debuff", {duration=0.2})
		    end
		    times = times + 1
			return 0.1
		else
			ParticleManager:DestroyParticle(p1,false)
		end
	end)
end
function SoulRequiem( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local angle = 0
	local point = GetRotationPoint(caster_location, 1200, angle)
	local vector = (point - caster_location):Normalized() * 1200
	local num = -1
	local abilityName = "destory_hit"
	if HasExclusive(caster,3) then
		abilityName = "destory_hit_up"
	end
	local damage = caster:FindAbilityByName(abilityName):GetSpecialValueFor("damage")
	local damageType = ability:GetAbilityDamageType()
	local radius = 300
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	for i=1,24 do
		local p1 = CreateParticle( "particles/heroes/tartarus/soul_requiem_ofsouls_line.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( p1, 0, caster_location )
		ParticleManager:SetParticleControl( p1, 1, vector )
		ParticleManager:SetParticleControl( p1, 2, Vector(0,1,0) )
		ParticleManager:SetParticleControl( p1, 3, point )
		local startTime = GameRules:GetGameTime()
    	local endTime = startTime + 2
		ability.endTime = endTime
		local projID = ProjectileManager:CreateLinearProjectile( {
	        Ability             = ability,
	        EffectName          = "",
	        vSpawnOrigin        = caster_location,
	        fDistance           = 1200,
	        fStartRadius        = 200,
	        fEndRadius          = 200,
	        Source              = caster,
	        bHasFrontalCone     = false,
	        bReplaceExisting    = false,
	        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        iUnitTargetFlags    = DOTA_UNIT_TARGET_FLAG_NONE,
	        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        fExpireTime         = endTime,
	        bDeleteOnHit        = false,
	        vVelocity           = vector,
	        bProvidesVision     = true,
	        iVisionRadius       = 0,
	        iVisionTeamNumber   = caster:GetTeamNumber(),
	    } )
		angle = angle + 15
		point = GetRotationPoint(caster_location, 1200, angle)
		vector = (point - caster_location):Normalized() * 1200
		if num == -1 and HasExclusive(caster,4) then
			local skill = caster:FindAbilityByName(abilityName)
			local vector_2 = (point - caster_location):Normalized()
			local point = caster_location + vector_2 * 300
			local time = 0
			Timers:CreateTimer(function()
				if time < 3 then
					local p1 = CreateParticle( "particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
					ParticleManager:SetParticleControl( p1, 0, point )
					local point_1 = point
					Timers:CreateTimer(0.8,function()
						local p2 = CreateParticle( "particles/heroes/tartarus/destory_hit.vpcf", PATTACH_CUSTOMORIGIN, caster )
						ParticleManager:SetParticleControl( p2, 0, point_1 )
						local unitGroup = FindUnitsInRadius(teamNumber, point_1, caster, radius, targetTeam, targetType, targetFlag, 0, false)
						for k, v in pairs( unitGroup ) do
							CauseDamage(caster, v, damage * caster:GetStrength(), damageType, ability)
							if v:HasModifier("modifier_destory_hit") then
								local stackcount = v:GetModifierStackCount("modifier_destory_hit", caster)
								skill:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 12})
								v:SetModifierStackCount("modifier_destory_hit", caster, stackcount + 1)
								SetUnitDamagePercent(v,(stackcount + 1) * -30,12)
							else
								skill:ApplyDataDrivenModifier(caster, v, "modifier_destory_hit", {duration = 6})
								v:SetModifierStackCount("modifier_destory_hit", caster, 1)
								SetUnitDamagePercent(v,-30,6)
							end
						end
						EmitSoundOn("Hero_Nevermore.Shadowraze", caster)
					end)
					point = point + vector_2 * 300
					time = time + 1
					return 0.2
				end
			end)
		end
		num = num * -1
	end
end
function SoulRequiemDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetStrength() * ability:GetSpecialValueFor("damage")
	--print(ability:GetSpecialValueFor("damage"))
	local damageType = ability:GetAbilityDamageType()
	CauseDamage(caster, target, damage, damageType, ability)
	--[[local caster_location = caster:GetAbsOrigin()
	local endTime = ability.endTime
	local duration = math.floor((endTime - GameRules:GetGameTime()) * 10)
	local times = 0
	Timers:CreateTimer(function()
		if times < duration then
	        local target_location = target:GetAbsOrigin()
	        local vector_distance = target_location - caster_location
	        local distance = 1200 - (vector_distance):Length2D()
	        local direction = (vector_distance):Normalized()
	        local speed = 1800 / vector_distance:Length2D()
	        local target_point = target_location + direction * speed
	        if GridNav:CanFindPath(target_location,target_point) then
				target:SetAbsOrigin(target_location + direction * speed)
				target:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
				ability:ApplyDataDrivenModifier(caster, target, "modifier_soul_requiem_debuff", {duration=0.2})
			end
		    times = times + 1
			return 0.1
		end
	end)]]--
end
function OnExclusiveCreated( t )
	local caster = t.caster
	caster.destory_hit_up_timer = Timers:CreateTimer(function ()
		if HasExclusive(caster,3) then
			local ability = caster:FindAbilityByName("destory_hit")
			if ability then
				new_ability = caster:AddAbility("destory_hit_up")
				new_ability:SetLevel(ability:GetLevel())
				caster:SwapAbilities(ability:GetAbilityName(), new_ability:GetAbilityName(), false, true)
				caster:RemoveAbility("destory_hit")
			end
		else
			return 1
		end
	end)
end
function OnExclusiveDestory( t )
	local caster = t.caster
    local ability = caster:FindAbilityByName("destory_hit_up")
    if ability then
        new_ability = caster:AddAbility("destory_hit")
        new_ability:SetLevel(ability:GetLevel())
        caster:SwapAbilities(new_ability:GetAbilityName(), ability:GetAbilityName(), true, false)
        caster:RemoveAbility("destory_hit_up")
	end
	Timers:RemoveTimer(caster.destory_hit_up_timer)
end