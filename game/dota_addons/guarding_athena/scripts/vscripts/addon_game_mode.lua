_G.Service = require("service/init")
_G.json = require("game/dkjson")

_G.old_debug_traceback = old_debug_traceback or debug.traceback
if IsInToolsMode() then
	debug.traceback = function(...)
		local a = old_debug_traceback(...)
		-- print("[debug error]:", a)
		return a
	end

	local src = debug.getinfo(1).source
	if src:sub(2):find("(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]") then
		_G.GameDir, _G.AddonName = string.match(src:sub(2), "(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]")
		_G.ContentDir = GameDir:gsub("\\game\\dota_addons\\", "\\content\\dota_addons\\")
	end
else
	_G.tError = {}
	debug.traceback = function(error, ...)
		local a = old_debug_traceback(error, ...)
		local sMsg = tostring(error)
		print("[debug error]:", a)
		if not tError[sMsg] then
			tError[sMsg] = pcall(function()
				Service:HTTPRequest("POST", ACTION_DEBUG_ERROR_MSG, {debug_msg=a}, function(iStatusCode, sBody)
					if iStatusCode ~= 200 then
						tError[sMsg] = nil
					end
				end, 30)
			end)
		end
		return a
	end
end

require("kv")

if GuardingAthena == nil then
	_G.GuardingAthena = class({})
end

require("guarding_athena")
require("teleport")
require("practice")
require("ability_hero")
require("ability_unit")
require("ability_item")
require("ability_hero/hippolyta")
-- require('setting')
-- require('filter')
require('game_event')
require('scoreManager')
require('event_listener')
require("libraries/timers")
require("libraries/util")
require("libraries/md5")
require("libraries/server")
require("libraries/quest")
require("libraries/notifications")
require("libraries/physics")
require("libraries/spawner")
require("libraries/hero")
require("libraries/json")
--require("libraries/attribute")
require("libraries/ai")
--require("libraries/equilibrium_constant")
--require("modifiers/ring/ring_0_6")
--require("modifiers/ring/ring_1_2")

