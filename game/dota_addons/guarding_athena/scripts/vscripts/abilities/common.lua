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
--spell power
function GetSpellPower(unit)
return Load(unit, "spell_power") or 0
end
function ModifySpellPower(unit, amount)
if type(amount) ~= "number" then return end
local value = GetSpellPower(unit)
value = math.max(0, value+amount)
Save(unit, "spell_power", value)
if IsServer() then
	local modifier = unit:FindModifierByName("modifier_spell_power")
	if modifier then
		modifier:SetStackCount(value)
	end
end
return value
end

-- 已弃用
function GetTalent(unit, talentName)
if unit == nil then return 0 end
return (CustomNetTables:GetTableValue("common", "talent_"..unit:entindex()) or {})[talentName] or 0
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


-- 获取技能的特殊键值
function GetAbilityNameLevelSpecialValueFor(sAbilityName, sKey, iLevel)
local tAbilityKeyValues = KeyValues.AbilitiesKv[sAbilityName]
if tAbilityKeyValues ~= nil then
	if tAbilityKeyValues.AbilitySpecial ~= nil then
		for sIndex, tData in pairs(tAbilityKeyValues.AbilitySpecial) do
			if tData[sKey] ~= nil then
				local aValues = vlua.split(tostring(tData[sKey]), " ")
				if aValues and #aValues > 0 and aValues[math.min(iLevel+1, #aValues)] then
					return tonumber(aValues[math.min(iLevel+1, #aValues)])
				end
			end
		end
	end
end
return 0
end

if IsClient() then
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
	local fValue = 1-self:GetStatusResistance()
	if IsValid(hCaster) then
		fValue = fValue * (1-hCaster:GetStatusResistanceCaster())
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
	for index = self:GetAbilityCount()-1, 0, -1 do
		local hAbility = self:GetAbilityByIndex(index)
		if hAbility then
			self:RemoveAbility(hAbility:GetAbilityName())
		end
	end

	self:SetAbilityPoints(0)

	for index = 0, self:GetAbilityCount()-1, 1 do
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
function CDOTA_BaseNPC:Attack(hTarget, iAttackState,ExtarData)
	local modifier = ATTACK_SYSTEM_DUMMY:AddNewModifier(ATTACK_SYSTEM_DUMMY, nil, "modifier_attack_system", {iAttacker=self:entindex(), iAttackState=iAttackState})

	local bUseCastAttackOrb = (bit.band(iAttackState, ATTACK_STATE_NOT_USECASTATTACKORB) ~= ATTACK_STATE_NOT_USECASTATTACKORB)
	local bProcessProcs = (bit.band(iAttackState, ATTACK_STATE_NOT_PROCESSPROCS) ~= ATTACK_STATE_NOT_PROCESSPROCS)
	local bSkipCooldown = (bit.band(iAttackState, ATTACK_STATE_SKIPCOOLDOWN) == ATTACK_STATE_SKIPCOOLDOWN)
	local bIgnoreInvis = (bit.band(iAttackState, ATTACK_STATE_IGNOREINVIS) == ATTACK_STATE_IGNOREINVIS)
	local bUseProjectile = (bit.band(iAttackState, ATTACK_STATE_NOT_USEPROJECTILE) ~= ATTACK_STATE_NOT_USEPROJECTILE)
	local bFakeAttack = (bit.band(iAttackState, ATTACK_STATE_FAKEATTACK) == ATTACK_STATE_FAKEATTACK)
	local bNeverMiss = (bit.band(iAttackState, ATTACK_STATE_NEVERMISS) == ATTACK_STATE_NEVERMISS)

	if not bFakeAttack and bProcessProcs and bUseCastAttackOrb then
		local params = {
			attacker = self,
			target = hTarget,
		}
		if self.tSourceModifierEvents and self.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
			local tModifiers = self.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
					hModifier:OnAttackStart_AttackSystem(params,ExtarData)
				end
			end
		end
		if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
			local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
					hModifier:OnAttackStart_AttackSystem(params,ExtarData)
				end
			end
		end
	end

	self:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss)
	return modifier.record
end
function CDOTA_BaseNPC:AttackFilter(iRecord, ...)
	local bool = false
	if self.ATTACK_SYSTEM == nil then self.ATTACK_SYSTEM = {} end
	for i, iAttackState in pairs({...}) do
		bool = bool or (bit.band(self.ATTACK_SYSTEM[iRecord] or 0, iAttackState) == iAttackState)
	end
	return bool
end
-- 在暴击效果里插入
function CDOTA_BaseNPC:Crit(iRecord)
	if self.ATTACK_SYSTEM == nil then self.ATTACK_SYSTEM = {} end
	if self.ATTACK_SYSTEM[iRecord] ~= nil then
		if bit.band(self.ATTACK_SYSTEM[iRecord], ATTACK_STATE_CRIT) ~= ATTACK_STATE_CRIT then
			self.ATTACK_SYSTEM[iRecord] = self.ATTACK_SYSTEM[iRecord] + ATTACK_STATE_CRIT
		end
	else
		local modifier = ATTACK_SYSTEM_DUMMY:AddNewModifier(self, nil, "modifier_attack_system", {iAttacker=self:entindex(), iAttackState=ATTACK_STATE_CRIT, iRecord=iRecord})
		self.ATTACK_SYSTEM[iRecord] = ATTACK_STATE_CRIT
	end
end

function CDOTA_BaseNPC:GetStatusResistanceCaster()
	local fValue = 0

	local tModifiers = {
		modifier_item_timeless_relic = 0.25,
	}

	for sModifierName, _fValue in pairs(tModifiers) do
		local iCount = #(self:FindAllModifiersByName(sModifierName))
		fValue = 1- ((1-fValue) * math.pow(1+_fValue, iCount))
	end

	return fValue
end

function CDOTA_BaseNPC:GetStatusResistanceFactor(hCaster)
	local fValue = 1-self:GetStatusResistance()
	if IsValid(hCaster) then
		fValue = fValue * (1-hCaster:GetStatusResistanceCaster())
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
function CDOTA_BaseNPC:IsFriendly(hCaster)
	return self:GetTeamNumber() == hCaster:GetTeamNumber()
end

function PfromC(c)
	if c == 0 then return 1 end
	local pProcOnN = 0
	local pProcByN = 0
	local sumNpProcOnN = 0
	local maxFails = math.ceil(1/c)
	for N = 1, maxFails, 1 do
		pProcOnN = math.min(1, N*c)*(1-pProcByN)
		pProcByN = pProcByN + pProcOnN
		sumNpProcOnN = sumNpProcOnN + N * pProcOnN
	end
	return 1/sumNpProcOnN
end
function CfromP(p)
	local Cupper = p
	local Clower = 0
	local Cmid
	local p1
	local p2 = 1
	while true do
		Cmid = (Cupper+Clower)/2
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
	local C = CfromP(i*0.01)
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
	if RandomFloat(0, 1) <= C*N then
		table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = 1
		return true
	end
	table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = N + 1
	return false
end

function CDOTA_BaseNPC:ReplaceItem(old_item,new_item)
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

	--[[
	获取某单位范围内单位最多的单位
	搜索点，搜索范围，队伍，范围，队伍过滤，类型过滤，特殊过滤
]]--
function GetAOEMostTargetsSpellTarget(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order)
	local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius+radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
	local hTarget
	-- local N = 0
	local iMax = 0
	for i = 1, #targets, 1 do
		local first_target = targets[i]
		local n = 0
		if first_target:IsPositionInRange(search_position, search_radius) then
			if hTarget == nil then hTarget = first_target end
			for j = 1, #targets, 1 do
				-- N = N + 1
				local second_target = targets[j]
				if second_target:IsPositionInRange(first_target:GetAbsOrigin(), radius+second_target:GetHullRadius()) then
					n = n + 1
				end
			end
		end
		if n > iMax then
			hTarget = first_target
			iMax = n
		end
	end
	-- print("O(n):"..N)
	return hTarget
end
--[[
	获取一定范围内单位最多的点
	搜索点，搜索范围，队伍，范围，队伍过滤，类型过滤，特殊过滤
]]--
function GetAOEMostTargetsPosition(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order)
	local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius+radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
	local position = vec3_invalid
	-- local N = 0
	if #targets == 1 then
		local vDirection = targets[1]:GetAbsOrigin() - search_position
		vDirection.z = 0
		position = GetGroundPosition(search_position + vDirection:Normalized()*math.min(search_radius-1, vDirection:Length2D()), nil)
	elseif #targets > 1 then
		local tPoints = {}
		local funcInsertCheckPoint = function(vPoint)
			-- DebugDrawCircle(GetGroundPosition(vPoint, nil), Vector(0, 0, 255), 32, 32, true, 0.5)
			table.insert(tPoints, vPoint)
		end
		-- 取圆中点或交点
		for i = 1, #targets, 1 do
			local first_target = targets[i]
			-- DebugDrawCircle(first_target:GetAbsOrigin(), Vector(0, 255, 0), 32, radius, false, 0.5)
			for j = i+1, #targets, 1 do
				-- N = N + 1
				local second_target = targets[j]
				local vDirection = second_target:GetAbsOrigin() - first_target:GetAbsOrigin()
				vDirection.z = 0
				local fDistance = vDirection:Length2D()
				if fDistance <= radius*2 and fDistance > 0 then
					local vMid = (second_target:GetAbsOrigin()+first_target:GetAbsOrigin())/2
					if (vMid-search_position):Length2D() <= search_radius then
						table.insert(tPoints, vMid)
					else
						local fHalfLength = math.sqrt(radius^2 - (fDistance/2)^2)
						local v = Rotation2D(vDirection:Normalized(), math.rad(90))
						local p = {
							vMid-v*fHalfLength,
							vMid+v*fHalfLength,
						}
						for k, vPoint in pairs(p) do
							if (vPoint-search_position):Length2D() <= search_radius then
								table.insert(tPoints, vPoint)
							end
						end
					end
				end
			end
		end
		-- print("O(n):"..N)
		local iMax = 0
		for i = 1, #tPoints, 1 do
			local vPoint = tPoints[i]
			local n = 0
			for j = 1, #targets, 1 do
				-- N = N + 1
				local hTarget = targets[j]
				if hTarget:IsPositionInRange(vPoint, radius+hTarget:GetHullRadius()) then
					n = n + 1
				end
			end
			if n > iMax then
				position = vPoint
				iMax = n
			end
		end
		-- 如果
		if position == vec3_invalid then
			local vDirection = targets[1]:GetAbsOrigin() - search_position
			vDirection.z = 0
			position = GetGroundPosition(search_position + vDirection:Normalized()*math.min(search_radius-1, vDirection:Length2D()), nil)
		end
	end
	-- print("O(n):"..N)
	-- 获取地面坐标
	if position ~= vec3_invalid then
		position = GetGroundPosition(position, nil)
	end
	-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
	return position
end
--[[
	获取一条线上单位最多的施法点
	搜索点，搜索范围，队伍，开始宽度，结束宽度，队伍过滤，类型过滤，特殊过滤
]]--
function GetLinearMostTargetsPosition(search_position, search_radius, team_number, start_width, end_width, team_filter, type_filter, flag_filter, order)
	local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius+end_width, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
	local position = vec3_invalid
	-- local N = 0
	if #targets == 1 then
		local vDirection = targets[1]:GetAbsOrigin() - search_position
		vDirection.z = 0
		position = GetGroundPosition(search_position + vDirection:Normalized()*math.min(search_radius-1, vDirection:Length2D()), nil)
	elseif #targets > 1 then
		local tPolygons = {}
		local funcInsertCheckPolygon = function(tPolygon)
			-- for i = 1, #tPolygon, 1 do
			-- 	local vP1 = tPolygon[i]
			-- 	local vP2 = tPolygon[i+1]
			-- 	if vP2 == nil then
			-- 		vP2 = tPolygon[1]
			-- 	end
			-- 	DebugDrawLine(vP1, vP2, 255, 0, 0, false, 0.5)
			-- end
			-- DebugDrawCircle(tPolygon[3], Vector(255, 0, 0), 32, end_width, false, 0.5)
			table.insert(tPolygons, tPolygon)
		end
		for i = 1, #targets, 1 do
			local first_target = targets[i]
			for j = i+1, #targets, 1 do
				-- N = N + 1
				local second_target = targets[j]

				local vDirection1 = first_target:GetAbsOrigin() - search_position
				vDirection1.z = 0
				local vDirection2 = second_target:GetAbsOrigin() - search_position
				vDirection2.z = 0
				local vDirection = (vDirection1 + vDirection2)/2
				vDirection.z = 0
				local v = Rotation2D(vDirection:Normalized(), math.rad(90))
				local vEndPosition = search_position + vDirection:Normalized()*(search_radius-1)
				local tPolygon = {
					search_position+v*start_width,
					vEndPosition+v*end_width,
					vEndPosition,
					vEndPosition-v*end_width,
					search_position-v*start_width,
				}
				if (IsPointInPolygon(first_target:GetAbsOrigin(), tPolygon) or first_target:IsPositionInRange(tPolygon[3], end_width+first_target:GetHullRadius()))
				and (IsPointInPolygon(second_target:GetAbsOrigin(), tPolygon) or second_target:IsPositionInRange(tPolygon[3], end_width+second_target:GetHullRadius())) then
					funcInsertCheckPolygon(tPolygon)
				end
			end
			local vDirection = first_target:GetAbsOrigin() - search_position
			vDirection.z = 0
			local v = Rotation2D(vDirection:Normalized(), math.rad(90))
			local vEndPosition = search_position + vDirection:Normalized()*(search_radius-1)
			local tPolygon = {
				search_position+v*start_width,
				vEndPosition+v*end_width,
				vEndPosition,
				vEndPosition-v*end_width,
				search_position-v*start_width,
			}
			funcInsertCheckPolygon(tPolygon)
		end
		-- print("O(n):"..N)
		local iMax = 0
		for i = 1, #tPolygons, 1 do
			local tPolygon = tPolygons[i]
			local n = 0
			for j = 1, #targets, 1 do
				-- N = N + 1
				local hTarget = targets[j]
				if IsPointInPolygon(hTarget:GetAbsOrigin(), tPolygon) or hTarget:IsPositionInRange(tPolygon[3], end_width+hTarget:GetHullRadius()) then
					n = n + 1
				end
			end
			if n > iMax then
				position = tPolygon[3]
				iMax = n
			end
		end
	end
	-- print("O(n):"..N)
	if position ~= vec3_invalid then
		position = GetGroundPosition(position, nil)
	end
	-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
	return position
end

--[[
	获取弹射目标
	现在目标，队伍，选择位置，范围，队伍过滤，类型过滤，特殊过滤，选择方式，单位记录表，是否可以弹射回来（缺省false）
]]--
function GetBounceTarget(last_target, team_number, position, radius, team_filter, type_filter, flag_filter, order, unit_table, can_bounce_bounced_unit)
	local first_targets = FindUnitsInRadius(team_number, position, nil, radius, team_filter, type_filter, flag_filter, order, false)

	for i = #first_targets, 1, -1 do
		local unit = first_targets[i]
		if unit == last_target then
			table.remove(first_targets,i)
		end
	end

	local second_targets = {}
	for k,v in pairs(first_targets) do
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

--[[
	进行分裂操作
	攻击者，攻击目标，开始宽度，结束宽度，距离，操作函数
]]--
function DoCleaveAction(hAttacker, hTarget, fStartWidth, fEndWidth, fDistance, func, iTeamFilter, iTypeFilter, iFlagFilter)
	local fRadius = math.sqrt(fDistance^2+(fEndWidth/2)^2)
	local vStart = hAttacker:GetAbsOrigin()
	local vDirection = hTarget:GetAbsOrigin() - vStart
	vDirection.z = 0
	vDirection = vDirection:Normalized()

	local vEnd = vStart + vDirection*fDistance
	local v = Rotation2D(vDirection, math.rad(90))
	local tPolygon = {
		vStart + v*fStartWidth,
		vEnd + v*fEndWidth,
		vEnd - v*fEndWidth,
		vStart - v*fStartWidth,
	}
	DebugDrawLine(tPolygon[1], tPolygon[2], 255,255,255, true, hAttacker:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[2], tPolygon[3], 255,255,255, true, hAttacker:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[3], tPolygon[4], 255,255,255, true, hAttacker:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[4], tPolygon[1], 255,255,255, true, hAttacker:GetSecondsPerAttack())

	local iTeamNumber = hAttacker:GetTeamNumber()
	iTeamFilter = iTeamFilter or (DOTA_UNIT_TARGET_TEAM_ENEMY)
	iTypeFilter = iTypeFilter or (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
	iFlagFilter = iFlagFilter or (DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
	local tTargets = FindUnitsInRadius(iTeamNumber, vStart, nil, fRadius+100, iTeamFilter, iTypeFilter, iFlagFilter, FIND_CLOSEST, false)
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

ONLY_REFLECT_ABILITIES = {"tusk_snowball_imba"}
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
		if IsValid(hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT+1]) then
			hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT+1]:RemoveSelf()
			table.remove(hCaster.reflectSpellAbilities, MAX_REFLECT_ABILITIES_COUNT+1)
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

--[[
	创建幻象，tModifierKeys支持[outgoing_damage,incoming_damage,bounty_base,bounty_growth,outgoing_damage_structure,outgoing_damage_roshan]
]]--
function CDOTA_BaseNPC_Hero:CreateIllusions(hOwner, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
	local illusions = CreateIllusions(hOwner, self, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

	for i, illusion in ipairs(illusions) do
		illusion:FixAbilities(self)
	end

	return illusions
end

--阻挡生成野怪
function CDOTA_BaseNPC:ResistSpawneNeutral(bVal)
	self.bResistSpawneNeutral = bVal
end
--是否阻挡生成野怪
function CDOTA_BaseNPC:IsResistSpawneNeutral()
	return nil == self.bResistSpawneNeutral or self.bResistSpawneNeutral
end
end
