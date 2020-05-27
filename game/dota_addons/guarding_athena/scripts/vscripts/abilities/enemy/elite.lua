LinkLuaModifier( "modifier_elite", "abilities/enemy/elite.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elite_buff", "abilities/enemy/elite.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite == nil then
	elite = class({})
end
function elite:GetIntrinsicModifierName()
	return "modifier_elite"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite == nil then
	modifier_elite = class({}, nil, ModifierHidden)
end
function modifier_elite:OnCreated(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetDeathXP(hParent:GetDeathXP() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMinimumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMaximumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseDamageMin(hParent:GetBaseDamageMin() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseDamageMax(hParent:GetBaseDamageMax() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseMaxHealth(hParent:GetBaseMaxHealth() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMaxHealth(hParent:GetBaseMaxHealth())
		hParent:SetHealth(hParent:GetBaseMaxHealth())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_huskar_lifebreak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_elite:OnRefresh(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	end
end
function modifier_elite:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_elite:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end
function modifier_elite:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end
function modifier_elite:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_elite:GetModifierModelScale()
	return 50
end