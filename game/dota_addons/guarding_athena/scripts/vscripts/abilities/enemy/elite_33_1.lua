LinkLuaModifier( "modifier_elite_33_1", "abilities/enemy/elite_33_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elite_33_1_buff", "abilities/enemy/elite_33_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_33_1 == nil then
	elite_33_1 = class({})
end
function elite_33_1:GetIntrinsicModifierName()
	return "modifier_elite_33_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_33_1 == nil then
	modifier_elite_33_1 = class({}, nil, ModifierHidden)
end
function modifier_elite_33_1:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
	end
end
function modifier_elite_33_1:OnRefresh(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
	end
end
function modifier_elite_33_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_elite_33_1:GetModifierAvoidDamage(params)
	if self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled() then
		self:GetAbility():UseResources(false, false, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_elite_33_1_buff", {duration = self.delay, iEntIndex = params.attacker:entindex()})
		return 1
	end
end
---------------------------------------------------------------------
if modifier_elite_33_1_buff == nil then
	modifier_elite_33_1_buff = class({}, nil, ModifierHidden)
end
function modifier_elite_33_1_buff:OnCreated(params)
	self.image_count = self:GetAbilitySpecialValueFor("image_count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.outgoing_damage = self:GetAbilitySpecialValueFor("outgoing_damage")
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
	if IsServer() then
		local hParent = self:GetParent()
		self.hTarget = EntIndexToHScript(params.iEntIndex)
		self.vPosition = self.hTarget:GetAbsOrigin()
		-- damage
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		hParent:DealDamage(tTargets, self:GetAbility(), self:GetAbilityDamage())
		-- sound
		hParent:EmitSound("Hero_NagaSiren.MirrorImage")
	else
		-- 娜迦分身水波特效
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl( iParticleID, 1, Vector(self.radius,self.radius,self.radius))
		ParticleManager:SetParticleControl( iParticleID, 3, Vector(self.radius,0,0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_33_1_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local vStartVector = RandomVector(175)
		FindClearSpaceForUnit(hParent, self.vPosition + vStartVector, true)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:SetForwardVector((self.vPosition - hParent:GetAbsOrigin()):Normalized())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf", PATTACH_ABSORIGIN, hParent)
		-- 幻象
		local tIllusions = CreateIllusions( hParent, hParent, {duration = self:GetAbilityDuration(), outgoing_damage = self.outgoing_damage, incoming_damage = self.incoming_damage}, self.image_count, 100, true, true )
		for i = 1, self.image_count do
			FindClearSpaceForUnit(tIllusions[i], self.vPosition + Rotation2D(vStartVector, math.rad(360 / self.image_count * i)), true)
			tIllusions[i]:SetForwardVector((self.vPosition - tIllusions[i]:GetAbsOrigin()):Normalized())
			tIllusions[i]:SetForceAttackTarget(self.hTarget)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf", PATTACH_ABSORIGIN, tIllusions[i])
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_elite_33_1_buff:DeclareFunctions()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end