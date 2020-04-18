if KeyValues == nil then
	KeyValues = class({})
end

if IsServer() then
	KeyValues.PetsKv = LoadKeyValues("scripts/npc/kv/npc_pet.kv")
	KeyValues.UnitsKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	KeyValues.HeroesKv = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	KeyValues.AbilitiesKv = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	KeyValues.ItemsKv = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	KeyValues.DropsKv = LoadKeyValues("scripts/kv/item_drops.kv")
	-- KeyValues.ItemsKv = TableReplace(TableOverride(LoadKeyValues("scripts/npc/items.txt"), LoadKeyValues("scripts/npc/npc_items_custom.txt")), LoadKeyValues("scripts/npc/npc_abilities_override.txt"))

	require("generate_json")

	if IsInToolsMode() then
		KvToJson("HeroesKv", KeyValues.HeroesKv)
		-- KvToJson("AbilitiesKv", KeyValues.AbilitiesKv)
	-- 	KvToJson("AssetModifiersKv", KeyValues.AssetModifiersKv)
	-- 	KvToJson("BannerGoodsKv", KeyValues.BannerGoodsKv)
	-- 	KvToJson("BattlepassKv", KeyValues.BattlepassKv)
	-- 	KvToJson("CardTypeKv", KeyValues.CardTypeKv)
	-- 	KvToJson("CourierFxKv", KeyValues.CourierFxKv)
	-- 	KvToJson("CourierKv", KeyValues.CourierKv)
	-- 	KvToJson("HeroIDKv", KeyValues.HeroIDKv)
	-- 	KvToJson("ItemsKv", KeyValues.ItemsKv)
	-- 	KvToJson("ItemsRarityKv", KeyValues.ItemsRarityKv)
	-- 	KvToJson("NpcEnemyKv", KeyValues.NpcEnemyKv)
	-- 	KvToJson("NpcHeroesTowerSkinKv", KeyValues.NpcHeroesTowerSkinKv)
	-- 	KvToJson("PermanentModifiersKv", KeyValues.PermanentModifiersKv)
	-- 	KvToJson("QualificationAbilitiesKv", KeyValues.QualificationAbilitiesKv)
	-- 	KvToJson("UnitsKv", KeyValues.UnitsKv)
	-- 	KvToJson("WaveKv", KeyValues.WaveKv)
	end
else
end