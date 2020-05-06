if modifier_courier_fx_ambient_1 == nil then
	modifier_courier_fx_ambient_1 = class({})
end

local public = modifier_courier_fx_ambient_1

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_cluckles/courier_cluckles_ambient.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 0, 0))
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end