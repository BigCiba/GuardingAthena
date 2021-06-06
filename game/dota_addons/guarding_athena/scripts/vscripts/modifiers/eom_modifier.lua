--[[	Example: 
	modifier_item_dagon_custom = eom_modifier({
		Name = "modifier_item_dagon_custom",	-- 在技能文件中的modifier可以填Name以省去LinkLuaModifier
		-- 在MODIFIER_BOOLEAN_LIST定义过的值才可以直接这样写
		IsHidden = false,
		IsDebuff = false,
		IsPurgable = false,
		IsPurgeException = false,
		IsStunDebuff = false,
		AllowIllusionDuplicate = true,
		RemoveOnDeath = false,

		LuaModifierType = LUA_MODIFIER_MOTION_NONE,		-- 一般是motion才需要填
		Super = true,	-- 当填写base时会继承base的OnCreated, OnRefresh, OnDestroy, DeclareFunctions, EDeclareFunctions函数
	}, nil, item_base)
]]
DOTA_MODIFIER_FUNCTIONS = nil
xpcall(function()
	DOTA_MODIFIER_FUNCTIONS = require("utils/modifierfunction")
end, function()
	DOTA_MODIFIER_FUNCTIONS = {}
end)

MODIFIER_BOOLEAN_LIST = {
	"IsHidden",
	"IsDebuff",
	"IsPermanent",
	"IsPurgable",
	"IsPurgeException",
	"IsStunDebuff",
	"RemoveOnDeath",
	"ShouldUseOverheadOffset",
	"DestroyOnExpire",
	"CanParentBeAutoAttacked",
	"AllowIllusionDuplicate",
}

---@class eom_modifier
eom_modifier = {}

local mt = {}
mt.__call = function(class_tbl, def, static, base)
	local c = class(def, static, base)

	c.constructor = function(self)
		self._base_ = base
		local _OnCreated = self.OnCreated
		if type(_OnCreated) == "function" then
			self.OnCreated = function(...)
				if self.GetAbilitySpecialValue then
					self:GetAbilitySpecialValue()
				end
				if self.Super and self._base_ and type(self._base_.OnCreated) == "function" then
					self._base_.OnCreated(...)
				end
				local result = _OnCreated(...)
				if type(eom_modifier.OnCreated) == "function" then
					eom_modifier.OnCreated(...)
				end
				return result
			end
			self._OnCreated_ = true
		else
			self.OnCreated = eom_modifier.OnCreated
		end

		local _OnRefresh = self.OnRefresh
		if type(_OnRefresh) == "function" then
			self.OnRefresh = function(...)
				if self.GetAbilitySpecialValue then
					self:GetAbilitySpecialValue()
				end
				if self.Super and self._base_ and type(self._base_.OnRefresh) == "function" then
					self._base_.OnRefresh(...)
				end
				local result = _OnRefresh(...)
				if type(eom_modifier.OnRefresh) == "function" then
					eom_modifier.OnRefresh(...)
				end
				return result
			end
			self._OnRefresh_ = true
		else
			self.OnRefresh = eom_modifier.OnRefresh
		end

		local _OnDestroy = self.OnDestroy
		if type(_OnDestroy) == "function" then
			self.OnDestroy = function(...)
				if self.Super and self._base_ and type(self._base_.OnDestroy) == "function" then
					self._base_.OnDestroy(...)
				end
				local result = _OnDestroy(...)
				if type(eom_modifier.OnDestroy) == "function" then
					eom_modifier.OnDestroy(...)
				end
				return result
			end
			self._OnDestroy_ = true
		else
			self.OnDestroy = eom_modifier.OnDestroy
		end

		for _, key in ipairs(MODIFIER_BOOLEAN_LIST) do
			if type(self[key]) == "boolean" then
				local value = self[key]
				self[key] = function(self)
					return value
				end
			end
		end

		self._DeclareFunctions = self.DeclareFunctions
		if type(self._DeclareFunctions) == "function" then
			local t = self:_DeclareFunctions()
			if type(t) == "table" then
				local tDeclareFunctions = {}
				for i, v in ipairs(t) do
					table.insert(tDeclareFunctions, v)
				end
				if self.Super and self._base_ then
					local tBaseDeclareFunctions = self._base_.DeclareFunctions(self)
					if type(tBaseDeclareFunctions) == "table" then
						for k, v in pairs(tBaseDeclareFunctions) do
							if type(k) == "string" then
								local i = _G[k]
								if type(i) == "number" then
									table.insert(tDeclareFunctions, i)
									local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
									if type(sFunctionName) == "string" then
										self[sFunctionName] = function(self, params)
											return v
										end
									end
								end
							else
								table.insert(tDeclareFunctions, v)
							end
						end
					end
				end
				for k, v in pairs(t) do
					if type(k) == "string" then
						local i = _G[k]
						if type(i) == "number" then
							table.insert(tDeclareFunctions, i)
							local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
							if type(sFunctionName) == "string" then
								self[sFunctionName] = function(self, params)
									return v
								end
							end
						end
					else
						table.insert(tDeclareFunctions, v)
					end
				end
				self.DeclareFunctions = function(self)
					return tDeclareFunctions
				end
			end
		end
	end

	-- 自动link只支持技能里的modifier
	if type(c.__initprops__.Name) == "string" then
		local linkType = c.__initprops__.LuaModifierType or LUA_MODIFIER_MOTION_NONE
		local env, source = unpack(getFileScope(nil))
		local fileName = string.gsub(source, ".*scripts[\\/]vscripts[\\/]", "")
		LinkLuaModifier(c.__initprops__.Name, fileName, linkType)
	end

	return c
end
setmetatable(eom_modifier, mt)

function eom_modifier:EDeclareFunctions(bUnregister)
	return {}
end
function eom_modifier:ECheckState(bUnregister)
	return {}
