GameUI.CustomUIConfig().NaturesKv = {
	"kobold": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_kobold/kobold_c/n_creep_kobold_frost.vmdl",
		"ModelScale": 1.2,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 200,
		"BountyGoldMin": 80,
		"BountyGoldMax": 80,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 2000,
		"StatusHealthRegen": 50,
		"StatusMana": 1000,
		"StatusManaRegen": 10,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 300,
		"AttackDamageMax": 500,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 5,
		"MagicalResistance": 5,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_BASIC",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
	},
	"kobold_lord": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_kobold/kobold_a/n_creep_kobold_a.vmdl",
		"ModelScale": 1.2,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 600,
		"BountyGoldMin": 200,
		"BountyGoldMax": 200,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 10000,
		"StatusHealthRegen": 50,
		"StatusMana": 1000,
		"StatusManaRegen": 10,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 1200,
		"AttackDamageMax": 2000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 10,
		"MagicalResistance": 20,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_BASIC",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "hell_beast_aura",
	},
	"beast": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_beast/n_creep_beast.vmdl",
		"ModelScale": 1,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 600,
		"BountyGoldMin": 100,
		"BountyGoldMax": 100,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 4000,
		"StatusHealthRegen": 80,
		"StatusMana": 2000,
		"StatusManaRegen": 20,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 700,
		"AttackDamageMax": 900,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 15,
		"MagicalResistance": 15,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_BASIC",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
	},
	"hell_beast": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl",
		"ModelScale": 1.2,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 4000,
		"BountyGoldMin": 400,
		"BountyGoldMax": 400,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 8000,
		"StatusHealthRegen": 50,
		"StatusMana": 1000,
		"StatusManaRegen": 10,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 1200,
		"AttackDamageMax": 2000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 10,
		"MagicalResistance": 20,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 0,
		"UseNeutralCreepBehavior": 0,
		"Ability1": "boss_beat",
	},
	"ancient_golem": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl",
		"ModelScale": 1.6,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 10000,
		"BountyGoldMin": 1000,
		"BountyGoldMax": 1000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 100000,
		"StatusHealthRegen": 500,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 2000,
		"AttackDamageMax": 3000,
		"AttackRate": 3,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 40,
		"MagicalResistance": 0,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss_stone",
	},
	"ogre": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl",
		"ModelScale": 1,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 3000,
		"BountyGoldMin": 500,
		"BountyGoldMax": 500,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 10000,
		"StatusHealthRegen": 10,
		"StatusMana": 500,
		"StatusManaRegen": 5,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 1200,
		"AttackDamageMax": 1500,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 100,
		"ArmorPhysical": 20,
		"MagicalResistance": 20,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_BASIC",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
	},
	"boss_ogre": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/ogre_1/boss_ogre.vmdl",
		"ModelScale": 2.1,
		"Level": 20,
		"HealthBarOffset": 360,
		"BountyXP": 8000,
		"BountyGoldMin": 1200,
		"BountyGoldMax": 1200,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 325,
		"MovementTurnRate": 0.5,
		"StatusHealth": 100000,
		"StatusHealthRegen": 100,
		"StatusMana": 5000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 6400,
		"AttackDamageMax": 9000,
		"AttackRate": 2.8,
		"AttackAnimationPoint": 0.3,
		"AttackAcquisitionRange": 300,
		"AttackRange": 256,
		"ArmorPhysical": 40,
		"MagicalResistance": 0,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 0,
		"UseNeutralCreepBehavior": 0,
		"Ability1": "ogre_strike",
		"Ability2": "ogre_jump_strike",
	},
	"dog": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/life_stealer/life_stealer.vmdl",
		"ModelScale": 1,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 2000,
		"BountyGoldMin": 400,
		"BountyGoldMax": 400,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 20000,
		"StatusHealthRegen": 200,
		"StatusMana": 1000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 1000,
		"AttackDamageMax": 1000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 100,
		"ArmorPhysical": 10,
		"MagicalResistance": 20,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_BASIC",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dog_wound",
	},
	"boss_dog": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/life_stealer/life_stealer.vmdl",
		"ModelScale": 1.4,
		"Level": 20,
		"HealthBarOffset": 400,
		"BountyXP": 6000,
		"BountyGoldMin": 600,
		"BountyGoldMax": 600,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 325,
		"MovementTurnRate": 0.5,
		"StatusHealth": 40000,
		"StatusHealthRegen": 400,
		"StatusMana": 5000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 2000,
		"AttackDamageMax": 2000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 100,
		"ArmorPhysical": 20,
		"MagicalResistance": 40,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dog_wound",
		"Ability2": "boss_rage",
		"Wearable1": 6463,
		"Wearable2": 6477,
		"Wearable3": 9199,
	},
	"dragon_1": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl",
		"ModelScale": 1,
		"Level": 20,
		"HealthBarOffset": -1,
		"BountyXP": 3000,
		"BountyGoldMin": 300,
		"BountyGoldMax": 300,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 60000,
		"StatusHealthRegen": 600,
		"StatusMana": 6000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 3000,
		"AttackDamageMax": 3000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 600,
		"ProjectileModel": "particles/base_attacks/ranged_badguy.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 30,
		"MagicalResistance": 30,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dragon_energy_ball",
	},
	"dragon_2": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl",
		"ModelScale": 1.2,
		"Level": 20,
		"HealthBarOffset": -1,
		"BountyXP": 4000,
		"BountyGoldMin": 400,
		"BountyGoldMax": 400,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 80000,
		"StatusHealthRegen": 800,
		"StatusMana": 8000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 4000,
		"AttackDamageMax": 4000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 600,
		"ProjectileModel": "particles/base_attacks/ranged_badguy.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 35,
		"MagicalResistance": 35,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dragon_energy_ball",
	},
	"dragon_3": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl",
		"ModelScale": 1.4,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 5000,
		"BountyGoldMin": 500,
		"BountyGoldMax": 500,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 100000,
		"StatusHealthRegen": 1000,
		"StatusMana": 1000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 5000,
		"AttackDamageMax": 5000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 600,
		"ProjectileModel": "particles/base_attacks/ranged_badguy.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 40,
		"MagicalResistance": 40,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dragon_energy_ball",
	},
	"zombie_stand": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/lane_creeps/creep_bad_melee_diretide/creep_bad_melee_diretide.vmdl",
		"ModelScale": 1.4,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 2500,
		"BountyGoldMin": 800,
		"BountyGoldMax": 800,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 50000,
		"StatusHealthRegen": 1000,
		"StatusMana": 1000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 5000,
		"AttackDamageMax": 5000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 125,
		"ArmorPhysical": 40,
		"MagicalResistance": 40,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dragon_energy_ball",
	},
	"zombie_disable": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/creeps/lane_creeps/creep_bad_ranged_diretide/creep_bad_ranged_diretide.vmdl",
		"ModelScale": 1.4,
		"Level": 10,
		"HealthBarOffset": -1,
		"BountyXP": 3000,
		"BountyGoldMin": 800,
		"BountyGoldMax": 800,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 300,
		"MovementTurnRate": 0.5,
		"StatusHealth": 50000,
		"StatusHealthRegen": 1000,
		"StatusMana": 1000,
		"StatusManaRegen": 50,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 5000,
		"AttackDamageMax": 5000,
		"AttackRate": 1.6,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 200,
		"AttackRange": 600,
		"ProjectileModel": "particles/base_attacks/ranged_badguy.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 40,
		"MagicalResistance": 40,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_creep",
		"MinimapIconSize": 200,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "dragon_energy_ball",
	},
	"boss_sandking": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/sand_king/sand_king.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 30000,
		"BountyGoldMin": 2500,
		"BountyGoldMax": 3500,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 325,
		"MovementTurnRate": 0.5,
		"StatusHealth": 800000,
		"StatusHealthRegen": 2000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 30000,
		"AttackDamageMax": 30000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 600,
		"AttackRange": 100,
		"ArmorPhysical": 50,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "boss_invisible",
		"Ability3": "boss_burrowstrike",
		"Ability4": "boss_epicenter",
		"Wearable1": 6610,
		"Wearable2": 6611,
		"Wearable3": 6612,
		"Wearable4": 6613,
		"Wearable5": 6614,
	},
	"boss_visage": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/visage/visage.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 2500,
		"BountyGoldMax": 3500,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 325,
		"MovementTurnRate": 0.5,
		"StatusHealth": 600000,
		"StatusHealthRegen": 2000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 20000,
		"AttackDamageMax": 20000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 600,
		"AttackRange": 100,
		"ProjectileModel": "particles/base_attacks/ranged_badguy.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 50,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "boss_soulbody",
		"Ability3": "boss_soulconnect",
		"Ability4": "boss_soulclash",
		"Wearable1": 7997,
		"Wearable2": 9051,
	},
	"boss_fire_demon": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 50000,
		"BountyGoldMin": 4000,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 325,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 500,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 50000,
		"AttackDamageMax": 50000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 600,
		"AttackRange": 100,
		"ArmorPhysical": 60,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "boss_fire_stun",
		"Ability3": "boss_fire_land",
		"Ability4": "boss_fire_reborn",
	},
	"boss_treant": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/treant_protector/treant_protector.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 280,
		"MovementTurnRate": 0.5,
		"StatusHealth": 400000,
		"StatusHealthRegen": 500,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 12000,
		"AttackDamageMax": 12000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 600,
		"AttackRange": 200,
		"ArmorPhysical": 40,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "boss_absorb",
		"Ability3": "boss_green_protect",
		"Ability4": "boss_overgrowth",
		"Wearable1": 9898,
		"Wearable2": 9899,
		"Wearable3": 9900,
		"Wearable4": 9901,
	},
	"boss_clotho": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/enchantress/enchantress.vmdl",
		"ModelScale": 1.4,
		"Level": 1,
		"HealthBarOffset": 400,
		"BountyXP": 10000,
		"BountyGoldMin": 1000,
		"BountyGoldMax": 1000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 280,
		"MovementTurnRate": 0.5,
		"StatusHealth": 100000,
		"StatusHealthRegen": 500,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 2000,
		"AttackDamageMax": 2000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 900,
		"AttackRange": 900,
		"ProjectileModel": "particles/units/heroes/hero_enchantress/enchantress_impetus.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 20,
		"MagicalResistance": 5,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "boss_untouchable",
		"Ability3": "hit_back",
		"Wearable1": 4678,
		"Wearable2": 6857,
		"Wearable3": 4787,
		"Wearable4": 4676,
		"Wearable5": 7459,
	},
	"boss_iapetos": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/obsidian_destroyer/obsidian_destroyer.vmdl",
		"ModelScale": 1.4,
		"Level": 1,
		"HealthBarOffset": 400,
		"BountyXP": 10000,
		"BountyGoldMin": 1000,
		"BountyGoldMax": 1000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 280,
		"MovementTurnRate": 0.5,
		"StatusHealth": 500000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_RANGED_ATTACK",
		"AttackDamageMin": 25000,
		"AttackDamageMax": 30000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 900,
		"AttackRange": 900,
		"ProjectileModel": "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_arcane_orb.vpcf",
		"ProjectileSpeed": 900,
		"ArmorPhysical": 50,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_ancient",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"IsNeutralUnitType": 1,
		"UseNeutralCreepBehavior": 1,
		"Ability1": "boss",
		"Ability2": "arcane_attack",
		"Ability3": "original_crash",
		"Ability4": "boss_clear",
		"Wearable1": 9367,
		"Wearable2": 9795,
		"Wearable3": 8376,
		"Wearable4": 9370,
	},
	"boss_chaos_demon_1": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/heroes/warlock/warlock_demon.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 40000,
		"AttackDamageMax": 40000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 100,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
	"boss_chaos_demon_2": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/tevent_2_gatekeeper_golem/tevent_2_gatekeeper_golem.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 50000,
		"AttackDamageMax": 50000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 200,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
	"boss_chaos_demon_3": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/doom_of_ithogoaki/doom_of_ithogoaki.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 60000,
		"AttackDamageMax": 60000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 200,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
	"boss_chaos_demon_4": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/obsidian_golem/obsidian_golem.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 70000,
		"AttackDamageMax": 70000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 200,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
	"boss_chaos_demon_5": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/ahmhedoq/ahmhedoq.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 80000,
		"AttackDamageMax": 80000,
		"AttackRate": 1.4,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 200,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
	"boss_chaos_demon_6": {
		"BaseClass": "npc_dota_creature",
		"Model": "models/items/warlock/golem/grimoires_pitlord_ultimate/grimoires_pitlord_ultimate.vmdl",
		"ModelScale": 1.4,
		"Level": 30,
		"HealthBarOffset": 400,
		"BountyXP": 40000,
		"BountyGoldMin": 3500,
		"BountyGoldMax": 4000,
		"BoundsHullName": "DOTA_HULL_SIZE_REGULAR",
		"MovementCapabilities": "DOTA_UNIT_CAP_MOVE_GROUND",
		"MovementSpeed": 340,
		"MovementTurnRate": 0.5,
		"StatusHealth": 1000000,
		"StatusHealthRegen": 5000,
		"StatusMana": 10000,
		"StatusManaRegen": 100,
		"AttackCapabilities": "DOTA_UNIT_CAP_MELEE_ATTACK",
		"AttackDamageMin": 80000,
		"AttackDamageMax": 80000,
		"AttackRate": 1.2,
		"AttackAnimationPoint": 0.5,
		"AttackAcquisitionRange": 1500,
		"AttackRange": 250,
		"ArmorPhysical": 150,
		"MagicalResistance": 38,
		"CombatClassAttack": "DOTA_COMBAT_CLASS_ATTACK_HERO",
		"CombatClassDefend": "DOTA_COMBAT_CLASS_DEFEND_HERO",
		"MinimapIcon": "minimap_candybucket",
		"MinimapIconSize": 800,
		"IsAncient": 1,
		"Ability1": "boss",
		"Ability2": "boss_chaos_land",
		"Ability3": "boss_chaos_fall",
		"Ability4": "demon_sun_strike",
		"Ability5": "boss_hell_fist",
	},
};