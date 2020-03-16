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
function modifier_pet_02_1:OnCreated(params)
	self.tItems = {
		"item_bag_of_gold",
		"item_str_book",
		"item_agi_book",
		"item_int_book",
		"item_original_str_pickup",
		"item_original_agi_pickup",
		"item_original_int_pickup",
		"item_clarity4",
		"item_salve4",
		"item_clarity4",
		"item_clarity4",
		"item_clarity4",
		"item_clarity4",
	}
	if IsServer() then
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_02_1:OnIntervalThink()
	local hParent = self:GetParent()
	local item = CreateItem(RandomValue(self.tItems), nil, nil)
	item:SetPurchaseTime(GameRules:GetGameTime() - 10)
	local pos = hParent:GetAbsOrigin()
	local drop = CreateItemOnPositionSync( pos, item )
	local pos_launch = pos + RandomVector(RandomFloat(0,50))
	hParent:EmitSound("Hero_SkywrathMage.ChickenTaunt")
end