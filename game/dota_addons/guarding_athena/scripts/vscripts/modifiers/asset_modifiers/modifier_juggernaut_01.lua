if modifier_juggernaut_01 == nil then
	modifier_juggernaut_01 = class({}, nil, AssetModifier)
end
local public = modifier_juggernaut_01

function public:OnCreated(params)
	self:Init()
	-- self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	local hParent = self:GetParent()


	-- -- 是否装备魔导师秘钥
	-- hParent.HasArcana = function (hParent)
	-- 	return true
	-- end
	if IsServer() then
		self:StartIntervalThink(0.1)
		-- 替换饰品
		AssetModifiers:ReplaceWearables("juggernaut_01", hParent)
		-- 替换技能
		AssetModifiers:ReplaceAbilities("juggernaut_01", hParent)
		-- -- 空间裂缝
		-- self.hAbility = hParent:FindAbilityByName("juggernaut_0")
	else
		-- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/juggernaut_arcana/juggernaut_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		-- ParticleManager:SetParticleControl(iParticleID, 60, Vector(0, 0, 255))
		-- ParticleManager:SetParticleControl(iParticleID, 61, Vector(0, 0, 255))
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	-- AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function public:OnIntervalThink()
	self:GetParent():SetSkin(1)
	self:StartIntervalThink(-1)
	-- RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function public:OnAttackLanded(params)
	-- if IsServer() then
	-- 	if params.attacker == self:GetParent() then
	-- 		self.hAbility:FadeBolt(params.target)
	-- 	end
	-- end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement("juggernaut_01")
end
function public:GetModifierProjectileName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_base_attack.vpcf", self:GetParent())
end
function public:GetModifierProjectileSpeedBonus()
	return 10000
end