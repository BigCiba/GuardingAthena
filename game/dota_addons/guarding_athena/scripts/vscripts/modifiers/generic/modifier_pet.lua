if modifier_pet == nil then
	modifier_pet = class({}, nil, ModifierBasic)
end
function modifier_pet:IsHidden()
    return true
end
function modifier_pet:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet:OnCreated(params)
	if IsServer() then
		-- self:StartIntervalThink(0)
	end
end
function modifier_pet:OnIntervalThink()
    -- self:GetParent():StartGesture(ACT_DOTA_RUN)
end
function modifier_pet:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end