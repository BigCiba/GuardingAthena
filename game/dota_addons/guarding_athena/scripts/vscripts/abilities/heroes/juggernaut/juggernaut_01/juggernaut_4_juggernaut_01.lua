juggernaut_4_juggernaut_01 = class({})
function juggernaut_4_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	-- hCaster:Dash()
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_4_juggernaut_01", { duration = self:GetSpecialValueFor("duration") })
end
---------------------------------------------------------------------
--Modifiers
modifier_juggernaut_4_juggernaut_01 = eom_modifier({
	Name = "modifier_juggernaut_4_juggernaut_01",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_4_juggernaut_01:OnCreated(params)
	-- self.radius = self:GetAbilitySpecialValueFor("radius")
	-- self.attack_range = self:GetAbilitySpecialValueFor("attack_range")
	-- self.damage_add = self:GetAbilitySpecialValueFor("damage_add")
	self.interval = 0.1
	-- self.physical_factor = self:GetAbilitySpecialValueFor("physical_factor")
	if IsServer() then
		self.count = 0	-- 次数标记
		self.flDamageRecorder = 0	-- 记录格挡次数
		self:StartIntervalThink(self.interval)
		-- self:OnIntervalThink()
	else
	end
end
function modifier_juggernaut_4_juggernaut_01:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vDirection = hParent:GetForwardVector()
	-- local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.attack_range, hAbility)
	-- if IsValid(tTargets[1]) then
	-- 	hParent:Attack(tTargets[1], ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
	-- end
	-- 挥剑特效
	local sParticleName = self.count == 0 and "particles/units/heroes/hero_juggernaut/juggernaut_3_2.vpcf" or "particles/units/heroes/hero_juggernaut/juggernaut_3.vpcf"
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(iParticleID, false, false, -1, false, false)
	local tInfo = {
		Ability = hAbility,
		Source = hParent,
		EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_4_juggernaut_01_wave.vpcf",
		vSpawnOrigin = hParent:GetAbsOrigin(),
		fDistance = 2000,
		fStartRadius = 300,
		fEndRadius = 300,
		vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, RandomInt(-15, 15), 0), vDirection) * 2000,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	-- 音效
	self:GetParent():EmitSound("Hero_DragonKnight.PreAttack")
	self.count = self.count == 0 and 1 or 0
end
-- function modifier_juggernaut_4_juggernaut_01:OnDestroy()
-- 	local hParent = self:GetParent()
-- 	if IsServer() and hParent:IsAlive() and GSManager:getStateType() == GS_Battle then
-- 		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_juggernaut_3_particle", { duration = 0.5 })
-- 		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
-- 		hParent:DealDamage(tTargets, self:GetAbility(), self.physical_factor * hParent:GetPhysicalAttack() * (1 + self.flDamageRecorder * self.damage_add * 0.01) * 0.01)
-- 		for _, hUnit in pairs(tTargets) do
-- 			hParent:KnockBack(hParent:GetAbsOrigin(), hUnit, 300, 0, 0.1, true)
-- 		end
-- 	end
-- end
-- function modifier_juggernaut_4_juggernaut_01:EDeclareFunctions()
-- 	return {
-- 		-- [EMDF_PHYSICAL_INCOMING_PERCENTAGE] = -1000,
-- 		-- EMDF_MAGICAL_INCOMING_PERCENTAGE,
-- 		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
-- 		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
-- 		MODIFIER_EVENT_ON_ATTACK_DAMAGE = {nil, self:GetParent() },
-- 		-- MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
-- 		EOM_MODIFIER_PROPERTY_ATTACK_BEHAVIOR,
-- 		MODIFIER_EVENT_ON_BATTLE_END
-- 	}
-- end
-- function modifier_juggernaut_4_juggernaut_01:OnBattleEnd()
-- 	-- 处理动作
-- 	self:Destroy()
-- 	self:GetParent():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
-- end
function modifier_juggernaut_4_juggernaut_01:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 1
	}
end
-- function modifier_juggernaut_4_juggernaut_01:OnTakeDamage(params)
-- 	if IsServer() then
-- 		self.flDamageRecorder = self.flDamageRecorder + 1
-- 	end
-- end
function modifier_juggernaut_4_juggernaut_01:GetOverrideAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end
function modifier_juggernaut_4_juggernaut_01:GetOverrideAnimationRate()
	return RemapValClamped(self.interval, 0.3, 0.1, 2, 6)
end
-- function modifier_juggernaut_4_juggernaut_01:OnAttackDamage(params)
-- 	local hParent = self:GetParent()
-- 	local hTarget = params.target
-- 	if hTarget == self:GetParent() then
-- 		EachAttackDamage(params, function(iDamageType, fDamage)
-- 			ApplyDamage({
-- 				ability = self:GetAbility(),
-- 				attacker = hParent,
-- 				victim = params.attacker,
-- 				damage = fDamage,
-- 				damage_type = iDamageType,
-- 			})
-- 		end)
-- 	end
-- end
-- function modifier_juggernaut_4_juggernaut_01:EOM_GetAttackBehavior(params)
-- 	if params.attack_behavior == true then
-- 		return
-- 	end
-- 	local hParent = self:GetParent()
-- 	local hTarget = params.target
-- 	local hAbility = self:GetAbility()
-- 	if params.attacker == hParent then
-- 		local flFaceAngle = VectorToAngles(hParent:GetForwardVector())[2]
-- 		if IsValid(params.attack_ability) and type(params.attack_ability.OnAttackHit) == "function" then
-- 			-- 范围伤害
-- 			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.attack_range, self:GetAbility())
-- 			for _, hUnit in pairs(tTargets) do
-- 				local vDirection = CalculateDirection(hUnit, hParent)
-- 				local flAngle = VectorToAngles(vDirection)[2]
-- 				if AngleDiff(flFaceAngle, flAngle) <= 100 then
-- 					params.attack_ability:OnAttackHit({
-- 						attacker = hParent,
-- 						target = hUnit,
-- 						crit_damage = params.crit_damage,
-- 						attack_ability = params.attack_ability,
-- 						record = params.record,
-- 					})
-- 				end
-- 			end
-- 		end
-- 		return true
-- 	end
-- end