--Abilities
if pet_22_4_2 == nil then
	pet_22_4_2 = class({})
end
function pet_22_4_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local flDamage = hMaster:GetPrimaryStatValue() * self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")
	local vLocation = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment( "attach_stump" ))
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetDuration() * hUnit:GetStatusResistanceFactor()})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(vLocation, hCaster))
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius,radius,radius))
	hCaster:EmitSound("Hero_Centaur.HoofStomp")
end