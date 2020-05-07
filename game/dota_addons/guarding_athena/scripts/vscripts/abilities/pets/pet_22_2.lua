LinkLuaModifier( "modifier_pet_22_2", "abilities/pets/pet_22_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_22_2 == nil then
	pet_22_2 = class({})
end
function pet_22_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_2", {duration = self:GetDuration()})
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_2 == nil then
	modifier_pet_22_2 = class({}, nil, ModifierHidden)
end
function modifier_pet_22_2:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_22_2:OnIntervalThink()
	local item = CreateItem("item_bag_of_coin", nil, nil)
	item:SetPurchaseTime(GameRules:GetGameTime() - 10)
	local pos = hParent:GetAbsOrigin()
	local drop = CreateItemOnPositionSync( pos, item )
	local pos_launch = pos + RandomVector(RandomFloat(0,50))
	item:LaunchLoot(item:IsCastOnPickup(), 200, 0.75, pos_launch)
end