if modifier_courier_fx_ambient_24 == nil then
	modifier_courier_fx_ambient_24 = class({})
end

local public = modifier_courier_fx_ambient_24

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_wabbit/courier_wabbit_ambient_lvl3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bottle", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_ear_base_l", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_ear_base_r", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_scroll", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_pendant", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end