end
function eom_modifier:OnCreated(params)
	print("self.GetAbilitySpecialValue", self.GetAbilitySpecialValue)
	if self.GetAbilitySpecialValue then
		self:GetAbilitySpecialValue()
	end
	if not self._OnCreated_ then
		if self.Super and self._base_ and type(self._base_.OnCreated) == "function" then
			self._base_.OnCreated(self, params)
		end
	end
	if type(self._DeclareFunctions) == "function" then
		local t = self:_DeclareFunctions()
		if type(t) == "table" then
			local tDeclareFunctions = {}
			for i, v in ipairs(t) do
				table.insert(tDeclareFunctions, v)
			end
			if self.Super and self._base_ then
				local tBaseDeclareFunctions = self._base_.DeclareFunctions(self)
				if type(tBaseDeclareFunctions) == "table" then
					for k, v in pairs(tBaseDeclareFunctions) do
						if type(k) == "string" then
							local i = _G[k]
							if type(i) == "number" then
								table.insert(tDeclareFunctions, i)
								local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
								if type(sFunctionName) == "string" then
									self[sFunctionName] = function(self, params)
										return v
									end
								end
							end
						else
							table.insert(tDeclareFunctions, v)
						end
					end
				end
			end
			for k, v in pairs(t) do
				if type(k) == "string" then
					local i = _G[k]
					if type(i) == "number" then
						table.insert(tDeclareFunctions, i)
						local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
						if type(sFunctionName) == "string" then
							self[sFunctionName] = function(self, params)
								return v
							end
						end
					end
				else
					table.insert(tDeclareFunctions, v)
				end
			end
			self.DeclareFunctions = function(self)
				return tDeclareFunctions
			end
		end
	end
	if not self._bDestroy and not self._tDeclareFunction and type(self.EDeclareFunctions) == "function" then
		self._tDeclareFunction = self:EDeclareFunctions()
		if self.Super and self._base_ and type(self._base_.EDeclareFunctions) == "function" then
			local tBaseEDeclareFunctions = self._base_.EDeclareFunctions(self)
			if type(tBaseEDeclareFunctions) == "table" then
				for k, v in pairs(tBaseEDeclareFunctions) do
					if self._tDeclareFunction[k] == nil then
						self._tDeclareFunction[k] = v
					end
				end
				for i, v in ipairs(tBaseEDeclareFunctions) do
					if TableFindKey(self._tDeclareFunction, v) == nil then
						table.insert(self._tDeclareFunction, v)
					end
				end
			end
		end
		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false
		local bCalculateAcquisitionRange = false

		local fManaPercent
		if IsServer() then
			hParent:CalculateGenericBonuses()
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				RegisterModifierProperty(hParent, self, iProperty)
				if IsServer() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, v)
					if IsServer() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
						bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						AddModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
		if IsServer() and bCalculateAcquisitionRange then
			hParent:CalculateAcquisitionRange()
		end
	end

	if not self._bDestroy and type(self.ECheckState) == "function" then
		local hParent = self:GetParent()
		self._tECheckState = self:ECheckState()
		for iState, bEnable in pairs(self._tECheckState) do
			RegisterModifierState(hParent, self, iState)
		end
	end
end
function eom_modifier:OnRefresh(params)
	if self.GetAbilitySpecialValue then
		self:GetAbilitySpecialValue()
	end
	if not self._OnRefresh_ then
		if self.Super and self._base_ and type(self._base_.OnRefresh) == "function" then
			self._base_.OnRefresh(self, params)
		end
	end
	if type(self._DeclareFunctions) == "function" then
		local t = self:_DeclareFunctions()
		if type(t) == "table" then
			local tDeclareFunctions = {}
			for i, v in ipairs(t) do
				table.insert(tDeclareFunctions, v)
			end
			if self.Super and self._base_ then
				local tBaseDeclareFunctions = self._base_.DeclareFunctions(self)
				if type(tBaseDeclareFunctions) == "table" then
					for k, v in pairs(tBaseDeclareFunctions) do
						if type(k) == "string" then
							local i = _G[k]
							if type(i) == "number" then
								table.insert(tDeclareFunctions, i)
								local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
								if type(sFunctionName) == "string" then
									self[sFunctionName] = function(self, params)
										return v
									end
								end
							end
						else
							table.insert(tDeclareFunctions, v)
						end
					end
				end
			end
			for k, v in pairs(t) do
				if type(k) == "string" then
					local i = _G[k]
					if type(i) == "number" then
						table.insert(tDeclareFunctions, i)
						local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
						if type(sFunctionName) == "string" then
							self[sFunctionName] = function(self, params)
								return v
							end
						end
					end
				else
					table.insert(tDeclareFunctions, v)
				end
			end
			self.DeclareFunctions = function(self)
				return tDeclareFunctions
			end
		end
	end
	if not self._bDestroy and type(self.EDeclareFunctions) == "function" then
		self._tDeclareFunction = self:EDeclareFunctions()
		if self.Super and self._base_ and type(self._base_.EDeclareFunctions) == "function" then
			local tBaseEDeclareFunctions = self._base_.EDeclareFunctions(self)
			if type(tBaseEDeclareFunctions) == "table" then
				for k, v in pairs(tBaseEDeclareFunctions) do
					if self._tDeclareFunction[k] == nil then
						self._tDeclareFunction[k] = v
					end
				end
				for i, v in ipairs(tBaseEDeclareFunctions) do
					if TableFindKey(self._tDeclareFunction, v) == nil then
						table.insert(self._tDeclareFunction, v)
					end
				end
			end
		end
		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false
		local bCalculateAcquisitionRange = false

		local fManaPercent
		if IsServer() then
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				if IsServer() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil and v ~= nil then
					if IsServer() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
						bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
					end
					SetModifierProperty(hParent, self, iProperty, v)
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
		if IsServer() and bCalculateAcquisitionRange then
			hParent:CalculateAcquisitionRange()
		end
	end
end
function eom_modifier:OnDestroy(params)
	if not self._OnDestroy_ then
		if self.Super and self._base_ and type(self._base_.OnDestroy) == "function" then
			self._base_.OnDestroy(self)
		end
	end
	self._bDestroy = true

	if self._tDeclareFunction then
		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false
		local bCalculateAcquisitionRange = false

		local fManaPercent
		if IsServer() and hParent:IsAlive() then
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				UnregisterModifierProperty(hParent, self, iProperty)
				if IsServer() and hParent:IsAlive() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, nil)
					if IsServer() and hParent:IsAlive() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
						bCalculateAcquisitionRange = bCalculateAcquisitionRange or UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty]
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						RemoveModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer() and hParent:IsAlive() then
			if bCalculateHealth then
				hParent:CalculateHealth()
			end
			if bCalculateMana then
				hParent:CalculateGenericBonuses()
				hParent:SetMana(fManaPercent * hParent:GetMaxMana())
			end
			if bCalculateAcquisitionRange then
				hParent:CalculateAcquisitionRange()
			end
		end

		self._tDeclareFunction = nil
	end

	if self.ECheckState then
		local hParent = self:GetParent()
		self._tECheckState = self:ECheckState()
		for iState, bEnable in pairs(self._tECheckState) do
			UnregisterModifierState(hParent, self, iState)
		end
	end
end

ZERO_VALUE = 1e-10

-- 加法相乘（百分比）
function AdditionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return ((1 + a * 0.01) * (1 + b * 0.01) - 1) * 100
end

-- 减法相乘（百分比）
function SubtractionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return -AdditionMultiplicationPercentage(-a, -b)
end

-- 最大值
function Maximum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.max(a, b)
end

-- 最小值
function Minimum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.min(a, b)
end

