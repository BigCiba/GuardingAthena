juggernaut_0_juggernaut_01 = class({})
-- function juggernaut_0_juggernaut_01:CastFilterResultTarget(hTarget)
-- 	if not hTarget:HasModifier("modifier_juggernaut_0_juggernaut_01_mark") then
-- 		return UF_FAIL_ENEMY
-- 	end
-- 	return UF_SUCCESS
-- end
function juggernaut_0_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTA_BaseNPC
	local hTarget = self:GetCursorTarget()
	hCaster:AddNewModifier(hTarget, self, "modifier_juggernaut_0_juggernaut_01_buff", { iStackCount = self:GetSpecialValueFor("threshold") })
	-- local hModifier = hTarget:FindModifierByName("modifier_juggernaut_0_juggernaut_01_mark")
	-- if IsValid(hModifier) then
	-- 	hModifier:Destroy()
	-- end
end
function juggernaut_0_juggernaut_01:GetIntrinsicModifierName()
	return "modifier_juggernaut_0_juggernaut_01"
end
---------------------------------------------------------------------
--Modifiers
modifier_juggernaut_0_juggernaut_01 = eom_modifier({
	Name = "modifier_juggernaut_0_juggernaut_01",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_0_juggernaut_01:GetAbilitySpecialValue()
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_juggernaut_0_juggernaut_01:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_juggernaut_0_juggernaut_01:OnAttackLanded(params)
	if IsServer() then
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		if params.attacker == hParent then
			if not hParent:HasModifier("modifier_juggernaut_0_juggernaut_01_buff") then
				params.target:AddNewModifier(params.attacker, hAbility, "modifier_juggernaut_0_juggernaut_01_mark", { duration = self.duration })
			end
		end
	end
end
---------------------------------------------------------------------
modifier_juggernaut_0_juggernaut_01_mark = eom_modifier({
	Name = "modifier_juggernaut_0_juggernaut_01_mark",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_0_juggernaut_01_mark:GetAbilitySpecialValue()
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
end
function modifier_juggernaut_0_juggernaut_01_mark:OnCreated(params)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		self:IncrementStackCount()
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_0_juggernaut_01_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(0, self:GetStackCount(), 0))
	end
end
function modifier_juggernaut_0_juggernaut_01_mark:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(0, self:GetStackCount(), 0))
		if self:GetStackCount() >= self.threshold then
			---@type CDOTA_BaseNPC
			local hCaster = self:GetCaster()
			---@type CDOTA_BaseNPC
			local hParent = self:GetParent()
			---@type CDOTABaseAbility
			local hAbility = self:GetAbility()
			hCaster:AddNewModifier(hParent, hAbility, "modifier_juggernaut_0_juggernaut_01_buff", { iStackCount = self:GetStackCount() })
			self:Destroy()
		end
	end
end
---------------------------------------------------------------------
modifier_juggernaut_0_juggernaut_01_buff = eom_modifier({
	Name = "modifier_juggernaut_0_juggernaut_01_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_0_juggernaut_01_buff:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
end
function modifier_juggernaut_0_juggernaut_01_buff:OnCreated(params)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hTarget = self:GetCaster()
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()

		self.iStackCount = params.iStackCount

		local vDirection = hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()
		vDirection.z = 0
		local vPosition = hTarget:GetAbsOrigin() + vDirection:Normalized() * (hParent:GetHullRadius() + hTarget:GetHullRadius())

		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 0, -vDirection:Normalized())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hParent:EmitSound("Hero_Juggernaut.OmniSlash")

		AddFOWViewer(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), 300, self.interval, false)

		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())

		FindClearSpaceForUnit(hParent, vPosition, true)

		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hParent:SetForwardVector(-vDirection:Normalized())
		hParent:FaceTowards(hTarget:GetAbsOrigin())

		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Juggernaut.OmniSlash.Damage", hCaster)

		hParent:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS)

		self:StartIntervalThink(self.interval)

		hParent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	end
end
function modifier_juggernaut_0_juggernaut_01_buff:OnRefresh(params)
	if IsServer() then
		self:OnCreated(params)
	end
end
function modifier_juggernaut_0_juggernaut_01_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = self:GetCaster()
		if IsValid(hTarget) then
			local vDirection = hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()
			vDirection.z = 0
			local vPosition = hTarget:GetAbsOrigin() + vDirection:Normalized() * (hParent:GetHullRadius() + hTarget:GetHullRadius())

			hParent:EmitSound("Hero_Juggernaut.OmniSlash")

			AddFOWViewer(hParent:GetTeamNumber(), hTarget:GetAbsOrigin(), 300, self.interval, false)

			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf", PATTACH_CUSTOMORIGIN, hParent)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())

			FindClearSpaceForUnit(hParent, vPosition, true)

			ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(iParticleID)

			if vDirection:Normalized() ~= Vector(0, 0, 0) then
				hParent:SetForwardVector(-vDirection:Normalized())
			end
			hParent:FaceTowards(hTarget:GetAbsOrigin())

			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Juggernaut.OmniSlash.Damage", hParent)

			hParent:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN)
		end
		self.iStackCount = self.iStackCount - 1
		if self.iStackCount <= 0 then
			self:Destroy()
		end
	end
end
function modifier_juggernaut_0_juggernaut_01_buff:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hParent:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	end
end
function modifier_juggernaut_0_juggernaut_01_buff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		-- [MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end