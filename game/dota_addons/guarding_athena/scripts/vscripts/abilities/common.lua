function Save(table, key, value)
	if type(table) ~= "table" then return end
	table.abilitydata = table.abilitydata or {}
	table.abilitydata[key] = value
end
function Load(table, key)
	if type(table) ~= "table" then return end
	table.abilitydata = table.abilitydata or {}
	return table.abilitydata[key]
end

-- CDOTA_Buff
function CDOTA_Buff:GetAbilitySpecialValueFor(szName)
	if not IsValid(self:GetAbility()) then
		return self[szName] or 0
	end
	return self:GetAbility():GetSpecialValueFor(szName)
end
function CDOTA_Buff:GetAbilityLevelSpecialValueFor(szName, iLevel)
	if not IsValid(self:GetAbility()) then
		return self[szName] or 0
	end
	return self:GetAbility():GetLevelSpecialValueFor(szName, iLevel)
end
function CDOTA_Buff:GetAbilityLevel()
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) then
		return 0
	end
	return hAbility:GetLevel()
end
function CDOTA_Buff:GetAbilitySpecialValueWithLevel(szName)
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) then
		return 0
	end
	return hAbility:GetSpecialValueWithLevel(szName)
end
if CDOTA_Buff._IncrementStackCount == nil then
	CDOTA_Buff._IncrementStackCount = CDOTA_Buff.IncrementStackCount
end
function CDOTA_Buff:IncrementStackCount(iStackCount)
	if iStackCount == nil then
		self:_IncrementStackCount()
	else
		self:SetStackCount(self:GetStackCount() + iStackCount)
	end
end
if CDOTA_Buff._DecrementStackCount == nil then
	CDOTA_Buff._DecrementStackCount = CDOTA_Buff.DecrementStackCount
end
function CDOTA_Buff:DecrementStackCount(iStackCount)
	if iStackCount == nil then
		self:_DecrementStackCount()
	else
		self:SetStackCount(self:GetStackCount() - iStackCount)
	end
end
-- 技能暴击
function SetSpellCriticalStrike(unit, chance, damage, key)
	if unit.spellCriticalStrikes == nil then
		unit.spellCriticalStrikes = {}
	end

	key = key or DoUniqueString("SpellCriticalStrike")
	if chance == nil or chance <= 0 then
		unit.spellCriticalStrikes[key] = nil
	else
		unit.spellCriticalStrikes[key] = {
			spell_crit_chance = chance,
			spell_crit_damage = damage
		}
	end

	return key
end
function GetSpellCriticalStrike(unit)
	if unit.spellCriticalStrikes == nil then
		unit.spellCriticalStrikes = {}
	end

	local crit_damage = 0

	for key, data in pairs(unit.spellCriticalStrikes) do
		if PRD(unit, data.spell_crit_chance, key) then
			crit_damage = math.max(crit_damage, data.spell_crit_damage)
		end
	end

	return crit_damage
end

-- 技能暴击额外百分比
function SetSpellCriticalStrikeDamage(unit, value, key)
	if unit.spellCriticalStrikeDamage == nil then
		unit.spellCriticalStrikeDamage = {}
	end

	key = key or DoUniqueString("SpellCriticalStrikeDamage")
	unit.spellCriticalStrikeDamage[key] = value

	return key
end
function GetSpellCriticalStrikeDamage(unit)
	if unit.spellCriticalStrikeDamage == nil then
		unit.spellCriticalStrikeDamage = {}
	end

	local value = 0
	for key, v in pairs(unit.spellCriticalStrikeDamage) do
		value = value + v
	end
	return value
end

-- 暴击额外百分比
function SetCriticalStrikeDamage(unit, value, key)
	if unit.criticalStrikeDamage == nil then
		unit.criticalStrikeDamage = {}
	end

	key = key or DoUniqueString("CriticalStrikeDamage")
	unit.criticalStrikeDamage[key] = value

	return key
end
function GetCriticalStrikeDamage(unit)
	if unit.criticalStrikeDamage == nil then
		unit.criticalStrikeDamage = {}
	end

	local value = 0
	for key, v in pairs(unit.criticalStrikeDamage) do
		value = value + v
	end
	return value
end

-- 无视魔抗
function SetIgnoreMagicResistanceValue(unit, value, key)
	if unit.ignoreMagicResistanceValues == nil then
		unit.ignoreMagicResistanceValues = {}
	end

	key = key or DoUniqueString("IgnoreMagicResistanceValue")
	unit.ignoreMagicResistanceValues[key] = value

	return key
end
function GetIgnoreMagicResistanceValue(unit)
	if unit.ignoreMagicResistanceValues == nil then
		unit.ignoreMagicResistanceValues = {}
	end

	local value = 0
	for key, v in pairs(unit.ignoreMagicResistanceValues) do
		value = 1 - (1 - value) * (1 - v)
	end
	return value
