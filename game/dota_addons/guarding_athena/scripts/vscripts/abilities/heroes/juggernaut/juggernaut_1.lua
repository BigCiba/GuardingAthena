LinkLuaModifier( "modifier_juggernaut_1", "abilities/heroes/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_juggernaut_1_buff", "abilities/heroes/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_1 == nil then
	juggernaut_1 = class({})
end
function juggernaut_1:GetCastRange()
	return self:GetSpecialValueFor("blade_fury_radius")
end
function juggernaut_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	hCaster:Purge(false, true, false, false, false)
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_1_buff", {duration = duration})
	if not hCaster.mirror_image_illusions then
		hCaster.mirror_image_illusions = {}
	end
	local illusions = hCaster.mirror_image_illusions
	for k,v in pairs(illusions) do
		if v:IsNull() then 
			table.remove(illusions, k)
		end
	end
	if #illusions > 0 then
		for k, v in pairs( illusions ) do
			if IsValid(v) then
				v:AddNewModifier(hCaster, self, "modifier_juggernaut_1_buff", {duration = duration})
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_1_buff == nil then
	modifier_juggernaut_1_buff = class({}, nil, ModifierBasic)
end
function modifier_juggernaut_1_buff:OnCreated(params)
	self.blade_fury_damage_tick = self:GetAbilitySpecialValueFor("blade_fury_damage_tick")
	self.blade_fury_radius = self:GetAbilitySpecialValueFor("blade_fury_radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.illusion_damage_percent = self:GetAbilitySpecialValueFor("illusion_damage_percent")
	if IsServer() then
		self.HasExclusive = self:GetParent():GetScepterLevel() >= 2
		self.damage_type = self:GetAbility():GetAbilityDamageType()

		local hCaster = self:GetParent()

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self.blade_fury_radius, self.blade_fury_radius, self.blade_fury_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_null.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		if self:GetCaster() == self:GetParent() then
			hCaster:EmitSound("Hero_Juggernaut.BladeFuryStart")
		end

		self:StartIntervalThink(self.blade_fury_damage_tick)
	end
end
function modifier_juggernaut_1_buff:OnRefresh(params)
	self.blade_fury_damage_tick = self:GetAbilitySpecialValueFor("blade_fury_damage_tick")
	self.blade_fury_radius = self:GetAbilitySpecialValueFor("blade_fury_radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.illusion_damage_percent = self:GetAbilitySpecialValueFor("illusion_damage_percent")
end
function modifier_juggernaut_1_buff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetParent()
		local hAbility = self:GetAbility()
		local damage = (self.base_damage + self.damage * hCaster:GetAverageTrueAttackDamage(hCaster)) * self.blade_fury_damage_tick
		local radius = self.blade_fury_radius

		local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for n, target in pairs(targets) do
			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", hCaster), PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			if self:GetCaster() == self:GetParent() then
				EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Juggernaut.BladeFury.Impact", hCaster)
				CauseDamage(self:GetCaster(),target,damage,self.damage_type,hAbility)
			else
				CauseDamage(self:GetCaster(),target,damage * self.illusion_damage_percent * 0.01,self.damage_type,hAbility)
			end
		end
	end
end
function modifier_juggernaut_1_buff:OnDestroy()
	if IsServer() then
		if self:GetCaster() == self:GetParent() then
			self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
			self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
		end
	end
end
function modifier_juggernaut_1_buff:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = self.HasExclusive and true or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_juggernaut_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_juggernaut_1_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_juggernaut_1_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_juggernaut_1_buff:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end