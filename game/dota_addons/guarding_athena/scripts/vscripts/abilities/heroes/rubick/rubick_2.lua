--Abilities
if rubick_2 == nil then
	rubick_2 = class({})
end
function rubick_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local sParticleName = "particles/heroes/chronos_magic/teleport_open.vpcf"
	if hCaster.gift then
		sParticleName = "particles/heroes/chronos_magic/teleport_open_gold.vpcf"
	end
	self.tParticleID = {}
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	table.insert(self.tParticleID, iParticleID)
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	table.insert(self.tParticleID, iParticleID)
	-- sound
	hCaster:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.End")
	-- 动作
	hCaster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_4)
	return true
end
function rubick_2:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)

	if self.tParticleID then
		for i, iParticleID in ipairs(self.tParticleID) do
			ParticleManager:DestroyParticle(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
	self.tParticleID = nil
end
function rubick_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDelay = self:GetSpecialValueFor("delay")
	local flDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetIntellect()
	hCaster:AddNewModifier(hCaster, self, "modifier_rubick_2_root", {duration = flDelay})
	
	-- 伤害
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCasterLoc, flRadius, self)
	hCaster:DealDamage(tTargets, self, flDamage)
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	hCaster:DealDamage(tTargets, self, flDamage)
	-- 传送
	FindClearSpaceForUnit(hCaster, vPosition, true)
	-- 天赋
	hCaster:SpaceRift(vCasterLoc + RandomVector(RandomInt(0, flRadius)))
	hCaster:SpaceRift(vPosition + RandomVector(RandomInt(0, flRadius)))
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/chronos_magic/teleport_startleague.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vCasterLoc)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/chronos_magic/teleport_endflash_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_Furion.Teleport_Disappear")
end
function rubick_2:GetIntrinsicModifierName()
	return "modifier_rubick_2"
end