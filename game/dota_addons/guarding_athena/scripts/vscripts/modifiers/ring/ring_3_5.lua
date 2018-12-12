ring_3_5 = class({})
function ring_3_5:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        if caster.ability_critical_chance == nil then
            caster.ability_critical_chance = 0
        end
        if caster.ability_critical_damage == nil then
            caster.ability_critical_damage = 0
        end
        caster.ability_critical_chance = caster.ability_critical_chance + 50
        caster.ability_critical_damage = caster.ability_critical_damage + 100
    end
end
function ring_3_5:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        caster.ability_critical_chance = caster.ability_critical_chance - 50
        caster.ability_critical_damage = caster.ability_critical_damage - 100
    end
end
function ring_3_5:IsHidden() 
	return false
end
function ring_3_5:GetTexture()
    return "item_ring_secret"
end