LinkLuaModifier( "modifier_hades_4", "abilities/enemy/hades_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if hades_4 == nil then
	hades_4 = class({})
end
function hades_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	if not hTarget:TriggerSpellAbsorb(self) then
		hTarget:AddNewModifier(hCaster, self, "modifier_hades_4", {duration=stun_duration})
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
---------------------------------------------------------------------
--Modifiers
if modifier_hades_4 == nil then
	modifier_hades_4 = class({}, nil, ModifierBasic)
end
function modifier_hades_4:IsDebuff()
	return true
end
function modifier_hades_4:OnCreated(params)
	self.damage_per_health = self:GetAbilitySpecialValueFor("damage_per_health")
	if IsServer() then
		self.flHealth = math.max(self:GetParent():GetHealth(), 1)
		self:StartIntervalThink(0)
	end
end
function modifier_hades_4:OnIntervalThink()
	if IsValid(self:GetParent()) and self:GetParent():IsAlive() then
		if self:GetParent():GetHealth() > self.flHealth then
			self:GetParent():ModifyHealth(self.flHealth, self, false, 0)
		else
			self.flHealth = self:GetParent():GetHealth()
		end
	end
end
function modifier_hades_4:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local flDamage = hParent:GetHealthDeficit() * self.damage_per_health
		self:GetCaster():DealDamage(hParent, self:GetAbility(), flDamage)
	end
end
function modifier_hades_4:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end