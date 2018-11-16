function OnCreated( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
		if not ability.damage_count then
			ability.damage_count = 0
		end
		if not ability.buff_count then
			ability.buff_count = 0
		end
		if not ability.absorb_count then
			ability.absorb_count = 0
		end
	elseif abilityIndex == 1 then
	elseif abilityIndex == 2 then
		ability.cooldown_reduce = false
		caster:SetModifierStackCount("modifier_revelater_cooldown",caster,3)
		ability.timer = nil
	elseif abilityIndex == 3 then
	elseif abilityIndex == 4 then
		ability.absorb = 0
		local interval = 0.2
		if HasExclusive(caster,4) then
			interval = 0.1
		end
		--[[if caster.gift then
			ability.particle = CreateParticle("particles/heroes/revelater/revelater_trail_ultimate_gold.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,12)
	    else
	    	ability.particle = CreateParticle("particles/heroes/revelater/revelater_trail_ultimate.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,12)
	    end]]--
	    ability.particle = CreateParticle("particles/heroes/revelater/revelater_trail_ultimate.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,12)
		local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility() + ability:GetSpecialValueFor("base_damage")
		local radius = ability:GetSpecialValueFor("radius")
		local teamNumber = caster:GetTeamNumber()
		local targetTeam = ability:GetAbilityTargetTeam()
		local targetType = ability:GetAbilityTargetType()
		local targetFlag = ability:GetAbilityTargetFlags()
		local time = 0
		Timers:CreateTimer(function (  )
			if time < 12 then
				local caster_location = caster:GetAbsOrigin()
				local unitGroup = FindUnitsInRadius(teamNumber, caster_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
				for k,v in pairs(unitGroup) do
					if v:IsAlive() then
						CauseDamage(caster,v,damage,DAMAGE_TYPE_MAGICAL,ability)
						ability:ApplyDataDrivenModifier(caster,v,"modifier_revelater_4_stun",nil)
					end
				end
				CreateSound("Hero_TemplarAssassin.PsiBlade.Resonance",caster,0.8,nil)
				time = time + interval
				return interval
			end
		end)
	end
end
function OnDestroy( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
	elseif abilityIndex == 1 then
	elseif abilityIndex == 2 then
	elseif abilityIndex == 3 then
	elseif abilityIndex == 4 then
	end
end
function OnTakeDamage( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local damage = t.DamageTaken
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
		if caster:HasModifier("modifier_revelater_0_absorb") then
			if ability.absorb_count > 0 then
				ability.absorb_count = ability.absorb_count - 1
				if ability.absorb_count == 0 then
					ParticleManager:DestroyParticle(ability.particle_shield,false)
					caster:RemoveModifierByName("modifier_revelater_0_absorb")
				else
					ParticleManager:DestroyParticle(ability.particle_shield,false)
					ability.particle_shield = CreateParticle( "particles/heroes/revelater/revelater_shield_"..ability.absorb_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
				end
			end
		else
			if ability.damage_count < 6 then
				ability.damage_count = ability.damage_count + 1
			end
			if ability.damage_count >= 6 then
				if ability.buff_count < 3 then
					ability.damage_count = 0
					ability.buff_count = ability.buff_count + 1
					if ability.particle_orb then
						ParticleManager:DestroyParticle(ability.particle_orb,false)
					end
					ability.particle_orb = CreateParticle( "particles/heroes/revelater/revelater_orb_"..ability.buff_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
					--ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_0_buff",nil)
					--caster:SetModifierStackCount("modifier_revelater_0_buff",caster,ability.buff_count)
				end
			end
		end
	elseif abilityIndex == 4 then
		local absorb = ability:GetSpecialValueFor("damage_absorb") * damage
		Heal(caster,absorb,0,false)
	end
end
function OnAttackLanded( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local abilityIndex = ability:GetAbilityIndex()
	if abilityIndex == 1 then
		caster:RemoveModifierByName("modifier_revelater_attack")
	elseif abilityIndex == 3 then
		local damage = t.DamageTaken
		local armor = target:GetPhysicalArmorValue()
		local reduce = (armor * 0.06)/(1 + armor * 0.06)
		local initdamage = damage / (1 - reduce)
		CauseDamage(caster, target, initdamage, DAMAGE_TYPE_MAGICAL,ability)
	end
end
function OnDealDamage( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
end
function OnCastAbility( t )
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
		CastAbility0(t)
	elseif abilityIndex == 1 then
		CastAbility1(t)
	elseif abilityIndex == 2 then
		CastAbility2(t)
	elseif abilityIndex == 3 then
		CastAbility3(t)
	elseif abilityIndex == 4 then
	end
end
function OnProjectileHitUnit(t)
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 1 then
		--local fxIndex = CreateParticle( "particles/heroes/revelater/revelater_soul.vpcf", PATTACH_POINT, target )
		local targetHealth = target:GetHealth()
		local healthDash = targetHealth * 0.3
		local ability_4 = caster:FindAbilityByName("revelater_4")
		local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility() + healthDash + ability:GetSpecialValueFor("base_damage")
		if ability_4.absorb then
			damage = damage + ability_4.absorb
			ability_4.absorb = 0
		end
		--local realDamage = damage * (1 - target:GetMagicalArmorValue())
		CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL,ability)
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_attack",nil)
		caster:PerformAttack(target,true,true,true,false,false,false,true)
		SoulRegen(t,healthDash)
		local angle = ability:GetSpecialValueFor("angle") * 2
		local radius = 600
		if ability.bonus_distance then
			ability.bonus_distance = false
			radius = 900
			angle = angle * 1.5
		end
		local target_location = target:GetAbsOrigin()
		local forwardVector = (target:GetAbsOrigin() - caster.cast_location):Normalized()
		local unitGroup = GetUnitsInSector(caster,ability,target_location,forwardVector,angle,radius)
		--if realDamage < targetHealth then
			damage = damage + healthDash
		--end
		for k,v in pairs(unitGroup) do
			if v ~= target then
				local p0 = CreateParticle( "particles/heroes/revelater/revelater_cash_back.vpcf", PATTACH_CUSTOMORIGIN, caster )
				ParticleManager:SetParticleControl( p0, 0, target:GetAbsOrigin() + Vector(0,0,64))
				ParticleManager:SetParticleControl( p0, 1, v:GetAbsOrigin() + Vector(0,0,64))
				CauseDamage(caster,v,damage,DAMAGE_TYPE_MAGICAL,ability)
			end
		end
	elseif abilityIndex == 2 then
		local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility() + ability:GetSpecialValueFor("base_damage")
		CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL,ability)
	end
end
function OnIntervalThink( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = ability:GetAbilityIndex()
	if abilityIndex == 0 then
		if HasExclusive(caster,1) and ability.absorb_count < 3 then
			ability.absorb_count = ability.absorb_count + 1
			if ability.particle_orb then
				ParticleManager:DestroyParticle(ability.particle_orb,false)
			end
			ability.particle_orb = CreateParticle( "particles/heroes/revelater/revelater_orb_"..ability.buff_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			if ability.particle_shield then
				ParticleManager:DestroyParticle(ability.particle_shield,false)
			end
			ability.particle_shield = CreateParticle( "particles/heroes/revelater/revelater_shield_"..ability.absorb_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			--caster:SetModifierStackCount("modifier_revelater_0_buff",caster,ability.buff_count)
			ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_0_absorb",nil)
			CreateSound("Hero_TemplarAssassin.Refraction",caster)
		end
	end
end
function OnChannelFinish( t )
end
function OnRemoveModifier( t )
	-- 单位死亡，持续时间结束，主动触发
	local caster = t.caster
	local target = t.target
	local ability = t.ability
end
function SoulRegen( t,totalHealth )
	local caster = t.caster
	local target = t.target
	local ability = t.ability

	local attackspeed = math.floor(target:GetAttackSpeed() * 30)
	local movespeed = math.floor(target:GetBaseMoveSpeed() * 0.3)
	local damageInput = 30
	ability:ApplyDataDrivenModifier(caster,target,"modifier_revelater_attackspeed",nil)
	ability:ApplyDataDrivenModifier(caster,target,"modifier_revelater_movespeed",nil)
	ability:ApplyDataDrivenModifier(caster,target,"modifier_revelater_damage",nil)
	target:SetModifierStackCount("modifier_revelater_attackspeed",caster,attackspeed)
	target:SetModifierStackCount("modifier_revelater_movespeed",caster,movespeed)
	target:SetModifierStackCount("modifier_revelater_damage",caster,30)
	local attackspeedRegen = attackspeed / 50
	local movespeedRegen = movespeed / 50
	local damageInputRegen = damageInput / 50

	target.soul_count = 0
	target.totalHealth = totalHealth
	target.attackspeed = 0
	target.movespeed = 0
	target.damageInput = 0
	Timers:CreateTimer(function ()
		if target:IsAlive() then
			if target.soul_count < 50 then
				target.soul_count = target.soul_count + 1
				target.attackspeed = target.attackspeed + attackspeedRegen
				target.movespeed = target.movespeed + movespeedRegen
				target.damageInput = target.damageInput + damageInputRegen
				Heal(target,totalHealth * 0.02,0,false)
				target:SetModifierStackCount("modifier_revelater_attackspeed",caster,attackspeed - math.floor(target.attackspeed))
				target:SetModifierStackCount("modifier_revelater_movespeed",caster,movespeed - math.floor(target.movespeed))
				target:SetModifierStackCount("modifier_revelater_damage",caster,damageInput - math.floor(target.damageInput))
				return 0.1
			else
				target.soul_count = nil
				target.totalHealth = nil
				target:RemoveModifierByName("modifier_revelater_attackspeed")
				target:RemoveModifierByName("modifier_revelater_movespeed")
				target:RemoveModifierByName("modifier_revelater_damage")
			end
		end
	end)
end
function Cooldown( t )
	local caster = t.caster
	local ability = t.ability
	local stackcount = caster:GetModifierStackCount("modifier_revelater_cooldown",caster)
	if stackcount > 0 then
		ability:EndCooldown()
		caster:SetModifierStackCount("modifier_revelater_cooldown",caster,stackcount - 1)
	else
		ability:EndCooldown()
		ability:StartCooldown(4)
	end
	if ability.timer == nil then
		ability.timer = Timers:CreateTimer(6,function ()
			if caster:IsAlive() then
				local current_stackcount = caster:GetModifierStackCount("modifier_revelater_cooldown",caster)
				if current_stackcount < 3 then
					caster:SetModifierStackCount("modifier_revelater_cooldown",caster,current_stackcount + 1)
					if HasExclusive(caster,2) then
						return 4
					else
						return 6
					end
				else
					Timers:RemoveTimer(ability.timer)
					ability.timer = nil
				end
			else
				Timers:RemoveTimer(ability.timer)
				ability.timer = nil
			end
		end)
	end
end
--[[function MotionControler( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	if not caster:IsAlive() then
		target:InterruptMotionControllers(false)
	end
	if ability.traveled_distance < ability.distance then
		target:SetAbsOrigin(target:GetAbsOrigin() + ability.direction * ability.speed)
		ability.traveled_distance = ability.traveled_distance + ability.speed
		ProjectileManager:ProjectileDodge(caster)
	else
		target:InterruptMotionControllers(false)
		ProjectileManager:ProjectileDodge(caster)
		target:RemoveModifierByName("modifier_revelater_motion")
		target:RemoveModifierByName("modifier_revelater_motion_caster")
		if target.soul_count then
			local duration = (50 - target.soul_count) * 0.1
			Heal(target,target.totalHealth * 0.02 * (50 - target.soul_count),0,false)
			target.soul_count = 50
			ability:ApplyDataDrivenModifier(caster,target,"modifier_revelater_stun",{duration = duration})
		end
		--caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	end
end]]
function MotionControler( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	Timers:CreateTimer(function ()
		if ability.traveled_distance < ability.distance then
			--target:SetAbsOrigin(target:GetAbsOrigin() + ability.direction * ability.speed )
			SetUnitPosition(target, target:GetAbsOrigin() + ability.direction * ability.speed, true)
			ability.traveled_distance = ability.traveled_distance + ability.speed
			ProjectileManager:ProjectileDodge(caster)
			return 0.01
		else
			--target:InterruptMotionControllers(false)
			SetUnitPosition(target, target:GetAbsOrigin())
			ProjectileManager:ProjectileDodge(caster)
			target:RemoveModifierByName("modifier_revelater_motion")
			target:RemoveModifierByName("modifier_revelater_motion_caster")
			if target.soul_count then
				local duration = (50 - target.soul_count) * 0.1
				Heal(target,target.totalHealth * 0.02 * (50 - target.soul_count),0,false)
				target.soul_count = 50
				ability:ApplyDataDrivenModifier(caster,target,"modifier_revelater_stun",{duration = duration})
			end
			--caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
		end
	end)
end
function CastAbility0( t )
	local caster = t.caster
	local ability = t.ability
	if ability.buff_count > 0 then
		ability.buff_count = ability.buff_count - 1
		ability.absorb_count = ability.absorb_count + 1
		if ability.particle_orb then
			ParticleManager:DestroyParticle(ability.particle_orb,false)
		end
		ability.particle_orb = CreateParticle( "particles/heroes/revelater/revelater_orb_"..ability.buff_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		if ability.particle_shield then
			ParticleManager:DestroyParticle(ability.particle_shield,false)
		end
		ability.particle_shield = CreateParticle( "particles/heroes/revelater/revelater_shield_"..ability.absorb_count..".vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		--caster:SetModifierStackCount("modifier_revelater_0_buff",caster,ability.buff_count)
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_0_absorb",nil)
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_0_invisible",{duration = 1.5})
	end
end
function CastAbility1( t )
	local caster = t.caster
	caster.cast_location = caster:GetAbsOrigin()
	if caster:HasModifier("modifier_revelater_buff") then
		t.ability.bonus_distance = true
	end
end
function CastAbility2( t )
	local caster = t.caster
	local ability = t.ability
	local target_point = t.target_points[1]
	local caster_location = caster:GetAbsOrigin()
	local speed = ability:GetSpecialValueFor("speed")
	local distance = (target_point - caster_location):Length2D()
	local distance_limit = distance
	local maxDistance = ability:GetSpecialValueFor("distance")
	if distance > maxDistance then
		distance = maxDistance
	end
	local direction = (target_point - caster_location):Normalized()
	local duration = distance/speed
	local spawnOrigin = caster_location

	ability.distance = distance
	ability.speed = speed * 1/30
	ability.direction = direction
	ability.traveled_distance = 0

	if t.target then
		ability.direction = ability.direction * -1
		if distance_limit < 1000 then
			ability.distance = distance - 200
		end
		spawnOrigin = target_point
		ability:ApplyDataDrivenModifier(caster,t.target,"modifier_revelater_motion",nil)
	else
		caster:StartGesture( ACT_DOTA_CAST_ABILITY_2 )
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_motion_caster",nil)
	end
	Cooldown(t)
	ProjectileManager:ProjectileDodge(caster)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_revelater_buff",{duration = ability:GetSpecialValueFor("duration") + duration})

	local startTime = GameRules:GetGameTime()
    local endTime = startTime + 2
    local velocity = ability.direction * 1600
	local projID = ProjectileManager:CreateLinearProjectile( {
	        Ability             = ability,
	        EffectName          = "",
	        vSpawnOrigin        = spawnOrigin,
	        fDistance           = ability.distance,
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
	        vVelocity           = velocity,
	        bProvidesVision     = true,
	        iVisionRadius       = 0,
	        iVisionTeamNumber   = caster:GetTeamNumber(),
	    } )
end
function CastAbility3( t )
	local caster = t.caster
	local ability = t.ability
	local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility()
	local radius = ability:GetSpecialValueFor("radius")
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local hurtedGroup = {}
	local time = 0
	Timers:CreateTimer(0.5,function ()
		if caster:IsAlive() and time < 1 then
			local caster_location = caster:GetAbsOrigin()
			local canHurt = true
			local unitGroup = FindUnitsInRadius(teamNumber, caster_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
			for k,v in pairs(unitGroup) do
				if v:IsAlive() then
					for key,unit in pairs(hurtedGroup) do
						if unit == v then
							canHurt = false
						end
					end
					if canHurt then
						CauseDamage(caster,v,damage,DAMAGE_TYPE_MAGICAL,ability)
						caster:PerformAttack(v,true,true,true,false,false,false,true)
						table.insert(hurtedGroup, v)
					end
				end
			end
			time = time + 0.1
			return 0.1
		end
	end)
	if HasExclusive(caster,3) then
		Timers:CreateTimer(0.5,function ()
			if caster.dodge_damage == nil then
				caster.dodge_damage = 0
			end
			caster.dodge_damage = caster.dodge_damage + 1
		end)
		Timers:CreateTimer(1.5,function ()
			caster.dodge_damage = caster.dodge_damage - 1
			if caster.dodge_damage <= 0 then
				caster.dodge_damage = nil
			end
		end)
	end
	CreateParticle("particles/heroes/revelater/revelater_trail.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,1)
	Timers:CreateTimer(0.5,function ()
		CreateParticle("particles/heroes/revelater/revelater_trail_blade.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,1)
		CreateSound("DOTA_Item.BladeMail.Activate",caster,2,nil)
	end)
end