-- 优先前值
function First(a, b)
	if a == nil then
		return b
	else
		return a
	end
end

--[[	自定义属性列表
	格式：
		属性名称 = "属性函数名"
		这种格式会自动将不同modifier里提供的属性在GetModifierProperty函数里加起来返回。

		如果需要修改加法规则可以额外填格式，例如：
		属性名称 = {sFunctionName = "属性函数名", funcSettleCallback = SubtractionMultiplicationPercentage} 或 属性名称 = {"属性函数名", SubtractionMultiplicationPercentage} (如果用第二种写法省略变量名的话，就必须全部变量名都省略)
		其中SubtractionMultiplicationPercentage函数是固定参量(a, b)的函数，a和b分别为上一次的值和新获取到的值（两者都为nil的话，为定义a的初始值），函数需要返回下次运算时的a值。

		实际效果在发挥对应效果的地方使用GetModifierProperty来获取数值。
]]
---@type _G
EOM_MODIFIER_PROPERTIES = {
	-- 一些仅能对敌方使用的属性
	EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY = { "EOM_GetModifierHealthPercentageEnemy", AdditionMultiplicationPercentage }, -- 敌方血量百分比加减，为乘法叠加
	EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE_ENEMY = { "EOM_GetModifierIncomingDamagePercentageEnemy", AdditionMultiplicationPercentage }, -- NOTE:给怪物做减伤技能一定要用这个
	-- AdditionMultiplicationPercentage
	-- 攻击力
	EOM_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE = "EOM_GetModifierBaseAttack_BonusDamage",
	-- 物理护甲
	EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE = "EOM_GetModifierPhysicalArmorBase",
	EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = "EOM_GetModifierPhysicalArmorBonus",
	EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE = "EOM_GetModifierPhysicalArmorBasePercentage",
	EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_PERCENTAGE = "EOM_GetModifierPhysicalArmorPercentage",
	-- 无视物理护甲 需要传入正值（百分比）
	EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE = { "EOM_GetModifierIgnorePhysicalArmorPercentage", SubtractionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE_UNIQUE = { "EOM_GetModifierIgnorePhysicalArmorPercentageUnique", Maximum },
	EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE_TARGET = { "EOM_GetModifierIgnorePhysicalArmorPercentageTarget", SubtractionMultiplicationPercentage }, -- 护甲被无视一定比例，一般用于[符合条件的单位]无视此单位一定护甲的情况
	-- 魔法护甲
	EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BASE = "EOM_GetModifierMagicalArmorBase",
	EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BONUS = "EOM_GetModifierMagicalArmorBonus",
	EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BASE_PERCENTAGE = "EOM_GetModifierMagicalArmorBasePercentage",
	EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_PERCENTAGE = "EOM_GetModifierMagicalArmorPercentage",
	EOM_MODIFIER_PROPERTY_IGNORE_MAGICAL_ARMOR_PERCENTAGE = { "EOM_GetModifierIgnoreMagicalArmorPercentage", SubtractionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_IGNORE_MAGICAL_ARMOR_PERCENTAGE_UNIQUE = { "EOM_GetModifierIgnoreMagicalArmorPercentageUnique", Maximum },
	-- 技能增强
	EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BASE = "EOM_GetModifierSpellAmplifyBase",
	EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS = "EOM_GetModifierSpellAmplifyBonus",
	EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_UNIQUE = { "EOM_GetModifierSpellAmplifyBonusUnique", Maximum },
	-- 生命值
	EOM_MODIFIER_PROPERTY_HEALTH_BONUS = "EOM_GetModifierHealthBonus",
	EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE = "EOM_GetModifierHealthPercentage",
	-- 生命恢复
	EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = "EOM_GetModifierConstantHealthRegen",
	-- 魔法值
	EOM_MODIFIER_PROPERTY_MANA_BONUS = "EOM_GetModifierManaBonus",
	EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE = "EOM_GetModifierManaPercentage",
	-- 魔法恢复
	EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = "EOM_GetModifierConstantManaRegen",
	EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE = "EOM_GetModifierConstantManaRegenUnique",
	-- 能量值
	EOM_MODIFIER_PROPERTY_ENERGY_BONUS = "EOM_GetModifierEnergyBonus",
	EOM_MODIFIER_PROPERTY_ENERGY_PERCENTAGE = "EOM_GetModifierEnergyPercentage",
	-- 状态抗性
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING = { "EOM_GetModifierStatusResistanceStacking", SubtractionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_UNIQUE = { "EOM_GetModifierStatusResistanceUnique", Maximum },
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER = { "EOM_GetModifierStatusResistanceCaster", AdditionMultiplicationPercentage },
	-- 闪避
	EOM_MODIFIER_PROPERTY_EVASION_CONSTANT = { "EOM_GetModifierEvasion_Constant", SubtractionMultiplicationPercentage },
	-- 冷却减少
	EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = { "EOM_GetModifierPercentageCooldown", SubtractionMultiplicationPercentage },
	-- 攻击暴击
	EOM_MODIFIER_PROPERTY_CRITICALSTRIKE = { "EOM_GetModifierCriticalStrike", Maximum },
	EOM_MODIFIER_PROPERTY_TARGET_CRITICALSTRIKE = { "EOM_GetModifierTargetCriticalStrike", Maximum },
	EOM_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE = "EOM_GetModifierCriticalStrikeDamage", -- 额外暴击伤害
	EOM_MODIFIER_PROPERTY_INCOMING_CRITICALSTRIKE_PERCENT = "EOM_GetModifierIncomingCriticalStrikePercent", -- 受到的暴击伤害总体乘一个百分比
	-- 技能暴击
	EOM_MODIFIER_PROPERTY_SPELL_CRITICALSTRIKE = { "EOM_GetModifierSpellCriticalStrike", Maximum }, -- 技能暴击
	EOM_MODIFIER_PROPERTY_TARGET_SPELL_CRITICALSTRIKE = { "EOM_GetModifierTargetSpellCriticalStrike", Maximum }, -- 目标技能暴击
	EOM_MODIFIER_PROPERTY_SPELL_CRITICALSTRIKE_DAMAGE = "EOM_GetModifierSpellCriticalStrikeDamage", -- 额外技能暴击伤害
	-- 最大攻击速度
	EOM_MODIFIER_PROPERTY_MAX_ATTACKSPEED_BONUS = "EOM_GetModifierMaximumAttackSpeedBonus",
	-- 造成伤害
	EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = "EOM_GetModifierOutgoingDamagePercentage", -- 造成全伤害提升
	EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE = "EOM_GetModifierOutgoingPhysicalDamagePercentage",
	EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE = "EOM_GetModifierOutgoingMagicalDamagePercentage",
	EOM_MODIFIER_PROPERTY_OUTGOING_PURE_DAMAGE_PERCENTAGE = "EOM_GetModifierOutgoingPureDamagePercentage",
	EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE_PRIMARY_ATTRIBUTE = "EOM_GetModifierOutgoingDamagePercentagePrimaryAttribute", -- NOTE:勿用，用于主属性的全伤害提升
	EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE_SPECIAL = { "EOM_GetModifierOutgoingDamagePercentageSpecial", AdditionMultiplicationPercentage }, -- 用于特殊情况，例如复仇之魂的幻象
	EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_CONSTANT = "EOM_GetModifierOutgoingPhysicalDamageConstant", -- 额外造成固定数值物理伤害
	EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_CONSTANT = "EOM_GetModifierOutgoingMagicalDamageConstant", -- 额外造成固定数值魔法伤害
	EOM_MODIFIER_PROPERTY_OUTGOING_PURE_DAMAGE_CONSTANT = "EOM_GetModifierOutgoingPureDamageConstant", -- 额外造成固定数值纯粹伤害

	-- 受到伤害
	EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingDamagePercentage",
	EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingPhysicalDamagePercentage",
	EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingMagicalDamagePercentage",
	EOM_MODIFIER_PROPERTY_INCOMING_PURE_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingPureDamagePercentage",
	EOM_MODIFIER_PROPERTY_INCOMING_DOT_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingDOTDamagePercentage", -- 持续性伤害加深
	-- 毒相关
	EOM_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE = "EOM_GetModifierIncomingPoisonDamagePercentage", -- 毒伤害加深
	EOM_MODIFIER_PROPERTY_OUTGOING_POISON_COUNT_PERCENTAGE = "EOM_GetModifierOutGoingPoisonCountPercentage", -- 施加的毒层数增加比例
	EOM_MODIFIER_PROPERTY_INCOMING_POISON_COUNT_PERCENTAGE = "EOM_GetModifierIncomingPoisonCountPercentage", -- 被施加的毒层数增加比例
	-- 主属性
	EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BONUS = "EOM_GetModifierBonusStats_Primary",
	-- EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BASE = "EOM_GetModifierBaseStats_Primary",
	EOM_MODIFIER_PROPERTY_STATS_PRIMARY_PERCENTAGE = "EOM_GetModifierStats_Primary_Percentage", -- 主属性百分比
	-- EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Primary_Percentage",
	-- 次属性
	EOM_MODIFIER_PROPERTY_STATS_SECONDARY_BONUS = "EOM_GetModifierBonusStats_Secondary",
	EOM_MODIFIER_PROPERTY_STATS_SECONDARY_PERCENTAGE = "EOM_GetModifierStats_Secondary_Percentage", -- 次属性百分比
	-- 全属性
	EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = "EOM_GetModifierBonusStats_All",
	-- EOM_MODIFIER_PROPERTY_STATS_ALL_BASE = "EOM_GetModifierBaseStats_All",
	EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE = "EOM_GetModifierStats_All_Percentage", -- 全属性百分比
	-- EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_All_Percentage",
	-- 力量
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = "EOM_GetModifierBonusStats_Strength",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE = "EOM_GetModifierBaseStats_Strength",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE = "EOM_GetModifierStats_Strength_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Strength_Percentage",
	-- 敏捷
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS = "EOM_GetModifierBonusStats_Agility",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE = "EOM_GetModifierBaseStats_Agility",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_PERCENTAGE = "EOM_GetModifierStats_Agility_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Agility_Percentage",
	-- 智力
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = "EOM_GetModifierBonusStats_Intellect",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE = "EOM_GetModifierBaseStats_Intellect",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE = "EOM_GetModifierStats_Intellect_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Intellect_Percentage",
	-- 吸血
	EOM_MODIFIER_PROPERTY_LIFESTEAL = "EOM_GetModifierLifesteal",
	EOM_MODIFIER_PROPERTY_SPELL_LIFESTEAL = "EOM_GetModifierSpellLifesteal",
	-- 吸血增强
	EOM_MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE = { "EOM_GetModifierLifestealAmplify_Percentage", SubtractionMultiplicationPercentage },
	-- 警戒范围
	EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BONUS = "EOM_GetModifierAcquisitionRangeBonus",
	EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BASE = "EOM_GetModifierAcquisitionRangeBase",
	EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_PERCENTAGE = "EOM_GetModifierAcquisitionRange_Percentage",
	---子弹弹射
	EOM_MODIFIER_PROPERTY_BOUNCE_BONUS = "EOM_GetModifierBonusBounce",
	---商店打折
	EOM_MODIFIER_PROPERTY_DISCOUNT_RATE = "EOM_GetModifierDiscountRate",
	---额外信仰数量
	EOM_MODIFIER_PROPERTY_FAITH_COUNT_BONUS = "EOM_GetModifierBonusFaithCount",
	---弹道距离
	EOM_MODIFIER_PROPERTY_PROJECTILE_DISTANCE_BONUS = "EOM_GetModifierBonusProjectileDistance",
	---弹道速度
	EOM_MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS = "EOM_GetModifierBonusProjectileSpeed",
}

-- 事件
_G.EOM_MODIFIER_EVENTS = {
	-- 官方
	[MODIFIER_EVENT_ON_SPELL_TARGET_READY] = true,
	[MODIFIER_EVENT_ON_ATTACK_RECORD] = true,
	[MODIFIER_EVENT_ON_ATTACK_START] = true,
	[MODIFIER_EVENT_ON_ATTACK] = true,
	[MODIFIER_EVENT_ON_ATTACK_LANDED] = true,
	[MODIFIER_EVENT_ON_ATTACK_FAIL] = true,
	[MODIFIER_EVENT_ON_ATTACK_ALLIED] = true,
	-- [MODIFIER_EVENT_ON_PROJECTILE_DODGE] = true,
	[MODIFIER_EVENT_ON_ORDER] = true,
	[MODIFIER_EVENT_ON_UNIT_MOVED] = true,
	[MODIFIER_EVENT_ON_ABILITY_START] = true,
	[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = true,
	[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] = true,
	-- [MODIFIER_EVENT_ON_BREAK_INVISIBILITY] = true,
	[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] = true,
	-- [MODIFIER_EVENT_ON_PROCESS_UPGRADE] = true,
	-- [MODIFIER_EVENT_ON_REFRESH] = true,
	[MODIFIER_EVENT_ON_TAKEDAMAGE] = true,
	[MODIFIER_EVENT_ON_STATE_CHANGED] = true,
	-- [MODIFIER_EVENT_ON_ORB_EFFECT] = true,
	-- [MODIFIER_EVENT_ON_PROCESS_CLEAVE] = true,
	[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] = true,
	[MODIFIER_EVENT_ON_ATTACKED] = true,
	[MODIFIER_EVENT_ON_DEATH] = true,
	[MODIFIER_EVENT_ON_RESPAWN] = true,
	[MODIFIER_EVENT_ON_SPENT_MANA] = true,
	[MODIFIER_EVENT_ON_TELEPORTING] = true,
	[MODIFIER_EVENT_ON_TELEPORTED] = true,
	-- [MODIFIER_EVENT_ON_SET_LOCATION] = true,
	[MODIFIER_EVENT_ON_HEALTH_GAINED] = true,
	[MODIFIER_EVENT_ON_MANA_GAINED] = true,
	[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] = true,
	[MODIFIER_EVENT_ON_HERO_KILLED] = true,
	[MODIFIER_EVENT_ON_HEAL_RECEIVED] = true,
	-- [MODIFIER_EVENT_ON_BUILDING_KILLED] = true,
	-- [MODIFIER_EVENT_ON_MODEL_CHANGED] = true,
	[MODIFIER_EVENT_ON_MODIFIER_ADDED] = true,
	-- [MODIFIER_EVENT_ON_DOMINATED] = true,
	[MODIFIER_EVENT_ON_ATTACK_FINISHED] = true,
	[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = true,
	-- [MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT] = true,
	[MODIFIER_EVENT_ON_ATTACK_CANCELLED] = true,

-- 自定义
	[MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED] = true,
	[MODIFIER_EVENT_ON_ATTACK_PROJECTILE_DISABLED] = true,
}

--------------------------------------------------------------------------------
-- 自定义状态常数
--------------------------------------------------------------------------------
MODIFIER_STATE_ATTACK_PROJECTILE_DISABLED = 0		---无效远程攻击弹道
-- MODIFIER_STATE_COUNTER_PROJECTILE = 1		---反弹弹道
-- MODIFIER_STATE_DESTROY_PROJECTILE = 2		---销毁弹道
-- MODIFIER_STATE_BREAKABLE = 3				---可破坏物
-- MODIFIER_STATE_DODGE_TRAP = 4				---闪避陷阱

_G.EOM_MODIFIER_PROPERTY_NAME = {}
_G.EOM_MODIFIER_PROPERTY_FUNCTIONS = {}
_G.EOM_MODIFIER_PROPERTY_INDEXES = {}

local _tSettleCallbacks = {}
local _iIndex = 0
function _InitModifierProperty(sPropertyName, sFunctionName, funcSettleCallback)
	_G[sPropertyName] = _iIndex
	EOM_MODIFIER_PROPERTY_INDEXES[sPropertyName] = _iIndex
	EOM_MODIFIER_PROPERTY_NAME[_iIndex] = sPropertyName
	EOM_MODIFIER_PROPERTY_FUNCTIONS[_iIndex] = sFunctionName
	_tSettleCallbacks[_iIndex] = funcSettleCallback
	_iIndex = _iIndex + 1
end

for k, v in pairs(EOM_MODIFIER_PROPERTIES) do
	if type(k) ~= "number" then
		local sPropertyName = k
		if type(v) == "string" then
			_InitModifierProperty(sPropertyName, v)
		elseif type(v) == "table" then
			local sFunctionName = v.sFunctionName
			if type(sFunctionName) == "string" then
				_InitModifierProperty(sPropertyName, sFunctionName, v.funcSettleCallback)
			else
				sFunctionName = v[1]
				if type(sFunctionName) == "string" then
					_InitModifierProperty(sPropertyName, sFunctionName, v[2])
				end
			end
		end
	end
end

-- 血量更新的属性
_G.UPDATE_HEALTH_PROPERTY = {
	[EOM_MODIFIER_PROPERTY_HEALTH_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY] = true,
	[EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_PRIMARY_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_SECONDARY_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_SECONDARY_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE] = true,
}

-- 蓝量更新的属性
_G.UPDATE_MANA_PROPERTY = {
	[EOM_MODIFIER_PROPERTY_MANA_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_PRIMARY_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_SECONDARY_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_SECONDARY_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE] = true,
}

-- 警戒范围更新
_G.UPDATE_ACQUISITION_RANGE_PROPERTY = {
	[EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BASE] = true,
	[EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_PERCENTAGE] = true,
}

function CDOTA_Buff:RefreshModifierProperties(iProperty, fValue)
	local hParent = self:GetParent()

	local fManaPercent
	if IsServer() then
		fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
	end

	SetModifierProperty(hParent, self, iProperty, fValue)

	if IsServer() then
		if UPDATE_HEALTH_PROPERTY[iProperty] then
			hParent:CalculateHealth()
		end
		if UPDATE_MANA_PROPERTY[iProperty] then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
		if UPDATE_ACQUISITION_RANGE_PROPERTY[iProperty] then
			hParent:CalculateAcquisitionRange()
		end
	end
end

function SetModifierProperty(hUnit, hModifier, iProperty, fValue)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
		if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

		local tPropertyValues = hUnit.tPropertyValues[iProperty]
		local funcSettleCallback = _tSettleCallbacks[iProperty]

		tPropertyValues[hModifier] = fValue

		tPropertyValues.fValue = 0
		if funcSettleCallback ~= nil then
			tPropertyValues.fValue = funcSettleCallback()
		end
		for hModifier, fValue in pairs(tPropertyValues) do
			if type(hModifier) == "table" then
				if funcSettleCallback ~= nil then
					tPropertyValues.fValue = funcSettleCallback(tPropertyValues.fValue, fValue)
				else
					tPropertyValues.fValue = tPropertyValues.fValue + fValue
				end
			end
		end

		if tPropertyValues.fValue == ZERO_VALUE then
			tPropertyValues.fValue = 0
		end
	end
end

function RegisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		table.insert(tPropertyModifers, hModifier)

		table.sort(tPropertyModifers, function(a, b)
			local iPriorityA = type(a.GetPriority) == "function" and a:GetPriority() or MODIFIER_PRIORITY_NORMAL
			local iPriorityB = type(b.GetPriority) == "function" and b:GetPriority() or MODIFIER_PRIORITY_NORMAL
			return iPriorityA < iPriorityB
		end)
	elseif EOM_MODIFIER_EVENTS[iProperty] then
		AddModifierEvents(iProperty, hModifier)
	end
end

function UnregisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		ArrayRemove(tPropertyModifers, hModifier)
	elseif EOM_MODIFIER_EVENTS[iProperty] then
		RemoveModifierEvents(iProperty, hModifier)
	end
end

---注册修改器状态
function RegisterModifierState(hUnit, hModifier, iState)
	if hUnit == nil then return end
	if hUnit.tPropertyStates == nil then hUnit.tPropertyStates = {} end
	if hUnit.tPropertyStates[iState] == nil then hUnit.tPropertyStates[iState] = {} end

	local tPropertyStates = hUnit.tPropertyStates[iState]

	table.insert(tPropertyStates, hModifier)

	table.sort(tPropertyStates, function(a, b)
		local iPriorityA = type(a.GetPriority) == "function" and a:GetPriority() or MODIFIER_PRIORITY_NORMAL
		local iPriorityB = type(b.GetPriority) == "function" and b:GetPriority() or MODIFIER_PRIORITY_NORMAL
		return iPriorityA < iPriorityB
	end)
end

---解除注册修改器状态
function UnregisterModifierState(hUnit, hModifier, iState)
	if hUnit == nil then return end
	if hUnit.tPropertyStates == nil then hUnit.tPropertyStates = {} end
	if hUnit.tPropertyStates[iState] == nil then hUnit.tPropertyStates[iState] = {} end

	local tPropertyStates = hUnit.tPropertyStates[iState]

	ArrayRemove(tPropertyStates, hModifier)
end

function GetModifierProperty(hUnit, iProperty, tParams)
	if hUnit == nil then return 0 end
	if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
	if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end
	if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
	if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

	local tPropertyModifers = hUnit.tPropertyModifers[iProperty]
	local tPropertyValues = hUnit.tPropertyValues[iProperty]
	local funcSettleCallback = _tSettleCallbacks[iProperty]
	local sFunctionName = EOM_MODIFIER_PROPERTY_FUNCTIONS[iProperty]

	local fTotalValue = tPropertyValues.fValue or 0
	if funcSettleCallback ~= nil then
		fTotalValue = funcSettleCallback()
		if tPropertyValues.fValue ~= nil then
			fTotalValue = funcSettleCallback(fTotalValue, tPropertyValues.fValue)
		end
	end

	for i = #tPropertyModifers, 1, -1 do
		local hModifier = tPropertyModifers[i]
		if IsValid(hModifier) and type(hModifier[sFunctionName]) == "function" then
			local fValue = hModifier[sFunctionName](hModifier, tParams)
			if fValue ~= nil then
				if funcSettleCallback ~= nil then
					fTotalValue = funcSettleCallback(fTotalValue, fValue)
				else
					fTotalValue = fTotalValue + fValue
				end
			end
		else
			table.remove(tPropertyModifers, i)
		end
	end

	if fTotalValue == ZERO_VALUE then
		fTotalValue = 0
	end

	return fTotalValue
end

--------------------------------------------------------------------------------
-- 自定义状态
--------------------------------------------------------------------------------
---获取状态
function GetModifierState(hUnit, iState)
	if hUnit == nil then return false end
	if hUnit.tPropertyStates == nil then hUnit.tPropertyStates = {} end
	if hUnit.tPropertyStates[iState] == nil then hUnit.tPropertyStates[iState] = {} end

	if #hUnit.tPropertyStates[iState] > 0 then
		local tPropertyStates = hUnit.tPropertyStates[iState][#hUnit.tPropertyStates[iState]]:ECheckState()
		return tPropertyStates[iState]
	end
	return false
end

---@type CDOTA_BaseNPC 
local BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC

---是否无效远程攻击弹道
function BaseNPC:IsAttackProjectileDisabled()
	return GetModifierState(self, MODIFIER_STATE_ATTACK_PROJECTILE_DISABLED)
end
--------------------------------------------------------------------------------
-- 自定义属性
--------------------------------------------------------------------------------
-- 额外基础攻击力
function GetBaseBonusDamage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, tParams)
end
-- 物理防御
function GetBasePhysicalArmor(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BasePhysicalArmor == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BasePhysicalArmor = tonumber(tData.ArmorPhysical) or 0
			end
		end
		if hUnit._BasePhysicalArmor ~= nil then
			fDefault = hUnit._BasePhysicalArmor
		end
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE) + fDefault
end
function GetBonusPhysicalArmor(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS)
end
function GetBasePhysicalArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE)
end
function GetPhysicalArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_PERCENTAGE)
end
function GetPhysicalArmor(hUnit)
	local fTotalPercent = GetPhysicalArmorPercentage(hUnit) * 0.01 -- 不要调用两遍
	return GetBasePhysicalArmor(hUnit) * (1 + GetBasePhysicalArmorPercentage(hUnit) * 0.01 + fTotalPercent) + GetBonusPhysicalArmor(hUnit) * (1 + fTotalPercent)
end
function GetIgnorePhysicalArmorPercentage(hUnit, tParams)
	return SubtractionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE_UNIQUE, tParams))
end
function GetIgnorePhysicalArmorPercentageTarget(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR_PERCENTAGE_TARGET, tParams)
end
function GetPhysicalReduction(hUnit, tParams)
	local fValue = GetPhysicalArmor(hUnit)
	-- 负甲的时候没必要计算，节省计算量
	if fValue > 0 then
		local fIgnore = GetIgnorePhysicalArmorPercentageTarget(hUnit, tParams) -- 自身的百分比减甲
		if tParams and IsValid(tParams.attacker) then
			fIgnore = SubtractionMultiplicationPercentage(fIgnore, GetIgnorePhysicalArmorPercentage(tParams.attacker, tParams))
		end
		fValue = fValue - math.max(fValue * fIgnore * 0.01, 0)
	end
	return PHYSICAL_ARMOR_FACTOR * fValue / (1 + PHYSICAL_ARMOR_FACTOR * math.abs(fValue))
end
-- 魔法防御
function GetBaseMagicalArmor(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseMagicalArmor == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BaseMagicalArmor = tonumber(tData.MagicalResistance) or 0
			end
		end
		if hUnit._BaseMagicalArmor ~= nil then
			fDefault = hUnit._BaseMagicalArmor
		end
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BASE) + fDefault
end
function GetBonusMagicalArmor(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BONUS)
end
function GetBaseMagicalArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BASE_PERCENTAGE)
end
function GetMagicalArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_PERCENTAGE)
end
function GetMagicalArmor(hUnit)
	return GetBaseMagicalArmor(hUnit) * (1 + GetBaseMagicalArmorPercentage(hUnit) * 0.01 + GetMagicalArmorPercentage(hUnit) * 0.01) + GetBonusMagicalArmor(hUnit) * (1 + GetMagicalArmorPercentage(hUnit) * 0.01)
