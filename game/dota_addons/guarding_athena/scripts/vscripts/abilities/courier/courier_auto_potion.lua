courier_auto_potion = class({})
function courier_auto_potion:Spawn()
	if IsServer() then
		self:ToggleAbility()
	end
end
function courier_auto_potion:OnToggle()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	if self:GetToggleState() == true then
		hCaster:AddNewModifier(hCaster, self, "modifier_courier_auto_potion", nil)
	else
		hCaster:RemoveModifierByName("modifier_courier_auto_potion")
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_courier_auto_potion = eom_modifier({
	Name = "modifier_courier_auto_potion",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_courier_auto_potion:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_courier_auto_potion:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	local hHero = hParent:GetOwner()
	if hHero:IsAlive() then
		for i = 1, 6 do
			local hItem = hParent:GetItemInSlot(i - 1)
			if hItem then
				local sItemName = hItem:GetAbilityName()
				if string.sub(sItemName, 6, 10) == "salve" then
					local iLevel = tonumber(string.sub(sItemName, 11, string.len(sItemName)))
					local flHealAmount = hItem:GetSpecialValueFor("total_hp")
					if hHero:GetHealthDeficit() * 2 >= flHealAmount and not hHero:HasModifier("modifier_item_salve" .. iLevel) then
						ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hItem)
					end
				end
			end
		end
		for i = 1, 6 do
			local hItem = hParent:GetItemInSlot(i - 1)
			if hItem then
				local sItemName = hItem:GetAbilityName()
				if string.sub(sItemName, 6, 12) == "clarity" then
					local iLevel = tonumber(string.sub(sItemName, 13, string.len(sItemName)))
					local flHealAmount = hItem:GetSpecialValueFor("total_mana")
					if (hHero:GetMaxMana() - hHero:GetMana()) * 2 >= flHealAmount and not hHero:HasModifier("modifier_item_clarity" .. iLevel) then
						ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hItem)
					end
				end
			end
		end
	end
end