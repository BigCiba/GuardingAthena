if modifier_courier_fx_ambient_13 == nil then
	modifier_courier_fx_ambient_13 = class({})
end

local public = modifier_courier_fx_ambient_13

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_amaterasu/courier_amaterasu_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end