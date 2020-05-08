LinkLuaModifier( "modifier_pet_22_4", "abilities/pets/pet_22_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_4 == nil then
	pet_22_4 = class({})
end
function pet_22_4:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Lycan.Shapeshift.Cast")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	return true
end
function pet_22_4:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_Lycan.Shapeshift.Cast")
end
function pet_22_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetDuration()})
	local hUnit = CreateUnitByName("nian", hCaster:GetAbsOrigin(), true, hMaster, hMaster:GetPlayerOwner(), hCaster:GetTeamNumber())
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	hUnit:AddNewModifier(hCaster, self, "modifier_kill", {duration = self:GetDuration()})
	hUnit:SetBaseDamageMin(hMaster:GetPrimaryStatValue() * 100)
	hUnit:SetBaseDamageMax(hMaster:GetPrimaryStatValue() * 100)
	hUnit:SetBaseMaxHealth(hMaster:GetPrimaryStatValue() * 1000)
	hUnit:SetMaxHealth(hMaster:GetPrimaryStatValue() * 1000)
	hUnit:SetHealth(hMaster:GetPrimaryStatValue() * 1000)
	hUnit:SetPhysicalArmorBaseValue(hMaster:GetPrimaryStatValue() / 100)
	hUnit.GetMaster = function (hUnit)
		return hMaster
	end
	hCaster:AddNoDraw()
	hCaster:GameTimer(self:GetDuration(), function ()
		hCaster:RemoveNoDraw()
		hCaster:SetAbsOrigin(hUnit:GetAbsOrigin())
		hUnit:AddNoDraw()
	end)
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_4 == nil then
	modifier_pet_22_4 = class({})
end
function modifier_pet_22_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_pet_22_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pet_22_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_pet_22_4:DeclareFunctions()
	return {
	}
end