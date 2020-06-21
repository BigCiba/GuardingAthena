if modifier_rubick_03 == nil then
	modifier_rubick_03 = class({}, nil, AssetModifier)
end
local public = modifier_rubick_03

function public:OnCreated(params)
	self:Init()
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 60, Vector(255, 241, 124))
		ParticleManager:SetParticleControl(iParticleID, 61, Vector(255, 241, 124))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement(self:GetParent():GetSkinName())
end