end
function GetIgnoreMagicalArmorPercentage(hUnit, tParams)
	return SubtractionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_MAGICAL_ARMOR_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_MAGICAL_ARMOR_PERCENTAGE_UNIQUE, tParams))
end
function GetMagicalReduction(hUnit, tParams)
	local fValue = GetMagicalArmor(hUnit)
	if tParams and IsValid(tParams.attacker) and fValue > 0 then
		fValue = fValue - math.max(fValue * GetIgnoreMagicalArmorPercentage(tParams.attacker, tParams) * 0.01, 0)
	end
	return MAGICAL_ARMOR_FACTOR * fValue / (1 + MAGICAL_ARMOR_FACTOR * math.abs(fValue))
end
-- 技能增强
function GetBaseSpellAmplify(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BASE, tParams)
end
function GetBonusSpellAmplify(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS, tParams)
end
function GetBonusSpellAmplifyUnique(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS_UNIQUE, tParams)
end
function GetSpellAmplify(hUnit, tParams)
	return GetBaseSpellAmplify(hUnit, tParams) + GetBonusSpellAmplify(hUnit, tParams) + GetBonusSpellAmplifyUnique(hUnit, tParams)
end
-- 生命值
function GetHealthBonus(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_BONUS)
end
function GetHealthPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE)
end
function GetHealthPercentageEnemy(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY)
end
-- 生命恢复
function GetHealthRegen(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT)
end
-- 魔法值
function GetManaBonus(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_BONUS)
end
function GetManaPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE)
end
function GetBaseMana(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._StatusMana == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._StatusMana = tonumber(tData.StatusMana) or 0
			end
		end
		if hUnit._StatusMana ~= nil then
			fValue = hUnit._StatusMana
		end
	end
	return fValue
end
function GetMana(hUnit)
	return (GetManaBonus(hUnit) + GetBaseMana(hUnit)) * (1 + GetManaPercentage(hUnit) * 0.01)
end
-- 魔法恢复
function GetManaRegen(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE)
end
-- 状态抗性
function GetStatusResistanceStack(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING)
end
function GetStatusResistanceUnique(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_UNIQUE)
end
function GetStatusResistance(hUnit)
	return (1 - (1 - GetStatusResistanceStack(hUnit) * 0.01) * (1 - GetStatusResistanceUnique(hUnit) * 0.01)) * 100
end
function GetStatusResistanceCaster(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER)
end
-- 闪避
function GetEvasion(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_EVASION_CONSTANT, tParams)
end
-- 冷却减少
function GetCooldownReduction(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, tParams)
end
-- 暴击
function GetCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_CRITICALSTRIKE, tParams)
end
function GetTargetCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_TARGET_CRITICALSTRIKE, tParams)
end
-- 额外暴击伤害
function GetCriticalStrikeDamage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE)
end
-- 受到的暴击伤害倍率放大：（基础+额外）x （暴击伤害倍率）= 最终暴击伤害倍率
function GetIncomingCriticalStrikePercent(hUnit, tParams)
	return 1 + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_CRITICALSTRIKE_PERCENT, tParams) / 100
