juggernaut_2_juggernaut_01 = class({})
function juggernaut_2_juggernaut_01:CastFilterResultTarget(hTarget)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hTarget:GetUnitName() ~= hCaster:GetUnitName() then
		return UF_FAIL_ENEMY
	end
	return UF_SUCCESS
end
function juggernaut_2_juggernaut_01:Spawn()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	self.hMaskGhost = nil
	hCaster.GetMaskGhost = function(hCaster)
		return self.hMaskGhost
	end
end
function juggernaut_2_juggernaut_01:CreateMaskGhost(vPosition)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if self.hMaskGhost then
		self.hMaskGhost:Kill(self, hCaster)
	end
	local tData = {
		MapUnitName = hCaster:GetUnitName(),
		teamnumber = hCaster:GetTeamNumber(),
		IsSummoned = "1",
	}
	local hUnit = CreateUnitFromTable(tData, vPosition)
	hUnit:SetAbsOrigin(vPosition)
	hUnit:SetOwner(hCaster)
	hUnit:MakeIllusion()
	hUnit:AddNewModifier(hCaster, nil, "modifier_juggernaut_01", nil)
	hUnit:AddNewModifier(hCaster, self, "modifier_juggernaut_2_juggernaut_01_illusion", nil)
	hUnit:AddActivityModifier("arcana")
	hUnit:StartGesture(ACT_DOTA_SPAWN)
	hUnit:EmitSound("Hero_Grimstroke.InkCreature.Cast")
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	for i = 0, 5 do
		local hItem = hCaster:GetItemInSlot(i)
		if hItem then
			hUnit:AddItemByName(hItem:GetAbilityName())
		end
	end
	for i = 1, 4 do
		local hAbility = hCaster:GetAbilityByIndex(i)
		hUnit:GetAbilityByIndex(i):SetLevel(hAbility:GetLevel())
	end
	hUnit:SetAbilityPoints(0)
	for i = 1, hCaster:GetLevel() - 1 do
		hUnit:HeroLevelUp(false)
	end
	hUnit:SetBaseStrength(hCaster:GetBaseStrength())
	hUnit:SetBaseAgility(hCaster:GetBaseAgility())
	hUnit:SetBaseIntellect(hCaster:GetBaseIntellect())
	self.hMaskGhost = hUnit
end
function juggernaut_2_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()
	if hTarget then
		if hTarget == hCaster then
			local hUnit = self.hMaskGhost
			if self.hMaskGhost then
				local tProjectileInfo = {
					Ability = self,
					Target = hCaster,
					EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_return.vpcf",
					bDodgeable = false,
					iMoveSpeed = 900,
					vSourceLoc = hUnit:GetAttachmentPosition("attach_hitloc"),
				}
				ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
				self.hMaskGhost:Kill(self, hCaster)
				self.hMaskGhost = nil
			end
		else
			local tProjectileInfo = {
				Ability = self,
				Target = hTarget,
				EffectName = "particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_return.vpcf",
				bDodgeable = false,
				iMoveSpeed = 900,
				vSourceLoc = hCaster:GetAttachmentPosition("attach_hitloc"),
			}
			ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
			hCaster:SetAbsOrigin(hCaster:GetAbsOrigin() + Vector(0, 0, -1000))
			hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_2_juggernaut_01_ghost", { duration = 3 })
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	else
		CreateModifierThinker(hCaster, self, "modifier_juggernaut_2_juggernaut_01_thinker", { duration = 1 }, vPosition, hCaster:GetTeamNumber(), false)
		hCaster:EmitSound("Hero_Juggernaut.MaskGhost.Cast")
	end
end
function juggernaut_2_juggernaut_01:OnProjectileHit(hTarget, vLocation)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if hTarget then
		if hTarget == self.hMaskGhost then
			hCaster:SetAbsOrigin(self.hMaskGhost:GetAbsOrigin())
			self.hMaskGhost:Kill(self, hCaster)
			self.hMaskGhost = nil
		end
		hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_2_juggernaut_01_buff", { duration = 10 })
		hCaster:RemoveModifierByName("modifier_juggernaut_2_juggernaut_01_ghost")
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_juggernaut_2_juggernaut_01_thinker = eom_modifier({
	Name = "modifier_juggernaut_2_juggernaut_01_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_juggernaut_2_juggernaut_01_thinker:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_juggernaut_2_juggernaut_01_thinker:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_blob.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_2_juggernaut_01_thinker:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_juggernaut_2_juggernaut_01_thinker:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		hAbility:CreateMaskGhost(hParent:GetAbsOrigin())
	end
end
function modifier_juggernaut_2_juggernaut_01_thinker:DeclareFunctions()
	return {
	}
end
function modifier_juggernaut_2_juggernaut_01_thinker:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
modifier_juggernaut_2_juggernaut_01_illusion = eom_modifier({
	Name = "modifier_juggernaut_2_juggernaut_01_illusion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_2_juggernaut_01_illusion:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_juggernaut_2_juggernaut_01_illusion:OnCreated(params)
	if IsServer() then
	else
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_grimstroke_ink_swell.vpcf", PATTACH_INVALID, nil)
		self:AddParticle(iParticleID, false, true, 100, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_illusion.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_2_juggernaut_01_illusion:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_juggernaut_2_juggernaut_01_illusion:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		for _, v in ipairs(hParent._tWearable) do
			UTIL_Remove(v)
		end
		hParent:AddNoDraw()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_2_juggernaut_01_illusion:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end
function modifier_juggernaut_2_juggernaut_01_illusion:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
modifier_juggernaut_2_juggernaut_01_buff = eom_modifier({
	Name = "modifier_juggernaut_2_juggernaut_01_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_2_juggernaut_01_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_juggernaut_2_juggernaut_01_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = self:GetParent():GetBaseStrength(),
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS = self:GetParent():GetBaseAgility(),
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = self:GetParent():GetBaseIntellect(),
	}
end
---------------------------------------------------------------------
modifier_juggernaut_2_juggernaut_01_ghost = eom_modifier({
	Name = "modifier_juggernaut_2_juggernaut_01_ghost",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_juggernaut_2_juggernaut_01_ghost:OnCreated()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		-- hCaster:AddNoDraw()
		-- for i, v in ipairs(hCaster._tWearable) do
		-- 	v:AddEffects(EF_NODRAW)
		-- end
	end
end
function modifier_juggernaut_2_juggernaut_01_ghost:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		-- hCaster:RemoveNoDraw()
		-- for i, v in ipairs(hCaster._tWearable) do
		-- 	v:RemoveEffects(EF_NODRAW)
		-- end
	end
end
function modifier_juggernaut_2_juggernaut_01_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = 1,
	}
end
function modifier_juggernaut_2_juggernaut_01_ghost:CheckState()
	return {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end