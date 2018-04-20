function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    caster.percent_bonus_damage = caster.percent_bonus_damage + ability:GetSpecialValueFor("magic_damage_increase")
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    caster.percent_bonus_damage = caster.percent_bonus_damage - ability:GetSpecialValueFor("magic_damage_increase")
end
function DebuffCreated( t )
    local ability = t.ability
    local target = t.target
    target.percent_bonus_damage = target.percent_bonus_damage - ability:GetSpecialValueFor("damage_reduce")
end
function DebuffDestroy( t )
    local ability = t.ability
    local target = t.target
    target.percent_bonus_damage = target.percent_bonus_damage + ability:GetSpecialValueFor("damage_reduce")
end
function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local scale = ability:GetSpecialValueFor("health")
    local health = caster:GetMaxHealth() * scale
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_world_editor_hp", {duration=duration})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_world_editor_regen", {duration=duration})
    caster:SetModifierStackCount("modifier_item_world_editor_hp", caster, health)
end