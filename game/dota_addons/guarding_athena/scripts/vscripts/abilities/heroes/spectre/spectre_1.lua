LinkLuaModifier( "modifier_spectre_1", "abilities/heroes/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_1_root", "abilities/heroes/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_1_thinker", "abilities/heroes/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_1_debuff", "abilities/heroes/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_1 == nil then
	spectre_1 = class({})
end
function spectre_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local speed = self:GetSpecialValueFor("speed")
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vDir = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_spectre_1_thinker", {vStart = hCaster:GetAbsOrigin()}, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	local tProjectileInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = vDir * speed,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		ExtraData = {
			iEntIndex = hThinker:GetEntityIndex()
		}
	}
	local iParticleID = ProjectileManager:CreateLinearProjectile(tProjectileInfo)
	-- sound
	hCaster:EmitSound("Hero_Spectre.DaggerCast")
	local hAbility = hCaster:FindAbilityByName("spectre_1_0")
	hAbility:SetLevel(1)
	hAbility.iParticleID = iParticleID
	hAbility.hThinker = hThinker
	hAbility.flDuration = duration
	hCaster:SwapAbilities("spectre_1", "spectre_1_0", false, true)
end
function spectre_1:OnProjectileThink_ExtraData(vLocation, ExtraData)
	local hThinker = EntIndexToHScript(ExtraData.iEntIndex)
	hThinker:SetAbsOrigin(vLocation)
end
function spectre_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		local root_duration = self:GetSpecialValueFor("root_duration")
		local flDamage = self:GetSpecialValueFor("damage") * hCaster:GetStrength() + self:GetSpecialValueFor("base_damage")
		hTarget:AddNewModifier(hCaster, self, "modifier_spectre_1_root", {duration = root_duration * hTarget:GetStatusResistanceFactor()})
		hCaster:DealDamage(hTarget, self, flDamage)
		-- sound
		EmitSoundOnLocationWithCaster(vLocation, "Hero_Spectre.DaggerImpact", hCaster)
	else
		local hThinker = EntIndexToHScript(ExtraData.iEntIndex)
		hCaster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
		hThinker:FindModifierByName("modifier_spectre_1_thinker"):SetDuration(self:GetSpecialValueFor("duration"), false)
	end
end
--Abilities
if spectre_1_0 == nil then
	spectre_1_0 = class({})
end
function spectre_1_0:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
	FindClearSpaceForUnit(hCaster, self.hThinker:GetAbsOrigin(), true)
	ProjectileManager:DestroyLinearProjectile(self.iParticleID)
	self.hThinker:FindModifierByName("modifier_spectre_1_thinker"):SetDuration(self.flDuration, false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_1_root == nil then
	modifier_spectre_1_root = class({}, nil, ModifierDebuff)
end
function modifier_spectre_1_root:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_bramble_root.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_1_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end
---------------------------------------------------------------------
if modifier_spectre_1_thinker == nil then
	modifier_spectre_1_thinker = class({}, nil, ModifierThinker)
end
function modifier_spectre_1_thinker:OnCreated(params)
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self.radius = self:GetAbilitySpecialValueFor("radius")
		self.flInterval = 0.1
		self.flDamage = self:GetAbilitySpecialValueFor("per_damage") * self.flInterval * self:GetCaster():GetStrength()
		self:StartIntervalThink(self.flInterval)
	end
end
function modifier_spectre_1_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local vPosition = hParent:GetAbsOrigin()
	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vStart, vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_spectre_1_debuff", nil)
	end
end
---------------------------------------------------------------------
if modifier_spectre_1_debuff == nil then
	modifier_spectre_1_debuff = class({}, nil, ModifierDebuff)
end
function modifier_spectre_1_debuff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
		self:SetDuration(0.1, false)
	end
end
function modifier_spectre_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_spectre_1_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end