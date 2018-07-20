-- undying
function OnAbsorb( t )
	local caster = t.caster
	local ability = t.ability
	local caster_location = caster:GetAbsOrigin()
	local radius = ability:GetSpecialValueFor("radius")
	local damage_percent = ability:GetSpecialValueFor("damage") * 0.01
	local heal_percent = ability:GetSpecialValueFor("heal") * 0.01
	local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
	local particle = CreateParticle( "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( particle, 0, caster_location )
	ParticleManager:SetParticleControl( particle, 1, Vector(800,800,800) )
	for i,unit in pairs(unitGroup) do
		local damage = unit:GetMaxHealth() * damage_percent
		local heal = caster:GetMaxHealth() * heal_percent
		CauseDamage( caster, unit, damage, DAMAGE_TYPE_MAGICAL )
		Heal( caster, heal, 0, true )
		local particle_tril = CreateParticle( "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay_strength_xfer.vpcf", PATTACH_CUSTOMORIGIN, caster )
		ParticleManager:SetParticleControl( particle_tril, 0, unit:GetAbsOrigin() + Vector(0,0,64) )
		ParticleManager:SetParticleControl( particle_tril, 1, caster_location + Vector(0,0,64) )
	end
end
function OnDeath( t )
	local caster = t.caster
	local ability = t.ability
	local caster_location = caster:GetAbsOrigin()
	local unitName = "mubei"
	local duration = ability:GetSpecialValueFor("duration")
	local bonus_health = ability:GetSpecialValueFor("health")
	if ability:IsCooldownReady() then
		PrecacheUnitByNameAsync(unitName,function()
			local unit = CreateUnitByName(unitName, caster_location, true, nil, nil, DOTA_TEAM_BADGUYS )
			EmitSoundOn("Hero_Undying.Tombstone", unit)
			unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() + bonus_health)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_mubei", nil)
			Timers:CreateTimer(duration,function ()
				if not unit:IsNull() then
					if unit:IsAlive() then
						local target_location = unit:GetAbsOrigin()
						local rebornUnitName = "guai_38"
						local particle = CreateParticle( "particles/econ/items/undying/undying_manyone/undying_pale_tower_destruction.vpcf", PATTACH_ABSORIGIN, unit )
						ParticleManager:SetParticleControl( particle, 0, target_location)
						unit:SetAbsOrigin(target_location + Vector(0,0,-600))
						unit:ForceKill(false)
						PrecacheUnitByNameAsync(rebornUnitName,function()
							local rebornUnit = CreateUnitByName(rebornUnitName, target_location, true, nil, nil, DOTA_TEAM_BADGUYS )
							local ability_mubei = rebornUnit:FindAbilityByName("mubei")
							local cd = ability_mubei:GetSpecialValueFor("cooldown")
							ability_mubei:StartCooldown(cd)
							EmitSoundOn("Greevil.FleshGolem.Cast", rebornUnit)
							rebornUnit.corpse = true
						end)
					end
				end
			end)
		end)
	end
end
function OnTombstoneDeath( t )
	local target = t.unit
	local target_location = target:GetAbsOrigin()
	local particle = CreateParticle( "particles/econ/items/undying/undying_manyone/undying_pale_tower_destruction.vpcf", PATTACH_ABSORIGIN, target )
	ParticleManager:SetParticleControl( particle, 0, target_location)
	target:SetAbsOrigin(target_location + Vector(0,0,-600))
