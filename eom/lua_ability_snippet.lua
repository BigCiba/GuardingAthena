[filename] = class({})
function [filename]:GetIntrinsicModifierName()
	return "modifier_[filename]"
end
---------------------------------------------------------------------
--Modifiers
modifier_[filename] = eom_modifier({
	Name = "modifier_[filename]",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_[filename]:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_[filename]:OnCreated(params)
	if IsServer() then
	end
end
function modifier_[filename]:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_[filename]:OnDestroy()
	if IsServer() then
	end
end
function modifier_[filename]:DeclareFunctions()
	return {
	}
end
function modifier_[filename]:EDeclareFunctions()
	return {
	}
end