end
-- 技能暴击
function GetSpellCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_CRITICALSTRIKE, tParams)
end
function GetTargetSpellCriticalStrike(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_TARGET_SPELL_CRITICALSTRIKE, tParams)
end
-- 额外技能暴击伤害
function GetSpellCriticalStrikeDamage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_CRITICALSTRIKE_DAMAGE)
end
-- 最大攻击速度
function GetBonusMaximumAttackSpeed(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAX_ATTACKSPEED_BONUS)
end
-- 造成的伤害
function GetOutgoingDamagePercentPrimaryAttribute(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE_PRIMARY_ATTRIBUTE)
end
function GetOutgoingDamagePercentSpecial(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE_SPECIAL)
end
function GetOutgoingDamagePercent(hUnit, tParams)
	return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE, tParams), GetOutgoingDamagePercentPrimaryAttribute(hUnit)), GetOutgoingDamagePercentSpecial(hUnit, tParams))
end
function GetOutgoingPhysicalDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE, tParams)
end
function GetOutgoingMagicalDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE, tParams)
end
function GetOutgoingPureDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PURE_DAMAGE_PERCENTAGE, tParams)
end
function GetModifierOutgoingPhysicalDamageConstant(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_CONSTANT, tParams)
end
function GetModifierOutgoingMagicalDamageConstant(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_CONSTANT, tParams)
end
function GetModifierOutgoingPureDamageConstant(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PURE_DAMAGE_CONSTANT, tParams)
end
-- 受到的伤害
function GetIncomingDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, tParams)
end
function GetIncomingPhysicalDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE, tParams)
end
function GetIncomingMagicalDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE, tParams)
end
function GetIncomingPureDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_PURE_DAMAGE_PERCENTAGE, tParams)
end
function GetIncomingDamagePercentEnemy(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE_ENEMY, tParams)
end
function GetIncomingDotDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DOT_DAMAGE_PERCENTAGE, tParams)
end
--毒伤害相关
function GetIncomingPoisonDamagePercent(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE, tParams)
end
function GetOutgoingPoisonCountPercent(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_POISON_COUNT_PERCENTAGE)
end
function GetIncomingPoisonCountPercent(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_POISON_COUNT_PERCENTAGE)
end
-- 属性
function GetBaseStrength(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseStrength == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BaseStrength = tonumber(tData.BaseStrength) or 0
			end
		end
		if IsValid(hUnit) and hUnit._StrengthGain == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._StrengthGain = tonumber(tData.StrengthGain) or 0
			end
		end
		if hUnit._BaseStrength ~= nil then
			fValue = hUnit._BaseStrength
		end
		if hUnit._StrengthGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._StrengthGain
		end
		fValue = math.floor(fValue)
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE)) + fValue, 0)
end
function GetBaseAgility(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseAgility == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BaseAgility = tonumber(tData.BaseAgility) or 0
			end
		end
		if IsValid(hUnit) and hUnit._AgilityGain == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._AgilityGain = tonumber(tData.AgilityGain) or 0
			end
		end
		if hUnit._BaseAgility ~= nil then
			fValue = hUnit._BaseAgility
		end
		if hUnit._AgilityGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._AgilityGain
		end
		fValue = math.floor(fValue)
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE)) + fValue, 0)
end
function GetBaseIntellect(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseIntellect == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BaseIntellect = tonumber(tData.BaseIntellect) or 0
			end
		end
		if IsValid(hUnit) and hUnit._IntellectGain == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._IntellectGain = tonumber(tData.IntellectGain) or 0
			end
		end
		if hUnit._BaseIntellect ~= nil then
			fValue = hUnit._BaseIntellect
		end
		if hUnit._IntellectGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._IntellectGain
		end
		fValue = math.floor(fValue)
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE)) + fValue, 0)
end
function GetBaseStrengthPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE)
end
function GetBaseAgilityPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE_PERCENTAGE)
end
function GetBaseIntellectPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE)
end
function GetBonusPrimaryStat(hUnit, iPrimaryStat)
	if type(hUnit.GetPrimaryAttribute) == "function" and hUnit:GetPrimaryAttribute() == iPrimaryStat then
		return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BONUS)
	end
	return 0
