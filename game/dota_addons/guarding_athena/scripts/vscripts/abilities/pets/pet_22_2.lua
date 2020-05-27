LinkLuaModifier( "modifier_pet_22_2", "abilities/pets/pet_22_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_2 == nil then
	pet_22_2 = class({})
end
function pet_22_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_2", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_2 == nil then
	modifier_pet_22_2 = class({}, nil, ModifierHidden)
end
function modifier_pet_22_2:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/pets/pet_22_2.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bag", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_22_2:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local iGold = RandomInt(20, 80) * (Spawner.gameRound or 1)
	hMaster:ModifyGold(iGold, true, 0)
	SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_GOLD, self:GetParent():GetMaster(), iGold, self:GetParent():GetPlayerOwner())
	self:GetParent():EmitSound("ui.comp_coins_tick")
end