monkey_king_3 = class({})
function monkey_king_3:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		if not hCaster:IsSummoned() then
			self.tSoldiers = {}
			self.tFreeSoldiers = {}
			local iMaxCount = self:GetLevelSpecialValueFor("max_count", 1)
			for i = 1, iMaxCount do
				local tData = {
					MapUnitName = hCaster:GetUnitName(),
					teamnumber = hCaster:GetTeamNumber(),
					IsSummoned = "1",
				}
				local hSoldier = CreateUnitFromTable(tData, hCaster:GetAbsOrigin())
				hSoldier:AddNewModifier(hCaster, self, "modifier_monkey_king_3_soldier", nil)
				hSoldier:SetOwner(hCaster)
				table.insert(self.tSoldiers, hSoldier)
				table.insert(self.tFreeSoldiers, hSoldier)
			end
		end
	end
end
function monkey_king_3:CreateSoldier(vPosition, flDuration)
	if IsServer() then
		local hCaster = self:GetCaster()
		if #self.tFreeSoldiers > 0 then
			local hSoldier = self.tFreeSoldiers[1]
			FindClearSpaceForUnit(hSoldier, vPosition, false)
			hSoldier:AddNewModifier(hCaster, self, "modifier_monkey_king_3_activity", { duration = flDuration })
			ArrayRemove(self.tFreeSoldiers, hSoldier)
			for iItemSlot = 0, 5 do
				local hItem = hCaster:GetItemInSlot(iItemSlot)
				if hItem ~= nil then
					local sItemName = hItem:GetName()
					local hNewItem = CreateItem(sItemName, hSoldier, hSoldier)
					hSoldier:AddItem(hNewItem)
				end
			end
			for i = 0, 4 do
				hSoldier:GetAbilityByIndex(i):SetLevel(hCaster:GetAbilityByIndex(i):GetLevel())
			end
			if hSoldier:GetLevel() < hCaster:GetLevel() then
				for i = 1, hCaster:GetLevel() - hSoldier:GetLevel() do
					hSoldier:HeroLevelUp(false)
				end
			end
			hSoldier:SetBaseStrength(hCaster:GetBaseStrength())
			hSoldier:SetBaseAgility(hCaster:GetBaseAgility())
			hSoldier:SetBaseIntellect(hCaster:GetBaseIntellect())
			hSoldier:Stop()
			ExecuteOrder(hSoldier, DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, hSoldier:GetAbsOrigin())
			return hSoldier
		end
	end
end
function monkey_king_3:UpdateOnRemove()
	if IsServer() then
		for i, v in ipairs(self.tSoldiers) do
			v:RemoveModifierByName("modifier_monkey_king_3_soldier")
		end
	end
end
function monkey_king_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_monkey_king_3_buff", { duration = self:GetSpecialValueFor("duration") })
end
function monkey_king_3:GetIntrinsicModifierName()
	return "modifier_monkey_king_3"
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_3 = eom_modifier({
	Name = "modifier_monkey_king_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false
})
function modifier_monkey_king_3:GetAbilitySpecialValue()
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
	self.scepter_interval = self:GetAbilitySpecialValueFor("scepter_interval")
	self.scepter_duration = self:GetAbilitySpecialValueFor("scepter_duration")
	self.scepter_counter_duration = self:GetAbilitySpecialValueFor("scepter_counter_duration")
end
function modifier_monkey_king_3:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.scepter_interval)
	end
end
function modifier_monkey_king_3:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(self.scepter_interval)
	end
end
function modifier_monkey_king_3:OnIntervalThink()
	if not self:GetParent():IsSummoned() and self:GetParent():GetScepterLevel() >= 1 then
		local hAbility = self:GetAbility()
		hAbility:CreateSoldier(self:GetParent():GetAbsOrigin() + RandomVector(300), self.scepter_duration)
	end
end
function modifier_monkey_king_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() }
	}
end
function modifier_monkey_king_3:OnDamageCalculated(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	DoCleaveAttack(params.attacker, params.target, hAbility, self.cleave_damage, 260, 520, self.cleave_radius, "sCleaveParticle")
	if hParent:GetScepterLevel() >= 2 then
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_monkey_king_3_debuff", { duration = self.scepter_counter_duration })
	end
end
---------------------------------------------------------------------
modifier_monkey_king_3_buff = eom_modifier({
	Name = "modifier_monkey_king_3_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false
})
function modifier_monkey_king_3_buff:GetAbilitySpecialValue()
	self.summon_count = self:GetAbilitySpecialValueFor("summon_count")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_monkey_king_3_buff:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		local iParticleID = CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_top", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_top", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_bot", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hParent:EmitSound("Hero_MonkeyKing.IronCudgel")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_3_buff:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		hParent:EmitSound("Hero_MonkeyKing.IronCudgel")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_start.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_3_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() }
	}