end
function GetBonusSecondaryStat(hUnit, iPrimaryStat)
	if type(hUnit.GetPrimaryAttribute) == "function" and hUnit:GetPrimaryAttribute() ~= iPrimaryStat then
		return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_SECONDARY_BONUS)
	end
	return 0
end
function GetBonusAllStat(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS)
end
function GetBonusStrength(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS) + GetBonusPrimaryStat(hUnit, DOTA_ATTRIBUTE_STRENGTH) + GetBonusAllStat(hUnit) + GetBonusSecondaryStat(hUnit, DOTA_ATTRIBUTE_STRENGTH)
end
function GetBonusAgility(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS) + GetBonusPrimaryStat(hUnit, DOTA_ATTRIBUTE_AGILITY) + GetBonusAllStat(hUnit) + GetBonusSecondaryStat(hUnit, DOTA_ATTRIBUTE_AGILITY)
end
function GetBonusIntellect(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS) + GetBonusPrimaryStat(hUnit, DOTA_ATTRIBUTE_INTELLECT) + GetBonusAllStat(hUnit) + GetBonusSecondaryStat(hUnit, DOTA_ATTRIBUTE_INTELLECT)
end
function GetPrimaryStatPercent(hUnit, iPrimaryStat)
	if type(hUnit.GetPrimaryAttribute) == "function" and hUnit:GetPrimaryAttribute() == iPrimaryStat then
		return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_PRIMARY_PERCENTAGE)
	else
		return 0
	end
