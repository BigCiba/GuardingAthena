LinkLuaModifier("modifier_void_spirit_2_phase", "abilities/heroes/void_spirit/void_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_2 == nil then
	void_spirit_2 = class({})
end
function void_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Cast")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Portals")
	-- local disappear_time = self:GetSpecialValueFor("disappear_time")
	-- hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_2_phase", { duration = disappear_time, vPosition = vPosition })
	hCaster:AetherRemnant(hCaster:GetAbsOrigin())
	FindClearSpaceForUnit(hCaster, vPosition, true)
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
	--特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius / 1.5, 0, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for k, hTarget in pairs(tTargets) do
		hCaster:DealDamage(hTarget, self)
		hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	end
	hCaster:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_2_phase == nil then
	modifier_void_spirit_2_phase = class({})
end
function modifier_void_spirit_2_phase:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		local hParent = self:GetParent()
		self.vPosition = StringToVector(params.vPosition)
		self:CreateDoor(self.vPosition)

		-- 隐藏英雄
		hParent:AddNoDraw()
		ProjectileManager:ProjectileDodge(hParent)
	end
end
function modifier_void_spirit_2_phase:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
	end
end
function modifier_void_spirit_2_phase:OnDestroy()
	if IsServer() then
		if IsServer() then
			local hParent = self:GetParent()
			--现身
			hParent:RemoveNoDraw()
			FindClearSpaceForUnit(hParent, self.vPosition, true)
			hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
			--特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius / 1.5, 0, self.radius))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local tTargets = FindUnitsInRadiusWithAbility(hParent, self.vPosition, self.radius, self:GetAbility())
			for k, hTarget in pairs(tTargets) do
				hParent:DealDamage(hTarget, self:GetAbility())
				hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration })
			end
			hParent:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
		end
	end
end
function modifier_void_spirit_2_phase:CreateDoor(vPosition)
	vPosition = GetGroundPosition(vPosition, nil)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius + 30, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 0, 0))
	self:AddParticle(iParticleID, false, false, -1, false, false)
end
function modifier_void_spirit_2_phase:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end