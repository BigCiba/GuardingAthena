if modifier_ignore_armor == nil then
	modifier_ignore_armor = class({})
end
function modifier_ignore_armor:IsHidden()
	return true
end
function modifier_ignore_armor:IsDebuff()
	return true
end
function modifier_ignore_armor:IsPurgable()
	return false
end
function modifier_ignore_armor:IsPurgeException()
	return false
end
function modifier_ignore_armor:IsStunDebuff()
	return false
end
function modifier_ignore_armor:AllowIllusionDuplicate()
	return false
end
function modifier_ignore_armor:RemoveOnDeath()
	return false
end
function modifier_ignore_armor:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ignore_armor:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function modifier_ignore_armor:GetModifierIgnorePhysicalArmor(params)
	return 1
end
function modifier_ignore_armor:OnTakeDamage(params)
	if params.unit == self:GetParent() and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
		self:Destroy()
	end
end