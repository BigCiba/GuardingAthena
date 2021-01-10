LinkLuaModifier("modifier_void_spirit_3_phase", "abilities/heroes/void_spirit/void_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_3 == nil then
	void_spirit_3 = class({})
end
function void_spirit_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Cast")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Portals")
	local disappear_time = self:GetSpecialValueFor("disappear_time")
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_3_phase", { duration = disappear_time })
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_3_phase == nil then
	modifier_void_spirit_3_phase = class({})
end
function modifier_void_spirit_3_phase:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		local destination_fx_radius = self:GetAbilitySpecialValueFor("destination_fx_radius")
		local portals_per_ring = self:GetAbilitySpecialValueFor("portals_per_ring")
		local angle_per_ring_portal = self:GetAbilitySpecialValueFor("angle_per_ring_portal")
		local first_ring_distance_offset = self:GetAbilitySpecialValueFor("first_ring_distance_offset")

		self.tDoors = {}
		local vPosition = hParent:GetAbsOrigin()
		self:CreateDoor(vPosition, true)
		local vDir = hParent:GetForwardVector()
		for i = 1, portals_per_ring do
			--偏移方向角度
			self:CreateDoor(vPosition + vDir * first_ring_distance_offset)
			vDir = RotatePosition(Vector(0, 0, 0), QAngle(0, 60, 0), vDir)
		end
		-- 隐藏英雄
		hParent:AddNoDraw()
		ProjectileManager:ProjectileDodge(hParent)
	end
end
function modifier_void_spirit_3_phase:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_void_spirit_3_phase:OnDestroy()
	if IsServer() then
		if IsServer() then
			local hParent = self:GetParent()
			--现身
			hParent:RemoveNoDraw()
			-- FindClearSpaceForUnit(hParent, self.vPosition, true)
			hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
			--特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius / 1.5, 0, self.radius))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			for k, hTarget in pairs(tTargets) do
				hParent:DealDamage(hTarget, self:GetAbility())
				-- hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration })
			end
			hParent:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
		end
	end
end
function modifier_void_spirit_3_phase:CreateDoor(vPosition, bCenter)
	vPosition = GetGroundPosition(vPosition, nil)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius + 30, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, 0, 0))
	self:AddParticle(iParticleID, false, false, -1, false, false)
	if not bCenter then
		table.insert(self.tDoors, {
			iParticleID = iParticleID,
			vPosition = vPosition,
			bActive = false
		})
	else
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 0, 0))
	end
end
function modifier_void_spirit_3_phase:CheckState()
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