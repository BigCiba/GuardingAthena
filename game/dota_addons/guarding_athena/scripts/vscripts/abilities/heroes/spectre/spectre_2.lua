LinkLuaModifier( "modifier_spectre_2", "abilities/heroes/spectre/spectre_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_2_buff", "abilities/heroes/spectre/spectre_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_2_debuff", "abilities/heroes/spectre/spectre_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_2 == nil then
	spectre_2 = class({})
end
function spectre_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_spectre_2_buff", {duration = 0.5})
	-- 使下次攻击达到浮动上限
	hCaster:GetIntrinsicModifier():SetStackCount(self:GetSpecialValueFor("damage_limit"))
	hCaster:EmitSound("Hero_Bane.BrainSap.Target")
end
function spectre_2:GetIntrinsicModifierName()
	return "modifier_spectre_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_2 == nil then
	modifier_spectre_2 = class({}, nil, ModifierHidden)
end
function modifier_spectre_2:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage_add = self:GetAbilitySpecialValueFor("damage_add")
	self.health_cost = self:GetAbilitySpecialValueFor("health_cost")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_spectre_2:OnRefresh(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage_add = self:GetAbilitySpecialValueFor("damage_add")
	self.health_cost = self:GetAbilitySpecialValueFor("health_cost")
	if IsServer() then
	end
end
function modifier_spectre_2:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_spectre_2:OnAttackLanded(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = params.target
		if params.attacker == self:GetParent() then
			-- 消耗生命
			local flHealthCost = hParent:GetMaxHealth() * self.health_cost * 0.01
			hParent:ModifyHealth(hParent:GetHealth() - flHealthCost, self:GetAbility(), false, 0)
			-- 触发受到伤害效果
			local hModifier = hParent:FindModifierByName("modifier_spectre_3")
			if IsValid(hModifier) then
				hModifier:OnTakeDamage({unit = hParent, damage = flHealthCost})
			end
			self:OnTakeDamage({unit = hParent, damage = flHealthCost})
			-- 造成攻击伤害
			local flStrength = hParent:IsRealHero() and hParent:GetStrength() or hParent:GetOwner():GetStrength()
			local iMaxFactor = self.damage + self:GetStackCount()
			local iScepterLevel = hParent:GetScepterLevel()
			-- 二转：最小伤害提升为最大伤害的一半
			local flMinDamage = hParent:GetScepterLevel() >= 2 and iMaxFactor * self:GetSpecialValueFor("scepter_min_damage_pct") * 0.01 * flStrength or 1
			local flDamage = RandomInt(flMinDamage, iMaxFactor * flStrength)
			hParent:DealDamage(hTarget, self:GetAbility(), flDamage)
			if hParent:IsRealHero() then
				CreateNumberEffect(hTarget, flDamage, 1, MSG_ORIT, {199,21,133}, 6)
			else
				CreateNumberEffect(hTarget, flDamage, 1, MSG_ORIT, {148,0,211}, 6)
			end
			-- particle
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_desolate.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			local vDirection = hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()
			vDirection.z = 0
			ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection:Normalized())
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- sound
			hParent:EmitSound("Hero_Spectre.Desolate")

			self:SetStackCount(0)
		end
	end
end
function modifier_spectre_2:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit == hParent then
			if self:GetStackCount() < self.damage_limit then
				self:SetStackCount(math.min(self:GetStackCount() + self.damage_add, self.damage_limit))
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_spectre_2_buff == nil then
	modifier_spectre_2_buff = class({}, nil, ModifierHidden)
end
function modifier_spectre_2_buff:OnCreated(params)
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_active = self:GetAbilitySpecialValueFor("damage_active")
	self.shock_duration = self:GetAbilitySpecialValueFor("shock_duration")
	if IsServer() then
		local hParent = self:GetParent()
		local flHealthCost = hParent:GetHealth() * 0.3
		hParent:ModifyHealth(hParent:GetHealth() - flHealthCost, self, false, 0)
		-- 触发受到伤害效果
		local hModifier = hParent:FindModifierByName("modifier_spectre_3")
		if IsValid(hModifier) then
			hModifier:OnTakeDamage({unit = hParent, damage = flHealthCost})
		end
		self.flDamage = self.damage_active * flHealthCost * (0.1 / self:GetDuration())
		self:StartIntervalThink(0.1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_2_tentacle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_2_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_spectre_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hUnit:Stop()
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_spectre_2_debuff", {duration = self.shock_duration})
		hParent:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		hParent:Heal(self.heal * self.flDamage, self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_spectre_2_debuff == nil then
	modifier_spectre_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_spectre_2_debuff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.2)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_2_debuff:OnIntervalThink()
	self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
end
function modifier_spectre_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_spectre_2_debuff:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
end
function modifier_spectre_2_debuff:GetModifierMoveSpeed_Absolute()
	return 100
end