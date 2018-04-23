health = class({})

function health:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end
function health:OnCreated( t )
    if IsServer() then
        self.health = t.health
    end
end
function health:GetModifierHealthBonus(t)
    if IsServer() then
        return self.health
    end
end
function health:IsHidden() 
	return true
end
function health:GetTexture()
    return "item_world_editor"
end