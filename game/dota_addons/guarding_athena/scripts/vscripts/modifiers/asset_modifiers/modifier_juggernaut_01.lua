if modifier_juggernaut_01 == nil then
	modifier_juggernaut_01 = class({}, nil, AssetModifier)
end
local public = modifier_juggernaut_01

function public:OnCreated(params)
	self:Init()
	-- self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	local hParent = self:GetParent()

	-- -- 是否装备魔导师秘钥
	-- hParent.HasArcana = function (hParent)
	-- 	return true
	-- end
	if IsServer() then
		-- hParent:SetUnitName("npc_dota_hero_juggernaut_juggernaut_01")
		-- print("bigciba", hParent:GetUnitName())
		hParent:AddActivityModifier("arcana_style")
		hParent:AddActivityModifier("red")
		self:StartIntervalThink(0.1)
		-- 替换饰品
		AssetModifiers:ReplaceWearables("juggernaut_01", hParent)
		--主身为红头发版本
		if not hParent:IsSummoned() then
			for _, v in ipairs(hParent._tWearable) do
				v:SetSkin(1)
			end
		end
		-- 替换技能
		AssetModifiers:ReplaceAbilities("juggernaut_01", hParent)
	else
		-- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/juggernaut_arcana/juggernaut_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		-- ParticleManager:SetParticleControl(iParticleID, 60, Vector(0, 0, 255))
		-- ParticleManager:SetParticleControl(iParticleID, 61, Vector(0, 0, 255))
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnIntervalThink()
	self:GetParent():SetSkin(1)
	self:StartIntervalThink(-1)
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_EVENT_ON_RESPAWN
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement("juggernaut_01")
end
function public:OnRespawn(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if hParent == params.unit then
		-- 重新替换饰品
		AssetModifiers:ReplaceWearables("juggernaut_01", hParent)
	end
end