LinkLuaModifier("modifier_ignore_armor","modifiers/generic/ignore_armor.lua",LUA_MODIFIER_MOTION_NONE)

modifier_monkey_king_exclusive = class({})

function modifier_monkey_king_exclusive:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
    return funcs
end
function modifier_monkey_king_exclusive:OnAttackLanded( params )
    if params.target == nil then return end
	if params.attacker == self:GetParent() then
		local caster = self:GetCaster()
        local ability = self:GetAbility()
        if self.trigger then
            self.trigger = false
            params.target:AddNewModifier(caster, self:GetAbility(), "modifier_ignore_armor", {duration=1/30})
        end
	end
end
function modifier_monkey_king_exclusive:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
    end
end
function modifier_monkey_king_exclusive:IsHidden() 
	return true
end
function modifier_monkey_king_exclusive:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        if params.attacker == self:GetParent() and HasExclusive(self:GetCaster(),3) then
            if RollPercentage(25) then
                self.trigger = true
                return self:GetCaster() == self:GetParent() and 5000 or 3000
            end
        end
    end
end