_G.tPrecacheList = require("precache")

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	for sPrecacheMode, tList in pairs(tPrecacheList) do
		for _, sResource in pairs(tList) do
			PrecacheResource(sPrecacheMode, sResource, context)
		end
	end
	PrecacheResource( "model", "models/heroes/juggernaut/juggernaut.vmdl", context )
	PrecacheResource( "model", "models/props_structures/tower_bad_sfm.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/gold_bag.vmdl", context )
	PrecacheResource( "model", "models/props_structures/dire_tower001.vmdl", context )
	PrecacheResource( "model", "models/items/undying/idol_of_ruination/idol_tower_sim.vmdl", context )
	PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl", context )
	PrecacheResource( "model", "models/items/doom/eleven_curses__head/eleven_curses__head.vmdl", context )
	PrecacheResource( "model", "models/items/earthshaker/redguardian_arms/redguardian_arms.vmdl", context )
	PrecacheResource( "model", "models/items/meepo/diggers_divining_rod/diggers_divining_rod_gem_ruby.vmdl", context )
	PrecacheResource( "model", "models/items/meepo/diggers_divining_rod/diggers_divining_rod_gem_saphire.vmdl", context )
	PrecacheResource( "model", "models/items/meepo/diggers_divining_rod/diggers_divining_rod_gem_topaz2.vmdl", context )
	PrecacheResource( "model", "models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes_flying.vmdl", context )
	PrecacheResource( "model", "models/creeps/greevil_shopkeeper/greevil_shopkeeper.vmdl", context )
	PrecacheResource( "model", "models/heroes/phantom_assassin/pa_arcana_weapons.vmdl", context )
	PrecacheResource( "model", "models/items/templar_assassin/psi_blades/psi_blades_immortal.vmdl", context )
	PrecacheResource( "model", "models/items/omniknight/light_hammer/mesh/light_hammer_model.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/rainmaker_bow/rainmaker_bow.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/ti6_falcon_bow/ti6_falcon_bow_model.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/sylvan_cascade/sylvan_cascade.vmdl", context )
	PrecacheResource( "model", "models/items/ember_spirit/rapier_burning_god_offhand/rapier_burning_god_offhand.vmdl", context )
	PrecacheResource( "model", "models/items/ember_spirit/rapier_burning_god_weapon/rapier_burning_god_weapon.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/force_staff/force_staff.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/ornithomancer_back/ornithomancer_back.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/golden_ornithomancer_mantle/golden_ornithomancer_mantle.vmdl", context )
	PrecacheResource( "model", "models/items/juggernaut/serrakura/jugg_serrakura.vmdl", context )
	PrecacheResource( "model", "models/items/juggernaut/serrakura/serrakura.vmdl", context )
	PrecacheResource( "model", "models/items/antimage/skullbasher/skullbasher_offhand.vmdl", context )
	PrecacheResource( "model", "models/items/antimage/skullbasher/skullbasher.vmdl", context )
	PrecacheResource( "model", "models/items/antimage/skullbasher/skullbasher_gold_offhand.vmdl", context )
	PrecacheResource( "model", "models/items/antimage/skullbasher/skullbasher_gold.vmdl", context )
	PrecacheResource( "model", "models/heroes/shadow_fiend/head_arcana.vmdl", context )
	PrecacheResource( "model", "models/items/shadow_fiend/arms_deso/arms_deso.vmdl", context )
	PrecacheResource( "model", "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl", context )
	PrecacheResource( "model", "models/items/lina/origins_flamehair/origins_flamehair.vmdl", context )
	PrecacheResource( "model", "models/items/lina/lina_immortal_ii/mesh/lina_immortal_ii.vmdl", context )
	PrecacheResource( "model", "models/items/legion_commander/demon_sword.vmdl", context )
	PrecacheResource( "model", "models/items/legion_commander/legacy_of_the_fallen_legion/legacy_of_the_fallen_legion.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/harlequin_head_black/harlequin_head_black.vmdl", context )
	PrecacheResource( "model", "models/items/rubick/harlequin_shoulder/harlequin_shoulder.vmdl", context )
	PrecacheResource( "model", "models/items/ember_spirit/rekindled_ashes_head/rekindled_ashes_head.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl", context )
	PrecacheResource( "model", "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl", context )
	PrecacheResource( "model", "models/heroes/tuskarr/tuskarr_sigil.vmdl", context )
	PrecacheResource( "model", "models/items/crystal_maiden/ward_staff/ward_staff.vmdl", context )
	PrecacheResource( "model", "models/items/crystal_maiden/ward_staff/ward_staff_crystal.vmdl", context )
	PrecacheResource( "model", "models/items/omniknight/omniknight_sacred_light_head/omniknight_sacred_light_head.vmdl", context )
	PrecacheResource( "model", "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl", context )
	PrecacheResource( "model", "models/items/legion_commander/lc_immortal_head_ti7/lc_immortal_head_ti7.vmdl", context )
	PrecacheResource( "model", "models/items/monkey_king/monkey_king_immortal_weapon/monkey_king_immortal_weapon.vmdl", context )
	PrecacheResource( "model", "models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl", context )
	PrecacheResource( "model", "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl", context )
	PrecacheResource( "model", "models/items/lanaya/raiment_of_the_violet_archives_shoulder/raiment_of_the_violet_archives_shoulder.vmdl", context )
	
	--PrecacheResource( "model", "models/items/templar_assassin/psi_blades/psi_blades_immortal.vmdl", context )
	PrecacheResource( "model", "models/heroes/furion/treant.vmdl", context )
	PrecacheResource( "model", "models/props_gameplay/gem01.vmdl", context )
	PrecacheResource( "soundfile", "soundevents/custom_sound.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_items.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_crystalmaiden.vsndevts", context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_ui.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context )
	--PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
	PrecacheResource( "particle_folder", "particles/skills", context )
	PrecacheResource( "particle_folder", "particles/wings", context )
	PrecacheResource( "particle_folder", "particles/unit", context )
	PrecacheResource( "particle_folder", "particles/heroes", context )
	PrecacheResource( "particle_folder", "particles/items", context )
	PrecacheResource( "particle_folder", "particles/linear_projectile", context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ground.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", context )
	-- 弹道
	PrecacheResource( "particle", "particles/base_attacks/ranged_badguy.vpcf", context )
	PrecacheResource( "particle", "particles/base_attacks/ranged_tower_bad.vpcf", context )
	PrecacheResource( "particle", "particles/base_attacks/fountain_attack.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/necrolyte/necronub_base_attack/necrolyte_base_attack_ka.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_immortal_lightning.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/base_attacks/ranged_tower_good.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/rubick/rubick_staff_wandering/rubick_base_attack_whset.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_projectile.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/techies/techies_arcana/techies_base_attack_arcana.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_warlock/warlock_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_base_attack.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", context )
	PrecacheResource( "particle", "particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/templar_assassin/templar_assassin_focal/ta_focal_ambient.vpcf", context )
	PrecacheItemByNameSync( "item_str_book", context )
	PrecacheItemByNameSync( "item_bag_of_coin", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_nevermore", context )
	PrecacheResource( "particle_folder", "particles/econ/items/phantom_assassin", context )
	PrecacheResource( "particle_folder", "particles/econ/items/shadow_fiend", context )
	PrecacheResource( "particle_folder", "particles/econ/items/ember_spirit", context )
	PrecacheResource( "particle_folder", "particles/econ/items/omniknight", context )
	PrecacheResource( "particle_folder", "particles/econ/items/windrunner", context )
	PrecacheResource( "particle_folder", "particles/econ/items/rubick", context )
	PrecacheResource( "particle_folder", "particles/econ/items/juggernaut", context )
	PrecacheResource( "particle_folder", "particles/econ/items/antimage", context )
	PrecacheResource( "particle_folder", "particles/econ/items/lina", context )
	PrecacheResource( "particle_folder", "particles/econ/items/legion_commander", context )
	PrecacheResource( "particle_folder", "particles/econ/items/templar_assassin", context )
	PrecacheUnitByNameSync("npc_dota_hero_nevermore",context)
	PrecacheUnitByNameSync("npc_dota_hero_phantom_assassin",context)
	PrecacheUnitByNameSync("npc_dota_hero_juggernaut",context)
	PrecacheUnitByNameSync("npc_dota_hero_antimage",context)
	PrecacheUnitByNameSync("npc_dota_hero_lina",context)
	PrecacheUnitByNameSync("npc_dota_hero_omniknight",context)
	PrecacheUnitByNameSync("npc_dota_hero_rubick",context)
	PrecacheUnitByNameSync("npc_dota_hero_windrunner",context)
	PrecacheUnitByNameSync("npc_dota_hero_legion_commander",context)
	PrecacheUnitByNameSync("npc_dota_hero_ember_spirit",context)
	PrecacheUnitByNameSync("npc_dota_hero_templar_assassin",context)
	PrecacheModel( "models/props_gameplay/gold_bag.vmdl", context)
	PrecacheModel( "npc_dota_hero_nevermore", context )
	PrecacheModel( "npc_dota_hero_phantom_assassin", context )
	PrecacheModel( "npc_dota_hero_juggernaut", context )
	PrecacheModel( "npc_dota_hero_antimage", context )
	PrecacheModel( "npc_dota_hero_lina", context )
	PrecacheModel( "npc_dota_hero_omniknight", context )
	PrecacheModel( "npc_dota_hero_rubick", context )
	PrecacheModel( "npc_dota_hero_windrunner", context )
	PrecacheModel( "npc_dota_hero_legion_commander", context )
	PrecacheModel( "npc_dota_hero_ember_spirit", context )
	PrecacheModel( "npc_dota_hero_templar_assassin", context )
end

function Activate()
	print ( '[GuardingAthena] Creating game mode' )
	Initialize(false)
	GuardingAthena:InitGameMode()
end
function Require(requireList, bReload)
	for k, v in pairs(requireList) do
		local t = require(v)
		if t ~= nil and type(t) == "table" then
			_G[k] = t
			if t.init ~= nil then
				t:init(bReload)
			end
		end
	end
end
function Initialize(bReload)
	_G.CustomUIEventListenerIDs = {}
	_G.GameEventListenerIDs = {}
	_G.TimerEventListenerIDs = {}
	_G.Activated = true

	-- Require({
	-- 	Request = "libraries/pet",

	-- 	"libraries/util",
	-- 	"libraries/md5",

	-- 	"class/weight_pool",
	-- }, bReload)

	Require({
		Settings = "setting",
		Filters = "filters",
		-- GuardingAthena = "guarding_athena",
	}, bReload)

	Require({
		Mechanics = "mechanics/main",
	}, bReload)

	Service:init(bReload)
end
function Reload()
	local state = GameRules:State_Get()
	if state > DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		_ClearEventListenerIDs()

		GameRules:Playtesting_UpdateAddOnKeyValues()
		FireGameEvent("client_reload_game_keyvalues", {})

		local tUnits = Entities:FindAllByClassname("npc_dota_creature")
		for n, hUnit in pairs(tUnits) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				for i = 0, hUnit:GetAbilityCount()-1, 1 do
					local hAbility = hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) and hAbility:GetLevel() > 0 then
						if hAbility:GetIntrinsicModifierName() ~= nil and hAbility:GetIntrinsicModifierName() ~= "" then
							hUnit:RemoveModifierByName(hAbility:GetIntrinsicModifierName())
							hUnit:AddNewModifier(hUnit, hAbility, hAbility:GetIntrinsicModifierName(), nil)
						end
					end
				end
			end
		end

		print("Reload Scripts")

		Initialize(true)
	end
end

function CustomUIEvent(eventName, func, context)
	table.insert(CustomUIEventListenerIDs, CustomGameEventManager:RegisterListener(eventName, function(...)
		if context ~= nil then
			return func(context, ...)
		end
		return func(...)
	end))
end
_G.CustomUIEvent = CustomUIEvent

function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end
_G.GameEvent = GameEvent

function GameTimerEvent(startInterval, func, context)
	local hGameMode = GameRules:GetGameModeEntity()
	table.insert(TimerEventListenerIDs, hGameMode:GameTimer(startInterval, function()
		if context ~= nil then
			return func(context)
		end
		return func()
	end))
end
_G.GameTimerEvent = GameTimerEvent

function _ClearEventListenerIDs()
	for i = #CustomUIEventListenerIDs, 1, -1 do
		CustomGameEventManager:UnregisterListener(CustomUIEventListenerIDs[i])
	end
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	local hGameMode = GameRules:GetGameModeEntity()
	for i = #TimerEventListenerIDs, 1, -1 do
		hGameMode:SetContextThink(TimerEventListenerIDs[i], nil, -1)
	end
end

if Activated == true then
	Reload()
end