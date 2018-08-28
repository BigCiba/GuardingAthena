function OnAbilityPhaseStart( t )
	local caster = t.caster
	local casterLoc = caster:GetAbsOrigin()
	local p = CreateParticle( "particles/skills/dark_fire_circle.vpcf", PATTACH_ABSORIGIN, caster, 2 )
	ParticleManager:SetParticleControl( p, 0, casterLoc )
	ParticleManager:SetParticleControl( p, 1, casterLoc )
end
function OnAbilityExecuted( t )
	local caster = t.caster
	local ability = t.ability
	local usedAbility = t.event_ability
	local exclusive = caster.exclusive
	-- 排除物品与切换技能
	if usedAbility:IsItem() or usedAbility:IsToggle() then
        return
	end
	local duration = ability:GetSpecialValueFor("duration")
	local abilityLv = usedAbility:GetLevel()
	local reduce = ability:GetSpecialValueFor("reduce") * caster:GetIntellect()
	AddModifierStackCount(caster,caster,ability,"modifier_ashes_buff",abilityLv,duration,true)
	caster.const_reduce_damage = caster.const_reduce_damage + reduce * abilityLv
	Timers:CreateTimer(duration,function()
		caster.const_reduce_damage = caster.const_reduce_damage - reduce * abilityLv
	end)
	if HasExclusive(caster,3) then
		local damageIncrease = exclusive:GetSpecialValueFor("damage_increase")
		SetUnitDamagePercent(caster,abilityLv * damageIncrease,duration)
	end
end
-- 弃用
function OnDealDamage( t )
	local caster = t.caster
	local target = t.unit
	local ability = t.ability
	local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect() * caster:GetModifierStackCount("modifier_ashes_buff",nil)
	local damageType = ability:GetAbilityDamageType()
	local igniteCount = ability:GetSpecialValueFor("damage") * caster:GetModifierStackCount("modifier_ashes_buff",nil)
	if ability.can_trigger == nil then ability.can_trigger = true end
	if ability.can_trigger then
		ability.can_trigger = false
		CauseDamage(caster,target,damage,damageType,ability)
		ApplyIgnite(caster,target,igniteCount)
		ability.can_trigger = true
	end
end
function OnIntervalThink( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = ability:GetAbilityIndex()
	local damageType = ability:GetAbilityDamageType()
	local igniteCount = ability:GetSpecialValueFor("ignite_count")
	if abilityIndex == 0 then
		local casterLoc = caster:GetAbsOrigin()
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect() * caster:GetModifierStackCount("modifier_ashes_buff",nil)
		local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,radius)
		for k, v in pairs( unitGroup ) do
			CauseDamage(caster, v, damage, damageType, ability)
			ApplyIgnite(caster,v, igniteCount)
		end
	elseif abilityIndex == 3 then
		local target = t.target
		if target:IsNull() then
			return
		end
		local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect() * target:GetModifierStackCount("modifier_ignite_debuff",nil)
		CauseDamage(caster, target, damage, damageType, ability)
	end
