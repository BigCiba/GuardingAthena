if modifier_courier_fx_ambient_36 == nil then
	modifier_courier_fx_ambient_36 = class({})
end

local public = modifier_courier_fx_ambient_36

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_f2p/courier_f2p_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end