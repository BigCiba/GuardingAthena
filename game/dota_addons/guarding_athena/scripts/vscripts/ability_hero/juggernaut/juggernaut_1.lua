LinkLuaModifier("modifier_juggernaut_1_buff", "ability_hero/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if juggernaut_1 == nil then
	juggernaut_1 = class({})
end
function juggernaut_1:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:Purge(false, true, false, false, false)
    caster:AddNewModifier(caster, self, "modifier_juggernaut_1_buff", {duration=duration})
    if not caster.mirror_image_illusions then
        caster.mirror_image_illusions = {}
    end
    local illusions = caster.mirror_image_illusions
	for k,v in pairs(illusions) do
        if v:IsNull() then 
            table.remove(illusions, k)
        end
    end
    if #illusions > 0 then
        for k, v in pairs( illusions ) do
            v:AddNewModifier(caster, self, "modifier_juggernaut_1_buff", {duration=duration})
        end
    end
end
function juggernaut_1:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
function juggernaut_1:GetCastRange()
	return self:GetSpecialValueFor("blade_fury_radius")
end
function juggernaut_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_1_buff == nil then
	modifier_juggernaut_1_buff = class({})
end
function modifier_juggernaut_1_buff:IsHidden()
	return false
end
function modifier_juggernaut_1_buff:IsDebuff()
	return false
end
function modifier_juggernaut_1_buff:IsPurgable()
	return false
end
function modifier_juggernaut_1_buff:IsPurgeException()
	return false
end
function modifier_juggernaut_1_buff:IsStunDebuff()
	return false
end
function modifier_juggernaut_1_buff:AllowIllusionDuplicate()
	return false
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
        self.HasExclusive = HasExclusive( self:GetParent(),2 )
        self.damage_type = self:GetAbility():GetAbilityDamageType()

		local caster = self:GetParent()

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particleID, 5, Vector(self.blade_fury_radius, self.blade_fury_radius, self.blade_fury_radius))
		self:AddParticle(particleID, false, false, -1, false, false)

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_null.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		self:AddParticle(particleID, false, false, -1, false, false)
        if self:GetCaster() == self:GetParent() then
            caster:EmitSound("Hero_Juggernaut.BladeFuryStart")
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
        local caster = self:GetParent()
        local ability = self:GetAbility()
        local damage = (self.base_damage + self.damage * caster:GetAverageTrueAttackDamage(caster)) * self.blade_fury_damage_tick * self:GetAbility():GetLevel()
        local radius = self.blade_fury_radius

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for n, target in pairs(targets) do
			local particleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", caster), PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(particleID, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particleID)

            if self:GetCaster() == self:GetParent() then
                EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Juggernaut.BladeFury.Impact", caster)
                CauseDamage(self:GetCaster(),target,damage,self.damage_type,ability)
            else
                CauseDamage(self:GetCaster(),target,damage * self.illusion_damage_percent * 0.01,self.damage_type,ability)
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