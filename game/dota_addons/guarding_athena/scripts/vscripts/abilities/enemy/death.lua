LinkLuaModifier( "modifier_death", "abilities/enemy/death.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if death == nil then
	death = class({})
end
function death:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	if not hTarget:TriggerSpellAbsorb(self) then
		hTarget:AddNewModifier(hCaster, self, "modifier_necrolyte_reapers_scythe", {duration=stun_duration})
		-- particle chain
		local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		-- particle scythe
		local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", hCaster), PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticle, 0, hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticle, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticle, 0, (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized())
		ParticleManager:SetParticleControlForward(iParticle, 1, (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized())
		-- sound
		hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
	end

end
function death:GetIntrinsicModifierName()
	return "modifier_death"
end
---------------------------------------------------------------------
--Modifiers
if modifier_death == nil then
	modifier_death = class({})
end
function modifier_death:OnCreated(params)
	if IsServer() then
	end
end
function modifier_death:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_death:OnDestroy()
	if IsServer() then
	end
end
function modifier_death:DeclareFunctions()
	return {
	}
end