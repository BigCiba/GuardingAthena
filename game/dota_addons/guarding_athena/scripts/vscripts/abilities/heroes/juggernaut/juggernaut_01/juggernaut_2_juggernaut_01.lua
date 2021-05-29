juggernaut_2_juggernaut_01 = class({})
function juggernaut_2_juggernaut_01:GetAssociatedSecondaryAbilities()
	return "juggernaut_2_juggernaut_01_1"
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
	local property_pct = self:GetSpecialValueFor("property_pct")
	hUnit:SetBaseStrength(hCaster:GetBaseStrength() * property_pct * 0.01)
	hUnit:SetBaseAgility(hCaster:GetBaseAgility() * property_pct * 0.01)
	hUnit:SetBaseIntellect(hCaster:GetBaseIntellect() * property_pct * 0.01)
	self.hMaskGhost = hUnit
end
function juggernaut_2_juggernaut_01:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	print("bigciba", hCaster:GetTogglableWearable(DOTA_LOADOUT_TYPE_HEAD))
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_juggernaut_2_juggernaut_01_thinker", { duration = 1 }, vPosition, hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Juggernaut.MaskGhost.Cast")
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
		hCaster:StartGesture(ACT_DOTA_TAUNT_SPECIAL)
		hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_2_juggernaut_01_buff", { duration = self:GetSpecialValueFor("duration") })
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
function modifier_juggernaut_2_juggernaut_01_thinker:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_blob.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
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
function modifier_juggernaut_2_juggernaut_01_illusion:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		for _, v in ipairs(hParent._tWearable) do
			UTIL_Remove(v)
		end
		hParent:AddNoDraw()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hAbility.hMaskGhost = nil
	end
end
function modifier_juggernaut_2_juggernaut_01_illusion:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
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
	self.property_pct = self:GetAbilitySpecialValueFor("property_pct")
end
function modifier_juggernaut_2_juggernaut_01_buff:OnCreated()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if IsServer() then
		hParent:EmitSound("Hero_Juggernaut.ArcanaTrigger")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_2_juggernaut_01_return_a.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "blade_attachment", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_2_juggernaut_01_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = self:GetParent():GetBaseStrength() * (self.property_pct or 0) * 0.01,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS = self:GetParent():GetBaseAgility() * (self.property_pct or 0) * 0.01,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = self:GetParent():GetBaseIntellect() * (self.property_pct or 0) * 0.01,
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