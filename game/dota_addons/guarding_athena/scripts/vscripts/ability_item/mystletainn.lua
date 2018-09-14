function OnCreated( t )
    local caster = t.caster
    if caster.mystletainn_attack == nil then caster.mystletainn_attack = 0 end
    local ability = t.ability
    local attackRate = ability:GetSpecialValueFor("attack_rate")
    local interval = ability:GetSpecialValueFor("interval")
    local absorbPercent = ability:GetSpecialValueFor("absorb") * 0.01
    local attackAdd = ability:GetSpecialValueFor("attack_increase")
    caster:SetBaseAttackTime(caster:GetBaseAttackTime() - attackRate)
    caster.mystletainn_timer = Timers:CreateTimer(function ()
        local absorbHealth = absorbPercent * caster:GetMaxHealth()
        if caster:IsAlive() and caster:GetHealth() > absorbHealth then
            --CauseDamage(caster,caster,absorbHealth,DAMAGE_TYPE_PURE,ability)
            RemoveHealth(caster,absorbHealth)
            caster.mystletainn_attack = caster.mystletainn_attack + attackAdd
            caster:SetBaseDamageMax(caster.mystletainn_attack)
            caster:SetBaseDamageMin(caster.mystletainn_attack)
        end
        return interval
    end)
end
function OnDestroy( t )
    local caster = t.caster
    local attackRate = t.ability:GetSpecialValueFor("attack_rate")
    caster:SetBaseAttackTime(caster:GetBaseAttackTime() + attackRate)
    Timers:RemoveTimer(caster.mystletainn_timer)
end
function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = t.DamageTaken
    local critical = ability:GetSpecialValueFor("critical")
    local rate = ability:GetSpecialValueFor("critical_rate")
    local duration = ability:GetSpecialValueFor("duration")
    local damageDeepen = ability:GetSpecialValueFor("damage_deepen")
    if RollPercentage(rate) then
        SetUnitIncomingDamageDeepen(target,damageDeepen,duration)
        CauseDamage(caster,target,damage * critical,DAMAGE_TYPE_PHYSICAL,ability)
        CreateNumberEffect(target,damage * critical,1.5,MSG_ORIT ,"orange",4)
    end
end