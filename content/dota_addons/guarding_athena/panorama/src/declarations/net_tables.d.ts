declare interface CustomNetTableDeclarations {
	service: { [x: string]: any; };
	common: {
		settings: {
			is_local_host: boolean,
			is_in_tools_mode: 0 | 1,
			is_cheat_mode: 0 | 1,
			ATTRIBUTE_STRENGTH_ATTACK: number,
			ATTRIBUTE_STRENGTH_HP: number,
			ATTRIBUTE_STRENGTH_PHYSICAL_DAMAGE_PERCENT: number,
			ATTRIBUTE_AGILITY_ATTACK_SPEED: number,
			ATTRIBUTE_AGILITY_MOVE_SPEED: number,
			ATTRIBUTE_INTELLIGENCE_SPELL_AMPLIFY: number,
			ATTRIBUTE_INTELLIGENCE_MAGICAL_DAMAGE_PERCENT: number,
			ATTRIBUTE_INTELLIGENCE_MANA: number,
			PHYSICAL_ARMOR_FACTOR: number,
			MAGICAL_ARMOR_FACTOR: number,
			HERO_MAX_LEVEL: number,
			HERO_XP_PER_LEVEL_TABLE: Table;
			BUILDING_MAX_LEVEL: number,
			BUILDING_XP_PER_LEVEL_TABLE: Table,
			BASE_GOLD_COST: Table,
			BASE_INCOMES: Table,
		};

		enemy_hit_trigger_bounds: {
			[x: string]: {
				MinX: number,
				MinY: number,
				MaxX: number,
				MaxY: number,
			};
		};

		round_data: {
			round_number: number,
			prep_time_end: number,
			enemies_killed: Table,
			enemies_total: number,
			timed_round: number,
			timed_round_duration: number | undefined,
			timed_round_duration_end: number | undefined,
			timed_round_post_game: number | undefined,
			timed_round_post_game_end: number | undefined,
			teams_health: Table | undefined,
		};

		demo_settings: {
			free_spells: 0 | 1 | undefined,
			has_fog: 0 | 1 | undefined,
			lock_camera: 0 | 1 | undefined,
			unlock_mouse: 0 | 1 | undefined,
			creeps: 0 | 1 | undefined,
			free_building_order: 0 | 1 | undefined,
			base_invulnerability: 0 | 1 | undefined,
			game_time_frozen: 0 | 1 | undefined,
			enemy_controlable: 0 | 1 | undefined,
			projectile_debug_mode: 0 | 1 | undefined,
		};

		demo_round_info: {
			[x: string]: {
				round_title: string,
				round_description: string,
			};
		};
	};
	header: any;
}