end
function GetSecondaryStatPercent(hUnit, iPrimaryStat)
	if type(hUnit.GetPrimaryAttribute) == "function" and hUnit:GetPrimaryAttribute() ~= iPrimaryStat then
		return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_SECONDARY_PERCENTAGE)
	else
		return 0
	end
end
function GetAllStatPercent(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE)
end
function GetStrengthPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE) + GetPrimaryStatPercent(hUnit, DOTA_ATTRIBUTE_STRENGTH) + GetAllStatPercent(hUnit) + GetSecondaryStatPercent(hUnit, DOTA_ATTRIBUTE_STRENGTH)
end
function GetAgilityPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_PERCENTAGE) + GetPrimaryStatPercent(hUnit, DOTA_ATTRIBUTE_AGILITY) + GetAllStatPercent(hUnit) + GetSecondaryStatPercent(hUnit, DOTA_ATTRIBUTE_AGILITY)
end
function GetIntellectPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE) + GetPrimaryStatPercent(hUnit, DOTA_ATTRIBUTE_INTELLECT) + GetAllStatPercent(hUnit) + GetSecondaryStatPercent(hUnit, DOTA_ATTRIBUTE_INTELLECT)
end
function GetStrength(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	local fTotalPercent = GetStrengthPercentage(hUnit) * 0.01
	return math.max(math.floor(GetBaseStrength(hUnit) * (1 + GetBaseStrengthPercentage(hUnit) * 0.01 + fTotalPercent) + GetBonusStrength(hUnit) * (1 + fTotalPercent)), 0)
end
function GetStrengthWithoutPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(GetBaseStrength(hUnit) + GetBonusStrength(hUnit), 0)
end
function GetAgility(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	local fTotalPercent = GetAgilityPercentage(hUnit) * 0.01
	return math.max(math.floor(GetBaseAgility(hUnit) * (1 + GetBaseAgilityPercentage(hUnit) * 0.01 + fTotalPercent) + GetBonusAgility(hUnit) * (1 + fTotalPercent)), 0)
end
function GetAgilityWithoutPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(GetBaseAgility(hUnit) + GetBonusAgility(hUnit), 0)
end
function GetIntellect(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	local fTotalPercent = GetIntellectPercentage(hUnit) * 0.01
	return math.max(math.floor(GetBaseIntellect(hUnit) * (1 + GetBaseIntellectPercentage(hUnit) * 0.01 + fTotalPercent) + GetBonusIntellect(hUnit) * (1 + fTotalPercent)), 0)
end
function GetIntellectWithoutPercentage(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(GetBaseIntellect(hUnit) + GetBonusIntellect(hUnit), 0)
end
function GetLifesteal(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_LIFESTEAL)
end
function GetSpellLifesteal(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_SPELL_LIFESTEAL)
end
function GetLifestealAmplifyPercent(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE)
end
function GetLifestealAmplifyFactor(hUnit)
	return (1 + GetLifestealAmplifyPercent(hUnit) * 0.01)
end
function GetBaseAcquisitionRange(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseAcquisitionRange == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._BaseAcquisitionRange = tonumber(tData.AttackAcquisitionRange) or 800
			end
		end
		if hUnit._BaseAcquisitionRange ~= nil then
			fValue = hUnit._BaseAcquisitionRange
		end
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BASE) + fValue
end
function GetAcquisitionRangeBonus(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BONUS)
end
function GetAcquisitionRangePercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_PERCENTAGE)
end
function GetAcquisitionRange(hUnit)
	local fAttackRange = (IsValid(hUnit) and hUnit.Script_GetAttackRange ~= nil) and hUnit:Script_GetAttackRange() or 0
	return math.max(fAttackRange, (GetBaseAcquisitionRange(hUnit) + GetAcquisitionRangeBonus(hUnit)) * (1 + GetAcquisitionRangePercentage(hUnit) * 0.01))
end
function GetBaseMaxEnergy(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._StatusEnergy == nil then
			local sUnitName = hUnit:GetUnitName()
			local tData = hUnit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
			if tData then
				hUnit._StatusEnergy = tonumber(tData.StatusEnergy) or 0
			end
		end
		if hUnit._StatusEnergy ~= nil then
			fValue = hUnit._StatusEnergy
		end
	end
	return fValue
end
function GetMaxEnergyBonus(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ENERGY_BONUS)
end
function GetMaxEnergyPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ENERGY_PERCENTAGE)
end
function GetMaxEnergy(hUnit)
	return (GetBaseMaxEnergy(hUnit) + GetMaxEnergyBonus(hUnit)) * (1 + GetMaxEnergyPercentage(hUnit) * 0.01)
end
---获取打折百分比
---@param hUnit 单位
function GetDiscountRate(hUnit)
	return 100 - GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_DISCOUNT_RATE)
end
---获取额外信仰数量
---@param hUnit 单位
function GetFaithCount(hUnit)
	return 1 + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_FAITH_COUNT_BONUS)
end
---获取弹道速度
---@param hUnit 单位
function GetModifierProjectileSpeed(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS)
end
---获取弹道距离
---@param hUnit 单位
function GetModifierProjectileDistance(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PROJECTILE_DISTANCE_BONUS)
end