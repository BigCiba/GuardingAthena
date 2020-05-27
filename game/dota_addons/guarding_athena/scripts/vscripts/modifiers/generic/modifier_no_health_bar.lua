if modifier_no_health_bar == nil then
	modifier_no_health_bar = class({}, nil, ModifierBasic)
end
function modifier_no_health_bar:IsHidden()
	return true
end
function modifier_no_health_bar:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_no_health_bar:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end