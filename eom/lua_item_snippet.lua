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
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_[filename]:GetAbilitySpecialValue()
	self.auto_attack			= self:GetAbilitySpecialValueFor("auto_attack")
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