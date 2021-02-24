if modifier_particle_3 == nil then
	modifier_particle_3 = class({}, nil, ParticleModifier)
end
local public = modifier_particle_3

function public:OnCreated(params)
	if IsServer() then
	else
		local sModifierName = string.gsub(self:GetName(), "modifier_", "")
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/particle/" .. sModifierName .. "/" .. sModifierName .. ".vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end