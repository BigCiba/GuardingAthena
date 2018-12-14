function Cleave( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local casterLoc = caster:GetAbsOrigin()
    local targetLoc = target:GetAbsOrigin()
    local cleaveRadius = t.cleave_radius or ability:GetSpecialValueFor("cleave_radius")
    local cleavePercent = t.cleave_percent or ability:GetSpecialValueFor("cleave_percent") * 0.01
    local direction = (targetLoc - casterLoc):Normalized()
    local point = casterLoc + direction * cleaveRadius
    local damage = t.damage
    if damage == 0 then
        damage = caster:GetAverageTrueAttackDamage(caster)
    end
    damage = damage * cleavePercent
    local unitGroup = GetUnitsInRadius(caster,ability,point,cleaveRadius)
    for k,v in pairs(unitGroup) do
        if v ~= target then
            CauseDamage(caster,v,damage,DAMAGE_TYPE_PURE,ability)
            if caster:HasModifier("modifier_item_fu_buff") then
                ability:ApplyDataDrivenModifier(caster, v, "modifier_item_fu_debuff", nil)
            end
        end
    end
end