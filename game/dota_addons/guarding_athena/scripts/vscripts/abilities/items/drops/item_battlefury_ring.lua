LinkLuaModifier("modifier_item_battlefury_ring", "abilities/items/drops/item_battlefury_ring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_battlefury_ring_buff", "abilities/items/drops/item_battlefury_ring.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_battlefury_ring_attack", "abilities/items/drops/item_battlefury_ring.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_battlefury_ring == nil then
	item_battlefury_ring = class({})
end
function item_battlefury_ring:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = hCaster:GetAbsOrigin()
	local skill_radius = self:GetSpecialValueFor("skill_radius")
	local skill_damage = self:GetSpecialValueFor("skill_damage")
	local absorb_pct = self:GetSpecialValueFor("absorb_pct")
	local suicide = self:GetSpecialValueFor("suicide")
	local flDifficultyFactor = GameRules:GetDifficulty() or 1
	local flRoundFactor = (1 + (Spawner.gameRound or 1) * 0.01)
	local flDamage = (hCaster:GetStrength() + hCaster:GetAgility() + hCaster:GetIntellect()) * skill_damage * flDifficultyFactor * flRoundFactor
	local flAbsorbAmount = 0
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, skill_radius, self)
	for _, hUnit in pairs(tTargets) do
		local flAbsorbHealth = math.min(hUnit:GetMaxHealth() * absorb_pct * 0.01, hUnit:GetHealth())
		flAbsorbAmount = flAbsorbAmount + flAbsorbHealth
		hCaster:DealDamage(hUnit, self, flAbsorbHealth, self:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)
	end
	hCaster:DealDamage(tTargets, self, flDamage + flAbsorbAmount)
	-- 对自身造成伤害
	local flCostHealth = math.min(hCaster:GetMaxHealth() * suicide * 0.01, hCaster:GetHealth())
	hCaster:ModifyHealth(hCaster:GetHealth() - flCostHealth, self, true, 0)
	-- 增加伤害
	hCaster:AddNewModifier(hCaster, self, "modifier_item_battlefury_ring_buff", {duration = self:GetDuration()})
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items/battlefury_ring/battlefury_ring_eclipse.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( iParticleID, 0, vPosition )
	ParticleManager:SetParticleControl( iParticleID, 1, Vector(skill_radius, skill_radius, 1) )
	ParticleManager:SetParticleControl( iParticleID, 1, Vector(skill_radius, skill_radius, skill_radius) )
	-- sound
	hCaster:EmitSound("Hero_ObsidianDestroyer.SanityEclipse.Cast")
end
function item_battlefury_ring:GetIntrinsicModifierName()
	return "modifier_item_battlefury_ring"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_item_battlefury_ring == nil then
	modifier_item_battlefury_ring = class({}, nil, ModifierItemBasic)
end
function modifier_item_battlefury_ring:OnCreated(params)
	self.bonus_all_stats = self:GetAbilitySpecialValueFor("bonus_all_stats")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
	self.aura_damage = self:GetAbilitySpecialValueFor("aura_damage")
	self.aura_interval = self:GetAbilitySpecialValueFor("aura_interval")
	self.aura_damage = self:GetAbilitySpecialValueFor("aura_damage")
	if IsServer() then
		self:StartIntervalThink(self.aura_interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items/battlefury_ring_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_battlefury_ring:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local flAbsorbAmount = 0
	local flAttackAmount = 0
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.aura_radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		local flAbsorbHealth = math.min(hUnit:GetMaxHealth() * self.aura_damage * 0.01, hUnit:GetHealth())
		flAbsorbAmount = flAbsorbAmount + flAbsorbHealth
		local flAttack = math.ceil(hUnit:GetAverageTrueAttackDamage(hParent) * self.aura_damage * 0.01)
		if hUnit:IsRangedAttacker() == false then
			if string.find(hUnit:GetUnitName(), "guai_") then
				flAttack = math.floor(flAttack / ((Spawner.gameRound^2 - Spawner.gameRound + 100) * 0.01))
			end
		end
		flAttackAmount = flAttackAmount + flAttack
		hParent:DealDamage(hUnit, hAbility, flAbsorbHealth, hAbility:GetAbilityDamageType(), DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)
	end
	hParent:Heal(flAbsorbAmount, hAbility)
	hParent:ModifyStrength(1)
	hParent:ModifyAgility(1)
	hParent:ModifyIntellect(1)
	hParent:AddNewModifier(hParent, hAbility, "modifier_item_battlefury_ring_attack", {duration = 10, bonus_attack = flAttackAmount})
	self:StartIntervalThink(self.aura_interval - 0.2 * (100 - hParent:GetHealthPercent()) / 10)
end
function modifier_item_battlefury_ring:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_item_battlefury_ring:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end
function modifier_item_battlefury_ring:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end
function modifier_item_battlefury_ring:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end
function modifier_item_battlefury_ring:GetModifierTotalDamageOutgoing_Percentage(params)
	return self.bonus_damage
end
---------------------------------------------------------------------
if modifier_item_battlefury_ring_attack == nil then
	modifier_item_battlefury_ring_attack = class({}, nil, ModifierItemBasic)
end
function modifier_item_battlefury_ring_attack:IsHidden()
	return true
end
function modifier_item_battlefury_ring_attack:OnCreated(params)
	self.skill_damage_increase = self:GetAbilitySpecialValueFor("skill_damage_increase")
end
function modifier_item_battlefury_ring_attack:OnCreated(params)
	if IsServer() then
		self.tDatas = {}
		table.insert(self.tDatas, {
			iCount = params.bonus_attack,
			flDieTime = self:GetDieTime()
		})
		self:SetStackCount(self:GetStackCount() + params.bonus_attack)
		self:StartIntervalThink(0)
	end
end
function modifier_item_battlefury_ring_attack:OnRefresh(params)
	if IsServer() then
		table.insert(self.tDatas, {
			iCount = params.bonus_attack,
			flDieTime = self:GetDieTime()
		})
		self:SetStackCount(self:GetStackCount() + params.bonus_attack)
	end
end
function modifier_item_battlefury_ring_attack:OnIntervalThink()
	local fGameTime = GameRules:GetGameTime()
	for i = #self.tDatas, 1, -1 do
		if fGameTime >= self.tDatas[i].flDieTime then
			self:SetStackCount(self:GetStackCount() - self.tDatas[i].iCount)
			table.remove(self.tDatas, i)
		end
	end
end
function modifier_item_battlefury_ring_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
function modifier_item_battlefury_ring_attack:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_item_battlefury_ring_buff == nil then
	modifier_item_battlefury_ring_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_battlefury_ring_buff:OnCreated(params)
	self.skill_damage_increase = self:GetAbilitySpecialValueFor("skill_damage_increase")
end
function modifier_item_battlefury_ring_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_item_battlefury_ring_buff:GetModifierTotalDamageOutgoing_Percentage()
	return self.skill_damage_increase
end