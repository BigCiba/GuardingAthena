if modifier_courier_fx_ambient_76 == nil then
	modifier_courier_fx_ambient_76 = class({})
end

local public = modifier_courier_fx_ambient_76

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_staglift/courier_staglift_ambient.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_gearbox", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_pipe_c", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_pipe_b", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_pipe_a", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 7, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_foot_front_l", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 8, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_foot_front_r", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 9, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_foot_back_l", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 10, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_front_back_r", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end