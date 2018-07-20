function ThunderStrike( t )
	local caster = t.caster
	local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
	local damage = (ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("scale") * caster:GetStrength())
	local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
	for i,unit in pairs(unitGroup) do
		if unit:IsStunned() then
			ThunderPowerDamage( caster,unit,ability )
		end
        CauseDamage( caster, unit, damage, DAMAGE_TYPE_MAGICAL, ability )
    end
    local particleName = "particles/skills/thunder_strike.vpcf"
    if caster.gift then
        particleName = "particles/skills/thunder_strike_gold.vpcf"
    end
    CreateParticle(particleName,PATTACH_ABSORIGIN,caster,3)
	-- 冷却时间
	ThunderStrikeCoolDown(t)
end
function ThunderStrikeCreat( t )
	local caster = t.caster
	t.ability.cooldown_reduce = false
	caster:SetModifierStackCount("modifier_thunder_strike", caster, 2)
end
function ThunderStrikeCoolDown( t )
	local caster = t.caster
	local ability = t.ability
	local stackcount = caster:GetModifierStackCount("modifier_thunder_strike",caster)
    local buffpoint = 2
    if HasExclusive(caster,1) then
		buffpoint = 3
	end
	if stackcount > 0 then
		ability:EndCooldown()
		caster:SetModifierStackCount("modifier_thunder_strike",caster,stackcount - 1)
	end
	if ability.timer == nil then
		ability.timer = Timers:CreateTimer(6,function ()
			if caster:IsAlive() then
				local current_stackcount = caster:GetModifierStackCount("modifier_thunder_strike",caster)
				if current_stackcount < buffpoint then
					caster:SetModifierStackCount("modifier_thunder_strike",caster,current_stackcount + 1)
                    if caster:HasModifier("modifier_device_heal_aura") then
                        if caster.healRefresh == nil then
                            caster.healRefresh = 0
                        end
                        if RollPercentage(caster.healRefresh) then
                            local particle = CreateParticle( "particles/heroes/mechanic/heal_refresh.vpcf", PATTACH_ABSORIGIN, caster )
                            ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() + Vector(0,0,100) )
                            EmitSoundOn("Hero_Tinker.RearmStart", caster)
                            return 4
                        end
                    end
					return 8
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
function ThunderPowerCreated( t )
    t.ability.cooldown_reduce = false
end
function ThunderPower( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
    local cd = ability:GetSpecialValueFor("cooldown")
    local stun_chance = ability:GetSpecialValueFor("rate") + caster:FindAbilityByName("weightlifting"):GetSpecialValueFor("rate")
	if target:IsStunned() then
        ThunderPowerDamage( caster,target,ability )
        --target:EmitSound("Hero_Zuus.LightningBolt")
        CreateSound("Hero_Zuus.LightningBolt",target)
	end
    if ability:IsCooldownReady() then
        if RollPercentage(stun_chance) then
            caster:ModifyStrength(1)
            ability:ApplyDataDrivenModifier(caster, target, "modifier_thunder_power_stun", nil)
            ability:StartCooldown(cd)
            if caster:HasModifier("modifier_device_heal_aura") then
                if caster.healRefresh == nil then
                    caster.healRefresh = 0
                end
                if RollPercentage(caster.healRefresh) then
                    local particle = CreateParticle( "particles/heroes/mechanic/heal_refresh.vpcf", PATTACH_ABSORIGIN, caster )
                    ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() + Vector(0,0,100) )
                    --EmitSoundOn("Hero_Tinker.RearmStart", caster)
                    CreateSound("Hero_Zuus.LightningBolt",caster,1,1)
                    ability:EndCooldown()
                end
            end
        end
    end