end
-- 某种类型伤害增加（DAMAGE_TYPE_NONE为所有类型伤害增加）
function SetOutgoingDamagePercent(unit, damage_type, percent, key)
	if unit.outgoingDamagePercents == nil then
		unit.outgoingDamagePercents = {}
	end
	if unit.outgoingDamagePercents[damage_type] == nil then
		unit.outgoingDamagePercents[damage_type] = {}
	end

	key = key or DoUniqueString("OutgoingDamagePercent")
	unit.outgoingDamagePercents[damage_type][key] = percent

	if IsServer() then
		local fNewValue = Round(GetOutgoingDamagePercent(unit, DAMAGE_TYPE_PHYSICAL) - 100, 0.00001)
		local hModifier = unit:FindModifierByName("modifier_physical_damage_percent")
		if IsValid(hModifier) then
			if Round(hModifier:GetDuration(), 0.00001) ~= fNewValue then
				hModifier:Destroy()
				hModifier = unit:AddNewModifier(unit, nil, "modifier_physical_damage_percent", { duration = fNewValue })
			end
		else
			hModifier = unit:AddNewModifier(unit, nil, "modifier_physical_damage_percent", { duration = fNewValue })
		end

		local fNewValue = Round(GetOutgoingDamagePercent(unit, DAMAGE_TYPE_MAGICAL) - 100, 0.00001)
		local hModifier = unit:FindModifierByName("modifier_magical_damage_percent")
		if IsValid(hModifier) then
			if Round(hModifier:GetDuration(), 0.00001) ~= fNewValue then
				hModifier:Destroy()
				hModifier = unit:AddNewModifier(unit, nil, "modifier_magical_damage_percent", { duration = fNewValue })
			end
		else
			hModifier = unit:AddNewModifier(unit, nil, "modifier_magical_damage_percent", { duration = fNewValue })
		end

		local fNewValue = Round(GetOutgoingDamagePercent(unit, DAMAGE_TYPE_PURE) - 100, 0.00001)
		local hModifier = unit:FindModifierByName("modifier_pure_damage_percent")
		if IsValid(hModifier) then
			if Round(hModifier:GetDuration(), 0.00001) ~= fNewValue then
				hModifier:Destroy()
				hModifier = unit:AddNewModifier(unit, nil, "modifier_pure_damage_percent", { duration = fNewValue })
			end
		else
			hModifier = unit:AddNewModifier(unit, nil, "modifier_pure_damage_percent", { duration = fNewValue })
		end
	end

	return key
end
function GetOutgoingDamagePercent(unit, damage_type)
	if unit.outgoingDamagePercents == nil then
		unit.outgoingDamagePercents = {}
	end
	if unit.outgoingDamagePercents[damage_type] == nil then
		unit.outgoingDamagePercents[damage_type] = {}
	end

	local value = 100
	for key, v in pairs(unit.outgoingDamagePercents[damage_type]) do
		value = value + v
	end
	return value
end

-- 增加受到的伤害
function SetIncomingDamage(hUnit, damage_type, value, key)
	if hUnit.incomingDamagePercents == nil then
		hUnit.incomingDamagePercents = {}
	end
	if hUnit.incomingDamagePercents[damage_type] == nil then
		hUnit.incomingDamagePercents[damage_type] = {}
	end

	key = key or DoUniqueString("IncomingDamagePercent")
	hUnit.incomingDamagePercents[damage_type][key] = value
	return key
end
function GetIncomingDamagePercent(hUnit, damage_type)
	if hUnit.incomingDamagePercents == nil then
		hUnit.incomingDamagePercents = {}
	end
	if hUnit.incomingDamagePercents[damage_type] == nil then
		hUnit.incomingDamagePercents[damage_type] = {}
	end

	local value = 100
	for key, v in pairs(hUnit.incomingDamagePercents[damage_type]) do
		value = value + v
	end
	return value
end

-- 状态抗性
function SetStatusResistance(hUnit, fValue, key)
	if hUnit.statusResistances == nil then
		hUnit.statusResistances = {}
	end

	key = key or DoUniqueString("StatusResistance")
	hUnit.statusResistances[key] = fValue

	if IsServer() then
		local fNewValue = Round(GetStatusResistance(hUnit), 0.00001)
		local iSign = fNewValue < 0 and 1 or 0
		local hModifier = hUnit:FindModifierByName("modifier_status_resistance")
		if IsValid(hModifier) then
			if Round(hModifier:GetDuration(), 0.00001) ~= math.abs(fNewValue) or hModifier:GetStackCount() ~= iSign then
				hModifier:Destroy()
				hModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_status_resistance", { duration = math.abs(fNewValue) })
				if IsValid(hModifier) then
					hModifier:SetStackCount(iSign)
				end
			end
		else
			hModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_status_resistance", { duration = math.abs(fNewValue) })
			if IsValid(hModifier) then
				hModifier:SetStackCount(iSign)
			end
		end
	end

	return key
end
function GetStatusResistance(hUnit)
	if hUnit.statusResistances == nil then
		hUnit.statusResistances = {}
	end

	local fValue = 0
	for key, v in pairs(hUnit.statusResistances) do
		fValue = 1 - (1 - fValue) * math.max(1 - v, 0)
	end

	return fValue
end

function AddModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			table.insert(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			table.insert(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		table.insert(tModifierEvents[iModifierEvent], hModifier)
	end
end

function RemoveModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		ArrayRemove(tModifierEvents[iModifierEvent], hModifier)
	end
end

function FireCustomModifiersEvents(iModifierFunction, params)
	if CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction] == nil then return end

	if tModifierEvents and tModifierEvents[iModifierFunction] then
		local tModifiers = tModifierEvents[iModifierFunction]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier[CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction]] then
				hModifier[CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end

if IsClient() then
	_G.DAMAGE_TYPE_ALL = 7
	_G.DAMAGE_TYPE_HP_REMOVAL = 8
	_G.DAMAGE_TYPE_MAGICAL = 2
	_G.DAMAGE_TYPE_NONE = 0
	_G.DAMAGE_TYPE_PHYSICAL = 1
	_G.DAMAGE_TYPE_PURE = 4

	function C_DOTABaseAbility:GetSpecialValueWithLevel(szName)
		return self:GetSpecialValueFor(szName) * self:GetLevel()
	end
	function C_DOTA_BaseNPC:GetCastRangeBonus()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.CastRangeBonus or 0
	end
	function C_DOTA_BaseNPC:GetCooldownReduction()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.CooldownReduction or 0
	end
	function C_DOTA_BaseNPC:GetStatusResistance()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.StatusResistance or 0
	end
	function C_DOTA_BaseNPC:GetStatusResistanceCaster()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.StatusResistanceCaster or 0
	end
	function C_DOTA_BaseNPC:GetStatusResistanceFactor(hCaster)
		local fValue = 1 - self:GetStatusResistance()
		if IsValid(hCaster) then
			fValue = fValue * (1 - hCaster:GetStatusResistanceCaster())
		end
		return fValue
	end
	function C_DOTA_BaseNPC:GetPrimaryAttribute()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return DOTA_ATTRIBUTE_INVALID
		end
		return tHero.PrimaryAttribute or DOTA_ATTRIBUTE_INVALID
	end
	function C_DOTA_BaseNPC:GetPrimaryStatValue()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		if tHero.PrimaryAttribute == nil or tHero.PrimaryAttribute == DOTA_ATTRIBUTE_INVALID then
			return 0
		end
		if tHero.PrimaryAttribute == DOTA_ATTRIBUTE_STRENGTH then
			return self:GetStrength()
		elseif tHero.PrimaryAttribute == DOTA_ATTRIBUTE_AGILITY then
			return self:GetAgility()
		elseif tHero.PrimaryAttribute == DOTA_ATTRIBUTE_INTELLECT then
			return self:GetIntellect()
		end
		return 0
	end
	function C_DOTA_BaseNPC:GetBaseStrength()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.BaseStrength or 0
	end
	function C_DOTA_BaseNPC:GetStrength()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.Strength or 0
	end
	function C_DOTA_BaseNPC:GetBaseAgility()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.BaseAgility or 0
	end
	function C_DOTA_BaseNPC:GetAgility()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.Agility or 0
	end
	function C_DOTA_BaseNPC:GetBaseIntellect()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.BaseIntellect or 0
	end
	function C_DOTA_BaseNPC:GetIntellect()
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero == nil then
			return 0
		end
		return tHero.Intellect
	end
	function C_DOTA_BaseNPC:GetAbilityByIndex(iIndex)
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero then
			local tAbilities = tHero.Abilities
			if tAbilities then
				local sIndex = tostring(iIndex)
				local iAbilityEntIndex = tAbilities[sIndex]
				if iAbilityEntIndex then
					return EntIndexToHScript(iAbilityEntIndex)
				end
			end
		end
	end
	function C_DOTA_BaseNPC:FindAbilityByName(sAbilityName)
		local tHero = CustomNetTables:GetTableValue("heroes", tostring(self:entindex()))
		if tHero then
			local tAbilities = tHero.Abilities
			if tAbilities then
				for k, iAbilityEntIndex in pairs(tAbilities) do
					local hAbility = EntIndexToHScript(iAbilityEntIndex)
					if hAbility and hAbility:GetName() == sAbilityName then
						return hAbility
					end
				end
			end
		end
	end
	function C_DOTA_BaseNPC:GetAbilityNameSpecialValueFor(sAbilityName, sKey)
		local hAbility = self:FindAbilityByName(sAbilityName)
		if IsValid(hAbility) then
			return GetAbilityNameLevelSpecialValueFor(sAbilityName, sKey, hAbility:GetLevel())
		end
		return 0
	end
	function C_DOTABaseAbility:GetLevelSpecialValueFor(sKey, iLevel)
		ScriptAssert(type(sKey) == "string", "sKey is not a string!")
		ScriptAssert(type(iLevel) == "number", "iLevel is not a number!")
		if iLevel == -1 then
			iLevel = self:GetLevel()
		end
		return GetAbilityNameLevelSpecialValueFor(self:GetName(), sKey, iLevel)
	end
	-- 获取天赋加成
	function C_DOTA_BaseNPC:GetTalentValue(sTalentName, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return hAbility:GetSpecialValueFor(sKey)
		end
		return 0
	end
	-- 获取对应等级的天赋加成
	function C_DOTA_BaseNPC:GetLevelTalentValue(sTalentName, iLevel, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return hAbility:GetLevelSpecialValueFor(sKey, iLevel)
		end
		return 0
	end
	-- 是否为有效天赋
	function C_DOTA_BaseNPC:IsValidTalent(sTalentName)
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return true
		end
		return false
	end
	function C_DOTA_BaseNPC:IsFriendly(hCaster)
		return self:GetTeamNumber() == hCaster:GetTeamNumber()
	end
end

if IsServer() then
	function CDOTA_Buff:GetAbilityDuration()
		if not IsValid(self:GetAbility()) then
			return 0
		end
		return self:GetAbility():GetDuration()
	end
	function CDOTA_Buff:GetAbilityDamage()
		if not IsValid(self:GetAbility()) then
			return 0
		end
		return self:GetAbility():GetAbilityDamage()
	end
	function CDOTA_Item:IncrementCharges()
		return self:SetCurrentCharges(self:GetCurrentCharges() + 1)
	end
	function CDOTABaseAbility:GetIntrinsicModifier()
		local tModifiers = self:GetCaster():FindAllModifiersByName(self:GetIntrinsicModifierName())
		for i, hModifier in ipairs(tModifiers) do
			if hModifier:GetAbility() == self then
				return hModifier
			end
		end
		return nil
	end
	function CDOTABaseAbility:GetSpecialValueWithLevel(szName)
		return self:GetSpecialValueFor(szName) * self:GetLevel()
	end
	function CDOTABaseAbility:ReduceCooldown(flTime)
		local flRemainingTime = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self:StartCooldown(flRemainingTime - flTime)
	end
	function CDOTABaseAbility:ReduceCooldownPercent(flPercent)
		local flRemainingTime = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self:StartCooldown(flRemainingTime * (1 - flPercent * 0.01))
	end
	-- 治疗
	function CDOTABaseAbility:Heal(hCaster, flAmount)
		hCaster:Heal(flAmount, self)
		SendOverheadEventMessage(hCaster:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hCaster, flAmount, hCaster:GetPlayerOwner())
	end
	-- 治疗单位并默认显示数字，满血不接受治疗
	if CDOTA_BaseNPC._Heal == nil then
		CDOTA_BaseNPC._Heal = CDOTA_BaseNPC.Heal
	end
	function CDOTA_BaseNPC:Heal(flAmount, hInflictor, bShowOverhead)
		local flHealthDeficit = self:GetHealthDeficit()
		flAmount = math.min(flHealthDeficit, flAmount)
		if flAmount > 0 then
			self:_Heal(flAmount, hInflictor)
			if bShowOverhead == nil then bShowOverhead = true end
			if bShowOverhead then
				SendOverheadEventMessage(self:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self, flAmount, self:GetPlayerOwner())
			end
		end
	end
	function CDOTA_BaseNPC:GetAbilityNameSpecialValueFor(sAbilityName, sKey)
		local hAbility = self:FindAbilityByName(sAbilityName)
		if IsValid(hAbility) then
			return hAbility:GetSpecialValueFor(sKey)
		end
		return 0
	end
	-- 获取天赋加成
	function CDOTA_BaseNPC:GetTalentValue(sTalentName, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return hAbility:GetSpecialValueFor(sKey)
		end
		return 0
	end
	-- 获取对应等级的天赋加成
	function CDOTA_BaseNPC:GetLevelTalentValue(sTalentName, iLevel, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return hAbility:GetLevelSpecialValueFor(sKey, iLevel)
		end
		return 0
	end
	-- 是否为有效天赋
	function CDOTA_BaseNPC:IsValidTalent(sTalentName)
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return true
		end
		return false
	end

	-- 修正的技能
	function CDOTA_BaseNPC:FixAbilities(source)
		-- if not self:IsIllusion() then return end
		-- 删除技能
		for index = self:GetAbilityCount() - 1, 0, -1 do
			local hAbility = self:GetAbilityByIndex(index)
			if hAbility then
				self:RemoveAbility(hAbility:GetAbilityName())
			end
		end

		self:SetAbilityPoints(0)

		for index = 0, self:GetAbilityCount() - 1, 1 do
			local hAbility = source:GetAbilityByIndex(index)

			if hAbility then
				local _ability = self:AddAbility(hAbility:GetAbilityName())
				local abilityLevel = hAbility:GetLevel()
				if _ability then
					self:RemoveModifierByName(_ability:GetIntrinsicModifierName() or "")
					for i = 1, abilityLevel, 1 do
						self:UpgradeAbility(_ability)
					end
					_ability:SetHidden(hAbility:IsHidden())
					_ability:SetStolen(hAbility:IsStolen())
				end
			end
		end
	end

	function CDOTA_BaseNPC:IsStrongIllusion()
		local tModifiers = self:FindAllModifiers()
		for _, hModifier in pairs(tModifiers) do
			if hModifier:HasFunction(MODIFIER_PROPERTY_STRONG_ILLUSION) then
				return true
			end
		end
		return false
	end
	-- 获取下次record
	function GetNextRecord()
		if RECORD_SYSTEM_DUMMY.iLastRecord == nil then RECORD_SYSTEM_DUMMY.iLastRecord = 0 end
		if RECORD_SYSTEM_DUMMY.iLastRecord and RECORD_SYSTEM_DUMMY.iLastRecord >= 255 then
			RECORD_SYSTEM_DUMMY.iLastRecord = RECORD_SYSTEM_DUMMY.iLastRecord - 256
		end
		return RECORD_SYSTEM_DUMMY.iLastRecord + 1
	end

	DAMAGE_STATE_SPELL_CRIT = 1 -- 技能暴击
	if ApplyDamage_Engine == nil then
		ApplyDamage_Engine = ApplyDamage
	end
	function ApplyDamage(tDamageTable, iState)
		if iState == nil then iState = 0 end
		local iNextRecord = GetNextRecord()

		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iNextRecord] = iState

		return ApplyDamage_Engine(tDamageTable), iNextRecord
	end
	function DamageFilter(iRecord, ...)
		local bool = false
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		for i, iState in pairs({ ... }) do
			bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] or 0, iState) == iState)
		end
		return bool
	end
	-- 在法术暴击效果里插入
	function _SpellCrit(iRecord)
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = 0 end

		if bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord], DAMAGE_STATE_SPELL_CRIT) ~= DAMAGE_STATE_SPELL_CRIT then
			RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] + DAMAGE_STATE_SPELL_CRIT
		end
	end

	ATTACK_STATE_NOT_USECASTATTACKORB = 1 -- 不触发攻击法球
	ATTACK_STATE_NOT_PROCESSPROCS = 2 -- 不触发攻击特效
	ATTACK_STATE_SKIPCOOLDOWN = 8 -- 无视攻击间隔
	ATTACK_STATE_IGNOREINVIS = 16 -- 不触发破影一击
	ATTACK_STATE_NOT_USEPROJECTILE = 32 -- 没有攻击弹道
	ATTACK_STATE_FAKEATTACK = 64 -- 假攻击
	ATTACK_STATE_NEVERMISS = 128 -- 攻击不会丢失
	ATTACK_STATE_NO_CLEAVE = 256 -- 没有分裂攻击
	ATTACK_STATE_NO_EXTENDATTACK = 512 -- 没有触发额外攻击
	ATTACK_STATE_SKIPCOUNTING = 1024 -- 不减少各种攻击计数
	ATTACK_STATE_CRIT = 2048 -- 暴击，暴击技能里添加，Attack里加入无效
	function CDOTA_BaseNPC:Attack(hTarget, iAttackState)
		if iAttackState == nil then iAttackState = 0 end
		local iNextRecord = GetNextRecord()
		local bUseCastAttackOrb = (bit.band(iAttackState, ATTACK_STATE_NOT_USECASTATTACKORB) ~= ATTACK_STATE_NOT_USECASTATTACKORB)
		local bProcessProcs = (bit.band(iAttackState, ATTACK_STATE_NOT_PROCESSPROCS) ~= ATTACK_STATE_NOT_PROCESSPROCS)
		local bSkipCooldown = (bit.band(iAttackState, ATTACK_STATE_SKIPCOOLDOWN) == ATTACK_STATE_SKIPCOOLDOWN)
		local bIgnoreInvis = (bit.band(iAttackState, ATTACK_STATE_IGNOREINVIS) == ATTACK_STATE_IGNOREINVIS)
		local bUseProjectile = (bit.band(iAttackState, ATTACK_STATE_NOT_USEPROJECTILE) ~= ATTACK_STATE_NOT_USEPROJECTILE)
		local bFakeAttack = (bit.band(iAttackState, ATTACK_STATE_FAKEATTACK) == ATTACK_STATE_FAKEATTACK)
		local bNeverMiss = (bit.band(iAttackState, ATTACK_STATE_NEVERMISS) == ATTACK_STATE_NEVERMISS)

		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iNextRecord] = iAttackState

		if not bFakeAttack and bProcessProcs and bUseCastAttackOrb then
			local params = {
				attacker = self,
				target = hTarget,
			}
			if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
			if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
			if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
		end

		self:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss)

		return iNextRecord
	end
	function AttackFilter(iRecord, ...)
		local bool = false
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		for i, iAttackState in pairs({ ... }) do
			bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] or 0, iAttackState) == iAttackState)
		end
		return bool
	end
	-- 在暴击效果里插入
	function _Crit(iRecord)
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] = 0 end

		if bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord], ATTACK_STATE_CRIT) ~= ATTACK_STATE_CRIT then
			RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] + ATTACK_STATE_CRIT
		end
	end

	function CDOTA_BaseNPC:GetStatusResistanceCaster()
		local fValue = 0

		local tModifiers = {
			modifier_item_timeless_relic = 0.25,
		}

		for sModifierName, _fValue in pairs(tModifiers) do
			local iCount = #(self:FindAllModifiersByName(sModifierName))
			fValue = 1 - ((1 - fValue) * math.pow(1 + _fValue, iCount))
		end

		return fValue
	end

	function CDOTA_BaseNPC:GetStatusResistanceFactor(hCaster)
		local fValue = 1 - self:GetStatusResistance()
		if IsValid(hCaster) then
			fValue = fValue * (1 - hCaster:GetStatusResistanceCaster())
		end
		return fValue
	end

	-- 清除单个状态(是否驱散增益, 是否驱散负面, 单帧, 是否驱散晕眩, 是否强驱散)
	function CDOTA_BaseNPC:PurgeSingle(bRemovePositiveBuffs, bRemoveDebuffs, bFrameOnly, bRemoveStuns, bRemoveExceptions)
		local tModifiers = self:FindAllModifiers()
		for i, hModifier in ipairs(tModifiers) do
			if hModifier:GetDuration() ~= -1 then
				if hModifier:GetAbility() ~= nil and hModifier:GetAbility():IsItem() == true then
					if hModifier:IsDebuff() then	-- 负面状态
						if bRemoveDebuffs then
							if hModifier:IsStunDebuff() then
								if bRemoveStuns and bRemoveExceptions then
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							elseif hModifier:IsHexDebuff() then
								if bRemoveExceptions then
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							else
								print(hModifier:GetName())
								hModifier:Destroy()
								break
							end
						end
					else	-- 增益状态
						if bRemovePositiveBuffs then
							if hModifier:IsStunDebuff() then
								if bRemoveStuns and bRemoveExceptions then
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							elseif hModifier:IsHexDebuff() then
								if bRemoveExceptions then
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							else
								print(hModifier:GetName())
								hModifier:Destroy()
								break
							end
						end
					end
				elseif hModifier.IsPurgable then
					-- body
					if hModifier:IsPurgable() == true then	-- 能否弱驱散
						if hModifier:IsDebuff() == true then	-- 负面状态
							if bRemoveDebuffs then
								print(hModifier:GetName())
								hModifier:Destroy()
								break
							end
						else	-- 增益状态
							if bRemovePositiveBuffs then
								print(hModifier:GetName())
								hModifier:Destroy()
								break
							end
						end
					elseif hModifier:IsPurgeException() == true and bRemoveExceptions then	-- 能否强驱散
						if hModifier:IsDebuff() == true then	-- 负面状态
							if bRemoveDebuffs then
								if hModifier:IsStunDebuff() == true then
									if bRemoveStuns then
										print(hModifier:GetName())
										hModifier:Destroy()
										break
									end
								else
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							end
						else	-- 增益状态
							if bRemovePositiveBuffs then
								if hModifier:IsStunDebuff() == true then
									if bRemoveStuns then
										print(hModifier:GetName())
										hModifier:Destroy()
										break
									end
								else
									print(hModifier:GetName())
									hModifier:Destroy()
									break
								end
							end
						end
					end
				end
			end
		end
	end
	-- 是否是友军
	function CDOTA_BaseNPC:IsFriendly(hCaster)
		return self:GetTeamNumber() == hCaster:GetTeamNumber()
	end

	-- 造成伤害
	function CDOTA_BaseNPC:DealDamage(tTargets, hAbility, flDamage, iDamageType, iDamageFlags)
		if tTargets.IsHero ~= nil then
			tTargets = { tTargets }
		end
		if hAbility ~= nil and iDamageType == nil then
			iDamageType = hAbility:GetAbilityDamageType()
		end
		if iDamageFlags == nil then
			iDamageFlags = DOTA_DAMAGE_FLAG_NONE
		end
		if flDamage == nil then
			flDamage = hAbility:GetSpecialValueFor("base_damage") + hAbility:GetSpecialValueFor("damage") * self:GetPrimaryStatValue()
		end
		for i, hUnit in ipairs(tTargets) do
			local tDamageInfo = {
				attacker = self,
				victim = hUnit,
				ability = hAbility,
				damage = flDamage,
				damage_type = iDamageType,
				damage_flags = iDamageFlags
			}
			ApplyDamage(tDamageInfo)
		end
	end

	---使目标向某个方向冲刺
	---@param vDirection 方向
	---@param flDistance 距离
	---@param flHeight 最大高度
	---@param flDuration 持续时间
	---@param callback 结束回调
	function CDOTA_BaseNPC:Dash(vDirection, flDistance, flHeight, flDuration, callback)
		local kv =		{
			vDirection = vDirection,
			duration = flDuration,
			knockback_duration = flDuration,
			knockback_distance = flDistance,
			knockback_height = flHeight,
		}
		self:RemoveModifierByName("modifier_dash")
		local hModifier = self:AddNewModifier(self, nil, "modifier_dash", kv)
		if IsValid(hModifier) then
			hModifier.callback = callback
		end
		FireModifierEvent({
			event_name = MODIFIER_EVENT_ON_DASH,
			unit = self
		})
	end

	-- 击退
	---@param vDirection 方向
	---@param flDistance 距离
	---@param flHeight 最大高度
	---@param flDuration 持续时间
	---@param bStun 是否晕眩
	---@param bBlock 是否被障碍物阻挡
	---@param callback 结束回调
	function CDOTA_BaseNPC:KnockBack(vDirection, flDistance, flHeight, flDuration, bStun, bBlock, callback)
		if bStun == nil then bStun = true end
		if bBlock == nil then bBlock = false end
		local kv =		{
			vDirection = vDirection,
			duration = flDuration,
			knockback_duration = flDuration,
			knockback_distance = flDistance,
			knockback_height = flHeight,
			bStun = bStun,
			bBlock = bBlock,
		}
		self:RemoveModifierByName("modifier_knockback_custom")
		local hModifier = self:AddNewModifier(self, nil, "modifier_knockback_custom", kv)
		if IsValid(hModifier) then
			hModifier.callback = callback
		end
		FireModifierEvent({
			event_name = MODIFIER_EVENT_ON_DASH,
			unit = self
		})
	end

	function PfromC(c)
		if c == 0 then return 1 end
		local pProcOnN = 0
		local pProcByN = 0
		local sumNpProcOnN = 0
		local maxFails = math.ceil(1 / c)
		for N = 1, maxFails, 1 do
			pProcOnN = math.min(1, N * c) * (1 - pProcByN)
			pProcByN = pProcByN + pProcOnN
			sumNpProcOnN = sumNpProcOnN + N * pProcOnN
		end
		return 1 / sumNpProcOnN
	end
	function CfromP(p)
		local Cupper = p
		local Clower = 0
		local Cmid
		local p1
		local p2 = 1
		while true do
			Cmid = (Cupper + Clower) / 2
			p1 = PfromC(Cmid)
			if math.abs(p1 - p2) <= 0 then break end
			if p1 > p then
				Cupper = Cmid
			else
				Clower = Cmid
			end
			p2 = p1
		end
		return Cmid
	end

	PSEUDO_RANDOM_C = {}
	for i = 0, 100 do
		local C = CfromP(i * 0.01)
		PSEUDO_RANDOM_C[i] = C
	end
	function PRD_C(chance)
		chance = math.max(math.min(chance, 100), 0)
		return PSEUDO_RANDOM_C[math.floor(chance)]
	end
	function PRD(table, chance, pseudo_random_recording)
		if table.PSEUDO_RANDOM_RECORDING_LIST == nil then table.PSEUDO_RANDOM_RECORDING_LIST = {} end

		local N = table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] or 1
		local C = PRD_C(chance)
		if RandomFloat(0, 1) <= C * N then
			table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = 1
			return true
		end
		table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = N + 1
		return false
	end

	function CDOTA_BaseNPC:ReplaceItem(old_item, new_item)
		if type(old_item) ~= "table" then return end
		if type(new_item) == "string" then
			new_item = CreateItem(new_item, old_item:GetPurchaser(), old_item:GetPurchaser())
		end
		if type(new_item) ~= "table" then return end
		new_item:SetPurchaseTime(old_item:GetPurchaseTime())
		new_item:SetCurrentCharges(old_item:GetCurrentCharges())
		new_item:SetItemState(old_item:GetItemState())
		local index1 = 0
		for index = 0, 11 do
			local item = self:GetItemInSlot(index)
			if item and item == old_item then
				index1 = index
				break
			end
		end
		self:RemoveItem(old_item)
		self:AddItem(new_item)
		for index2 = 0, 11 do
			local item = self:GetItemInSlot(index2)
			if item and item == new_item then
				self:SwapItems(index2, index1)
				break
			end
		end
		return new_item
	end

	--[[		获取弹射目标
		现在目标，队伍，选择位置，范围，队伍过滤，类型过滤，特殊过滤，选择方式，单位记录表，是否可以弹射回来（缺省false）
	]]
	--
	function GetBounceTarget(last_target, team_number, position, radius, team_filter, type_filter, flag_filter, order, unit_table, can_bounce_bounced_unit)
		local first_targets = FindUnitsInRadius(team_number, position, nil, radius, team_filter, type_filter, flag_filter, order, false)

		for i = #first_targets, 1, -1 do
			local unit = first_targets[i]
			if unit == last_target then
				table.remove(first_targets, i)
			end
		end

		local second_targets = {}
		for k, v in pairs(first_targets) do
			second_targets[k] = v
		end

		if unit_table and type(unit_table) == "table" then
			for i = #first_targets, 1, -1 do
				if TableFindKey(unit_table, first_targets[i]) then
					table.remove(first_targets, i)
				end
			end
		end

		local first_target = first_targets[1]
		local second_target = second_targets[1]

		if can_bounce_bounced_unit ~= nil and type(can_bounce_bounced_unit) == "boolean" and can_bounce_bounced_unit == true then
			return first_target or second_target
		else
			return first_target
		end
	end

	--[[		进行分裂操作
		攻击者，攻击目标，开始宽度，结束宽度，距离，操作函数
	]]
	--
	function DoCleaveAction(hAttacker, hTarget, fStartWidth, fEndWidth, fDistance, func, iTeamFilter, iTypeFilter, iFlagFilter)
		local fRadius = math.sqrt(fDistance ^ 2 + (fEndWidth / 2) ^ 2)
		local vStart = hAttacker:GetAbsOrigin()
		local vDirection = hTarget:GetAbsOrigin() - vStart
		vDirection.z = 0
		vDirection = vDirection:Normalized()

		local vEnd = vStart + vDirection * fDistance
		local v = Rotation2D(vDirection, math.rad(90))
		local tPolygon = {
			vStart + v * fStartWidth,
			vEnd + v * fEndWidth,
			vEnd - v * fEndWidth,
			vStart - v * fStartWidth,
		}
		DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())

		local iTeamNumber = hAttacker:GetTeamNumber()
		iTeamFilter = iTeamFilter or (DOTA_UNIT_TARGET_TEAM_ENEMY)
		iTypeFilter = iTypeFilter or (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
		iFlagFilter = iFlagFilter or (DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
		local tTargets = FindUnitsInRadius(iTeamNumber, vStart, nil, fRadius + 100, iTeamFilter, iTypeFilter, iFlagFilter, FIND_CLOSEST, false)
		for _, hUnit in pairs(tTargets) do
			if hUnit ~= hTarget then
				if IsPointInPolygon(hUnit:GetAbsOrigin(), tPolygon) then
					if func(hUnit) == true then
						break
					end
				end
			end
		end
	end

	ONLY_REFLECT_ABILITIES = { "tusk_snowball_imba" }
	function IsAbilityOnlyReflect(hAbility)
		if hAbility == nil then return false end
		return TableFindKey(ONLY_REFLECT_ABILITIES, hAbility:GetName()) ~= nil
	end

	function IsReflectSpellAbility(hAbility)
		if hAbility == nil then return false end
		return hAbility:IsStolen() and hAbility:IsHidden() and hAbility.bIsReflectSpellAbility
	end

	MAX_REFLECT_ABILITIES_COUNT = 5
	function ReflectSpell(hCaster, hTarget, hAbility)
		if IsReflectSpellAbility(hAbility) then
			return
		end

		local sAbilityName = hAbility:GetAbilityName()
		local hReflectAbility
		if hCaster.reflectSpellAbilities == nil then hCaster.reflectSpellAbilities = {} end
		for i = #hCaster.reflectSpellAbilities, 1, -1 do
			local ab = hCaster.reflectSpellAbilities[i]
			if IsValid(ab) then
				if ab:GetAbilityName() == sAbilityName then
					hReflectAbility = ab
				end
			else
				table.remove(hCaster.reflectSpellAbilities, i)
			end
		end
		if hReflectAbility == nil then
			hReflectAbility = hCaster:AddAbility(sAbilityName)
			table.insert(hCaster.reflectSpellAbilities, 1, hReflectAbility)
			if IsValid(hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT + 1]) then
				hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT + 1]:RemoveSelf()
				table.remove(hCaster.reflectSpellAbilities, MAX_REFLECT_ABILITIES_COUNT + 1)
			end
		end

		hReflectAbility:SetStolen(true)
		hReflectAbility:SetHidden(true)
		hReflectAbility.bIsReflectSpellAbility = true
		hReflectAbility.ProcsMagicStick = function(self) return false end

		hReflectAbility:SetLevel(hAbility:GetLevel())
		hCaster:RemoveModifierByName(hReflectAbility:GetIntrinsicModifierName() or "")
		hReflectAbility.GetIntrinsicModifierName = function(self) return "" end

		local hRecordTarget = hCaster:GetCursorCastTarget()
		hCaster:SetCursorCastTarget(hTarget)
		hReflectAbility:OnSpellStart()
		hCaster:SetCursorCastTarget(hRecordTarget)
	end

	--[[		创建幻象，tModifierKeys支持[outgoing_damage,incoming_damage,bounty_base,bounty_growth,outgoing_damage_structure,outgoing_damage_roshan]
	]]
	--
	function CDOTA_BaseNPC_Hero:CreateIllusions(hOwner, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
		local illusions = CreateIllusions(hOwner, self, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

		for i, illusion in ipairs(illusions) do
			illusion:FixAbilities(self)
		end

		return illusions
	end

	--[[		在范围内搜素拥有Modifier的单位的单位组
	]]
	--
	function FindUnitsInRadiusByModifierName(sModifierName, iTeamNumber, vPosition, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder)
		local tUnits = FindUnitsInRadius(iTeamNumber, vPosition, nil, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		for i = #tUnits, 1, -1 do
			local hUnit = tUnits[i]
			if not hUnit:HasModifier(sModifierName) then
				table.remove(tUnits, i)
			end
		end
		return tUnits
	end

	-- 用技能kv寻找直线单位
	function FindUnitsInLineWithAbility(hCaster, vStart, vEnd, flWidth, hAbility)
		return FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, flWidth, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	end
	-- 用技能kv寻找单位
	function FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, hAbility, iOrder)
		if iOrder == nil then
			iOrder = FIND_ANY_ORDER
		end
		return FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, flRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), iOrder, false)
	end

	-- 发布指令
	--[[		DOTA_UNIT_ORDER_NONE
		DOTA_UNIT_ORDER_MOVE_TO_POSITION
		DOTA_UNIT_ORDER_MOVE_TO_TARGET
		DOTA_UNIT_ORDER_ATTACK_MOVE
		DOTA_UNIT_ORDER_ATTACK_TARGET
		DOTA_UNIT_ORDER_CAST_POSITION
		DOTA_UNIT_ORDER_CAST_TARGET
		DOTA_UNIT_ORDER_CAST_TARGET_TREE
		DOTA_UNIT_ORDER_CAST_NO_TARGET
		DOTA_UNIT_ORDER_CAST_TOGGLE
		DOTA_UNIT_ORDER_HOLD_POSITION
		DOTA_UNIT_ORDER_TRAIN_ABILITY
		DOTA_UNIT_ORDER_DROP_ITEM
		DOTA_UNIT_ORDER_GIVE_ITEM
		DOTA_UNIT_ORDER_PICKUP_ITEM
		DOTA_UNIT_ORDER_PICKUP_RUNE
		DOTA_UNIT_ORDER_PURCHASE_ITEM
		DOTA_UNIT_ORDER_SELL_ITEM
		DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
		DOTA_UNIT_ORDER_MOVE_ITEM
		DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
		DOTA_UNIT_ORDER_STOP
		DOTA_UNIT_ORDER_TAUNT
		DOTA_UNIT_ORDER_BUYBACK
		DOTA_UNIT_ORDER_GLYPH
		DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
		DOTA_UNIT_ORDER_CAST_RUNE
	]]
	function ExecuteOrder(hUnit, iOrder, hTarget, hAbility, vPosition)
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = iOrder,
			TargetIndex = IsValid(hTarget) and hTarget:entindex() or nil,
			AbilityIndex = IsValid(hAbility) and hAbility:entindex() or nil,
			Position = vPosition,
			Queue = 0
		})
	end
end