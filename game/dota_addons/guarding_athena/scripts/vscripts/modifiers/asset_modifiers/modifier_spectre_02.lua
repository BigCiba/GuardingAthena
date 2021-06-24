if modifier_spectre_02 == nil then
	modifier_spectre_02 = class({}, nil, AssetModifier)
end
local public = modifier_spectre_02

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
		-- hParent:AddActivityModifier("arcana_style")
		-- hParent:AddActivityModifier("red")
		self:StartIntervalThink(0.1)
		-- 替换饰品
		AssetModifiers:ReplaceWearables("spectre_02", hParent)
		hParent:AddNewModifier(hParent, nil, "modifier_spectre_arcana", nil)
		hParent:SetBodygroupByName("blade_01", 1)
		hParent:SetBodygroupByName("blade_02", 1)
		hParent:SetBodygroupByName("blade_03", 1)
		hParent:SetBodygroupByName("blade_04", 1)
		hParent:SetBodygroupByName("blade_05", 1)

		--主身为红头发版本
		-- if not hParent:IsSummoned() then
		-- 	for _, v in ipairs(hParent._tWearable) do
		-- 		v:SetSkin(1)
		-- 	end
		-- end
		-- 替换技能
		-- AssetModifiers:ReplaceAbilities("spectre_02", hParent)
	else
		self:StartIntervalThink(14)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/juggernaut_arcana/juggernaut_arc_ambient_lines.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		-- ParticleManager:SetParticleControl(iParticleID, 60, Vector(0, 0, 255))
		-- ParticleManager:SetParticleControl(iParticleID, 61, Vector(0, 0, 255))
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnIntervalThink()
	if IsServer() then
		self:GetParent():SetSkin(1)
		self:StartIntervalThink(-1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_floating_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_blade_left_fx", hParent:GetAbsOrigin(), true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_floating_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_blade_right_fx", hParent:GetAbsOrigin(), true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_floating_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_blade_03_fx", hParent:GetAbsOrigin(), true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_floating_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_blade_05_fx", hParent:GetAbsOrigin(), true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_floating_blade.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_blade_02_fx", hParent:GetAbsOrigin(), true)
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_EVENT_ON_RESPAWN
	}
end
function public:GetModifierModelChange()
	return AssetModifiers:GetEntityModelReplacement("spectre_02")
end
function public:OnRespawn(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if hParent == params.unit then
		-- 重新替换饰品
		AssetModifiers:ReplaceWearables("spectre_02", hParent)
	end
end