end
function OnCreated( t )
	local caster = t.caster
	local ability = t.ability
	local p1 = CreateParticle( "particles/skills/ashes_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( p1, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetOrigin(), false )
	ParticleManager:SetParticleControl( p1, 0, caster:GetOrigin() )
	ability.effect = p1
end
function OnDestroy( t )
	local caster = t.caster
	local ability = t.ability
	ParticleManager:DestroyParticle(ability.effect,false)
end
function OnSpellStart( t )
	local caster= t.caster
	local ability = t.ability
	local abilityIndex = ability:GetAbilityIndex()
	local exclusive = caster.exclusive
	if abilityIndex == 1 then
		local distance = ability:GetSpecialValueFor("distance")
		local width = ability:GetSpecialValueFor("width")
		local casterLoc = caster:GetAbsOrigin()
		local targetLoc = t.target_points[1]
		local targetLoc = casterLoc + (targetLoc - casterLoc):Normalized() * distance
		local damage = ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("intellect") * caster:GetIntellect()
		local igniteCount = ability:GetSpecialValueFor("ignite_count")
		local damageType = ability:GetAbilityDamageType()
		local unitGroup = GetUnitsInLine(caster,ability,casterLoc,targetLoc,width)
		for k,v in pairs(unitGroup) do
			CauseDamage(caster, v, damage, damageType, ability)
			ability:ApplyDataDrivenModifier(caster, v, "modifier_dark_fire_stun", nil)
			ApplyIgnite(caster,v,igniteCount)
		end
		local p = CreateParticle("particles/heroes/lina/dark_fire.vpcf",PATTACH_ABSORIGIN,caster,3)
		ParticleManager:SetParticleControl( p, 0, casterLoc + Vector(0,0,64))
		ParticleManager:SetParticleControl( p, 1, targetLoc + Vector(0,0,64))
		-- 专属一
		if HasExclusive(caster,1) then
			local duration = exclusive:GetSpecialValueFor("duration")
			local interval = exclusive:GetSpecialValueFor("interval")
			local damagePercent = exclusive:GetSpecialValueFor("damage_percent") * 0.01
			local p = CreateParticle("particles/heroes/lina/dark_fire_gound.vpcf",PATTACH_ABSORIGIN,caster,3)
			ParticleManager:SetParticleControl( p, 0, casterLoc)
			ParticleManager:SetParticleControl( p, 1, targetLoc)
			local time = 0
			Timers:CreateTimer(interval,function ()
				if time < duration then
					local unitGroup = GetUnitsInLine(caster,ability,casterLoc,targetLoc,width)
					CauseDamage(caster,unitGroup,damage * damagePercent,damageType,ability)
					for k,v in pairs(unitGroup) do
						ApplyIgnite(caster,v,math.ceil(igniteCount * damagePercent))
					end
					time = time + interval
					return interval
				end
			end)
		end
	elseif abilityIndex == 2 then
		local radius = ability:GetSpecialValueFor("radius")
		local interval = ability:GetSpecialValueFor("interval")
		local targetLoc = t.target_points[1]
		local duration = ability:GetSpecialValueFor("duration")
		local damage = ability:GetSpecialValueFor("intellect") * caster:GetIntellect() + ability:GetSpecialValueFor("base_damage")
		local damageType = ability:GetAbilityDamageType()
		local igniteCount = ability:GetSpecialValueFor("ignite_count")
		local p1 = CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, caster, 4 )
		ParticleManager:SetParticleControl( p1, 0, targetLoc )
		ParticleManager:SetParticleControl( p1, 1, Vector(300,1,1) )
		local p2 = CreateParticle( "particles/skills/fire_butterfly_gound.vpcf", PATTACH_CUSTOMORIGIN, caster, 4 )
		ParticleManager:SetParticleControl( p2, 0, targetLoc )
		local unitGroup = GetUnitsInRadius(caster,ability,targetLoc,radius)
		for k, v in pairs( unitGroup ) do
			CauseDamage(caster, v, damage, damageType, ability)
			ability:ApplyDataDrivenModifier(caster,v,"modifier_light_array_stun",nil)
			ApplyIgnite(caster,v,igniteCount)
		end
		local times = 0
		Timers:CreateTimer(interval,function()
			if times < duration then
				local unitGroup = GetUnitsInRadius(caster,ability,targetLoc,radius)
				for k, v in pairs( unitGroup ) do
					CauseDamage(caster, v, damage * 0.5, damageType, ability)
					ApplyIgnite(caster,v,math.ceil(igniteCount * 0.5))
				end
				times = times + interval
				return interval
			end
		end)
	elseif abilityIndex == 4 then
		local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect()
		local igniteCount = ability:GetSpecialValueFor("ignite_count")
		local interval = ability:GetSpecialValueFor("interval")
		local waveCount = ability:GetSpecialValueFor("wave_count")
		local countPerWave = ability:GetSpecialValueFor("count_per_wave")
		local radius = ability:GetSpecialValueFor("radius")
		local delay = ability:GetSpecialValueFor("delay")
		local maxRadius = ability:GetSpecialValueFor("max_radius")
		local damageType = ability:GetAbilityDamageType()
		local casterLoc = caster:GetAbsOrigin()
		local p1 = CreateParticle( "particles/skills/meteor_circle.vpcf", PATTACH_CUSTOMORIGIN, caster, 4 )
		ParticleManager:SetParticleControl( p1, 0, casterLoc )
		local time = 0
		local randomPoint
		Timers:CreateTimer(delay,function ()
			-- 陨石
			CreateSound("Hero_Invoker.ChaosMeteor.Loop",caster,1.3)
			--CreateSound("Ability.LightStrikeArray",caster,nil,1.3)
			if time <= waveCount then
				for i=1,countPerWave do
					randomPoint = GetRandomPoint(casterLoc,0,maxRadius)
					local unit = GetRandomUnit(caster,ability,casterLoc,maxRadius)
					if unit then
						randomPoint = GetRandomPoint(unit:GetAbsOrigin(),0,radius)
					end
					local particle = CreateParticle( "particles/skills/meteor_fly.vpcf", PATTACH_ABSORIGIN, caster, 4 )
					ParticleManager:SetParticleControl(particle, 0, randomPoint + Vector (300, 300, 1000))
					ParticleManager:SetParticleControl(particle, 1, randomPoint)
					ParticleManager:SetParticleControl(particle, 2, Vector(1.3, 0, 0))
					local pointSave = randomPoint
					Timers:CreateTimer(1.3,function (  )
						local particle = CreateParticle( "particles/skills/rain_of_chaos_landding_immortal1.vpcf", PATTACH_ABSORIGIN, caster, 4 )
						ParticleManager:SetParticleControl(particle, 0, pointSave)
						local unitGroup = GetUnitsInRadius(caster,ability,pointSave,radius)
						for k, v in pairs( unitGroup ) do
							CauseDamage(caster, v, damage, damageType, ability)
							ability:ApplyDataDrivenModifier(caster,v,"modifier_meteor_storm_debuff",nil)
							ApplyIgnite(caster,v,igniteCount)
						end
					end)
				end
				time = time + 1
				return interval
			end
		end)
	end
