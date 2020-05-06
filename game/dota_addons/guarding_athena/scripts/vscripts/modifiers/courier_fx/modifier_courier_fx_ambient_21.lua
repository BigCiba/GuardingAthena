if modifier_courier_fx_ambient_21 == nil then
	modifier_courier_fx_ambient_21 = class({})
end

local public = modifier_courier_fx_ambient_21

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_red_plus.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_eye_glow_green.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end