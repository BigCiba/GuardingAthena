if ember_spirit_4 == nil then
	ember_spirit_4 = class({})
end
function ember_spirit_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local speed_multiplier = self:GetSpecialValueFor("speed_multiplier")
	local duration = self:GetSpecialValueFor("duration")

	local vStartPosition = hCaster:GetAbsOrigin()
	local vTargetPosition = self:GetCursorPosition()
	local vDirection = vTargetPosition - vStartPosition
	vDirection.z = 0
	if vDirection:Length2D() == 0 then vDirection = Vector(1, 0, 0) end

	local hThinker = CreateUnitByName("npc_dota_ember_spirit_remnant", vStartPosition, false, hCaster, hCaster, hCaster:GetTeamNumber())
	hThinker:AddNewModifier(hCaster, self, "modifier_ember_spirit_4_thinker", nil)
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_4_timer", { duration = duration, thinker_index = hThinker:entindex() })

	local fSpeed = hCaster:GetMoveSpeedModifier(hCaster:GetBaseMoveSpeed(), false) * speed_multiplier * 0.01

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", PATTACH_CUSTOMORIGIN, hThinker)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_CUSTOMORIGIN, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection:Normalized() * fSpeed)
	ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
	hThinker.iParticleID = iParticleID

	hThinker.vVelocity = vDirection:Normalized() * fSpeed

	local tInfo = {
		Ability = self,
		Source = hCaster,
		vSpawnOrigin = vStartPosition,
		vVelocity = hThinker.vVelocity,
		fDistance = vDirection:Length2D(),
		ExtraData = {
			thinker_index = hThinker:entindex(),
		},
	}
	ProjectileManager:CreateLinearProjectile(tInfo)

	hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")

	local ember_spirit_4_1 = self:GetCaster():FindAbilityByName(self:GetAssociatedSecondaryAbilities())
	if ember_spirit_4_1 then
		local tRemnants = ember_spirit_4_1.tRemnants or {}
		table.insert(tRemnants, hThinker)
		ember_spirit_4_1.tRemnants = tRemnants
	end

	local fCooldown = self:GetCooldownTime()
	local hChargeCounter = hCaster:FindModifierByName(self:GetIntrinsicModifierName())
	if IsValid(hChargeCounter) and fCooldown > 0 then
		if hChargeCounter:GetDuration() == -1 then
			hChargeCounter:StartIntervalThink(fCooldown)
			hChargeCounter:SetDuration(fCooldown, true)
		end

		hChargeCounter:DecrementStackCount()

		if hChargeCounter:GetStackCount() == 0 then
			self:EndCooldown()
			self:StartCooldown(hChargeCounter:GetRemainingTime())
		else
			self:EndCooldown()
		end
	end
end
function ember_spirit_4:OnProjectileThink_ExtraData(vLocation, ExtraData)
	local hThinker = EntIndexToHScript(ExtraData.thinker_index)
	if IsValid(hThinker) then
		hThinker:SetAbsOrigin(vLocation)
	end