end
function OnAttackLanded( t )
	local caster = t.caster
	local igniteCount = t.ability:GetSpecialValueFor("ignite_count") 
	ApplyIgnite(caster,t.target,igniteCount)
end
function ApplyIgnite( ... )
	local caster,target,count = ...
	local ability = caster:GetAbilityByIndex(3)
	local exclusive = caster.exclusive
	if ability:GetLevel() >= 1 then
		local duration = ability:GetSpecialValueFor("duration")
		if HasExclusive(caster,2) then 
			duration = exclusive:GetSpecialValueFor("ignite_duration") 
		end
		AddModifierStackCount(caster,target,ability,"modifier_ignite_debuff",count,duration,true)
		SetModifierType(target,"modifier_ignite_debuff","unpurgable")
	end
end
function OnExclusiveCreated( t )
	local caster = t.caster
	local ability = t.ability
	ability.exclusive_timer = Timers:CreateTimer(function ()
		if HasExclusive(caster,4) then
			local ability_4 = caster:FindAbilityByName("meteor_storm")
			if ability_4 then
				local new_ability = caster:AddAbility("meteor_storm_up")
				new_ability:SetLevel(ability_4:GetLevel())
				caster:SwapAbilities(ability_4:GetAbilityName(), new_ability:GetAbilityName(), false, true)
				caster:RemoveAbility("meteor_storm")
			end
		end
		return 0.5
	end)
end
function OnExclusiveDestory( t )
	local caster = t.caster
	local ability = t.ability
	Timers:RemoveTimer(ability.exclusive_timer)
    local ability_4 = caster:FindAbilityByName("meteor_storm_up")
    if ability_4 then
        local new_ability = caster:AddAbility("meteor_storm")
        new_ability:SetLevel(ability_4:GetLevel())
        caster:SwapAbilities(ability_4:GetAbilityName(), new_ability:GetAbilityName(), false, true)
        caster:RemoveAbility("meteor_storm_up")
    end
end