function RoshanStunRandom( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    local cooldown = ability:GetSpecialValueFor("cooldown")
    if ability:IsCooldownReady() and target:HasModifier("modifier_roshan_stun_debuff") == false then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_roshan_stun_debuff", nil)
        CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL )
        ability:StartCooldown(cooldown)
        EmitSoundOn("Hero_Slardar.Bash", target)
    end
end
function RoshanSlamDamage( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetSpecialValueFor("damage")
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    for i,unit in pairs(unitGroup) do
        CauseDamage( caster, unit, damage, DAMAGE_TYPE_MAGICAL )
    end
end
function RoshanShock( t )
    local caster = t.caster
    local target = t.target
    target:MoveToPosition(target:GetAbsOrigin() + Vector(RandomInt(-500, 500),RandomInt(-500, 500),0))
end
function RoshanSlamAI( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    if #unitGroup >= 1 then
        if ability:IsCooldownReady() then
            local t_order = 
            {
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                TargetIndex = nil,
                AbilityIndex = caster:FindAbilityByName("roshan_strike"):entindex(),
                Position = nil,
                Queue = 0
            }
            caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
        end
    end
end
function RoshanShockAI( t )
    local caster = t.caster
    local ability = t.ability
    if caster:GetHealthPercent() <= 50 and ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("roshan_shock"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end