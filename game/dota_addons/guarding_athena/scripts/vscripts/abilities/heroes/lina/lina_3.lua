lina_3 = class({})
function lina_3:Spawn()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	hCaster._LinaIgnite = function(hCaster, hTarget, iStackCount)
		if self:GetLevel() > 0 then
			hTarget:AddNewModifier(hCaster, self, "modifier_lina_3_debuff", { duration = self:GetSpecialValueFor("duration"), iStackCount = iStackCount })
		end
	end
end
function lina_3:GetIntrinsicModifierName()
	return "modifier_lina_3"
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_3 = eom_modifier({
	Name = "modifier_lina_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_3:GetAbilitySpecialValue()
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_lina_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() }
	}
end
function modifier_lina_3:OnDamageCalculated(params)
	if IsServer() then
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		params.target:AddNewModifier(params.attacker, hAbility, "modifier_lina_3_debuff", { duration = self.duration })
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_3_debuff = eom_modifier({
	Name = "modifier_lina_3_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_3_debuff:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
end
function modifier_lina_3_debuff:OnCreated(params)
	if IsServer() then
		self.tData = {
			{
				flDieTime = self:GetDieTime(),
				iStackCount = params.iStackCount
			}
		}
		self:IncrementStackCount(params.iStackCount)
		self:StartIntervalThink(0)
		self.flTime = 0
	end
end
function modifier_lina_3_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount(params.iStackCount)
		table.insert(self.tData, {
			flDieTime = self:GetDieTime(),
			iStackCount = params.iStackCount
		})
	end
end
function modifier_lina_3_debuff:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()

	self.flTime = self.flTime + FrameTime()
	if self.flTime >= self.interval then
		self.flTime = 0
		hCaster:DealDamage(hParent, hAbility)
	end
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i].flDieTime < flTime then
			self:DecrementStackCount(self.tData[i].iStackCount)
			table.remove(self.tData, i)
		end
	end
end