LinkLuaModifier( "modifier_death_change", "abilities/enemy/death_change.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_death_change_stun", "abilities/enemy/death_change.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if death_change == nil then
	death_change = class({})
end
function death_change:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_death_change", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_death_change == nil then
	modifier_death_change = class({})
end
function modifier_death_change:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, true)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetCaster())
end
function modifier_death_change:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_death_change:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetCaster())
end
function modifier_death_change:OnDeath(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		if params.unit == hCaster then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			if not hParent:IsMagicImmune() and not hParent:IsInvulnerable() then
				hParent:AddNewModifier(hCaster, hAbility, "modifier_death_change_stun", {duration = self.stun_duration})
			end
			hCaster:RespawnUnit()
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_death_change_stun", {duration = self.stun_duration})
			hCaster:EmitSound("Hero_Abaddon.BorrowedTime")
		end
	end
end
function modifier_death_change:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---------------------------------------------------------------------
if modifier_death_change_stun == nil then
	modifier_death_change_stun = class({}, nil, ModifierBasic)
end
function modifier_death_change_stun:IsDebuff()
	return not self:GetParent():IsFriendly(self:GetCaster())
end
function modifier_death_change_stun:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/wave_26/death_change.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_death_change_stun:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if hParent:IsFriendly(hCaster) then
			hParent:Heal(hParent:GetMaxHealth() * 0.5, hAbility)
		else
			hParent:ForceKill(true)
			hCaster:Heal(hCaster:GetMaxHealth() * 0.5, hAbility)
		end
	end
end
function modifier_death_change_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end