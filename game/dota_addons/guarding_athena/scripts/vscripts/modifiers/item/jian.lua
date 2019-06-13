LinkLuaModifier("modifier_ignore_armor","modifiers/generic/ignore_armor.lua",LUA_MODIFIER_MOTION_NONE)

modifier_jian = class({})

function modifier_jian:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function modifier_jian:OnAttackLanded( params )
    if params.target == nil then return end
	if params.attacker == self:GetParent() then
		local caster = self:GetCaster()
        local ability = self:GetAbility()
        params.target:AddNewModifier(caster, self:GetAbility(), "modifier_ignore_armor", {duration=1/30})
	end
end
function modifier_jian:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
    end
end
function modifier_jian:IsHidden()
	return true
end