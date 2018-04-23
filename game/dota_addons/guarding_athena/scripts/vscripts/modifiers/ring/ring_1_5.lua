ring_1_5 = class({})

function ring_1_5:OnCreated()
    local caster = self:GetParent()
    if caster.ring_1_5 == nil then
        caster.ring_1_5 = 0
    end
    self:StartIntervalThink( 1 )
end
function ring_1_5:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local hpPercent = math.floor((100 - caster:GetHealthPercent()) / 10) + 1
        SetUnitDamagePercent(caster,-caster.ring_1_5)
        caster.ring_1_5 = hpPercent * 20
        SetUnitDamagePercent(caster,caster.ring_1_5)
    end
end
function ring_1_5:IsHidden() 
	return false
end
function ring_1_5:GetTexture()
    return "item_ring_secret"
end