end
function modifier_monkey_king_3_buff:OnDamageCalculated(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent == params.attacker then
		for i = 1, self.summon_count do
			if #hAbility.tFreeSoldiers > 0 then
				local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 600, hAbility)
				if IsValid(tTargets[1]) then
					local hSoldier = self:GetAbility():CreateSoldier(tTargets[1]:GetAbsOrigin() + RandomVector(200), self.duration)
					if hSoldier then
						hSoldier:MoveToTargetToAttack(tTargets[1])
					end
				end
			end
		end
	end
end
function modifier_monkey_king_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function modifier_monkey_king_3_buff:GetActivityTranslationModifiers(params)
	return "iron_cudgel_charged_attack"
end
---------------------------------------------------------------------
modifier_monkey_king_3_soldier = eom_modifier({
	Name = "modifier_monkey_king_3_soldier",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false
})
function modifier_monkey_king_3_soldier:OnCreated(params)
	if IsServer() then
		self:GetParent():SetDayTimeVisionRange(0)
		self:GetParent():SetNightTimeVisionRange(0)
		self:GetParent():AddNoDraw()
	end
end
function modifier_monkey_king_3_soldier:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveSelf()
	end
end
function modifier_monkey_king_3_soldier:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = not self:GetParent():HasModifier("modifier_monkey_king_3_activity"),
	}
end
function modifier_monkey_king_3_soldier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TEMPEST_DOUBLE,
		MODIFIER_PROPERTY_ALWAYS_AUTOATTACK_WHILE_HOLD_POSITION = 1
	}
end
function modifier_monkey_king_3_soldier:GetActivityTranslationModifiers(params)
	return "fur_army_soldier"
end
function modifier_monkey_king_3_soldier:GetModifierTempestDouble(params)
	return 1
end
---------------------------------------------------------------------
modifier_monkey_king_3_activity = eom_modifier({
	Name = "modifier_monkey_king_3_activity",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false
})
function modifier_monkey_king_3_activity:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveNoDraw()

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_fur_army_positions.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_top", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_top", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_weapon_bot", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_3_activity:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hParent:AddNoDraw()
		hParent:Stop()

		for i = 0, 5 do
			local hItemOld = hParent:GetItemInSlot(i)
			if hItemOld then
				hParent:RemoveItem(hItemOld)
			end
		end
		table.insert(hAbility.tFreeSoldiers, hParent)
	end
end
function modifier_monkey_king_3_activity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function modifier_monkey_king_3_activity:GetActivityTranslationModifiers(params)
	return "iron_cudgel_charged_attack"
end
---------------------------------------------------------------------
modifier_monkey_king_3_debuff = eom_modifier({
	Name = "modifier_monkey_king_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false
})
function modifier_monkey_king_3_debuff:GetAbilitySpecialValue()
	self.scepter_counter_attack = self:GetAbilitySpecialValueFor("scepter_counter_attack")
end
function modifier_monkey_king_3_debuff:OnCreated(params)
	if IsServer() then
		self.tData = { self:GetDieTime() }
		self:SetStackCount(1)
		self:StartIntervalThink(0)
		local hParent = self:GetParent()
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(0, 1, 0))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_3_debuff:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		table.insert(self.tData, self:GetDieTime())
		self:IncrementStackCount()
		local iStackCount = self:GetStackCount()
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(math.floor(iStackCount / 10), math.floor(iStackCount % 10), 0))
	end
end
function modifier_monkey_king_3_debuff:OnIntervalThink()
	local flGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i] < flGameTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
function modifier_monkey_king_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_TARGET
	}
end
function modifier_monkey_king_3_debuff:GetModifierPreAttack_BonusDamage_Target(params)
	if IsServer() then
		if params.attacker:HasModifier("modifier_monkey_king_3") then
			return self:GetStackCount() * self:GetCaster():GetAgility() * self.scepter_counter_attack
		end
	end
end