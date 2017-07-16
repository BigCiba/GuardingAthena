ring_3_5 = class({})
function ring_3_5:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        caster.double_ability_damage = 50
    end
end
function ring_3_5:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        caster.double_ability_damage = nil
    end
end
function ring_3_5:IsHidden() 
	return false
end
function ring_3_5:GetTexture()
    return "item_ring_secret"
end