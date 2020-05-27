LinkLuaModifier( "modifier_captain", "abilities/enemy/captain.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_captain_buff", "abilities/enemy/captain.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if captain == nil then
	captain = class({})
end
function captain:GetIntrinsicModifierName()
	return "modifier_captain"
end
---------------------------------------------------------------------
--Modifiers
if modifier_captain == nil then
	modifier_captain = class({}, nil, ModifierHidden)
end
function modifier_captain:OnCreated(params)
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
		self.flHealth = math.ceil(self:GetParent():GetMaxHealth() * self.damage_limit * 0.01)
		self.threshold = self:GetParent():GetMaxHealth() - self.flHealth
		local hParent = self:GetParent()
		hParent:SetDeathXP(hParent:GetDeathXP() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMinimumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMaximumGoldBounty(hParent:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseDamageMin(hParent:GetBaseDamageMin() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseDamageMax(hParent:GetBaseDamageMax() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetBaseMaxHealth(hParent:GetBaseMaxHealth() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
		hParent:SetMaxHealth(hParent:GetBaseMaxHealth())
		hParent:SetHealth(hParent:GetBaseMaxHealth())
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_captain:OnRefresh(params)
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_captain:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_captain:OnTakeDamage(params)
	local hCaster = params.unit
	if hCaster == self:GetParent() then
		local hAbility = self:GetAbility()
		if hCaster:GetHealth() == self.threshold then
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_captain_buff", {duration = self:GetAbilityDuration()})
			self:StartIntervalThink(0)
		end
	end
end
function modifier_captain:OnIntervalThink()
	self.threshold = math.max(self.threshold - self.flHealth, 0)
end
function modifier_captain:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_captain:GetMinHealth()
	if IsServer() then
		if self.threshold > 0 then
			return self.threshold
		end
	end
end
function modifier_captain:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end
function modifier_captain:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end
function modifier_captain:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_captain:GetModifierPreAttack_CriticalStrike(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		if not params.attacker:PassivesDisabled() and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
			if RollPercentage(self.crit_chance) then
				return self.crit_mult
			end
		end
	end
end
function modifier_captain:GetModifierModelScale()
	return 50
end
---------------------------------------------------------------------
if modifier_captain_buff == nil then
	modifier_captain_buff = class({}, nil, ModifierBasic)
end
function modifier_captain_buff:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
end
function modifier_captain_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_captain_buff:GetModifierIncomingDamage_Percentage(params)
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), -self.damage_reduce, 0)
end