end
function CreateHealDevice( t )
    local caster = t.caster
    local point = t.target_points[1]
    local ability = t.ability
    local Duration = ability:GetSpecialValueFor("duration")
    local str = caster:GetStrength()
    local unitName = "heal_device"
    if HasExclusive(caster,3) then
        unitName = "heal_device_move"
    end
    PrecacheUnitByNameAsync(unitName,function()
        local nature = CreateUnitByName(unitName, point, true, caster, caster, DOTA_TEAM_GOODGUYS )
        nature.ownerHero = caster
        nature:SetControllableByPlayer(caster:GetPlayerID(), true)
        nature:SetMaxHealth(str * 100)
        nature:SetHealth(str * 100)
        nature:SetBaseMaxHealth(str * 100)
        nature:SetPhysicalArmorBaseValue(str)
        nature:AddNewModifier(nature, nil, "modifier_kill", {duration=Duration})
        ability:ApplyDataDrivenModifier(caster, nature, "modifier_device_heal", nil)
        if HasExclusive(caster,3) then
            Timers:CreateTimer(function ()
                if nature:IsAlive() then
                    local unitGroup = GetUnitsInRadius(nature,ability,nature:GetAbsOrigin(),600)
                    for i,v in ipairs(unitGroup) do
                        ArcLightning({caster=nature,attacker=v,ability=ability})
                        if i >=3 then
                            break
                        end
                    end
                    return 1
                end
            end)
        end
    end)
end
function OnHealIn( t )
    local caster = t.caster
    local ability = t.ability
    caster.healRefresh = ability:GetSpecialValueFor("chance")
end
function OnHealOut( t )
    local caster = t.caster
    caster.healRefresh = 0
end
function ThunderPowerDamage( caster,target,ability )
    local scale = caster:GetAbilityByIndex(0):GetSpecialValueFor("scale") + caster:GetAbilityByIndex(3):GetSpecialValueFor("damage_scale")
    local damage = caster:GetStrength() * scale
    local target_location = target:GetAbsOrigin()
    local particle = CreateParticle("particles/heroes/mechanic/thunder_punish.vpcf", PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControl(particle, 0, target_location + Vector(0, 0, 5000))
	ParticleManager:SetParticleControl(particle, 1, target_location)
    ParticleManager:SetParticleControl(particle, 3, target_location)
    if HasExclusive(caster,1) then
        damage = damage * 2
    end
    if HasExclusive(caster,2) then
        target = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),300)
    end
    CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL, ability )
end
function WeightLifting( t )
	local caster = t.caster
    if caster.weightLift == nil then
        caster.weightLift = 0
    end    
	caster.weightLift = caster.weightLift + 1
	if caster.weightLift > 9 then
		caster.weightLift = 0
		caster:ModifyStrength(1)
	end
end
function VoidBarrierOn( t )
	local caster = t.caster
	local ability = t.ability
    local scale = ability:GetSpecialValueFor("scale")
    ability.barrier = scale
    SetUnitDamagePercent(caster,ability.barrier)
end
function VoidBarrierOff( t )
	local caster = t.caster
    local ability = t.ability
    SetUnitDamagePercent(caster,-ability.barrier)
end
function ArcLightning(t)
    local caster = t.caster
    local target = t.attacker
    local device = caster
    if not caster:IsRealHero() then
        caster = caster.ownerHero
    end
    local ability = t.ability
	local damage = caster:GetStrength() * 5
	local damageType = ability:GetAbilityDamageType()
    local damage = caster:GetStrength() * 5
    local count = 1
    local unit_start = device
    local unit_end = target
    if HasExclusive(caster,4) then
		count = 3
	end
    Timers:CreateTimer(function()
        if count > 0 and unit_start ~= unit_end then
            local particle = CreateParticle("particles/heroes/mechanic/arc_lightning.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster,3)
            ParticleManager:SetParticleControlEnt(particle, 0, unit_start, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_start:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(particle, 1, unit_end, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_end:GetAbsOrigin(), true)
            CauseDamage(caster,unit_end,damage,damageType,ability)
            if unit_end:IsStunned() then
                ThunderPowerDamage( caster,unit_end,ability )
            end
            unit_start = unit_end
            unitGroup = GetUnitsInRadius(caster,ability,unit_end:GetAbsOrigin(),500)
            for k,v in pairs(unitGroup) do
                if v:IsAlive() then
                    unit_end = v
                    break
                end
            end
            count = count - 1
            return 0.3
        end
    end)
end