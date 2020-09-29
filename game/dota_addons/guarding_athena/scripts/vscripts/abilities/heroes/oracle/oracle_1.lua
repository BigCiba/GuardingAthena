LinkLuaModifier( "modifier_oracle_1_buff", "abilities/heroes/oracle/oracle_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oracle_1_debuff", "abilities/heroes/oracle/oracle_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_1 == nil then
	oracle_1 = class({})
end
function oracle_1:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function oracle_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDuration = self:GetSpecialValueFor("duration")
	local flDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetIntellect()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_oracle_1_debuff", {duration = flDuration})
	end
	-- 回血
	hCaster:AddNewModifier(hCaster, self, "modifier_oracle_1_buff", {duration = flDuration})
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
end
function oracle_1:GetIntrinsicModifierName()
	return "modifier_oracle_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_1_buff == nil then
	modifier_oracle_1_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_oracle_1_buff:OnCreated(params)
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self.flHealAmount = self:GetCaster():GetIntellect() * self.damage_dot * self.interval
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_1_buff:OnRefresh(params)
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
end
function modifier_oracle_1_buff:OnIntervalThink()
	self:GetParent():Heal(self.flHealAmount, self:GetAbility())
end
---------------------------------------------------------------------
if modifier_oracle_1_debuff == nil then
	modifier_oracle_1_debuff = class({}, nil, ModifierPositiveBuff)
end
function modifier_oracle_1_debuff:OnCreated(params)
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	if IsServer() then
		self.flDamage = self:GetCaster():GetIntellect() * self.damage_dot * self.interval
		self:SetStackCount(1)
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_1_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_1_debuff:OnRefresh(params)
	self.damage_dot = self:GetAbilitySpecialValueFor("damage_dot")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_oracle_1_debuff:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.flDamage * self:GetStackCount())
end
function modifier_oracle_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_oracle_1_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return -self.damage_reduce_pct
end