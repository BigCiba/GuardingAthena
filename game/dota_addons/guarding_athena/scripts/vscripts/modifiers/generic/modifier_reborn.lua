if modifier_reborn == nil then
	modifier_reborn = class({}, nil, ModifierBasic)
end
function modifier_reborn:GetTexture()
	return "skeleton_king_reincarnation"
end
function modifier_reborn:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_reborn:OnCreated(params)
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_reborn:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_reborn:AllowIllusionDuplicate()
	return true
end
function modifier_reborn:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_reborn:OnTooltip()
	return self:GetStackCount()
end