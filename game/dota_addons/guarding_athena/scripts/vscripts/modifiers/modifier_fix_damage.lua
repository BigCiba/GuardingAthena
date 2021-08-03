if modifier_fix_damage == nil then
	modifier_fix_damage = class({})
end

local public = modifier_fix_damage

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function public:GetModifierAttackSpeedBaseOverride(params)
	local fBonus = self:GetParent():GetModifierStackCount("modifier_bonus_maximum_attack_speed", self:GetParent())
	return Clamp(1 + self:GetParent():GetIncreasedAttackSpeed(), 0.2, 5 + fBonus * 0.01)
end
function public:GetModifierIncomingDamage_Percentage(params)
	-- new_pos	Vector 00000000003C3C10 [0.000000 6749722244770428445374133913719406592.000000 0.000000]
	-- process_procs	true
	-- order_type	0
	-- octarine_tested	false
	-- issuer_player_index	0
	-- stout_tested	false
	-- activity	-1
	-- target	table: 0x00500208
	-- damage_category	1
	-- reincarnate	false
	-- locket_amp_applied	false
	-- damage	5481.599609375
	-- ignore_invis	false
	-- attacker	table: 0x003f0240
	-- ranged_attack	false
	-- record	28
	-- sange_amp_applied	false
	-- do_not_consume	false
	-- damage_type	1
	-- heart_regen_applied	false
	-- diffusal_applied	false
	-- mkb_tested	false
	-- distance	0
	-- no_attack_cooldown	false
	-- damage_flags	0
	-- original_damage	5481.599609375
	-- cost	0
	-- gain	0
	-- basher_tested	false
	-- fail_type	0
	local percent = 100
	local hAttacker = params.attacker
	local hParent = self:GetParent()

	if not IsValid(hAttacker) or not IsValid(hParent) then
		return 0
	end

	--三种类型伤害加成
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT) ~= DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT and
	bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS) ~= DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS then
		if params.damage_type == DAMAGE_TYPE_PHYSICAL then
			percent = percent * GetOutgoingDamagePercent(hAttacker, DAMAGE_TYPE_PHYSICAL) * 0.01
			percent = percent * GetIncomingDamagePercent(hParent, DAMAGE_TYPE_PHYSICAL) * 0.01
		elseif params.damage_type == DAMAGE_TYPE_MAGICAL then
			percent = percent * GetOutgoingDamagePercent(hAttacker, DAMAGE_TYPE_MAGICAL) * 0.01
			percent = percent * GetIncomingDamagePercent(hParent, DAMAGE_TYPE_MAGICAL) * 0.01
		elseif params.damage_type == DAMAGE_TYPE_PURE then
			percent = percent * GetOutgoingDamagePercent(hAttacker, DAMAGE_TYPE_PURE) * 0.01
			percent = percent * GetIncomingDamagePercent(hParent, DAMAGE_TYPE_PURE) * 0.01
		end
		--全伤害加成
		percent = percent * GetOutgoingDamagePercent(hAttacker, DAMAGE_TYPE_NONE) * 0.01
		percent = percent * GetIncomingDamagePercent(hParent, DAMAGE_TYPE_NONE) * 0.01
	end
	return percent - 100
end
function public:GetModifierIncomingSpellDamageConstant(params)
	-- 无视魔法抗性效果
	if params.attacker and params.damage_type == DAMAGE_TYPE_MAGICAL then
		local magicalArmor = self:GetParent():GetMagicalArmorValue()
		local value = GetIgnoreMagicResistanceValue(params.attacker)
		local ignore = math.max(magicalArmor, 0) - math.max(magicalArmor - value, 0)
		local actualMagicalArmor = magicalArmor - ignore
		local factor = (1 - actualMagicalArmor) / (1 - magicalArmor)
		return params.original_damage * (factor - 1)
	end
end
function public:GetModifierTotalDamageOutgoing_Percentage(params)
	local percent = 100
	local bIsSpellCrit = false
	if iDamageCategory ~= DOTA_DAMAGE_CATEGORY_ATTACK then
		RECORD_SYSTEM_DUMMY.iLastRecord = params.record
	end

	-- 法术暴击
	if	params.attacker == self:GetParent()
	and params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL
	and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_CRIT) ~= DOTA_DAMAGE_FLAG_NO_SPELL_CRIT
	then
		local spell_crit_damage = GetSpellCriticalStrike(params.attacker)
		if spell_crit_damage > 0 then
			spell_crit_damage = spell_crit_damage + GetSpellCriticalStrikeDamage(params.attacker)
			percent = percent * spell_crit_damage * 0.01
			bIsSpellCrit = true
		end
	end
	if bIsSpellCrit then
		if percent > 0 then
			-- FireModifiersEvents(MODIFIER_EVENT_ON_SPELL_CRIT, {
			-- 	attacker = params.attacker,
			-- 	target = params.target,
			-- 	original_damage = params.original_damage,
			-- 	damage = params.original_damage * percent * 0.01,
			-- 	damage_type = params.damage_type,
			-- 	damage_flags = params.damage_flags,
			-- 	damage_category = params.damage_category,
			-- })
			local iNumber = math.floor(params.original_damage * (percent + 100) * 0.01)
			local sNumber = tostring(iNumber)
			local fDuration = 3
			local vColor = Vector(0, 191, 255)
			local iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(0, iNumber, 4))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(fDuration, #sNumber + 1, 0))
			ParticleManager:SetParticleControl(iParticleID, 3, vColor)
			ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, params.target, params.original_damage * percent * 0.01, params.attacker:GetPlayerOwner())
			return percent
		end
	end
	return 0
end