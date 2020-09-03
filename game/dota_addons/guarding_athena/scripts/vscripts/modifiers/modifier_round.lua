if modifier_round == nil then
	modifier_round = class({}, nil, ModifierHidden)
end

local public = modifier_round

function public:AllowIllusionDuplicate()
	return true
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(5)
	end
end
function public:OnIntervalThink()
	self:GetParent():MoveToPositionAggressive(Spawner:GetBaseLocation())
end