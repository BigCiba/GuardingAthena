LinkLuaModifier("modifier_item_longinus_spear", "abilities/items/artifact/item_longinus_spear.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_longinus_spear_thinker", "abilities/items/artifact/item_longinus_spear.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_longinus_spear == nil then
	item_longinus_spear = class({})
end
function item_longinus_spear:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_item_longinus_spear_thinker", {duration = 0.3})
	-- sound
	hCaster:EmitSound("Ability.StarfallImpact")
end
function item_longinus_spear:GetIntrinsicModifierName()
	return "modifier_item_longinus_spear"
end
---------------------------------------------------------------------
-- Modifier
if modifier_item_longinus_spear == nil then
	modifier_item_longinus_spear = class({}, nil, ModifierItemBasic)
end
function modifier_item_longinus_spear:OnCreated(params)
	self.attribute = self:GetAbilitySpecialValueFor("attribute")
	self.block_percent = self:GetAbilitySpecialValueFor("block_percent")
	self.bonus_mana_regen_pct = self:GetAbilitySpecialValueFor("bonus_mana_regen_pct")
	self.mana_bonus = self:GetAbilitySpecialValueFor("mana_bonus")
	self.trigger_percent = self:GetAbilitySpecialValueFor("trigger_percent")
	self.magic_damage_increase = self:GetAbilitySpecialValueFor("magic_damage_increase")
	if IsServer() then
		self:OnIntervalThink()
	else
		local p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_desolation/sf_desolation_ambient_blade_energy.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(p, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_longinus_spear:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_longinus_spear_shield")
	end
end
function modifier_item_longinus_spear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end
function modifier_item_longinus_spear:GetModifierManaBonus()
	return self.mana_bonus
end
function modifier_item_longinus_spear:GetModifierBonusStats_Strength()
	return self.attribute
end
function modifier_item_longinus_spear:GetModifierBonusStats_Agility()
	return self.attribute
end
function modifier_item_longinus_spear:GetModifierBonusStats_Intellect()
	return self.attribute
end
function modifier_item_longinus_spear:GetModifierTotalPercentageManaRegen()
	return self.bonus_mana_regen_pct
end
function modifier_item_longinus_spear:GetModifierTotal_ConstantBlock()
	return self:GetParent():GetMaxMana() * self.block_percent * 0.01
end
function modifier_item_longinus_spear:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local hParent = self:GetParent()
		local flBlock = hParent:GetMaxMana() * self.block_percent * 0.01
		local flDamage = math.max(params.damage - flBlock, 0)
		local flShield = hParent:GetMana() - (hParent:GetMaxMana() * self.trigger_percent * 0.01)
		local flManaCost = math.min(flShield, flDamage)
		if flManaCost > 0 then
			hParent:SpendMana(flManaCost, self:GetAbility())
		end
		if flShield > 0 then
			local vDirection = (params.attacker:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
			local p = ParticleManager:CreateParticle("particles/items/longinus_spear/longinus_spear_atfield.vpcf",PATTACH_ABSORIGIN,hParent)
			ParticleManager:SetParticleControl(p, 0, hParent:GetAbsOrigin() + vDirection * 100)
			ParticleManager:SetParticleControlForward(p, 0, vDirection)
		end
		return flShield
	end
end
function modifier_item_longinus_spear:GetModifierSpellAmplify_Percentage()
	return self.magic_damage_increase
end
---------------------------------------------------------------------
if modifier_item_longinus_spear_thinker == nil then
	modifier_item_longinus_spear_thinker = class({}, nil, ModifierHidden)
end
function modifier_item_longinus_spear_thinker:OnCreated(params)
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/items/longinus_spear/longinus_spear_active.vpcf",PATTACH_ABSORIGIN,self:GetParent())
		ParticleManager:SetParticleControl(p, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(p, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(p)
	end
end
function modifier_item_longinus_spear_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
		local stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
		local radius = self:GetAbilitySpecialValueFor("radius")
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), hCaster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,hUnit in pairs(tTargets) do
			hCaster:DealDamage(tTargets, self:GetAbility(), hParent:GetMaxHealth() * damage_percent * 0.01, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS)
			hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_stunned", {duration = stun_duration})
		end
		EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Hero_ElderTitan.EchoStomp", hCaster)
	end
end