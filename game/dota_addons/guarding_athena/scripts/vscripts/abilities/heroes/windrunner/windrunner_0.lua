LinkLuaModifier( "modifier_windrunner_0", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_0_bonus_attack", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_0_active", "abilities/heroes/windrunner/windrunner_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_0 == nil then
	windrunner_0 = class({})
end
function windrunner_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_0_active", {duration = self:GetSpecialValueFor("duration"), iEntIndex = hTarget:entindex()})
	hCaster:MoveToTargetToAttack(hTarget)
end
function windrunner_0:GetIntrinsicModifierName()
	return "modifier_windrunner_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_0 == nil then
	modifier_windrunner_0 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_0:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.delay_pct = self:GetAbilitySpecialValueFor("delay_pct")
	if IsServer() then
		self.tRecord = {}
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
end
function modifier_windrunner_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_0:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
end
function modifier_windrunner_0:OnAttackRecord(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end

	local hParent = self:GetParent()
	if hParent:HasModifier("modifier_windrunner_0_bonus_attack") then
		table.insert(self.tRecord, params.record)
	end
end
function modifier_windrunner_0:OnAttackRecordDestroy(params)
	ArrayRemove(self.tRecord, params.record)
end
function modifier_windrunner_0:OnAttack(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	
	local hParent = self:GetParent()
	if not hParent:HasModifier("modifier_windrunner_0_bonus_attack") then
		self.hModifier = hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_windrunner_0_bonus_attack", nil)
	else
		hParent:RemoveModifierByName("modifier_windrunner_0_bonus_attack")
	end
end
function modifier_windrunner_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
end
function modifier_windrunner_0:GetOverrideAttackMagical(params)
	if TableFindKey(self.tRecord, params.record) then
		return 1
	end
end
function modifier_windrunner_0:GetModifierProcAttack_BonusDamage_Magical(params)
	if TableFindKey(self.tRecord, params.record) then
		local flDamage = params.damage
		if self:GetParent():GetScepterLevel() >= 1 then
			flDamage = flDamage + self:GetAbilitySpecialValueFor("scepter_damage") * self:GetParent():GetAgility()
		end
		return flDamage 
	end
end
---------------------------------------------------------------------
if modifier_windrunner_0_bonus_attack == nil then
	modifier_windrunner_0_bonus_attack = class({}, nil, ModifierHidden)
end
function modifier_windrunner_0_bonus_attack:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_windrunner_0_bonus_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end
function modifier_windrunner_0_bonus_attack:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() then
		return 1000
	end
end
function modifier_windrunner_0_bonus_attack:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		return 0.01
	end
end
function modifier_windrunner_0_bonus_attack:GetModifierProjectileName()
	return "particles/skills/moonstar_gold.vpcf"
end
---------------------------------------------------------------------
if modifier_windrunner_0_active == nil then
	modifier_windrunner_0_active = class({}, nil, ModifierPositiveBuff)
end
function modifier_windrunner_0_active:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.iEntIndex)
	end
end
function modifier_windrunner_0_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
end
function modifier_windrunner_0_active:GetModifierAttackSpeedBonus_Constant(params)
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return self.bonus_attackspeed
end
function modifier_windrunner_0_active:GetModifierAttackRangeBonus(params)
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return self.bonus_attack_range
end
function modifier_windrunner_0_active:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		local hAggro = self:GetParent():GetAggroTarget()
		if IsValid(hAggro) and hAggro ~= self.hTarget then
			return 0
		end
	end
	return 1
end