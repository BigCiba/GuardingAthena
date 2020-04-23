LinkLuaModifier( "modifier_rain_of_chaos", "abilities/enemy/rain_of_chaos.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rain_of_chaos == nil then
	rain_of_chaos = class({})
end
function rain_of_chaos:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_rain_of_chaos", {duration = self:GetSpecialValueFor("delay")}, vPosition, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_rain_of_chaos == nil then
	modifier_rain_of_chaos = class({}, nil, ModifierThinker)
end
function modifier_rain_of_chaos:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1.3, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_rain_of_chaos:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_rain_of_chaos:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Invoker.ChaosMeteor.Loop")
		EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Warlock.RainOfChaos_buildup", self:GetCaster())

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tTargets = FindUnitsInRadiusWithAbility(self:GetCaster(), self:GetParent():GetAbsOrigin(), self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			self:GetCaster():DealDamage(hUnit, self:GetAbility(), self:GetAbilityDamage())
			hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbilityDuration() * hUnit:GetStatusResistanceFactor()})
		end
	end
end
function modifier_rain_of_chaos:DeclareFunctions()
	return {
	}
end