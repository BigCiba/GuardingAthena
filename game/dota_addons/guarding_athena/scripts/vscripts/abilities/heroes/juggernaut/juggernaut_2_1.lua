LinkLuaModifier( "modifier_juggernaut_2_1", "abilities/heroes/juggernaut/juggernaut_2_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_2_1 == nil then
	juggernaut_2_1 = class({})
end
function juggernaut_2_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local illusions = Load(hCaster, "manta_illusion_table") or {}
	for i = #illusions, 1, -1 do
		local hIllusion = illusions[i]
		if not hIllusion:IsNull() and (hIllusion:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D() < 900 then 
			hIllusion:SetForwardVector((vPosition - hIllusion:GetAbsOrigin()):Normalized())
			hIllusion:StartGesture(ACT_DOTA_ATTACK_EVENT)
		end
	end
	return true
end
function juggernaut_2_1:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
	local illusions = Load(hCaster, "manta_illusion_table") or {}
	for i = #illusions, 1, -1 do
		local hIllusion = illusions[i]
		if not hIllusion:IsNull() then 
			hIllusion:FadeGesture(ACT_DOTA_ATTACK_EVENT)
		end
	end
end
function juggernaut_2_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDamage = self:GetSpecialValueFor("damage") * hCaster:GetAgility() + self:GetSpecialValueFor("base_damage")
	local flWidth = self:GetSpecialValueFor("width")
	local tTargets = FindUnitsInLineWithAbility(hCaster, hCaster:GetAbsOrigin(), vPosition, flWidth, self)
	for _, hUnit in pairs(tTargets) do
		local flHealth = hUnit:GetHealth()
		hCaster:DealDamage(hUnit, self, flDamage)
		local flHealthLoss = flHealth - hUnit:GetHealth()
		local flDuration = flHealthLoss / hUnit:GetMaxHealth() * 10
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = flDuration * hUnit:GetStatusResistanceFactor()})
	end

	-- 幻象
	local illusions = Load(hCaster, "manta_illusion_table") or {}
	for i = #illusions, 1, -1 do
		local hIllusion = illusions[i]
		if not hIllusion:IsNull() and (hIllusion:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D() <= 900 then
			local iParticleID = ParticleManager:CreateParticle("particles/skills/space_cut_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, hIllusion)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			local tTargets = FindUnitsInLineWithAbility(hCaster, hIllusion:GetAbsOrigin(), vPosition, flWidth, self)
			for _, hUnit in pairs(tTargets) do
				local flHealth = hUnit:GetHealth()
				hCaster:DealDamage(hUnit, self, flDamage)
				local flHealthLoss = flHealth - hUnit:GetHealth()
				local flDuration = flHealthLoss / hUnit:GetMaxHealth() * 10
				hUnit:AddNewModifier(hCaster, self, "modifier_stunned", {duration = flDuration * hUnit:GetStatusResistanceFactor()})
			end
			FindClearSpaceForUnit(hIllusion, vPosition, false)
		end
	end
	
	-- 位移
	local iParticleID = ParticleManager:CreateParticle("particles/skills/space_cut_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	FindClearSpaceForUnit(hCaster, vPosition, false)
end