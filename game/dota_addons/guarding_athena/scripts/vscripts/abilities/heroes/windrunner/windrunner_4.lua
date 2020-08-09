LinkLuaModifier( "modifier_windrunner_4", "abilities/heroes/windrunner/windrunner_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_windrunner_4_buff", "abilities/heroes/windrunner/windrunner_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_4 == nil then
	windrunner_4 = class({})
end
function windrunner_4:Precache(context)
	PrecacheResource("particle", "particles/skills/arrow_strom.vpcf", context)
	PrecacheResource("particle", "particles/skills/arrow_strom_1.vpcf", context)
end
function windrunner_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local flDuration = self:GetSpecialValueFor("duration")
	if hCaster:GetScepterLevel() >= 2 then
		flDuration = flDuration + self:GetSpecialValueFor("scepter_bonus_duration")
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_4_buff", {duration = flDuration})
	hCaster:EmitSound("Hero_DrowRanger.Attack")
end
function windrunner_4:GetIntrinsicModifierName()
	return "modifier_windrunner_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_4 == nil then
	modifier_windrunner_4 = class({}, nil, ModifierBasic)
end
function modifier_windrunner_4:IsHidden()
	return self:GetParent():GetScepterLevel() < 3
end
function modifier_windrunner_4:RemoveOnDeath()
	return false
end
function modifier_windrunner_4:DestroyOnExpire()
	return false
end
function modifier_windrunner_4:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_interval = self:GetAbilitySpecialValueFor("scepter_interval")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.scepter_duration = self:GetAbilitySpecialValueFor("scepter_duration")
	if IsServer() then
		self.flTick = 0.1
		self:SetDuration(self.scepter_interval, true)
		self:StartIntervalThink(self.flTick)
		self.flTime = 0
	end
end
function modifier_windrunner_4:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetStackCount() >= 1 and hParent:GetScepterLevel() >= 3 then	-- 有能量点则判断敌人
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		if IsValid(tTargets[1]) then
			self:SetStackCount(0)
			self:SetDuration(self.scepter_interval, true)
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_windrunner_4_buff", {duration = self.delay + self.scepter_duration})
		end
	else	-- 没有能量点则冷却
		if self.flTime >= self.scepter_interval then
			self.flTime = 0
			self:SetStackCount(1)
		else
			self.flTime = self.flTime + self.flTick
		end
	end
end
---------------------------------------------------------------------
if modifier_windrunner_4_buff == nil then
	modifier_windrunner_4_buff = class({}, nil, ModifierHidden)
end
function modifier_windrunner_4_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_windrunner_4_buff:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.scepter_duration = self:GetAbilitySpecialValueFor("scepter_duration")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
		self:StartIntervalThink(self.delay)
		self.bStart = false
		self.flDamage = self.base_damage + self.damage * self:GetParent():GetAgility()
	else
		if self:GetDuration() > self.delay + self.scepter_duration then
			local iParticleID = ParticleManager:CreateParticle("particles/skills/arrow_strom_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + Vector(0, 0, 2000))
			ParticleManager:SetParticleControl(iParticleID, 6, self:GetParent():GetAbsOrigin() + Vector(0, 0, -300))
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_windrunner_4_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_4_buff:OnIntervalThink()
	if self.bStart == false then
		self.bStart = true
		self:StartIntervalThink(self.interval)
	else
		local hParent = self:GetParent()
		for i = 1, (RollPercentage(self.chance) and 2 or 1) do
			local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
			if hParent:GetScepterLevel() >= 2 then
				local tTrackUnits = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
				if IsValid(tTrackUnits[1]) then
					vPosition = tTrackUnits[1]:GetAbsOrigin() + RandomVector(RandomInt(0, self.damage_radius))
				end
			end
			local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.damage_radius, self:GetAbility())
			local iDamageType = i == 1 and DAMAGE_TYPE_PHYSICAL or DAMAGE_TYPE_MAGICAL
			hParent:DealDamage(tTargets, self:GetAbility(), self.flDamage, iDamageType)
			-- particle
			local sParticleName = i == 1 and "particles/skills/arrow_strom.vpcf" or "particles/skills/arrow_strom_magic.vpcf"
			local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition + Vector(0, 0, 2000))
			self:AddParticle(iParticleID, false, false, -1, false, false)
			-- sound
			EmitSoundOnLocationWithCaster(vPosition, "Hero_DrowRanger.Attack", hParent)
		end
	end
end