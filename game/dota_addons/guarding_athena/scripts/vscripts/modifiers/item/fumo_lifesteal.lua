fumo_lifesteal = class({})

function fumo_lifesteal:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function fumo_lifesteal:OnCreated( t )
    if IsServer() then
        self.lifesteal = t.lifesteal
    end
end
function fumo_lifesteal:OnAttackLanded( t )
    if IsServer() then
        local damage = t.damage
        if t.attacker == self:GetParent() then
            Heal( t.attacker, damage * self.lifesteal, 0, true )
        end
    end
end
function fumo_lifesteal:IsHidden() 
	return false
end
function fumo_lifesteal:GetTexture()
    return "item_jian_9"
end
