LinkLuaModifier( "modifier_windrunner_4", "abilities/heroes/windrunner/windrunner_4.lua", LUA_MODIFIER_MOTION_NONE )
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
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_4", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_DrowRanger.Attack")
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_4 == nil then
	modifier_windrunner_4 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_4:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self:StartIntervalThink(self.delay)
		self.bStart = false
		self.flDamage = self.base_damage + self.damage * self:GetParent():GetAgility()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/skills/arrow_strom_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + Vector(0, 0, 2000))
		ParticleManager:SetParticleControl(iParticleID, 6, self:GetParent():GetAbsOrigin() + Vector(0, 0, -300))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_windrunner_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_4:OnIntervalThink()
	if self.bStart == false then
		self.bStart = true
		self:StartIntervalThink(self.interval)
	else
		local hParent = self:GetParent()
		local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
		local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.damage_radius, self:GetAbility())
		hParent:DealDamage(tTargets, self:GetAbility(), self.flDamage)
		local iParticleID = ParticleManager:CreateParticle("particles/skills/arrow_strom.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, vPosition + Vector(0, 0, 2000))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		EmitSoundOnLocationWithCaster(vPosition, "Hero_DrowRanger.Attack", hParent)
	end
end