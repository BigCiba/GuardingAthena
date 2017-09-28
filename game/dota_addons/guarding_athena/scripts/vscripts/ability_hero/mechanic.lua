function ThunderStrike( t )
	local caster = t.caster
	local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    if caster.voidBarrierScale == nil then
        caster.voidBarrierScale = 1
    end
	local damage = (ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("scale") * caster:GetStrength()) * caster.voidBarrierScale
	local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
	for i,unit in pairs(unitGroup) do
		if unit:IsStunned() then
			ThunderPowerDamage( caster,unit )
		end
        CauseDamage( caster, unit, damage, DAMAGE_TYPE_MAGICAL, ability )
	end
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
    if caster:HasModifier("modifier_zhuanshuok_state") then
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
    local unitName = "heal_device"
    if caster:HasModifier("modifier_zhuanshuok_state") then
        unitName = "heal_device_move"
    end
    PrecacheUnitByNameAsync(unitName,function()
        local nature = CreateUnitByName(unitName, point, true, caster, caster, DOTA_TEAM_GOODGUYS )
        nature:SetControllableByPlayer(caster:GetPlayerID(), true)
        nature:AddNewModifier(nature, nil, "modifier_kill", {duration=Duration})
        ability:ApplyDataDrivenModifier(caster, nature, "modifier_device_heal", nil)
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
function HealMove( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    if caster:HasModifier("modifier_zhuanshuok_state") then
        target:RemoveModifierByName("modifier_heal_device_move")
    end
end
function ThunderPowerDamage( caster,target,ability )
    if caster.voidBarrierScale == nil then
        caster.voidBarrierScale = 1
    end
    local damage = caster:GetStrength() * 5 * caster.voidBarrierScale
    if caster:HasModifier("modifier_zhuanshuok_state") then
        damage = damage * 2
    end
    CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL, ability )
    local target_location = target:GetAbsOrigin()
    local particle = CreateParticle("particles/heroes/mechanic/thunder_punish.vpcf", PATTACH_CUSTOMORIGIN, target)
    ParticleManager:SetParticleControl(particle, 0, target_location + Vector(0, 0, 5000))
	ParticleManager:SetParticleControl(particle, 1, target_location)
    ParticleManager:SetParticleControl(particle, 3, target_location)
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
    caster.voidBarrierScale = scale
end
function VoidBarrierOff( t )
	local caster = t.caster
	local ability = t.ability
    caster.voidBarrierScale = 1
end
function VoidBarrierDamage( t )
	local caster = t.caster
	local target = t.attacker
	local damage = t.Damage * caster:GetStrength()
	local damageType = t.ability:GetAbilityDamageType()
	CauseDamage(caster,target,damage,damageType,t.ability)
end