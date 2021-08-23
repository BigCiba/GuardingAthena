item_ogre_1 = class({})
function item_ogre_1:GetIntrinsicModifierName()
	return "modifier_item_ogre_1"
end
---------------------------------------------------------------------
--Modifiers
modifier_item_ogre_1 = eom_modifier({
	Name = "modifier_item_ogre_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_item_ogre_1:GetAbilitySpecialValue()
	self.auto_attack			= self:GetAbilitySpecialValueFor("auto_attack")
end
function modifier_item_ogre_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_ogre_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_ogre_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ogre_1:DeclareFunctions()
	return {
	}
end
function modifier_item_ogre_1:EDeclareFunctions()
	return {
	}
end