LinkLuaModifier("modifier_pet_02_1", "abilities/pets/pet_02_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_02_1 == nil then
	pet_02_1 = class({})
end
function pet_02_1:GetIntrinsicModifierName()
	return "modifier_pet_02_1"
end
function pet_02_1:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_02_1 == nil then
	modifier_pet_02_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_02_1:IsHidden()
	return true
end
function modifier_pet_02_1:OnCreated(params)
	self.tItems = {
		"item_bag_of_coin",
		"item_str_book",
		"item_agi_book",
		"item_int_book",
		"item_essence_small",
		"item_essence_medium",
		"item_essence_big",
		"item_clarity4",
		"item_salve4",
	}
	if IsServer() then
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_02_1:OnIntervalThink()
	local hParent = self:GetParent()
	local sItemName = RandomValue(self.tItems)
	local item = CreateItem(sItemName, nil, nil)
	item:SetPurchaseTime(GameRules:GetGameTime() - 10)
	local pos = hParent:GetAbsOrigin()
	local drop = CreateItemOnPositionSync( pos, item )
	local pos_launch = pos + RandomVector(RandomFloat(0,50))
	item:LaunchLoot(item:IsCastOnPickup(), 200, 0.75, pos_launch)
	hParent:EmitSound("Hero_SkywrathMage.ChickenTaunt")
end