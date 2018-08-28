function OnCreated( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local percent = ability:GetSpecialValueFor("percent")
    Timers:CreateTimer(function ()
        if target:HasModifier("modifier_heartstop_str") then
            local health_percent = target:GetHealthPercent()
            local limit = 100 - percent * target:GetModifierStackCount("modifier_heartstop_str", caster)
            if health_percent > limit and limit > 10 then
                target:SetHealth(target:GetMaxHealth() * limit * 0.01)
            end
            return 0.01
        end
    end)
end
function OnProjectileHit( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    local healAmount = ability:GetSpecialValueFor("regen") * caster:GetMaxHealth() * 0.01
    Heal(caster,healAmount,0,true)
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL,ability)
end
function OnIntervalThink( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    ability.no_damage_filter = true
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 1 then
        if target:IsRealHero() then
            AddModifierStackCount( caster, target, ability, "modifier_heartstop_str" )
            target:CalculateStatBonus()
        end
    elseif abilityIndex == 3 then
        local percent = ability:GetSpecialValueFor("percent")
        if target:IsRealHero() then
            if target:GetHealthPercent() < percent and target:HasModifier("modifier_reapers_scythe_datadriven") == false then
                ability:ApplyDataDrivenModifier(caster,target,"modifier_reapers_scythe_datadriven",nil)
                local particlestart = CreateParticle( "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", PATTACH_CUSTOMORIGIN, caster )
                ParticleManager:SetParticleControl( particlestart, 0, target:GetAbsOrigin() )
                ParticleManager:SetParticleControl( particlestart, 2, target:GetAbsOrigin() )
                ParticleManager:SetParticleControl( particlestart, 3, target:GetAbsOrigin() )
                local particle = CreateParticle( "particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_CUSTOMORIGIN, caster )
                ParticleManager:SetParticleControl( particle, 0, target:GetAbsOrigin() )
                ParticleManager:SetParticleControl( particle, 1, target:GetAbsOrigin() )
                ParticleManager:SetParticleControl( particle, 4, target:GetAbsOrigin() )
                EmitSoundOn("Hero_Necrolyte.ReapersScythe.Target", target)
                Timers:CreateTimer(1.5,function ()
                    --target:ForceKill(true)
                    CauseDamage(caster,target,target:GetBaseMaxHealth() * 100,DAMAGE_TYPE_PURE,ability)
                    Heal(caster,caster:GetMaxHealth() * percent * 0.01,0,true)
                end)
            end
        end
    end
end
function OnDeath( t )
     local caster = t.caster
     local target = t.attacker
     local ability = t.ability
     ability.no_damage_filter = true
     local cooldown = ability:GetSpecialValueFor("cooldown")
     if ability:IsCooldownReady() then
        Timers:CreateTimer(0.01,function ()
            caster:RespawnUnit()
            EmitSoundOn("necrolyte_necr_happy_06", target)
            EmitSoundOn("Hero_Abaddon.BorrowedTime", caster)
            caster:SetHealth(caster:GetMaxHealth() * target:GetHealthPercent() * 0.01)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_death_change_stun", nil)
            CreateParticle( "particles/units/wave_26/death_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, 3 )
            --if target:IsMagicImmune() == false or target:IsInvulnerable() == false then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_death_change_stun", nil)
            CreateParticle( "particles/units/wave_26/death_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, 3 )
            Timers:CreateTimer(3,function ()
                --target:ForceKill(true)
                CauseDamage(caster,target,target:GetBaseMaxHealth() * 100,DAMAGE_TYPE_PURE,ability)
            end)
            --end
            ability:StartCooldown(cooldown)
            Timers:CreateTimer(3,function ()
                Spawner.bossCurrent = caster
            end)
        end)
    end
end