end
function OnFulan( t )
	local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * 0.1
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL)
end
-- zeus
function OnLightCreated(t)
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local jump_delay = ability:GetSpecialValueFor("jump_delay")
	local radius = ability:GetSpecialValueFor("radius")
	local stackcount = 0
	if caster:HasModifier("modifier_electrostatic_field_buff") then
		stackcount = caster:GetModifierStackCount("modifier_electrostatic_field_buff", caster)
	end
    local damage = ability:GetSpecialValueFor("damage") * (1 + stackcount * 0.01)
	CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL,ability )
	target:RemoveModifierByName("modifier_lightning_attack_buff")
	Timers:CreateTimer(0.25,function()
		local current
		for i=0,ability.instance do
			if ability.target[i] ~= nil then
				if ability.target[i] == target then
					current = i
				end
			end
		end

		if target.hit == nil then
			target.hit = {}
		end
		target.hit[current] = true
	
		ability.jump_count[current] = ability.jump_count[current] - 1
	
		if ability.jump_count[current] > 0 then
			local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
			local closest = radius
			local new_target
			for i,unit in ipairs(units) do
				local unit_location = unit:GetAbsOrigin()
				local vector_distance = target:GetAbsOrigin() - unit_location
				local distance = (vector_distance):Length2D()
				if distance < closest then
					if unit.hit == nil then
						new_target = unit
						closest = distance
					elseif unit.hit[current] == nil then
						new_target = unit
						closest = distance
					end
				end
			end
			if new_target ~= nil then
				local lightningBolt = CreateParticle(t.particle, PATTACH_WORLDORIGIN, target)
				ParticleManager:SetParticleControl(lightningBolt,0,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
				ParticleManager:SetParticleControl(lightningBolt,1,Vector(new_target:GetAbsOrigin().x,new_target:GetAbsOrigin().y,new_target:GetAbsOrigin().z + new_target:GetBoundingMaxs().z ))
				ability.target[current] = new_target
				ability:ApplyDataDrivenModifier(caster, new_target, "modifier_lightning_attack_buff", {})
			else
				ability.target[current] = nil
			end
		else
			ability.target[current] = nil
		end
	end)
end
function OnLightCast(t)
	local caster = t.caster
	local ability = t.ability
	local target = t.target
	
	if ability.instance == nil then
		ability.instance = 0
		ability.jump_count = {}
		ability.target = {}
	else
		ability.instance = ability.instance + 1
	end
	
	ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1))
	ability.target[ability.instance] = target
	
	local lightningBolt = CreateParticle(t.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
end
function OnCrashCast( t )
    local caster = t.caster
    local target
    if t.attacker == caster then
        target = t.unit
    else
        target = t.attacker
    end
	if target:IsMagicImmune() or target:IsInvulnerable() then
		return
	end
	local ability = t.ability
    local target_location = target:GetAbsOrigin()
	local stackcount = 0
	if caster:HasModifier("modifier_electrostatic_field_buff") then
		stackcount = caster:GetModifierStackCount("modifier_electrostatic_field_buff", caster)
	end
	local damage = ability:GetSpecialValueFor("damage") * (1 + stackcount * 0.01)
    local particle = CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, target_location + Vector(0, 0, 5000))
	ParticleManager:SetParticleControl(particle, 1, target_location)
    ParticleManager:SetParticleControl(particle, 3, target_location)
	CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL )
	EmitSoundOn("Hero_Zuus.LightningBolt", caster)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_lightning_crash_debuff", nil)
	if stackcount < 100 then
		AddModifierStackCount( caster, caster, ability, "modifier_electrostatic_field_buff" )
	end
end
function OnCasterCastAbility( t )
	local caster = t.caster
	local ability = t.ability
	local stackcount = caster:GetModifierStackCount("modifier_electrostatic_field_buff", caster)
	if stackcount < 100 then
		AddModifierStackCount( caster, caster, ability, "modifier_electrostatic_field_buff" )
	end
	if caster:GetModifierStackCount("modifier_electrostatic_field_buff", caster) >= 100 then
		local ability_4 = caster:FindAbilityByName("thunder_wrath")
		ThunderWrath( {caster=caster,ability=ability_4} )
		casterRemoveModifierByName("modifier_electrostatic_field_buff")
	end
end
function OnTargetCastAbility( t )
	--PrintTable( t )
	local caster = t.caster
	local target = t.unit
	local ability = t.ability
	local stackcount = caster:GetModifierStackCount("modifier_electrostatic_field_buff", caster)
	local duration = stackcount * 0.03
	ability:ApplyDataDrivenModifier(caster, target, "modifier_electrostatic_field_slience", {duration=duration})
	local ability_arc = caster:FindAbilityByName("lightning_attack")
	OnLightCast({caster=caster,target=target,ability=ability_arc,particle="particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf"})
	ability_arc:ApplyDataDrivenModifier(caster, target, "modifier_lightning_attack_buff", nil)
	EmitSoundOn("Hero_Zuus.ArcLightning.Cast", target)
	if stackcount < 100 then
		AddModifierStackCount( caster, caster, ability, "modifier_electrostatic_field_buff" )
	end
