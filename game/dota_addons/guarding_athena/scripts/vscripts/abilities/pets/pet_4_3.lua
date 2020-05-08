LinkLuaModifier( "modifier_pet_4_3", "abilities/pets/pet_4_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_4_3_slow", "abilities/pets/pet_4_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_4_3 == nil then
	pet_4_3 = class({})
end
function pet_4_3:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_pet_4_3", nil)
end
function pet_4_3:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()

	hCaster:RemoveModifierByName("modifier_pet_4_3")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_4_3 == nil then
	modifier_pet_4_3 = class({})
end
function modifier_pet_4_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.explosion_radius = self:GetAbilitySpecialValueFor("explosion_radius")
	self.explosion_interval = self:GetAbilitySpecialValueFor("explosion_interval")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	self.explosion_min_dist = self.explosion_radius
	self.explosion_max_dist = self.radius - self.explosion_radius
	if IsServer() then
		local hParent = self:GetParent()
		self.flDamage = hParent:GetMaster():GetPrimaryStatValue() * self:GetAbilityDamage()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, iParticleID)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius + self.explosion_radius, self.radius + self.explosion_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)

		hParent:EmitSound("hero_Crystal.freezingField.wind")

		self.count = 0
		self:StartIntervalThink(self.explosion_interval)
	end
end
function modifier_pet_4_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pet_4_3:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("hero_Crystal.freezingField.wind")
	end
end
function modifier_pet_4_3:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local radian = math.rad(self.count*90 + RandomFloat(0, 90))
		local distance = RandomFloat(self.explosion_min_dist, self.explosion_max_dist)
		local vPosition = GetGroundPosition(hParent:GetAbsOrigin() + Rotation2D(Vector(1,0,0), radian)*distance, hParent)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.explosion_radius, hParent)
		hParent:DealDamage(tTargets, hParent, self.flDamage)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		EmitSoundOnLocationWithCaster(vPosition, "hero_Crystal.freezingField.explosion", hParent)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.radius, hParent)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_pet_4_3_slow", {duration = self.slow_duration * hUnit:GetStatusResistanceFactor()})
		end

		self.count = self.count + 1
	end
end
---------------------------------------------------------------------
if modifier_pet_4_3_slow == nil then
	modifier_pet_4_3_slow = class({}, nil, ModifierDebuff)
end
function modifier_pet_4_3_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end
function modifier_pet_4_3_slow:StatusEffectPriority()
	return 10
end
function modifier_pet_4_3_slow:OnCreated(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	self.attack_slow = self:GetAbilitySpecialValueFor("attack_slow")
end
function modifier_pet_4_3_slow:OnRefresh(params)
	self.movespeed_slow = self:GetAbilitySpecialValueFor("movespeed_slow")
	self.attack_slow = self:GetAbilitySpecialValueFor("attack_slow")
end
function modifier_pet_4_3_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_pet_4_3_slow:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed_slow
end
function modifier_pet_4_3_slow:GetModifierAttackSpeedBonus_Constant(params)
	return self.attack_slow
end