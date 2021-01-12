LinkLuaModifier("modifier_void_spirit_3", "abilities/heroes/void_spirit/void_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_3_debuff", "abilities/heroes/void_spirit/void_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_3 == nil then
	void_spirit_3 = class({})
end
function void_spirit_3:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local search_radius = self:GetSpecialValueFor("search_radius")
	local flMinDistance
	for _, hUnit in ipairs(hCaster.tAetherRemnant) do
		if IsValid(hUnit) and hUnit:IsAlive() then
			local flDistance = (hUnit:GetAbsOrigin() - vPosition):Length2D()
			if flDistance < search_radius then
				if flMinDistance == nil or flDistance < flMinDistance then
					flMinDistance = flDistance
					self.hIllusion = hUnit
				end
			end
		end
	end
	if IsValid(self.hIllusion) then
		self.hIllusion:SetForwardVector((hCaster:GetAbsOrigin() - self.hIllusion:GetAbsOrigin()):Normalized())
		self.hIllusion:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	end
	return true
end
function void_spirit_3:OnAbilityPhaseInterrupted()
	if IsValid(self.hIllusion) and self.hIllusion:IsAlive() then
		self.hIllusion:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
		self.hIllusion = nil
	end
end
function void_spirit_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()

	-- 幻象
	if not hCaster:IsIllusion() then
		if IsValid(self.hIllusion) and self.hIllusion:IsAlive() then
			self.hIllusion:SetCursorPosition(hCaster:GetAbsOrigin())
			self.hIllusion:FindAbilityByName("void_spirit_3"):OnSpellStart()
			self.hIllusion:Kill(self, hCaster)
			self.hIllusion = nil
			if self:GetCurrentAbilityCharges() < 2 then
				self:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges() + 1)
			end
		else
			hCaster:AetherRemnant(hCaster:GetAbsOrigin())
		end
	end

	--范围打击
	local radius = self:GetSpecialValueFor("radius")
	local min_travel_distance = self:GetSpecialValueFor("min_travel_distance")
	local max_travel_distance = self:GetSpecialValueFor("max_travel_distance")
	local pop_damage_delay = self:GetSpecialValueFor("pop_damage_delay")

	local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
	local fDis = math.min(max_travel_distance, math.max((vTarget - hCaster:GetAbsOrigin()):Length2D(), min_travel_distance))
	local vE = hCaster:GetAbsOrigin() + vDir * fDis
	self:AstralStep(vE)

	-- if #hCaster.tAetherRemnant > 0 then
	-- 	hCaster:GameTimer(0, function()
	-- 		local hUnit = RandomValue(hCaster.tAetherRemnant)
	-- 		if IsValid(hUnit) then
	-- 			self:AstralStep(hUnit:GetAbsOrigin())
	-- 			hUnit:Kill(self, hCaster)
	-- 			if #hCaster.tAetherRemnant > 0 then
	-- 				return 0.2
	-- 			end
	-- 		end
	-- 	end)
	-- end
end
function void_spirit_3:AstralStep(vPosition)
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_3", nil)
	hCaster:EmitSound('Hero_VoidSpirit.AstralStep.Start')

	--范围打击
	local radius = self:GetSpecialValueFor("radius")
	local pop_damage_delay = self:GetSpecialValueFor("pop_damage_delay")

	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), vPosition, nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	for _, hTarget in pairs(tTargets) do
		--造成攻击
		hCaster:PerformAttack(hTarget, true, true, true, true, false, false, true)
		--减速
		hTarget:AddNewModifier(hCaster, self, 'modifier_void_spirit_3_debuff', { duration = pop_damage_delay })
	end
	hCaster:RemoveModifierByName("modifier_void_spirit_3")
	--位移
	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iPtclID, 1, vPosition)
	hCaster:SetAbsOrigin(vPosition)
	FindClearSpaceForUnit(hCaster, vPosition, true)
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/void_spirit_attack_travel_strike_blur.vpcf', PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_3 == nil then
	modifier_void_spirit_3 = class({}, nil, ModifierHidden)
end
function modifier_void_spirit_3:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
end
function modifier_void_spirit_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end
function modifier_void_spirit_3:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
---------------------------------------------------------------------
if modifier_void_spirit_3_debuff == nil then
	modifier_void_spirit_3_debuff = class({}, nil, ModifierDebuff)
end
function modifier_void_spirit_3_debuff:GetStatusEffectName()
	return 'particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf'
end
function modifier_void_spirit_3_debuff:StatusEffectPriority()
	return 10
end
function modifier_void_spirit_3_debuff:GetEffectName()
	return 'particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf'
end
function modifier_void_spirit_3_debuff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_void_spirit_3_debuff:ShouldUseOverheadOffset()
	return true
end
function modifier_void_spirit_3_debuff:OnCreated(params)
	self.movement_slow_pct = self:GetAbilitySpecialValueFor("movement_slow_pct")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	if IsServer() then
		self:IncrementStackCount()
		local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(iPtclID, false, false, -1, false, true)
	end
end
function modifier_void_spirit_3_debuff:OnRefresh(params)
	self.movement_slow_pct = self:GetAbilitySpecialValueFor("movement_slow_pct")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_void_spirit_3_debuff:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local flDamage = (self:GetCaster():GetIntellect() * self.damage * self:GetStackCount()) * (1 + self:GetStackCount() * self.damage_deepen * 0.01)
		hCaster:DealDamage(self:GetParent(), self:GetAbility(), flDamage)
		local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iPtclID)
	end
end
function modifier_void_spirit_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_void_spirit_3_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movement_slow_pct
end