end
function ThunderWrath( keys )
    local caster = keys.caster
    local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	local cdIncrease = ability:GetSpecialValueFor("cooldown_increase")
    local caster_location = caster:GetAbsOrigin()
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, caster, 2000, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    for i,unit in pairs(targets) do
        CauseDamage(caster, unit, damage, DAMAGE_TYPE_MAGICAL)
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_thunder_wrath_debuff", nil)
        for i=1,5 do
			if unit:GetAbilityByIndex(i-1) then
				if not ability:IsToggle() then
					if ability:IsCooldownReady() then
						local ability_cd = unit:GetAbilityByIndex(i-1)
						ability_cd:StartCooldown(ability_cd:GetCooldownTime())
					else
						local ability_cd = unit:GetAbilityByIndex(i-1)
						local cd = ability_cd:GetCooldownTimeRemaining() + cdIncrease
						ability_cd:StartCooldown(cd)
					end
				end
            end
        end
        EmitSoundOn("Hero_Zuus.LightningBolt", unit)
        local target_location = unit:GetAbsOrigin()
        local particle = CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(particle, 0, target_location + Vector(0, 0, 4000))
        ParticleManager:SetParticleControl(particle, 1, target_location)
        ParticleManager:SetParticleControl(particle, 3, target_location)
    end
end
function ThunderCloud( keys )
    local caster = keys.caster
    local casterLocation = caster:GetAbsOrigin()
    local ability = keys.ability
    local damage = keys.Damage
    local time = 0
    local randompoint
    -- 控制点3控制云的浓度，控制点4控制云的半径，128的浓度大概对应400范围。
    local fxIndex = CreateParticle( "particles/test/lxq_storm.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( fxIndex, 3, Vector(512,0,0) )
    ParticleManager:SetParticleControl( fxIndex, 4, Vector(800,0,0) )
    Timers:CreateTimer(3,
        function()
            ParticleManager:DestroyParticle(fxIndex,false)
        end
    )
    Timers:CreateTimer(2,function (  )
        if time <= 50 then
            -- 随机点，控制点0控制落雷起始点，控制点1控制落雷结束点。
            randompoint = GetRandomPoint(casterLocation,0,900)
            local particle = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
            ParticleManager:SetParticleControl( particle, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
            ParticleManager:SetParticleControl( particle, 1, randompoint )
            -- 重复
            randompoint = GetRandomPoint(casterLocation,0,900)
            local particle1 = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
            ParticleManager:SetParticleControl( particle1, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
            ParticleManager:SetParticleControl( particle1, 1, randompoint )
            randompoint = GetRandomPoint(casterLocation,0,900)
            local particle2 = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
            ParticleManager:SetParticleControl( particle2, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
            ParticleManager:SetParticleControl( particle2, 1, randompoint )
            time = time + 1
            EmitSoundOn("Hero_Zuus.ArcLightning.Cast",caster)
            local targets = FindUnitsInRadius(caster:GetTeamNumber(), casterLocation, caster, 800, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
            for i,unit in pairs(targets) do
                CauseDamage(caster, unit, damage, DAMAGE_TYPE_MAGICAL)
                ability:ApplyDataDrivenModifier(caster, unit, "modifier_thunder_cloud_debuff", nil)
            end
            return 0.03
        end
    end)
end
function LightningAttackAI( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = caster:FindAbilityByName("lightning_attack"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function GodBody( t )
	local caster = t.caster
    local target = t.attacker
    local ability = t.ability
	local damage = t.DamageTaken
	local maxHealth = caster:GetMaxHealth()
	local max_damage = ability:GetSpecialValueFor("max_damage") * maxHealth * 0.01
	if damage > max_damage then
		Heal( caster, damage - max_damage, 0, false )
		local ability_crash = caster:FindAbilityByName("lightning_crash")
		if ability:IsCooldownReady() then
			OnCrashCast( {caster=caster,unit=target,attacker=caster,ability=ability_crash} )
			ability:StartCooldown(2)
		end
	end
end
function ThunderWrathAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
    if caster:GetHealthPercent() <= 70 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_thunder_wrath_buff", nil)
        EmitSoundOn("Hero_Zuus.GodsWrath.PreCast.Arcana", caster)
		local particle = CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_CUSTOMORIGIN, keys.caster)
		ParticleManager:SetParticleControl(particle, 0, caster_location)
		ParticleManager:SetParticleControl(particle, 1, caster_location)
		ParticleManager:SetParticleControl(particle, 2, caster_location)
		ParticleManager:SetParticleControl(particle, 3, caster_location)
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("thunder_wrath"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function ThunderCloudAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    if caster:GetHealthPercent() <= 50 and ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("thunder_cloud"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end