end
function ember_spirit_4:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hThinker = EntIndexToHScript(ExtraData.thinker_index)
	if IsValid(hThinker) then
		local hModifier = hThinker:FindModifierByName("modifier_ember_spirit_4_thinker")
		if hModifier then
			local hCaster = self:GetCaster()
			local radius = self:GetSpecialValueFor("radius")
			local tSequences = { 22, 23, 24 }

			vLocation = GetGroundPosition(vLocation, hCaster)

			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hThinker)
			ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
			ParticleManager:SetParticleFoWProperties(iParticleID, 0, -1, radius)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_CUSTOMORIGIN_FOLLOW, nil, vLocation, true)
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(tSequences[RandomInt(1, #tSequences)], 0, 0))
			hModifier:AddParticle(iParticleID, true, false, -1, false, false)

			hThinker:EmitSound("Hero_EmberSpirit.FireRemnant.Create")
		end

		if hThinker.iParticleID ~= nil then
			ParticleManager:DestroyParticle(hThinker.iParticleID, false)
			hThinker.iParticleID = nil
		end
	end
end
function ember_spirit_4:RefreshCharges()
	local hCaster = self:GetCaster()
	local hChargeCounter = hCaster:FindModifierByName(self:GetIntrinsicModifierName())
	if IsValid(hChargeCounter) then
		local iMaxCharges = self:GetCaster():GetScepterLevel() >= 1 and hChargeCounter.scepter_max_charges or hChargeCounter.max_charges
		hChargeCounter:SetStackCount(iMaxCharges)
		hChargeCounter:StartIntervalThink(-1)
		hChargeCounter:SetDuration(-1, true)
	end
end
function ember_spirit_4:GetAssociatedSecondaryAbilities()
	return "ember_spirit_4_1"
end
function ember_spirit_4:OnUpgrade()
	local ember_spirit_4_1 = self:GetCaster():FindAbilityByName(self:GetAssociatedSecondaryAbilities())
	if ember_spirit_4_1 then
		ember_spirit_4_1:UpgradeAbility(true)
	end
end
function ember_spirit_4:GetIntrinsicModifierName()
	return "modifier_ember_spirit_4_charge_counter"
end
function ember_spirit_4:ProcsMagicStick()
	return false
end
function ember_spirit_4:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
if ember_spirit_4_1 == nil then
	ember_spirit_4_1 = class({})
end
function ember_spirit_4_1:Spawn()
	if IsServer() then
		self:SetLevel(1)
		self:ToggleAutoCast()
	end
end
function ember_spirit_4_1:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_mana_cost")
	end
	return self.BaseClass.GetManaCost(self, iLevel)
end
function ember_spirit_4_1:FilterRemnants()
	if self.tRemnants ~= nil then
		for i = #self.tRemnants, 1, -1 do
			local hRemnant = self.tRemnants[i]
			if not IsValid(hRemnant) then
				table.remove(self.tRemnants, i)
			end
		end
	end
end
function ember_spirit_4_1:CastFilterResultLocation(vLocation)
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_ember_spirit_4") then
			self.error = "#dota_hud_error_ember_spirit_no_active_remnants"
			return UF_FAIL_CUSTOM
		end

		self:FilterRemnants()

		if self.tRemnants == nil or #self.tRemnants == 0 then
			self.error = "#dota_hud_error_ember_spirit_no_active_remnants"
			return UF_FAIL_CUSTOM
		end
	end
	return UF_SUCCESS
end
function ember_spirit_4_1:GetCustomCastErrorLocation(vLocation)
	return self.error or ""
end
function ember_spirit_4_1:OnSpellStart()
	self:FilterRemnants()

	if self.tRemnants ~= nil and #self.tRemnants > 0 then
		local vPosition = self:GetCursorPosition()
		local hCaster = self:GetCaster()

		if self:GetAutoCastState() then
			table.sort(self.tRemnants, function(a, b)
				return (vPosition - a:GetAbsOrigin()):Length2D() > (vPosition - b:GetAbsOrigin()):Length2D()
			end)
		else
			table.sort(self.tRemnants, function(a, b)
				return (vPosition - a:GetAbsOrigin()):Length2D() < (vPosition - b:GetAbsOrigin()):Length2D()
			end)
		end

		local hRemnant = self.tRemnants[1]
		if IsValid(hRemnant) then
			hCaster:RemoveModifierByName("modifier_ember_spirit_1")

			local speed = self:GetSpecialValueFor("speed")
			local fDistance = (hRemnant:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()

			self.hTargetRemnant = hRemnant
			self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()

			self.vLocation = hCaster:GetAbsOrigin()
			local tInfo =			{
				Target = hRemnant,
				Source = hCaster,
				Ability = self,
				iMoveSpeed = fDistance > speed and (fDistance / 0.4) or speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_NONE,
				vSourceLoc = hCaster:GetAbsOrigin(),
				flExpireTime = GameRules:GetGameTime() + 10,
				bReplaceExisting = true,
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)

			self.tTargets = {}

			hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_4", nil)
		end
	end
end
function ember_spirit_4_1:OnProjectileThink(vLocation)
	local hCaster = self:GetCaster()

	if IsValid(self.hTargetRemnant) then
		self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()
	end

	local vDirection = vLocation - self.vLocation
	vDirection.z = 0

	vLocation = GetGroundPosition(self.vLocation + vDirection:Normalized() * Clamp(vDirection:Length2D(), 0, (self.vLocation - self.vRemnantPosition):Length2D()), hCaster)

	GridNav:DestroyTreesAroundPoint(vLocation, 200, false)

	local radius = self:GetSpecialValueFor("radius")

	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vLocation, vLocation, nil, radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
	for n, hTarget in pairs(tTargets) do
		if TableFindKey(self.tTargets, hTarget) == nil then
			hCaster:DealDamage(hTarget, self)
			hCaster:ApplyEmber(hTarget)

			table.insert(self.tTargets, hTarget)
		end
	end

	self.vLocation = vLocation
end
function ember_spirit_4_1:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()

	if IsValid(self.hTargetRemnant) then
		self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()
	end

	self.vRemnantPosition = GetGroundPosition(self.vRemnantPosition, hCaster)
	GridNav:DestroyTreesAroundPoint(self.vRemnantPosition, 200, false)

	local fDamage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self.vRemnantPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
	for n, hTarget in pairs(tTargets) do
		if TableFindKey(self.tTargets, hTarget) == nil then
			hCaster:DealDamage(hTarget, self)
			hCaster:ApplyEmber(hTarget)

			table.insert(self.tTargets, hTarget)
		end
	end

	local hRemnant = self.tRemnants[1]
	if IsValid(hRemnant) then
		if hRemnant.iParticleID ~= nil then
			ParticleManager:DestroyParticle(hRemnant.iParticleID, false)
			hRemnant.iParticleID = nil
		end
		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vRemnantPosition)
		ParticleManager:SetParticleFoWProperties(iParticleID, 0, -1, radius)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hRemnant:RemoveModifierByName("modifier_ember_spirit_4_thinker")

		local tTimerModifiers = hCaster:FindAllModifiersByName("modifier_ember_spirit_4_timer")
		for k, hTimerModifier in pairs(tTimerModifiers) do
			if not IsValid(hTimerModifier.hThinker) then
				hTimerModifier:Destroy()
			end
		end
	end

	EmitSoundOnLocationWithCaster(self.vRemnantPosition, "Hero_EmberSpirit.FireRemnant.Explode", hCaster)

	self:FilterRemnants()

	if self.tRemnants ~= nil and #self.tRemnants > 0 and self:GetAutoCastState() then
		local hRemnant = self.tRemnants[1]
		if IsValid(hRemnant) then
			local speed = self:GetSpecialValueFor("speed")
			local fDistance = (hRemnant:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()

			self.hTargetRemnant = hRemnant
			self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()

			self.vLocation = hCaster:GetAbsOrigin()
			local tInfo =			{
				Target = hRemnant,
				Source = hCaster,
				Ability = self,
				iMoveSpeed = fDistance > speed and (fDistance / 0.4) or speed,
				vSourceLoc = hCaster:GetAbsOrigin(),
				flExpireTime = GameRules:GetGameTime() + 10,
				bReplaceExisting = true,
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)

			self.tTargets = {}
		end
	else
		hCaster:RemoveModifierByName("modifier_ember_spirit_4")
		FindClearSpaceForUnit(hCaster, self.vRemnantPosition, false)
		self.vLocation = nil
	end
end
function ember_spirit_4_1:GetAssociatedPrimaryAbilities()
	return "ember_spirit_4"
end
function ember_spirit_4_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
modifier_ember_spirit_4_charge_counter = eom_modifier({
	Name = "modifier_ember_spirit_4_charge_counter",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_4_charge_counter:GetAbilitySpecialValue()
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.scepter_max_charges = self:GetAbilitySpecialValueFor("scepter_max_charges")
	if IsServer() then
		if not self.initialized and self:GetAbility():GetLevel() ~= 0 then
			self.initialized = true

			if self:GetCaster():GetScepterLevel() >= 1 then
				self:SetStackCount(self.scepter_max_charges)
			else
				self:SetStackCount(self.max_charges)
			end
		end
	end
end
function modifier_ember_spirit_4_charge_counter:OnIntervalThink()
	if IsServer() then
		local iMaxCharges = self:GetCaster():GetScepterLevel() >= 1 and self.scepter_max_charges or self.max_charges
		if self:GetStackCount() < iMaxCharges then
			self:IncrementStackCount()
		end
		if self:GetStackCount() >= iMaxCharges then
			self:SetDuration(-1, true)
			self:StartIntervalThink(-1)
		else
			local charge_restore_time = self:GetAbility():GetEffectiveCooldown(-1)
			self:SetDuration(charge_restore_time, true)
			self:StartIntervalThink(charge_restore_time)
		end
	end
end
---------------------------------------------------------------------
modifier_ember_spirit_4_thinker = eom_modifier({
	Name = "modifier_ember_spirit_4_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_4_thinker:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		if hCaster:GetScepterLevel() >= 2 then
			self:StartIntervalThink(1)
		end
	end
end
function modifier_ember_spirit_4_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("ember_spirit_1")
	if IsValid(hAbility) then
		local flRadius = hAbility:GetSpecialValueFor("radius")
		local base_damage = hAbility:GetSpecialValueFor("base_damage")
		local damage = hAbility:GetSpecialValueFor("damage")
		local flDamage = base_damage + damage * hCaster:GetAverageTrueAttackDamage(hCaster)
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, self:GetParent():GetAbsOrigin(), flRadius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, hAbility, flDamage, DAMAGE_TYPE_MAGICAL)
			hCaster:ApplyEmber(hUnit)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, flRadius, flRadius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_ember_spirit_4_thinker:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveSelf()
	end
end
function modifier_ember_spirit_4_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
---------------------------------------------------------------------
modifier_ember_spirit_4_timer = eom_modifier({
	Name = "modifier_ember_spirit_4_timer",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_4_timer:RemoveOnDeath()
	return false
end
function modifier_ember_spirit_4_timer:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ember_spirit_4_timer:OnCreated(params)
	if IsServer() then
		self.hThinker = EntIndexToHScript(params.thinker_index)
		if not IsValid(self.hThinker) then
			self:Destroy()
		end
	end
end
function modifier_ember_spirit_4_timer:OnDestroy()
	if IsServer() then
		if IsValid(self.hThinker) then
			self.hThinker:RemoveModifierByName("modifier_ember_spirit_4_thinker")
		end
	end
end
---------------------------------------------------------------------
modifier_ember_spirit_4 = eom_modifier({
	Name = "modifier_ember_spirit_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	LuaModifierType = LUA_MODIFIER_MOTION_HORIZONTAL
})
function modifier_ember_spirit_4:GetTexture()
	return "ember_spirit_fire_remnant"
end
function modifier_ember_spirit_4:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetParent()

		hCaster:AddEffects(EF_NODRAW)
		hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
		hCaster:SetLocalAngles(0, 0, 0)

		if self:ApplyHorizontalMotionController() then
			self.hThinker = CreateModifierThinker(hCaster, self:GetAbility(), "modifier_dummy", nil, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", PATTACH_CUSTOMORIGIN, self.hThinker)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hThinker, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.hThinker:GetAbsOrigin(), true)
			self:AddParticle(iParticleID, false, false, -1, false, false)
		else
			self:Destroy()
		end
	end
end
function modifier_ember_spirit_4:OnDestroy()
	if IsServer() then
		local hCaster = self:GetParent()

		hCaster:StopSound("Hero_EmberSpirit.FireRemnant.Activate")

		hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")

		hCaster:RemoveHorizontalMotionController(self)

		hCaster:RemoveEffects(EF_NODRAW)

		if IsValid(self.hThinker) then
			self.hThinker:RemoveSelf()
		end
	end
end
function modifier_ember_spirit_4:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) or hAbility.vLocation == nil then
			self:Destroy()
			return
		end
		self.hThinker:SetAbsOrigin(hAbility.vLocation)
		me:SetAbsOrigin(hAbility.vLocation)
	end
end
function modifier_ember_spirit_4:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_ember_spirit_4:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function modifier_ember_spirit_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end
function modifier_ember_spirit_4:GetModifierDisableTurning(params)
	return 1
end