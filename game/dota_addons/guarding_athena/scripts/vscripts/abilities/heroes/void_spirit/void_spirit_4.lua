LinkLuaModifier("modifier_void_spirit_4", "abilities/heroes/void_spirit/void_spirit_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_4 == nil then
	void_spirit_4 = class({})
end
function void_spirit_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()

	--范围打击
	local radius = self:GetSpecialValueFor("radius")
	local min_travel_distance = self:GetSpecialValueFor("min_travel_distance")
	local max_travel_distance = self:GetSpecialValueFor("max_travel_distance")
	local pop_damage_delay = self:GetSpecialValueFor("pop_damage_delay")

	local vDir = (vTarget - hCaster:GetAbsOrigin()):Normalized()
	local fDis = math.min(max_travel_distance, math.max((vTarget - hCaster:GetAbsOrigin()):Length2D(), min_travel_distance))
	local vE = hCaster:GetAbsOrigin() + vDir * fDis
	self:AstralStep(vE)

	if #hCaster.tAetherRemnant > 0 then
		hCaster:GameTimer(0, function()
			local hUnit = RandomValue(hCaster.tAetherRemnant)
			if IsValid(hUnit) then
				self:AstralStep(hUnit:GetAbsOrigin())
				hUnit:Kill(self, hCaster)
				if #hCaster.tAetherRemnant > 0 then
					return 0.2
				end
			end
		end)
	end
end
function void_spirit_4:AstralStep(vPosition)
	local hCaster = self:GetCaster()
	hCaster:EmitSound('Hero_VoidSpirit.AstralStep.Start')

	--范围打击
	local radius = self:GetSpecialValueFor("radius")

	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), vPosition, nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	for _, hTarget in pairs(tTargets) do
		--造成攻击
		hCaster:PerformAttack(hTarget, true, true, true, true, false, false, true)
		--减速
		-- hTarget:AddNewModifier(hCaster, self, 'modifier_void_spirit_astral_step_imba_debuff', { duration = pop_damage_delay })
	end

	--位移
	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iPtclID, 1, vPosition)
	hCaster:SetAbsOrigin(vPosition)
	FindClearSpaceForUnit(hCaster, vPosition, true)
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
	local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/hero_void_spirit/void_spirit_attack_travel_strike_blur.vpcf', PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_4 == nil then
	modifier_void_spirit_4 = class({})
end
function modifier_void_spirit_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_void_spirit_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_void_spirit_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_void_spirit_4:DeclareFunctions()
	return {
	}
end