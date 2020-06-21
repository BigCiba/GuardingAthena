if modifier_rubick_02 == nil then
	modifier_rubick_02 = class({}, nil, AssetModifier)
end
local public = modifier_rubick_02

function public:OnCreated(params)
	self:Init()
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 60, Vector(0, 0, 255))
		ParticleManager:SetParticleControl(iParticleID, 61, Vector(0, 0, 255))
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