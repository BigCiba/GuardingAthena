function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    local interval = ability:GetSpecialValueFor("interval")
    local duration = ability:GetSpecialValueFor("duration")
    local bonusChance = ability:GetSpecialValueFor("ability_critical_chance")
    local bonusDamage = ability:GetSpecialValueFor("ability_critical_damage")
    local interval = ability:GetSpecialValueFor("interval")
    local duration = ability:GetSpecialValueFor("duration")
    if caster.ability_critical_chance == nil then caster.ability_critical_chance = 0 end
    if caster.ability_critical_damage == nil then caster.ability_critical_damage = 0 end
    caster.ability_critical_chance = caster.ability_critical_chance + bonusChance
    caster.ability_critical_damage = caster.ability_critical_damage + bonusDamage
    ability.timer = Timers:CreateTimer(function ()
        local point
        local angle = 0
        for i=1,8 do
            point = GetRotationPoint(caster:GetAbsOrigin(),120,angle)
            local p = CreateParticle("particles/items/yata_mirror/yata_mirror.vpcf",PATTACH_POINT,caster,1)
            ParticleManager:SetParticleControl( p, 0, point)
            ParticleManager:SetParticleControlForward(p, 0, (point - caster:GetAbsOrigin()):Normalized())
            angle = angle + 45
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_yata_mirror_buff", {duration=duration})
        end
        return interval
    end)
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    local bonusChance = ability:GetSpecialValueFor("ability_critical_chance")
    local bonusDamage = ability:GetSpecialValueFor("ability_critical_damage")
    caster.ability_critical_chance = caster.ability_critical_chance - bonusChance
    caster.ability_critical_damage = caster.ability_critical_damage - bonusDamage
    Timers:RemoveTimer(ability.timer)
end
function Active( t )
    local caster = t.caster
    local ability = t.ability
    local bonusDamage = ability:GetSpecialValueFor("damage")
    if caster.ability_critical_chance == nil then caster.ability_critical_chance = 0 end
    if caster.ability_critical_damage == nil then caster.ability_critical_damage = 0 end
    caster.ability_critical_chance = caster.ability_critical_chance + 100
    caster.ability_critical_damage = caster.ability_critical_damage + bonusDamage
end
function Remove( t )
    local caster = t.caster
    local ability = t.ability
    local bonusDamage = ability:GetSpecialValueFor("damage")
    caster.ability_critical_chance = caster.ability_critical_chance - 100
    caster.ability_critical_damage = caster.ability_critical_damage - bonusDamage
end