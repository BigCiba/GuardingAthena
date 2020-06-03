LinkLuaModifier( "modifier_poseidon_1", "abilities/enemy/poseidon_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_poseidon_1_thinker", "abilities/enemy/poseidon_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_poseidon_1_motion", "abilities/enemy/poseidon_1.lua", LUA_MODIFIER_MOTION_VERTICAL )
LinkLuaModifier( "modifier_poseidon_1_debuff", "abilities/enemy/poseidon_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if poseidon_1 == nil then
	poseidon_1 = class({})
end
function poseidon_1:Torrent(vPosition)
	local hCaster = self:GetCaster()
	local delay = self:GetSpecialValueFor("delay")
	CreateModifierThinker(hCaster, self, "modifier_poseidon_1_thinker", {duration=delay}, vPosition, hCaster:GetTeamNumber(), false)
end
function poseidon_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_poseidon_1", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_poseidon_1 == nil then
	modifier_poseidon_1 = class({}, nil, ModifierBasic)
end
function modifier_poseidon_1:IsHidden()
	return true
end
function modifier_poseidon_1:OnCreated(params)
	self.torrent_interval = self:GetAbilitySpecialValueFor("torrent_interval")
	self.torrent_max_distance = self:GetAbilitySpecialValueFor("torrent_max_distance")
	if IsServer() then
		self.hAbility = self:GetAbility()
		self.tRadian = {
			min = 0, 
			max = math.rad(90),
			Next = function ()
				self.tRadian.min = self.tRadian.max
				self.tRadian.max = self.tRadian.max + math.rad(90)
			end
		}
		if IsValid(self.hAbility) and self.hAbility:GetLevel() > 0 then
			self:OnIntervalThink()
			self:StartIntervalThink(self.torrent_interval)
		end
	end
end
function modifier_poseidon_1:OnIntervalThink()
	local vOrigin = self:GetParent():GetAbsOrigin()
	local vDirection = Rotation2D(Vector(1, 0, 0),  RandomFloat(self.tRadian.min, self.tRadian.max))
	local vPosition = vOrigin + vDirection * RandomInt(0,self.torrent_max_distance)
	self.hAbility:Torrent(vPosition)
	self.tRadian.Next()
end
---------------------------------------------------------------------
if modifier_poseidon_1_thinker == nil then
	modifier_poseidon_1_thinker = class({}, nil, ModifierThinker)
end
function modifier_poseidon_1_thinker:OnCreated(params)
	local hCaster = self:GetCaster()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.slow_duration = self:GetAbilitySpecialValueFor("slow_duration")
	if IsServer() then
		local position = self:GetParent():GetAbsOrigin()

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, position)
		self:AddParticle(particleID, false, false, -1, false, false)

		EmitSoundOnLocationForAllies(position, "Ability.pre.Torrent", hCaster)
	end
end
function modifier_poseidon_1_thinker:OnRemoved()
	if IsServer() then
		local hCaster = self:GetCaster()
		local position = self:GetParent():GetAbsOrigin()

		local ability = self:GetAbility()

		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
		for n, target in pairs(targets) do
			target:AddNewModifier(hCaster, ability, "modifier_poseidon_1_debuff", {duration=(self.stun_duration + self.slow_duration) * target:GetStatusResistanceFactor()})
			target:AddNewModifier(hCaster, ability, "modifier_poseidon_1_motion", {duration=self.stun_duration})
		end

		local particleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf", hCaster), PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, position)
		ParticleManager:ReleaseParticleIndex(particleID)

		EmitSoundOnLocationWithCaster(position, "Ability.Torrent", hCaster)

		self:GetParent():RemoveSelf()
	end
end
function modifier_poseidon_1_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
---------------------------------------------------------------------
if modifier_poseidon_1_motion == nil then
	modifier_poseidon_1_motion = class({})
end
function modifier_poseidon_1_motion:IsHidden()
	return false
end
function modifier_poseidon_1_motion:IsDebuff()
	return true
end
function modifier_poseidon_1_motion:IsPurgable()
	return false
end
function modifier_poseidon_1_motion:IsPurgeException()
	return true
end
function modifier_poseidon_1_motion:IsStunDebuff()
	return true
end
function modifier_poseidon_1_motion:AllowIllusionDuplicate()
	return false
end
function modifier_poseidon_1_motion:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
function modifier_poseidon_1_motion:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_poseidon_1_motion:OnCreated(params)
	if IsServer() then
		self.torrent_damage = self:GetAbilityDamage()
		self.damage_type = self:GetAbility():GetAbilityDamageType()
		self.tick_interval = 0.2
		self:StartIntervalThink(self.tick_interval)

		if self:ApplyVerticalMotionController() then
			self:GetParent():StartGesture(ACT_DOTA_FLAIL)
			self.fTime = 0
			self.fMotionDuration = 1.2

			self.vAcceleration = -self:GetParent():GetUpVector() * 1800
			self.vStartVerticalVelocity = Vector(0, 0, 0)/self.fMotionDuration - self.vAcceleration * self.fMotionDuration/2
		end
	end
end
function modifier_poseidon_1_motion:OnRefresh(params)
	self.torrent_damage = self:GetAbilityDamage()
	if IsServer() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_poseidon_1_motion:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_poseidon_1_motion:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local target = self:GetParent()
		local damage_per_second = self.torrent_damage/self:GetDuration()
		hCaster:DealDamage(target, self:GetAbility(), damage_per_second * self.tick_interval)
	end
end
function modifier_poseidon_1_motion:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin()+(self.vAcceleration*self.fTime+self.vStartVerticalVelocity)*dt)
		self.fTime = self.fTime + dt
		if self.fTime >= self.fMotionDuration then
			self:GetParent():RemoveGesture(ACT_DOTA_FLAIL)
			self:GetParent():RemoveVerticalMotionController(self)
		end
	end
end
function modifier_poseidon_1_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_FLAIL)
	end
end
function modifier_poseidon_1_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_poseidon_1_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_poseidon_1_motion:GetOverrideAnimation(params)
	return ACT_DOTA_DISABLED
end
---------------------------------------------------------------------
if modifier_poseidon_1_debuff == nil then
	modifier_poseidon_1_debuff = class({}, nil, ModifierDebuff)
end
function modifier_poseidon_1_debuff:OnCreated(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.bonus_move_speed = self:GetAbilitySpecialValueFor("bonus_move_speed")
end
function modifier_poseidon_1_debuff:OnRefresh(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.bonus_move_speed = self:GetAbilitySpecialValueFor("bonus_move_speed")
end
function modifier_poseidon_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_poseidon_1_debuff:GetModifierMoveSpeedBonus_Percentage(params)
	return -self.bonus_move_speed
end
function modifier_poseidon_1_debuff:GetModifierPhysicalArmorBonus(params)
	return -self.bonus_armor
end