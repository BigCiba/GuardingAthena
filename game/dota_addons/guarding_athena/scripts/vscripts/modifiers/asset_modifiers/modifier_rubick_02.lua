if modifier_rubick_02 == nil then
	modifier_rubick_02 = class({}, nil, AssetModifier)
end
local public = modifier_rubick_02

function public:OnCreated(params)
	self:Init()
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	local hParent = self:GetParent()
	-- 是否装备魔导师秘钥
	hParent.HasArcana = function (hParent)
		return true
	end
	if IsServer() then
		-- 替换饰品
		AssetModifiers:ReplaceWearables("rubick_02", hParent)
		-- 空间裂缝
		self.hAbility = hParent:FindAbilityByName("rubick_0")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 60, Vector(0, 0, 255))
		ParticleManager:SetParticleControl(iParticleID, 61, Vector(0, 0, 255))
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
		MODIFIER_EVENT_ON_RESPAWN
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement(self:GetParent():GetSkinName())
end
function public:GetModifierProjectileName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_rubick/rubick_base_attack.vpcf", self:GetParent())
end
function public:GetModifierProjectileSpeedBonus()
	return 10000
end
function public:OnRespawn(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if hParent == params.unit then
		-- 重新替换饰品
		AssetModifiers:ReplaceWearables("rubick_02", hParent)
	end
end