LinkLuaModifier( "modifier_elite_34_2", "abilities/enemy/elite_34_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_34_2 == nil then
	elite_34_2 = class({})
end
function elite_34_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vDirection = -hCaster:GetForwardVector()
	local duration = self:GetSpecialValueFor("duration")
	local health_pct = self:GetSpecialValueFor("health_pct")
	local tPosition = {
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(45)) * 400,
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-45)) * 400,
	}
	for i = 1, 2 do
		local hUnit = CreateUnitByName("elite_34_split", tPosition[i], false, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetBaseMaxHealth(hCaster:GetMaxHealth() * health_pct * 0.01)
		hUnit:SetMaxHealth(hUnit:GetBaseMaxHealth())
		hUnit:SetHealth(hCaster:GetBaseMaxHealth())
		hUnit:SetForwardVector(-vDirection)
		hUnit:AddNewModifier(hCaster, self, "modifier_elite_34_2", {duration = duration})
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		-- hUnit:AddAbility("pszAbilityName")
	end
	-- praticle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_QueenOfPain.Blink_out")
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_34_2 == nil then
	modifier_elite_34_2 = class({})
end
function modifier_elite_34_2:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_2_END)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hParent:EmitSound("Hero_QueenOfPain.Blink_in")
	else
	end
end
function modifier_elite_34_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_elite_34_2:OnRemoved()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		hParent:AddNoDraw()
		hParent:ForceKill(false)
		-- 回复主身血量
		local flAmount = hCaster:GetMaxHealth() * self.health_pct * 0.01
		self:GetAbility():Heal(hCaster, flAmount)
		hCaster:RefreshAbilities()
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end