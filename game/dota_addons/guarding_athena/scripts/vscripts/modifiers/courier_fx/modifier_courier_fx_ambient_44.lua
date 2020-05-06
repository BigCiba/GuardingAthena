if modifier_courier_fx_ambient_44 == nil then
	modifier_courier_fx_ambient_44 = class({})
end

local public = modifier_courier_fx_ambient_44

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
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_golden_skipper/golden_skipper_head_light.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_light", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_golden_skipper/golden_skipper_bubbles.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end