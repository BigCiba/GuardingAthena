if modifier_particle_2 == nil then
	modifier_particle_2 = class({}, nil, ParticleModifier)
end
local public = modifier_particle_2

function public:OnCreated(params)
	if IsServer() then
	else
		local sModifierName = string.gsub(self:GetName(), "modifier_", "")
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/particle/" .. sModifierName .. "/" .. sModifierName .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end