if modifier_rubick_03 == nil then
	modifier_rubick_03 = class({}, nil, AssetModifier)
end
local public = modifier_rubick_03

function public:OnCreated(params)
	self:Init()
	local hParent = self:GetParent()
	if IsServer() then
		self.hAbility = hParent:FindAbilityByName("rubick_0")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 60, Vector(255, 241, 124))
		ParticleManager:SetParticleControl(iParticleID, 61, Vector(255, 241, 124))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function public:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function public:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self.hAbility:FadeBolt(params.target)
		end
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement(self:GetParent():GetSkinName())
end
function public:GetModifierProjectileName()
	return "particles/econ/items/rubick/rubick_ti8_immortal/rubick_ti8_immortal_fade_bolt_head.vpcf"
end
function public:GetModifierProjectileSpeedBonus()
	return 10000
end