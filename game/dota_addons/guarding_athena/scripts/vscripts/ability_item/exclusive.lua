LinkLuaModifier("exclusive","modifiers/generic/exclusive.lua",LUA_MODIFIER_MOTION_NONE)
function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    caster:AddNewModifier(caster, ability, "exclusive", nil)
    SetModifierType(caster,"exclusive","unpurgable")
    caster.exclusive = ability
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    caster:RemoveModifierByName("exclusive")
end