GameUI.CustomUIConfig().AssetsKv = {
	"rubick_01": {
		"asset_modifier0": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_phase.vpcf",
			"modifier": "particles/heroes/chronos_magic/space_gold_phase.vpcf",
		},
		"asset_modifier1": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/chronos_magic_open.vpcf",
			"modifier": "particles/heroes/chronos_magic/chronos_magic_gold_open.vpcf",
		},
		"asset_modifier2": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_open.vpcf",
			"modifier": "particles/heroes/chronos_magic/teleport_open_gold.vpcf",
		},
		"asset_modifier3": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_barrier.vpcf",
			"modifier": "particles/heroes/chronos_magic/space_barrier_gold.vpcf",
		},
		"asset_modifier4": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/fluctuation.vpcf",
			"modifier": "particles/heroes/chronos_magic/fluctuation_gold.vpcf",
		},
	},
	"rubick_02": {
		"asset_modifier0": {
			"type": "entity_model",
			"asset": "npc_dota_hero_rubick",
			"modifier": "models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl",
		},
		"asset_modifier1": {
			"type": "wearable",
			"asset": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"modifier": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"criteria": "0,0,255",
		},
		"asset_modifier2": {
			"type": "particle_create",
			"asset": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf",
		},
		"asset_modifier3": {
			"type": "wearable",
			"asset": "models/items/rubick/force_staff/force_staff.vmdl",
			"modifier": "models/items/rubick/force_staff/force_staff.vmdl",
		},
		"asset_modifier4": {
			"type": "particle_create",
			"asset": "models/items/rubick/force_staff/force_staff.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_force_ambient/rubick_force_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_staff_ambient",
				},
			},
		},
		"asset_modifier5": {
			"type": "wearable",
			"modifier": "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl",
		},
		"asset_modifier6": {
			"type": "particle_create",
			"asset": "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_arcana/rubick_arc_shoulders_ambient.vpcf",
		},
		"asset_modifier7": {
			"type": "wearable",
			"modifier": "models/items/rubick/vestments_of_stellar_abyss_head/vestments_of_stellar_abyss_head.vmdl",
		},
		"asset_modifier8": {
			"type": "ability_icon",
			"asset": "rubick_0",
			"modifier": "rubick/ti8_immortal_shoulder/rubick_fade_bolt_immortal",
		},
		"asset_modifier9": {
			"type": "ability_icon",
			"asset": "rubick_1",
			"modifier": "rubick/arcana/rubick_spell_steal_arcana",
		},
		"asset_modifier10": {
			"type": "ability_icon",
			"asset": "rubick_2",
			"modifier": "rubick/staff_of_perplex/rubick_telekinesis",
		},
		"asset_modifier11": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_phase.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_0.vpcf",
		},
		"asset_modifier12": {
			"type": "particle",
			"asset": "particles/skills/chronos_magic.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_1_start.vpcf",
		},
		"asset_modifier13": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_1_chaos_fly.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_1_chaos_fly.vpcf",
		},
		"asset_modifier14": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/chronos_magic_open.vpcf",
			"modifier": "",
		},
		"asset_modifier15": {
			"type": "sound",
			"asset": "Hero_Dark_Seer.Vacuum",
			"modifier": "Hero_Zuus.Righteous.Layer",
		},
		"asset_modifier16": {
			"type": "sound",
			"asset": "Hero_FacelessVoid.TimeWalk",
			"modifier": "Hero_Invoker.ChaosMeteor.Impact",
		},
		"asset_modifier17": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_open.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_2_start.vpcf",
		},
		"asset_modifier18": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_startleague.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_2_appear.vpcf",
		},
		"asset_modifier19": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_endflash_nexon_hero_cp_2014.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_2_appear.vpcf",
		},
		"asset_modifier20": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_2_shield.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_2_shield.vpcf",
		},
		"asset_modifier21": {
			"type": "sound",
			"asset": "Hero_ObsidianDestroyer.AstralImprisonment.End",
			"modifier": "Hero_VoidSpirit.Dissimilate.Cast",
		},
		"asset_modifier22": {
			"type": "sound",
			"asset": "Hero_Furion.Teleport_Disappear",
			"modifier": "Hero_VoidSpirit.Dissimilate.TeleportIn",
		},
		"asset_modifier23": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_barrier.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_3.vpcf",
		},
		"asset_modifier24": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_base_attack.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_0_fade_bolt.vpcf",
		},
		"asset_modifier25": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/fluctuation.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana/rubick_4_core_spiral.vpcf",
		},
		"asset_modifier26": {
			"type": "sound",
			"asset": "Hero_FacelessVoid.Chronosphere",
			"modifier": "Hero_ObsidianDestroyer.SanityEclipse.TI8",
		},
	},
	"rubick_03": {
		"asset_modifier0": {
			"type": "entity_model",
			"asset": "npc_dota_hero_rubick",
			"modifier": "models/items/rubick/rubick_arcana/rubick_arcana_base.vmdl",
		},
		"asset_modifier1": {
			"type": "wearable",
			"asset": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"modifier": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"criteria": "0,0,255",
		},
		"asset_modifier2": {
			"type": "particle_create",
			"asset": "models/items/rubick/rubick_arcana/rubick_arcana_back.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_arcana/rubick_arc_ambient_default.vpcf",
		},
		"asset_modifier3": {
			"type": "wearable",
			"modifier": "models/items/rubick/force_staff/force_staff.vmdl",
			"skin": 1,
		},
		"asset_modifier4": {
			"type": "particle_create",
			"asset": "models/items/rubick/force_staff/force_staff.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_force_gold_ambient/rubick_force_ambient_gold.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_staff_ambient",
				},
			},
		},
		"asset_modifier5": {
			"type": "wearable",
			"modifier": "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl",
		},
		"asset_modifier6": {
			"type": "particle_create",
			"asset": "models/items/rubick/rubick_ti8_immortal_shoulders/rubick_ti8_immortal_shoulders.vmdl",
			"modifier": "particles/econ/items/rubick/rubick_arcana/rubick_arc_shoulders_ambient.vpcf",
		},
		"asset_modifier7": {
			"type": "wearable",
			"modifier": "models/items/rubick/vestments_of_stellar_abyss_head/vestments_of_stellar_abyss_head.vmdl",
		},
		"asset_modifier8": {
			"type": "ability_icon",
			"asset": "rubick_0",
			"modifier": "rubick/ti8_immortal_shoulder/rubick_fade_bolt_immortal",
		},
		"asset_modifier9": {
			"type": "ability_icon",
			"asset": "rubick_1",
			"modifier": "rubick/arcana/rubick_spell_steal_arcana",
		},
		"asset_modifier10": {
			"type": "ability_icon",
			"asset": "rubick_2",
			"modifier": "rubick/staff_of_perplex/rubick_telekinesis_gold",
		},
		"asset_modifier11": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_phase.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_0.vpcf",
		},
		"asset_modifier12": {
			"type": "particle",
			"asset": "particles/skills/chronos_magic.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_1_start.vpcf",
		},
		"asset_modifier13": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_1_chaos_fly.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_1_chaos_fly.vpcf",
		},
		"asset_modifier14": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/chronos_magic_open.vpcf",
			"modifier": "",
		},
		"asset_modifier15": {
			"type": "sound",
			"asset": "Hero_Dark_Seer.Vacuum",
			"modifier": "Hero_Zuus.Righteous.Layer",
		},
		"asset_modifier16": {
			"type": "sound",
			"asset": "Hero_FacelessVoid.TimeWalk",
			"modifier": "Hero_Invoker.ChaosMeteor.Impact",
		},
		"asset_modifier17": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_open.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_2_start.vpcf",
		},
		"asset_modifier18": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_startleague.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_2_appear.vpcf",
		},
		"asset_modifier19": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/teleport_endflash_nexon_hero_cp_2014.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_2_appear.vpcf",
		},
		"asset_modifier20": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_2_shield.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_2_shield.vpcf",
		},
		"asset_modifier21": {
			"type": "sound",
			"asset": "Hero_ObsidianDestroyer.AstralImprisonment.End",
			"modifier": "Hero_VoidSpirit.Dissimilate.Cast",
		},
		"asset_modifier22": {
			"type": "sound",
			"asset": "Hero_Furion.Teleport_Disappear",
			"modifier": "Hero_VoidSpirit.Dissimilate.TeleportIn",
		},
		"asset_modifier23": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/space_barrier.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_3.vpcf",
		},
		"asset_modifier24": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_rubick/rubick_base_attack.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_0_fade_bolt.vpcf",
		},
		"asset_modifier25": {
			"type": "particle_create",
			"asset": "models/items/rubick/force_staff/force_staff.vmdl",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_weapon_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 3,
					"attach_type": "point_follow",
					"attachment": "attach_staff_ambient",
				},
			},
		},
		"asset_modifier26": {
			"type": "particle",
			"asset": "particles/heroes/chronos_magic/fluctuation.vpcf",
			"modifier": "particles/units/heroes/hero_rubick/rubick_arcana_gold/rubick_4_core_spiral.vpcf",
		},
		"asset_modifier27": {
			"type": "sound",
			"asset": "Hero_FacelessVoid.Chronosphere",
			"modifier": "Hero_ObsidianDestroyer.SanityEclipse.TI8",
		},
	},
	"windrunner_01": {
		"asset_modifier0": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_0_magic_attack.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_0_magic_attack.vpcf",
		},
		"asset_modifier1": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_1.vpcf",
		},
		"asset_modifier2": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_1_magic.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_1_magic.vpcf",
		},
		"asset_modifier3": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_2.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_2.vpcf",
		},
		"asset_modifier4": {
			"type": "particle",
			"asset": "particles/items_fx/cyclone.vpcf",
			"modifier": "particles/econ/events/ti10/cyclone_ti10.vpcf",
		},
		"asset_modifier5": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_2_tornado.vpcf",
		},
		"asset_modifier6": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_4.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_4.vpcf",
		},
		"asset_modifier7": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_4_a.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_4_a.vpcf",
		},
		"asset_modifier8": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_windrunner/windrunner_4_magic.vpcf",
			"modifier": "particles/units/heroes/hero_windrunner/windrunner_gold/windrunner_4_magic.vpcf",
		},
	},
	"omniknight_01": {
		"asset_modifier0": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_omniknight/omniknight_0.vpcf",
			"modifier": "particles/units/heroes/hero_omniknight/thunder_warrior/omniknight_0.vpcf",
		},
		"asset_modifier1": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_omniknight/omniknight_1.vpcf",
			"modifier": "particles/units/heroes/hero_omniknight/thunder_warrior/omniknight_1.vpcf",
		},
		"asset_modifier2": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_omniknight/omniknight_2.vpcf",
			"modifier": "particles/units/heroes/hero_omniknight/thunder_warrior/omniknight_2.vpcf",
		},
		"asset_modifier4": {
			"type": "particle",
			"asset": "particles/units/heroes/hero_omniknight/omniknight_4.vpcf",
			"modifier": "particles/units/heroes/hero_omniknight/thunder_warrior/omniknight_4.vpcf",
		},
	},
	"juggernaut_01": {
		"asset_modifier0": {
			"type": "entity_model",
			"asset": "npc_dota_hero_juggernaut",
			"modifier": "models/heroes/juggernaut/juggernaut_arcana.vmdl",
			"skin": 1,
		},
		"asset_modifier1": {
			"type": "wearable",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head.vmdl",
			"modifier": "models/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head.vmdl",
		},
		"asset_modifier2": {
			"type": "wearable",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back.vmdl",
			"modifier": "models/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back.vmdl",
		},
		"asset_modifier3": {
			"type": "wearable",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms.vmdl",
			"modifier": "models/items/juggernaut/fall20_juggernaut_katz_arms/fall20_juggernaut_katz_arms.vmdl",
		},
		"asset_modifier4": {
			"type": "wearable",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon.vmdl",
			"modifier": "models/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon.vmdl",
		},
		"asset_modifier5": {
			"type": "wearable",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs.vmdl",
			"modifier": "models/items/juggernaut/fall20_juggernaut_katz_legs/fall20_juggernaut_katz_legs.vmdl",
		},
		"asset_modifier6": {
			"type": "particle_create",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_head/fall20_juggernaut_katz_head.vmdl",
			"modifier": "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_head.vpcf",
		},
		"asset_modifier7": {
			"type": "particle_create",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_back/fall20_juggernaut_katz_back.vmdl",
			"modifier": "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_back.vpcf",
		},
		"asset_modifier8": {
			"type": "particle_create",
			"asset": "models/items/juggernaut/fall20_juggernaut_katz_weapon/fall20_juggernaut_katz_weapon.vmdl",
			"modifier": "particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_weapon.vpcf",
		},
		"asset_modifier9": {
			"type": "ability",
			"asset": "juggernaut_0",
			"modifier": "juggernaut_0_juggernaut_01",
		},
		"asset_modifier10": {
			"type": "ability",
			"asset": "juggernaut_1",
			"modifier": "juggernaut_1_juggernaut_01",
		},
		"asset_modifier11": {
			"type": "ability",
			"asset": "juggernaut_2",
			"modifier": "juggernaut_2_juggernaut_01",
		},
		"asset_modifier12": {
			"type": "ability",
			"asset": "juggernaut_3",
			"modifier": "juggernaut_3_juggernaut_01",
		},
		"asset_modifier13": {
			"type": "ability",
			"asset": "juggernaut_4",
			"modifier": "juggernaut_4_juggernaut_01",
		},
		"asset_modifier14": {
			"type": "ability",
			"asset": "juggernaut_2_1",
			"modifier": "juggernaut_2_juggernaut_01_1",
		},
		"asset_modifier15": {
			"type": "scepter",
			"asset": "item_npc_dota_hero_juggernaut",
			"modifier": "item_npc_dota_hero_juggernaut_juggernaut_01",
		},
		"asset_modifier16": {
			"type": "itemdef",
			"modifier": 21653,
		},
	},
	"spectre_01": {
		"asset_modifier0": {
			"type": "particle_create",
			"asset": "particles/units/heroes/hero_spectre/spectre_ambient.vpcf",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient.vpcf",
		},
		"asset_modifier1": {
			"type": "entity_model",
			"asset": "npc_dota_hero_spectre",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_base.vmdl",
		},
		"asset_modifier2": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_hat.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_head.vmdl",
		},
		"asset_modifier3": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_wings.vmdl",
			"modifier": "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl",
		},
		"asset_modifier4": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_dress.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_skirt.vmdl",
		},
		"asset_modifier5": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_weapon.vmdl",
			"modifier": "models/items/spectre/spectre_diffusal.vmdl",
		},
		"asset_modifier6": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_head.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_head.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 1,
					"attach_type": "point_follow",
					"attachment": "attach_head_fx",
				},
				"1": {
					"control_point_index": 2,
					"attach_type": "point_follow",
					"attachment": "attach_hair_tip_fx",
				},
				"2": {
					"control_point_index": 3,
					"attach_type": "point_follow",
					"attachment": "attach_eye_r_fx",
				},
				"3": {
					"control_point_index": 4,
					"attach_type": "point_follow",
					"attachment": "attach_eye_l_fx",
				},
				"4": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_mouth_fx",
				},
			},
		},
		"asset_modifier7": {
			"type": "particle_create",
			"asset": "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_chest",
				},
			},
		},
		"asset_modifier8": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_diffusal.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_weapon_diffusal/spectre_diffusal_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_blade",
				},
			},
		},
		"asset_modifier9": {
			"type": "wearable",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
		},
		"asset_modifier10": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_skirt.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_skirt.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 1,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_fx",
				},
				"1": {
					"control_point_index": 2,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_r_fx",
				},
				"2": {
					"control_point_index": 3,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_l_fx",
				},
				"3": {
					"control_point_index": 4,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_r_front_fx",
				},
				"4": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_l_front_fx",
				},
			},
		},
		"asset_modifier11": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_bracers.vpcf",
		},
		"asset_modifier12": {
			"type": "wearable",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
		},
		"asset_modifier13": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_shoulder.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_spine_fx",
				},
				"1": {
					"control_point_index": 7,
					"attach_type": "point_follow",
					"attachment": "attach_pendant_fx",
				},
			},
		},
		"asset_modifier14": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_diffusal.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_weapon_ambient.vpcf",
		},
	},
	"spectre_02": {
		"asset_modifier0": {
			"type": "particle_create",
			"asset": "particles/units/heroes/hero_spectre/spectre_ambient.vpcf",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient.vpcf",
		},
		"asset_modifier1": {
			"type": "entity_model",
			"asset": "npc_dota_hero_spectre",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_base.vmdl",
		},
		"asset_modifier2": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_hat.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_head.vmdl",
			"body_group": "arcana",
			"body_group_value": 2,
		},
		"asset_modifier3": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_wings.vmdl",
			"modifier": "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl",
			"skin": 1,
		},
		"asset_modifier4": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_dress.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_skirt.vmdl",
			"body_group": "arcana",
			"body_group_value": 2,
		},
		"asset_modifier5": {
			"type": "wearable",
			"asset": "models/heroes/spectre/spectre_weapon.vmdl",
			"modifier": "models/items/spectre/spectre_diffusal.vmdl",
		},
		"asset_modifier6": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_head.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_head.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 1,
					"attach_type": "point_follow",
					"attachment": "attach_head_fx",
				},
				"1": {
					"control_point_index": 2,
					"attach_type": "point_follow",
					"attachment": "attach_hair_tip_fx",
				},
				"2": {
					"control_point_index": 3,
					"attach_type": "point_follow",
					"attachment": "attach_eye_r_fx",
				},
				"3": {
					"control_point_index": 4,
					"attach_type": "point_follow",
					"attachment": "attach_eye_l_fx",
				},
				"4": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_mouth_fx",
				},
			},
		},
		"asset_modifier7": {
			"type": "particle_create",
			"asset": "models/items/spectre/immortal_shoulders/immortal_shoulders.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_golden_transversant_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_chest",
				},
			},
		},
		"asset_modifier8": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_diffusal.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_weapon_diffusal/spectre_diffusal_ambient.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 0,
					"attach_type": "point_follow",
					"attachment": "attach_blade",
				},
			},
		},
		"asset_modifier9": {
			"type": "wearable",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
			"body_group": "arcana",
			"body_group_value": 2,
		},
		"asset_modifier10": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_skirt.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_skirt_v2.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 1,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_fx",
				},
				"1": {
					"control_point_index": 2,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_r_fx",
				},
				"2": {
					"control_point_index": 3,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_l_fx",
				},
				"3": {
					"control_point_index": 4,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_r_front_fx",
				},
				"4": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_skirt_l_front_fx",
				},
			},
		},
		"asset_modifier11": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_misc.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_v2_bracers.vpcf",
		},
		"asset_modifier12": {
			"type": "wearable",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
			"modifier": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
			"body_group": "arcana",
			"body_group_value": 2,
		},
		"asset_modifier13": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_arcana/spectre_arcana_shoulder.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_ambient_shoulder_debut_v2.vpcf",
			"attach_type": "customorigin",
			"attach_entity": "self",
			"control_points": {
				"0": {
					"control_point_index": 5,
					"attach_type": "point_follow",
					"attachment": "attach_spine_fx",
				},
				"1": {
					"control_point_index": 7,
					"attach_type": "point_follow",
					"attachment": "attach_pendant_fx",
				},
			},
		},
		"asset_modifier14": {
			"type": "particle_create",
			"asset": "models/items/spectre/spectre_diffusal.vmdl",
			"modifier": "particles/econ/items/spectre/spectre_arcana/spectre_arcana_v2_weapon_ambient.vpcf",
		},
	},
};