/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type SteamUGCQuery = SteamUgcQuery;

declare enum SteamUgcQuery {
    RANKED_BY_VOTE = 0,
    RANKED_BY_PUBLICATION_DATE = 1,
    ACCEPTED_FOR_GAME_RANKED_BY_ACCEPTANCE_DATE = 2,
    RANKED_BY_TREND = 3,
    FAVORITED_BY_FRIENDS_RANKED_BY_PUBLICATION_DATE = 4,
    CREATED_BY_FRIENDS_RANKED_BY_PUBLICATION_DATE = 5,
    RANKED_BY_NUM_TIMES_REPORTED = 6,
    CREATED_BY_FOLLOWED_USERS_RANKED_BY_PUBLICATION_DATE = 7,
    NOT_YET_RATED = 8,
    RANKED_BY_TOTAL_VOTES_ASC = 9,
    RANKED_BY_VOTES_UP = 10,
    RANKED_BY_TEXT_SEARCH = 11,
    RANKED_BY_TOTAL_UNIQUE_SUBSCRIPTIONS = 12,
    RANKED_BY_PLAYTIME_TREND = 13,
    RANKED_BY_TOTAL_PLAYTIME = 14,
    RANKED_BY_AVERAGE_PLAYTIME_TREND = 15,
    RANKED_BY_LIFETIME_AVERAGE_PLAYTIME = 16,
    RANKED_BY_PLAYTIME_SESSIONS_TREND = 17,
    RANKED_BY_LIFETIME_PLAYTIME_SESSIONS = 18,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type SteamUGCMatchingUGCType = SteamUgcMatchingUgcType;

declare enum SteamUgcMatchingUgcType {
    ITEMS = 0,
    ITEMS_MTX = 1,
    ITEMS_READY_TO_USE = 2,
    COLLECTIONS = 3,
    ARTWORK = 4,
    VIDEOS = 5,
    SCREENSHOTS = 6,
    ALL_GUIDES = 7,
    WEB_GUIDES = 8,
    INTEGRATED_GUIDES = 9,
    USABLE_IN_GAME = 10,
    CONTROLLER_BINDINGS = 11,
    GAME_MANAGED_ITEMS = 12,
}

declare enum SteamUniverse {
    INVALID = 0,
    INTERNAL = 3,
    DEV = 4,
    BETA = 2,
    PUBLIC = 1,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_GameState = GameState;

declare enum GameState {
    INIT = 0,
    WAIT_FOR_PLAYERS_TO_LOAD = 1,
    HERO_SELECTION = 3,
    STRATEGY_TIME = 4,
    PRE_GAME = 7,
    GAME_IN_PROGRESS = 8,
    POST_GAME = 9,
    DISCONNECT = 10,
    TEAM_SHOWCASE = 5,
    CUSTOM_GAME_SETUP = 2,
    WAIT_FOR_MAP_TO_LOAD = 6,
    LAST = 0,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_GC_TEAM = GcTeam;

declare enum GcTeam {
    GOOD_GUYS = 0,
    BAD_GUYS = 1,
    BROADCASTER = 2,
    SPECTATOR = 3,
    PLAYER_POOL = 4,
    NOTEAM = 5,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAConnectionState_t = ConnectionState;

declare enum ConnectionState {
    UNKNOWN = 0,
    NOT_YET_CONNECTED = 1,
    CONNECTED = 2,
    DISCONNECTED = 3,
    ABANDONED = 4,
    LOADING = 5,
    FAILED = 6,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type dotaunitorder_t = UnitOrder;

declare enum UnitOrder {
    NONE = 0,
    MOVE_TO_POSITION = 1,
    MOVE_TO_TARGET = 2,
    ATTACK_MOVE = 3,
    ATTACK_TARGET = 4,
    CAST_POSITION = 5,
    CAST_TARGET = 6,
    CAST_TARGET_TREE = 7,
    CAST_NO_TARGET = 8,
    CAST_TOGGLE = 9,
    HOLD_POSITION = 10,
    TRAIN_ABILITY = 11,
    DROP_ITEM = 12,
    GIVE_ITEM = 13,
    PICKUP_ITEM = 14,
    PICKUP_RUNE = 15,
    PURCHASE_ITEM = 16,
    SELL_ITEM = 17,
    DISASSEMBLE_ITEM = 18,
    MOVE_ITEM = 19,
    CAST_TOGGLE_AUTO = 20,
    STOP = 21,
    TAUNT = 22,
    BUYBACK = 23,
    GLYPH = 24,
    EJECT_ITEM_FROM_STASH = 25,
    CAST_RUNE = 26,
    PING_ABILITY = 27,
    MOVE_TO_DIRECTION = 28,
    PATROL = 29,
    VECTOR_TARGET_POSITION = 30,
    RADAR = 31,
    SET_ITEM_COMBINE_LOCK = 32,
    CONTINUE = 33,
    VECTOR_TARGET_CANCELED = 34,
    CAST_RIVER_PAINT = 35,
    PREGAME_ADJUST_ITEM_ASSIGNMENT = 36,
    DROP_ITEM_AT_FOUNTAIN = 37,
    TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH = 38,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_OVERHEAD_ALERT = OverheadAlert;

declare enum OverheadAlert {
    GOLD = 0,
    DENY = 1,
    CRITICAL = 2,
    XP = 3,
    BONUS_SPELL_DAMAGE = 4,
    MISS = 5,
    DAMAGE = 6,
    EVADE = 7,
    BLOCK = 8,
    BONUS_POISON_DAMAGE = 9,
    HEAL = 10,
    MANA_ADD = 11,
    MANA_LOSS = 12,
    LAST_HIT_EARLY = 13,
    LAST_HIT_CLOSE = 14,
    LAST_HIT_MISS = 15,
    MAGICAL_BLOCK = 16,
    INCOMING_DAMAGE = 17,
    OUTGOING_DAMAGE = 18,
    DISABLE_RESIST = 19,
    DEATH = 20,
    BLOCKED = 21,
}

declare const DOTA_HEROPICK_STATE_COUNT: 61;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_HeroPickState = HeroPickState;

declare enum HeroPickState {
    NONE = 0,
    AP_SELECT = 1,
    SD_SELECT = 2,
    INTRO_SELECT_UNUSED = 3,
    RD_SELECT_UNUSED = 4,
    CM_INTRO = 5,
    CM_CAPTAINPICK = 6,
    CM_BAN1 = 7,
    CM_BAN2 = 8,
    CM_BAN3 = 9,
    CM_BAN4 = 10,
    CM_BAN5 = 11,
    CM_BAN6 = 12,
    CM_BAN7 = 13,
    CM_BAN8 = 14,
    CM_BAN9 = 15,
    CM_BAN10 = 16,
    CM_BAN11 = 17,
    CM_BAN12 = 18,
    CM_BAN13 = 19,
    CM_BAN14 = 20,
    CM_SELECT1 = 21,
    CM_SELECT2 = 22,
    CM_SELECT3 = 23,
    CM_SELECT4 = 24,
    CM_SELECT5 = 25,
    CM_SELECT6 = 26,
    CM_SELECT7 = 27,
    CM_SELECT8 = 28,
    CM_SELECT9 = 29,
    CM_SELECT10 = 30,
    CM_PICK = 31,
    AR_SELECT = 32,
    MO_SELECT = 33,
    FH_SELECT = 34,
    CD_INTRO = 35,
    CD_CAPTAINPICK = 36,
    CD_BAN1 = 37,
    CD_BAN2 = 38,
    CD_BAN3 = 39,
    CD_BAN4 = 40,
    CD_BAN5 = 41,
    CD_BAN6 = 42,
    CD_SELECT1 = 43,
    CD_SELECT2 = 44,
    CD_SELECT3 = 45,
    CD_SELECT4 = 46,
    CD_SELECT5 = 47,
    CD_SELECT6 = 48,
    CD_SELECT7 = 49,
    CD_SELECT8 = 50,
    CD_SELECT9 = 51,
    CD_SELECT10 = 52,
    CD_PICK = 53,
    BD_SELECT = 54,
    ABILITY_DRAFT_SELECT = 55,
    ARDM_SELECT = 56,
    ALL_DRAFT_SELECT = 57,
    CUSTOMGAME_SELECT = 58,
    SELECT_PENALTY = 59,
    CUSTOM_PICK_RULES = 60,
}

declare const DOTA_TEAM_FIRST: 2;

declare const DOTA_TEAM_COUNT: 14;

declare const DOTA_TEAM_CUSTOM_MIN: 6;

declare const DOTA_TEAM_CUSTOM_MAX: 13;

declare const DOTA_TEAM_CUSTOM_COUNT: 8;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTATeam_t = DotaTeam;

declare enum DotaTeam {
    GOODGUYS = 2,
    BADGUYS = 3,
    NEUTRALS = 4,
    NOTEAM = 5,
    CUSTOM_1 = 6,
    CUSTOM_2 = 7,
    CUSTOM_3 = 8,
    CUSTOM_4 = 9,
    CUSTOM_5 = 10,
    CUSTOM_6 = 11,
    CUSTOM_7 = 12,
    CUSTOM_8 = 13,
}

declare const DOTA_RUNE_COUNT: 8;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_RUNES = RuneType;

declare enum RuneType {
    DOUBLEDAMAGE = 0,
    HASTE = 1,
    ILLUSION = 2,
    INVISIBILITY = 3,
    REGENERATION = 4,
    BOUNTY = 5,
    ARCANE = 6,
    XP = 7,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_UNIT_TARGET_TEAM = UnitTargetTeam;

declare enum UnitTargetTeam {
    NONE = 0,
    FRIENDLY = 1,
    ENEMY = 2,
    CUSTOM = 4,
    BOTH = 3,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_UNIT_TARGET_TYPE = UnitTargetType;

declare enum UnitTargetType {
    NONE = 0,
    HERO = 1,
    CREEP = 2,
    BUILDING = 4,
    COURIER = 16,
    OTHER = 32,
    TREE = 64,
    CUSTOM = 128,
    BASIC = 18,
    ALL = 55,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_UNIT_TARGET_FLAGS = UnitTargetFlags;

declare enum UnitTargetFlags {
    NONE = 0,
    RANGED_ONLY = 2,
    MELEE_ONLY = 4,
    DEAD = 8,
    MAGIC_IMMUNE_ENEMIES = 16,
    NOT_MAGIC_IMMUNE_ALLIES = 32,
    INVULNERABLE = 64,
    FOW_VISIBLE = 128,
    NO_INVIS = 256,
    NOT_ANCIENTS = 512,
    PLAYER_CONTROLLED = 1024,
    NOT_DOMINATED = 2048,
    NOT_SUMMONED = 4096,
    NOT_ILLUSIONS = 8192,
    NOT_ATTACK_IMMUNE = 16384,
    MANA_ONLY = 32768,
    CHECK_DISABLE_HELP = 65536,
    NOT_CREEP_HERO = 131072,
    OUT_OF_WORLD = 262144,
    NOT_NIGHTMARED = 524288,
    PREFER_ENEMIES = 1048576,
    RESPECT_OBSTRUCTIONS = 2097152,
}

/**
 * Max number of players connected to the server including spectators.
 */
declare const DOTA_MAX_PLAYERS: 64;

/**
 * Max number of players per team.
 */
declare const DOTA_MAX_TEAM: 24;

/**
 * Max number of player teams supported.
 */
declare const DOTA_MAX_PLAYER_TEAMS: 10;

/**
 * Max number of non-spectator players supported.
 */
declare const DOTA_MAX_TEAM_PLAYERS: 24;

/**
 * How many spectators can watch.
 */
declare const DOTA_MAX_SPECTATOR_TEAM_SIZE: 40;

/**
 * Max number of viewers in a spectator lobby.
 */
declare const DOTA_MAX_SPECTATOR_LOBBY_SIZE: 15;

/**
 * Default number of players per team.
 */
declare const DOTA_DEFAULT_MAX_TEAM: 5;

/**
 * Default number of non-spectator players supported.
 */
declare const DOTA_DEFAULT_MAX_TEAM_PLAYERS: 10;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAInventoryFlags_t = InventoryFlags;

declare enum InventoryFlags {
    ALLOW_NONE = 0,
    ALLOW_MAIN = 1,
    ALLOW_STASH = 2,
    ALLOW_DROP_ON_GROUND = 4,
    ALLOW_DROP_AT_FOUNTAIN = 8,
    LIMIT_DROP_ON_GROUND = 16,
    ALL_ACCESS = 3,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type EDOTA_ModifyGold_Reason = ModifyGoldReason;

declare enum ModifyGoldReason {
    UNSPECIFIED = 0,
    DEATH = 1,
    BUYBACK = 2,
    PURCHASE_CONSUMABLE = 3,
    PURCHASE_ITEM = 4,
    ABANDONED_REDISTRIBUTE = 5,
    SELL_ITEM = 6,
    ABILITY_COST = 7,
    CHEAT_COMMAND = 8,
    SELECTION_PENALTY = 9,
    GAME_TICK = 10,
    BUILDING = 11,
    HERO_KILL = 12,
    CREEP_KILL = 13,
    NEUTRAL_KILL = 14,
    ROSHAN_KILL = 15,
    COURIER_KILL = 16,
    BOUNTY_RUNE = 17,
    SHARED_GOLD = 18,
    ABILITY_GOLD = 19,
    WARD_KILL = 20,
}

declare const DOTA_UNIT_ATTACK_CAPABILITY_BIT_COUNT: 3;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAUnitAttackCapability_t = UnitAttackCapability;

declare enum UnitAttackCapability {
    NO_ATTACK = 0,
    MELEE_ATTACK = 1,
    RANGED_ATTACK = 2,
    RANGED_ATTACK_DIRECTIONAL = 4,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAUnitMoveCapability_t = UnitMoveCapability;

declare enum UnitMoveCapability {
    NONE = 0,
    GROUND = 1,
    FLY = 2,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type EShareAbility = ItemShareability;

declare enum ItemShareability {
    FULLY_SHAREABLE = 0,
    PARTIALLY_SHAREABLE = 1,
    NOT_SHAREABLE = 2,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAMusicStatus_t = MusicStatus;

declare enum MusicStatus {
    NONE = 0,
    EXPLORATION = 1,
    BATTLE = 2,
    PRE_GAME_EXPLORATION = 3,
    DEAD = 4,
    LAST = 5,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_ABILITY_BEHAVIOR = AbilityBehavior;

declare enum AbilityBehavior {
    NONE = 0,
    HIDDEN = 1,
    PASSIVE = 2,
    NO_TARGET = 4,
    UNIT_TARGET = 8,
    POINT = 16,
    AOE = 32,
    NOT_LEARNABLE = 64,
    CHANNELLED = 128,
    ITEM = 256,
    TOGGLE = 512,
    DIRECTIONAL = 1024,
    IMMEDIATE = 2048,
    AUTOCAST = 4096,
    OPTIONAL_UNIT_TARGET = 8192,
    OPTIONAL_POINT = 16384,
    OPTIONAL_NO_TARGET = 32768,
    AURA = 65536,
    ATTACK = 131072,
    DONT_RESUME_MOVEMENT = 262144,
    ROOT_DISABLES = 524288,
    UNRESTRICTED = 1048576,
    IGNORE_PSEUDO_QUEUE = 2097152,
    IGNORE_CHANNEL = 4194304,
    DONT_CANCEL_MOVEMENT = 8388608,
    DONT_ALERT_TARGET = 16777216,
    DONT_RESUME_ATTACK = 33554432,
    NORMAL_WHEN_STOLEN = 67108864,
    IGNORE_BACKSWING = 134217728,
    RUNE_TARGET = 268435456,
    DONT_CANCEL_CHANNEL = 536870912,
    VECTOR_TARGETING = 1073741824,
    LAST_RESORT_POINT = 2147483648,
    CAN_SELF_CAST = 4294967296,
    SHOW_IN_GUIDES = 8589934592,
    UNLOCKED_BY_EFFECT_INDEX = 17179869184,
    SUPPRESS_ASSOCIATED_CONSUMABLE = 34359738368,
    FREE_DRAW_TARGETING = 68719476736,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DAMAGE_TYPES = DamageTypes;

declare enum DamageTypes {
    NONE = 0,
    PHYSICAL = 1,
    MAGICAL = 2,
    PURE = 4,
    HP_REMOVAL = 8,
    ALL = 7,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type ABILITY_TYPES = AbilityTypes;

declare enum AbilityTypes {
    BASIC = 0,
    ULTIMATE = 1,
    ATTRIBUTES = 2,
    HIDDEN = 3,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type SPELL_IMMUNITY_TYPES = SpellImmunityTypes;

declare enum SpellImmunityTypes {
    NONE = 0,
    ALLIES_YES = 1,
    ALLIES_NO = 2,
    ENEMIES_YES = 3,
    ENEMIES_NO = 4,
    ALLIES_YES_ENEMIES_NO = 5,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTADamageFlag_t = DamageFlag;

declare enum DamageFlag {
    NONE = 0,
    IGNORES_MAGIC_ARMOR = 1,
    IGNORES_PHYSICAL_ARMOR = 2,
    BYPASSES_INVULNERABILITY = 4,
    BYPASSES_BLOCK = 8,
    REFLECTION = 16,
    HPLOSS = 32,
    NO_DIRECTOR_EVENT = 64,
    NON_LETHAL = 128,
    USE_COMBAT_PROFICIENCY = 256,
    NO_DAMAGE_MULTIPLIERS = 512,
    NO_SPELL_AMPLIFICATION = 1024,
    DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN = 2048,
    NO_SPELL_LIFESTEAL = 4096,
    PROPERTY_FIRE = 8192,
    IGNORES_BASE_PHYSICAL_ARMOR = 16384,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type EDOTA_ModifyXP_Reason = ModifyXpReason;

declare enum ModifyXpReason {
    UNSPECIFIED = 0,
    HERO_KILL = 1,
    CREEP_KILL = 2,
    ROSHAN_KILL = 3,
    TOME_OF_KNOWLEDGE = 4,
    OUTPOST = 5,
    MAX = 6,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type GameActivity_t = GameActivity;

declare enum GameActivity {
    DOTA_IDLE = 1500,
    DOTA_IDLE_RARE = 1501,
    DOTA_RUN = 1502,
    DOTA_ATTACK = 1503,
    DOTA_ATTACK_2 = 1504,
    DOTA_ATTACK_EVENT = 1505,
    DOTA_DIE = 1506,
    DOTA_FLINCH = 1507,
    DOTA_FLAIL = 1508,
    DOTA_DISABLED = 1509,
    DOTA_CAST_ABILITY_1 = 1510,
    DOTA_CAST_ABILITY_2 = 1511,
    DOTA_CAST_ABILITY_3 = 1512,
    DOTA_CAST_ABILITY_4 = 1513,
    DOTA_CAST_ABILITY_5 = 1514,
    DOTA_CAST_ABILITY_6 = 1515,
    DOTA_OVERRIDE_ABILITY_1 = 1516,
    DOTA_OVERRIDE_ABILITY_2 = 1517,
    DOTA_OVERRIDE_ABILITY_3 = 1518,
    DOTA_OVERRIDE_ABILITY_4 = 1519,
    DOTA_CHANNEL_ABILITY_1 = 1520,
    DOTA_CHANNEL_ABILITY_2 = 1521,
    DOTA_CHANNEL_ABILITY_3 = 1522,
    DOTA_CHANNEL_ABILITY_4 = 1523,
    DOTA_CHANNEL_ABILITY_5 = 1524,
    DOTA_CHANNEL_ABILITY_6 = 1525,
    DOTA_CHANNEL_END_ABILITY_1 = 1526,
    DOTA_CHANNEL_END_ABILITY_2 = 1527,
    DOTA_CHANNEL_END_ABILITY_3 = 1528,
    DOTA_CHANNEL_END_ABILITY_4 = 1529,
    DOTA_CHANNEL_END_ABILITY_5 = 1530,
    DOTA_CHANNEL_END_ABILITY_6 = 1531,
    DOTA_CONSTANT_LAYER = 1532,
    DOTA_CAPTURE = 1533,
    DOTA_SPAWN = 1534,
    DOTA_KILLTAUNT = 1535,
    DOTA_TAUNT = 1536,
    DOTA_THIRST = 1537,
    DOTA_CAST_DRAGONBREATH = 1538,
    DOTA_ECHO_SLAM = 1539,
    DOTA_CAST_ABILITY_1_END = 1540,
    DOTA_CAST_ABILITY_2_END = 1541,
    DOTA_CAST_ABILITY_3_END = 1542,
    DOTA_CAST_ABILITY_4_END = 1543,
    MIRANA_LEAP_END = 1544,
    WAVEFORM_START = 1545,
    WAVEFORM_END = 1546,
    DOTA_CAST_ABILITY_ROT = 1547,
    DOTA_DIE_SPECIAL = 1548,
    DOTA_RATTLETRAP_BATTERYASSAULT = 1549,
    DOTA_RATTLETRAP_POWERCOGS = 1550,
    DOTA_RATTLETRAP_HOOKSHOT_START = 1551,
    DOTA_RATTLETRAP_HOOKSHOT_LOOP = 1552,
    DOTA_RATTLETRAP_HOOKSHOT_END = 1553,
    STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE = 1554,
    DOTA_TINKER_REARM_1 = 1555,
    DOTA_TINKER_REARM_2 = 1556,
    DOTA_TINKER_REARM_3 = 1557,
    TINY_AVALANCHE = 1558,
    TINY_TOSS = 1559,
    TINY_GROWL = 1560,
    DOTA_WEAVERBUG_ATTACH = 1561,
    DOTA_CAST_WILD_AXES_END = 1562,
    DOTA_CAST_LIFE_BREAK_START = 1563,
    DOTA_CAST_LIFE_BREAK_END = 1564,
    DOTA_NIGHTSTALKER_TRANSITION = 1565,
    DOTA_LIFESTEALER_RAGE = 1566,
    DOTA_LIFESTEALER_OPEN_WOUNDS = 1567,
    DOTA_SAND_KING_BURROW_IN = 1568,
    DOTA_SAND_KING_BURROW_OUT = 1569,
    DOTA_EARTHSHAKER_TOTEM_ATTACK = 1570,
    DOTA_WHEEL_LAYER = 1571,
    DOTA_ALCHEMIST_CHEMICAL_RAGE_START = 1572,
    DOTA_ALCHEMIST_CONCOCTION = 1573,
    DOTA_JAKIRO_LIQUIDFIRE_START = 1574,
    DOTA_JAKIRO_LIQUIDFIRE_LOOP = 1575,
    DOTA_LIFESTEALER_INFEST = 1576,
    DOTA_LIFESTEALER_INFEST_END = 1577,
    DOTA_LASSO_LOOP = 1578,
    DOTA_ALCHEMIST_CONCOCTION_THROW = 1579,
    DOTA_ALCHEMIST_CHEMICAL_RAGE_END = 1580,
    DOTA_CAST_COLD_SNAP = 1581,
    DOTA_CAST_GHOST_WALK = 1582,
    DOTA_CAST_TORNADO = 1583,
    DOTA_CAST_EMP = 1584,
    DOTA_CAST_ALACRITY = 1585,
    DOTA_CAST_CHAOS_METEOR = 1586,
    DOTA_CAST_SUN_STRIKE = 1587,
    DOTA_CAST_FORGE_SPIRIT = 1588,
    DOTA_CAST_ICE_WALL = 1589,
    DOTA_CAST_DEAFENING_BLAST = 1590,
    DOTA_VICTORY = 1591,
    DOTA_DEFEAT = 1592,
    DOTA_SPIRIT_BREAKER_CHARGE_POSE = 1593,
    DOTA_SPIRIT_BREAKER_CHARGE_END = 1594,
    DOTA_TELEPORT = 1595,
    DOTA_TELEPORT_END = 1596,
    DOTA_CAST_REFRACTION = 1597,
    DOTA_CAST_ABILITY_7 = 1598,
    DOTA_CANCEL_SIREN_SONG = 1599,
    DOTA_CHANNEL_ABILITY_7 = 1600,
    DOTA_LOADOUT = 1601,
    DOTA_FORCESTAFF_END = 1602,
    DOTA_POOF_END = 1603,
    DOTA_SLARK_POUNCE = 1604,
    DOTA_MAGNUS_SKEWER_START = 1605,
    DOTA_MAGNUS_SKEWER_END = 1606,
    DOTA_MEDUSA_STONE_GAZE = 1607,
    DOTA_RELAX_START = 1608,
    DOTA_RELAX_LOOP = 1609,
    DOTA_RELAX_END = 1610,
    DOTA_CENTAUR_STAMPEDE = 1611,
    DOTA_BELLYACHE_START = 1612,
    DOTA_BELLYACHE_LOOP = 1613,
    DOTA_BELLYACHE_END = 1614,
    DOTA_ROQUELAIRE_LAND = 1615,
    DOTA_ROQUELAIRE_LAND_IDLE = 1616,
    DOTA_GREEVIL_CAST = 1617,
    DOTA_GREEVIL_OVERRIDE_ABILITY = 1618,
    DOTA_GREEVIL_HOOK_START = 1619,
    DOTA_GREEVIL_HOOK_END = 1620,
    DOTA_GREEVIL_BLINK_BONE = 1621,
    DOTA_IDLE_SLEEPING = 1622,
    DOTA_INTRO = 1623,
    DOTA_GESTURE_POINT = 1624,
    DOTA_GESTURE_ACCENT = 1625,
    DOTA_SLEEPING_END = 1626,
    DOTA_AMBUSH = 1627,
    DOTA_ITEM_LOOK = 1628,
    DOTA_STARTLE = 1629,
    DOTA_FRUSTRATION = 1630,
    DOTA_TELEPORT_REACT = 1631,
    DOTA_TELEPORT_END_REACT = 1632,
    DOTA_SHRUG = 1633,
    DOTA_RELAX_LOOP_END = 1634,
    DOTA_PRESENT_ITEM = 1635,
    DOTA_IDLE_IMPATIENT = 1636,
    DOTA_SHARPEN_WEAPON = 1637,
    DOTA_SHARPEN_WEAPON_OUT = 1638,
    DOTA_IDLE_SLEEPING_END = 1639,
    DOTA_BRIDGE_DESTROY = 1640,
    DOTA_TAUNT_SNIPER = 1641,
    DOTA_DEATH_BY_SNIPER = 1642,
    DOTA_LOOK_AROUND = 1643,
    DOTA_CAGED_CREEP_RAGE = 1644,
    DOTA_CAGED_CREEP_RAGE_OUT = 1645,
    DOTA_CAGED_CREEP_SMASH = 1646,
    DOTA_CAGED_CREEP_SMASH_OUT = 1647,
    DOTA_IDLE_IMPATIENT_SWORD_TAP = 1648,
    DOTA_INTRO_LOOP = 1649,
    DOTA_BRIDGE_THREAT = 1650,
    DOTA_DAGON = 1651,
    DOTA_CAST_ABILITY_2_ES_ROLL_START = 1652,
    DOTA_CAST_ABILITY_2_ES_ROLL = 1653,
    DOTA_CAST_ABILITY_2_ES_ROLL_END = 1654,
    DOTA_NIAN_PIN_START = 1655,
    DOTA_NIAN_PIN_LOOP = 1656,
    DOTA_NIAN_PIN_END = 1657,
    DOTA_LEAP_STUN = 1658,
    DOTA_LEAP_SWIPE = 1659,
    DOTA_NIAN_INTRO_LEAP = 1660,
    DOTA_AREA_DENY = 1661,
    DOTA_NIAN_PIN_TO_STUN = 1662,
    DOTA_RAZE_1 = 1663,
    DOTA_RAZE_2 = 1664,
    DOTA_RAZE_3 = 1665,
    DOTA_UNDYING_DECAY = 1666,
    DOTA_UNDYING_SOUL_RIP = 1667,
    DOTA_UNDYING_TOMBSTONE = 1668,
    DOTA_WHIRLING_AXES_RANGED = 1669,
    DOTA_SHALLOW_GRAVE = 1670,
    DOTA_COLD_FEET = 1671,
    DOTA_ICE_VORTEX = 1672,
    DOTA_CHILLING_TOUCH = 1673,
    DOTA_ENFEEBLE = 1674,
    DOTA_FATAL_BONDS = 1675,
    DOTA_MIDNIGHT_PULSE = 1676,
    DOTA_ANCESTRAL_SPIRIT = 1677,
    DOTA_THUNDER_STRIKE = 1678,
    DOTA_KINETIC_FIELD = 1679,
    DOTA_STATIC_STORM = 1680,
    DOTA_MINI_TAUNT = 1681,
    DOTA_ARCTIC_BURN_END = 1682,
    DOTA_LOADOUT_RARE = 1683,
    DOTA_SWIM = 1684,
    DOTA_FLEE = 1685,
    DOTA_TROT = 1686,
    DOTA_SHAKE = 1687,
    DOTA_SWIM_IDLE = 1688,
    DOTA_WAIT_IDLE = 1689,
    DOTA_GREET = 1690,
    DOTA_TELEPORT_COOP_START = 1691,
    DOTA_TELEPORT_COOP_WAIT = 1692,
    DOTA_TELEPORT_COOP_END = 1693,
    DOTA_TELEPORT_COOP_EXIT = 1694,
    DOTA_SHOPKEEPER_PET_INTERACT = 1695,
    DOTA_ITEM_PICKUP = 1696,
    DOTA_ITEM_DROP = 1697,
    DOTA_CAPTURE_PET = 1698,
    DOTA_PET_WARD_OBSERVER = 1699,
    DOTA_PET_WARD_SENTRY = 1700,
    DOTA_PET_LEVEL = 1701,
    DOTA_CAST_BURROW_END = 1702,
    DOTA_LIFESTEALER_ASSIMILATE = 1703,
    DOTA_LIFESTEALER_EJECT = 1704,
    DOTA_ATTACK_EVENT_BASH = 1705,
    DOTA_CAPTURE_RARE = 1706,
    DOTA_AW_MAGNETIC_FIELD = 1707,
    DOTA_CAST_GHOST_SHIP = 1708,
    DOTA_FXANIM = 1709,
    DOTA_VICTORY_START = 1710,
    DOTA_DEFEAT_START = 1711,
    DOTA_DP_SPIRIT_SIPHON = 1712,
    DOTA_TRICKS_END = 1713,
    DOTA_ES_STONE_CALLER = 1714,
    DOTA_MK_STRIKE = 1715,
    DOTA_VERSUS = 1716,
    DOTA_CAPTURE_CARD = 1717,
    DOTA_MK_SPRING_SOAR = 1718,
    DOTA_MK_SPRING_END = 1719,
    DOTA_MK_TREE_SOAR = 1720,
    DOTA_MK_TREE_END = 1721,
    DOTA_MK_FUR_ARMY = 1722,
    DOTA_MK_SPRING_CAST = 1723,
    DOTA_NECRO_GHOST_SHROUD = 1724,
    DOTA_OVERRIDE_ARCANA = 1725,
    DOTA_SLIDE = 1726,
    DOTA_SLIDE_LOOP = 1727,
    DOTA_GENERIC_CHANNEL_1 = 1728,
    DOTA_GS_SOUL_CHAIN = 1729,
    DOTA_GS_INK_CREATURE = 1730,
    DOTA_TRANSITION = 1731,
    DOTA_BLINK_DAGGER = 1732,
    DOTA_BLINK_DAGGER_END = 1733,
    DOTA_CUSTOM_TOWER_ATTACK = 1734,
    DOTA_CUSTOM_TOWER_IDLE = 1735,
    DOTA_CUSTOM_TOWER_DIE = 1736,
    DOTA_CAST_COLD_SNAP_ORB = 1737,
    DOTA_CAST_GHOST_WALK_ORB = 1738,
    DOTA_CAST_TORNADO_ORB = 1739,
    DOTA_CAST_EMP_ORB = 1740,
    DOTA_CAST_ALACRITY_ORB = 1741,
    DOTA_CAST_CHAOS_METEOR_ORB = 1742,
    DOTA_CAST_SUN_STRIKE_ORB = 1743,
    DOTA_CAST_FORGE_SPIRIT_ORB = 1744,
    DOTA_CAST_ICE_WALL_ORB = 1745,
    DOTA_CAST_DEAFENING_BLAST_ORB = 1746,
    DOTA_NOTICE = 1747,
    DOTA_CAST_ABILITY_2_ALLY = 1748,
    DOTA_SHUFFLE_L = 1749,
    DOTA_SHUFFLE_R = 1750,
    DOTA_OVERRIDE_LOADOUT = 1751,
    DOTA_TAUNT_SPECIAL = 1752,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAMinimapEvent_t = MinimapEventType;

declare enum MinimapEventType {
    ANCIENT_UNDER_ATTACK = 2,
    BASE_UNDER_ATTACK = 4,
    BASE_GLYPHED = 8,
    TEAMMATE_UNDER_ATTACK = 16,
    TEAMMATE_TELEPORTING = 32,
    TEAMMATE_DIED = 64,
    TUTORIAL_TASK_ACTIVE = 128,
    TUTORIAL_TASK_FINISHED = 256,
    HINT_LOCATION = 512,
    ENEMY_TELEPORTING = 1024,
    CANCEL_TELEPORTING = 2048,
    RADAR = 4096,
    RADAR_TARGET = 8192,
    MOVE_TO_TARGET = 16384,
}

declare const DOTA_PLAYER_LOADOUT_START: 57;

declare const DOTA_PLAYER_LOADOUT_END: 77;

declare const DOTA_LOADOUT_TYPE_COUNT: 79;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTASlotType_t = LoadoutType;

declare enum LoadoutType {
    TYPE_WEAPON = 0,
    TYPE_OFFHAND_WEAPON = 1,
    TYPE_WEAPON_2 = 2,
    TYPE_OFFHAND_WEAPON_2 = 3,
    TYPE_HEAD = 4,
    TYPE_SHOULDER = 5,
    TYPE_ARMS = 6,
    TYPE_ARMOR = 7,
    TYPE_BELT = 8,
    TYPE_NECK = 9,
    TYPE_BACK = 10,
    TYPE_LEGS = 11,
    TYPE_GLOVES = 12,
    TYPE_TAIL = 13,
    TYPE_MISC = 14,
    TYPE_BODY_HEAD = 15,
    TYPE_MOUNT = 16,
    TYPE_SUMMON = 17,
    TYPE_SHAPESHIFT = 18,
    TYPE_TAUNT = 19,
    TYPE_AMBIENT_EFFECTS = 20,
    TYPE_ABILITY_ATTACK = 21,
    TYPE_ABILITY_1 = 22,
    TYPE_ABILITY_2 = 23,
    TYPE_ABILITY_3 = 24,
    TYPE_ABILITY_4 = 25,
    TYPE_ABILITY_ULTIMATE = 26,
    TYPE_VOICE = 27,
    TYPE_WEAPON_PERSONA_1 = 28,
    TYPE_OFFHAND_WEAPON_PERSONA_1 = 29,
    TYPE_WEAPON_2_PERSONA_1 = 30,
    TYPE_OFFHAND_WEAPON_2_PERSONA_1 = 31,
    TYPE_HEAD_PERSONA_1 = 32,
    TYPE_SHOULDER_PERSONA_1 = 33,
    TYPE_ARMS_PERSONA_1 = 34,
    TYPE_ARMOR_PERSONA_1 = 35,
    TYPE_BELT_PERSONA_1 = 36,
    TYPE_NECK_PERSONA_1 = 37,
    TYPE_BACK_PERSONA_1 = 38,
    TYPE_LEGS_PERSONA_1 = 39,
    TYPE_GLOVES_PERSONA_1 = 40,
    TYPE_TAIL_PERSONA_1 = 41,
    TYPE_MISC_PERSONA_1 = 42,
    TYPE_BODY_HEAD_PERSONA_1 = 43,
    TYPE_MOUNT_PERSONA_1 = 44,
    TYPE_SUMMON_PERSONA_1 = 45,
    TYPE_SHAPESHIFT_PERSONA_1 = 46,
    TYPE_TAUNT_PERSONA_1 = 47,
    TYPE_AMBIENT_EFFECTS_PERSONA_1 = 48,
    TYPE_ABILITY_ATTACK_PERSONA_1 = 49,
    TYPE_ABILITY_1_PERSONA_1 = 50,
    TYPE_ABILITY_2_PERSONA_1 = 51,
    TYPE_ABILITY_3_PERSONA_1 = 52,
    TYPE_ABILITY_4_PERSONA_1 = 53,
    TYPE_ABILITY_ULTIMATE_PERSONA_1 = 54,
    TYPE_VOICE_PERSONA_1 = 55,
    PERSONA_1_START = 28,
    PERSONA_1_END = 55,
    TYPE_PERSONA_SELECTOR = 56,
    TYPE_COURIER = 57,
    TYPE_ANNOUNCER = 58,
    TYPE_MEGA_KILLS = 59,
    TYPE_MUSIC = 60,
    TYPE_WARD = 61,
    TYPE_HUD_SKIN = 62,
    TYPE_LOADING_SCREEN = 63,
    TYPE_WEATHER = 64,
    TYPE_HEROIC_STATUE = 65,
    TYPE_MULTIKILL_BANNER = 66,
    TYPE_CURSOR_PACK = 67,
    TYPE_TELEPORT_EFFECT = 68,
    TYPE_BLINK_EFFECT = 69,
    TYPE_EMBLEM = 70,
    TYPE_TERRAIN = 71,
    TYPE_RADIANT_CREEPS = 72,
    TYPE_DIRE_CREEPS = 73,
    TYPE_RADIANT_TOWER = 74,
    TYPE_DIRE_TOWER = 75,
    TYPE_VERSUS_SCREEN = 76,
    TYPE_STREAK_EFFECT = 77,
    TYPE_NONE = 78,
}

declare const MODIFIER_FUNCTION_LAST: 232;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type modifierfunction = ModifierFunction;

declare enum ModifierFunction {
    /**
     * Method Name: `GetModifierPreAttack_BonusDamage`
     */ PREATTACK_BONUS_DAMAGE = 0,
    /**
     * Method Name: `GetModifierPreAttack_BonusDamage_Target`
     */
    PREATTACK_BONUS_DAMAGE_TARGET = 1,
    /**
     * Method Name: `GetModifierPreAttack_BonusDamage_Proc`
     */
    PREATTACK_BONUS_DAMAGE_PROC = 2,
    /**
     * Method Name: `GetModifierPreAttack_BonusDamagePostCrit`
     */
    PREATTACK_BONUS_DAMAGE_POST_CRIT = 3,
    /**
     * Method Name: `GetModifierBaseAttack_BonusDamage`
     */
    BASEATTACK_BONUSDAMAGE = 4,
    /**
     * Method Name: `GetModifierProcAttack_BonusDamage_Physical`
     */
    PROCATTACK_BONUS_DAMAGE_PHYSICAL = 5,
    /**
     * Method Name: `GetModifierProcAttack_BonusDamage_Magical`
     */
    PROCATTACK_BONUS_DAMAGE_MAGICAL = 6,
    /**
     * Method Name: `GetModifierProcAttack_BonusDamage_Pure`
     */
    PROCATTACK_BONUS_DAMAGE_PURE = 7,
    /**
     * Method Name: `GetModifierProcAttack_Feedback`
     */
    PROCATTACK_FEEDBACK = 8,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierOverrideAttackDamage`.
     */
    OVERRIDE_ATTACK_DAMAGE = 9,
    /**
     * Method Name: `GetModifierPreAttack`
     */
    PRE_ATTACK = 10,
    /**
     * Method Name: `GetModifierInvisibilityLevel`
     */
    INVISIBILITY_LEVEL = 11,
    /**
     * Method Name: `GetModifierInvisibilityAttackBehaviorException`
     */
    INVISIBILITY_ATTACK_BEHAVIOR_EXCEPTION = 12,
    /**
     * Method Name: `GetModifierPersistentInvisibility`
     */
    PERSISTENT_INVISIBILITY = 13,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierMoveSpeedBonus_Constant`.
     */
    MOVESPEED_BONUS_CONSTANT = 14,
    /**
     * Method Name: `GetModifierMoveSpeedOverride`
     */
    MOVESPEED_BASE_OVERRIDE = 15,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Percentage`
     */
    MOVESPEED_BONUS_PERCENTAGE = 16,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Percentage_Unique`
     */
    MOVESPEED_BONUS_PERCENTAGE_UNIQUE = 17,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Percentage_Unique_2`
     */
    MOVESPEED_BONUS_PERCENTAGE_UNIQUE_2 = 18,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Special_Boots`
     */
    MOVESPEED_BONUS_UNIQUE = 19,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Special_Boots_2`
     */
    MOVESPEED_BONUS_UNIQUE_2 = 20,
    /**
     * Method Name: `GetModifierMoveSpeedBonus_Constant_Unique`
     */
    MOVESPEED_BONUS_CONSTANT_UNIQUE = 21,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierMoveSpeedBonus_Constant_Unique_2`.
     */
    MOVESPEED_BONUS_CONSTANT_UNIQUE_2 = 22,
    /**
     * Method Name: `GetModifierMoveSpeed_Absolute`
     */
    MOVESPEED_ABSOLUTE = 23,
    /**
     * Method Name: `GetModifierMoveSpeed_AbsoluteMin`
     */
    MOVESPEED_ABSOLUTE_MIN = 24,
    /**
     * Method Name: `GetModifierMoveSpeed_AbsoluteMax`
     */
    MOVESPEED_ABSOLUTE_MAX = 25,
    /**
     * Method Name: `GetModifierIgnoreMovespeedLimit`
     */
    IGNORE_MOVESPEED_LIMIT = 26,
    /**
     * Method Name: `GetModifierMoveSpeed_Limit`
     */
    MOVESPEED_LIMIT = 27,
    /**
     * Method Name: `GetModifierAttackSpeedBaseOverride`
     */
    ATTACKSPEED_BASE_OVERRIDE = 28,
    /**
     * Method Name: `GetModifierFixedAttackRate`
     */
    FIXED_ATTACK_RATE = 29,
    /**
     * Method Name: `GetModifierAttackSpeedBonus_Constant`
     */
    ATTACKSPEED_BONUS_CONSTANT = 30,
    /**
     * Method Name: `GetModifierCooldownReduction_Constant`
     */
    COOLDOWN_REDUCTION_CONSTANT = 31,
    /**
     * Method Name: `GetModifierManacostReduction_Constant`
     */
    MANACOST_REDUCTION_CONSTANT = 32,
    /**
     * Method Name: `GetModifierBaseAttackTimeConstant`
     */
    BASE_ATTACK_TIME_CONSTANT = 33,
    /**
     * Method Name: `GetModifierBaseAttackTimeConstant_Adjust`
     */
    BASE_ATTACK_TIME_CONSTANT_ADJUST = 34,
    /**
     * Method Name: `GetModifierAttackPointConstant`
     */
    ATTACK_POINT_CONSTANT = 35,
    /**
     * Method Name: `GetModifierBonusDamageOutgoing_Percentage`
     */
    BONUSDAMAGEOUTGOING_PERCENTAGE = 36,
    /**
     * Method Name: `GetModifierDamageOutgoing_Percentage`
     */
    DAMAGEOUTGOING_PERCENTAGE = 37,
    /**
     * Method Name: `GetModifierDamageOutgoing_Percentage_Illusion`
     */
    DAMAGEOUTGOING_PERCENTAGE_ILLUSION = 38,
    /**
     * Method Name: `GetModifierDamageOutgoing_Percentage_Illusion_Amplify`
     */
    DAMAGEOUTGOING_PERCENTAGE_ILLUSION_AMPLIFY = 39,
    /**
     * Method Name: `GetModifierTotalDamageOutgoing_Percentage`
     */
    TOTALDAMAGEOUTGOING_PERCENTAGE = 40,
    /**
     * Method Name: `GetModifierSpellAmplify_Percentage`
     */
    SPELL_AMPLIFY_PERCENTAGE = 41,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierSpellAmplify_PercentageUnique`.
     */
    SPELL_AMPLIFY_PERCENTAGE_UNIQUE = 42,
    /**
     * Method Name: `GetModifierHealAmplify_PercentageSource`
     */
    HEAL_AMPLIFY_PERCENTAGE_SOURCE = 43,
    /**
     * Method Name: `GetModifierHealAmplify_PercentageTarget`
     */
    HEAL_AMPLIFY_PERCENTAGE_TARGET = 44,
    /**
     * Method Name: `GetModifierHPRegenAmplify_Percentage`
     */
    HP_REGEN_AMPLIFY_PERCENTAGE = 45,
    /**
     * Method Name: `GetModifierLifestealRegenAmplify_Percentage`
     */
    LIFESTEAL_AMPLIFY_PERCENTAGE = 46,
    /**
     * Method Name: `GetModifierSpellLifestealRegenAmplify_Percentage`
     */
    SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE = 47,
    /**
     * Method Name: `GetModifierMPRegenAmplify_Percentage`
     */
    MP_REGEN_AMPLIFY_PERCENTAGE = 48,
    /**
     * Method Name: `GetModifierManaDrainAmplify_Percentage`
     */
    MANA_DRAIN_AMPLIFY_PERCENTAGE = 49,
    /**
     * Total amplify value is clamped to 0.
     *
     *
     *
     * Method Name: `GetModifierMPRestoreAmplify_Percentage`.
     */
    MP_RESTORE_AMPLIFY_PERCENTAGE = 50,
    /**
     * Method Name: `GetModifierBaseDamageOutgoing_Percentage`
     */
    BASEDAMAGEOUTGOING_PERCENTAGE = 51,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierBaseDamageOutgoing_PercentageUnique`.
     */
    BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE = 52,
    /**
     * Method Name: `GetModifierIncomingDamage_Percentage`
     */
    INCOMING_DAMAGE_PERCENTAGE = 53,
    /**
     * Method Name: `GetModifierIncomingPhysicalDamage_Percentage`
     */
    INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = 54,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierIncomingPhysicalDamageConstant`.
     */
    INCOMING_PHYSICAL_DAMAGE_CONSTANT = 55,
    /**
     * Method Name: `GetModifierIncomingSpellDamageConstant`
     */
    INCOMING_SPELL_DAMAGE_CONSTANT = 56,
    /**
     * Method Name: `GetModifierEvasion_Constant`
     */
    EVASION_CONSTANT = 57,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierNegativeEvasion_Constant`.
     */
    NEGATIVE_EVASION_CONSTANT = 58,
    /**
     * Method Name: `GetModifierStatusResistance`
     */
    STATUS_RESISTANCE = 59,
    /**
     * Method Name: `GetModifierStatusResistanceStacking`
     */
    STATUS_RESISTANCE_STACKING = 60,
    /**
     * Method Name: `GetModifierStatusResistanceCaster`
     */
    STATUS_RESISTANCE_CASTER = 61,
    /**
     * Method Name: `GetModifierAvoidDamage`
     */
    AVOID_DAMAGE = 62,
    /**
     * Method Name: `GetModifierAvoidSpell`
     */
    AVOID_SPELL = 63,
    /**
     * Method Name: `GetModifierMiss_Percentage`
     */
    MISS_PERCENTAGE = 64,
    /**
     * Values above 100% are ignored.
     *
     *
     *
     * Method Name: `GetModifierPhysicalArmorBase_Percentage`.
     */
    PHYSICAL_ARMOR_BASE_PERCENTAGE = 65,
    /**
     * Method Name: `GetModifierPhysicalArmorTotal_Percentage`
     */
    PHYSICAL_ARMOR_TOTAL_PERCENTAGE = 66,
    /**
     * Method Name: `GetModifierPhysicalArmorBonus`
     */
    PHYSICAL_ARMOR_BONUS = 67,
    /**
     * Method Name: `GetModifierPhysicalArmorBonusUnique`
     */
    PHYSICAL_ARMOR_BONUS_UNIQUE = 68,
    /**
     * Method Name: `GetModifierPhysicalArmorBonusUniqueActive`
     */
    PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE = 69,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierIgnorePhysicalArmor`.
     */
    IGNORE_PHYSICAL_ARMOR = 70,
    /**
     * Method Name: `GetModifierMagicalResistanceBaseReduction`
     */
    MAGICAL_RESISTANCE_BASE_REDUCTION = 71,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierMagicalResistanceDirectModification`.
     */
    MAGICAL_RESISTANCE_DIRECT_MODIFICATION = 72,
    /**
     * Method Name: `GetModifierMagicalResistanceBonus`
     */
    MAGICAL_RESISTANCE_BONUS = 73,
    /**
     * Method Name: `GetModifierMagicalResistanceBonusIllusions`
     */
    MAGICAL_RESISTANCE_BONUS_ILLUSIONS = 74,
    /**
     * Method Name: `GetModifierMagicalResistanceDecrepifyUnique`
     */
    MAGICAL_RESISTANCE_DECREPIFY_UNIQUE = 75,
    /**
     * Method Name: `GetModifierBaseRegen`
     */
    BASE_MANA_REGEN = 76,
    /**
     * Method Name: `GetModifierConstantManaRegen`
     */
    MANA_REGEN_CONSTANT = 77,
    /**
     * Method Name: `GetModifierConstantManaRegenUnique`
     */
    MANA_REGEN_CONSTANT_UNIQUE = 78,
    /**
     * Method Name: `GetModifierTotalPercentageManaRegen`
     */
    MANA_REGEN_TOTAL_PERCENTAGE = 79,
    /**
     * Method Name: `GetModifierConstantHealthRegen`
     */
    HEALTH_REGEN_CONSTANT = 80,
    /**
     * Method Name: `GetModifierHealthRegenPercentage`
     */
    HEALTH_REGEN_PERCENTAGE = 81,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierHealthRegenPercentageUnique`.
     */
    HEALTH_REGEN_PERCENTAGE_UNIQUE = 82,
    /**
     * Method Name: `GetModifierHealthBonus`
     */
    HEALTH_BONUS = 83,
    /**
     * Method Name: `GetModifierManaBonus`
     */
    MANA_BONUS = 84,
    /**
     * Method Name: `GetModifierExtraStrengthBonus`
     */
    EXTRA_STRENGTH_BONUS = 85,
    /**
     * Method Name: `GetModifierExtraHealthBonus`
     */
    EXTRA_HEALTH_BONUS = 86,
    /**
     * Method Name: `GetModifierExtraManaBonus`
     */
    EXTRA_MANA_BONUS = 87,
    /**
     * Method Name: `GetModifierExtraHealthPercentage`
     */
    EXTRA_HEALTH_PERCENTAGE = 88,
    /**
     * Method Name: `GetModifierExtraManaPercentage`
     */
    EXTRA_MANA_PERCENTAGE = 89,
    /**
     * Method Name: `GetModifierBonusStats_Strength`
     */
    STATS_STRENGTH_BONUS = 90,
    /**
     * Method Name: `GetModifierBonusStats_Agility`
     */
    STATS_AGILITY_BONUS = 91,
    /**
     * Method Name: `GetModifierBonusStats_Intellect`
     */
    STATS_INTELLECT_BONUS = 92,
    /**
     * Method Name: `GetModifierBonusStats_Strength_Percentage`
     */
    STATS_STRENGTH_BONUS_PERCENTAGE = 93,
    /**
     * Method Name: `GetModifierBonusStats_Agility_Percentage`
     */
    STATS_AGILITY_BONUS_PERCENTAGE = 94,
    /**
     * Method Name: `GetModifierBonusStats_Intellect_Percentage`
     */
    STATS_INTELLECT_BONUS_PERCENTAGE = 95,
    /**
     * Method Name: `GetModifierCastRangeBonus`
     */
    CAST_RANGE_BONUS = 96,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierCastRangeBonusTarget`.
     */
    CAST_RANGE_BONUS_TARGET = 97,
    /**
     * Method Name: `GetModifierCastRangeBonusStacking`
     */
    CAST_RANGE_BONUS_STACKING = 98,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierAttackRangeOverride`.
     */
    ATTACK_RANGE_BASE_OVERRIDE = 99,
    /**
     * Method Name: `GetModifierAttackRangeBonus`
     */
    ATTACK_RANGE_BONUS = 100,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierAttackRangeBonusUnique`.
     */
    ATTACK_RANGE_BONUS_UNIQUE = 101,
    /**
     * Method Name: `GetModifierAttackRangeBonusPercentage`
     */
    ATTACK_RANGE_BONUS_PERCENTAGE = 102,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierMaxAttackRange`.
     */
    MAX_ATTACK_RANGE = 103,
    /**
     * Method Name: `GetModifierProjectileSpeedBonus`
     */
    PROJECTILE_SPEED_BONUS = 104,
    /**
     * Method Name: `GetModifierProjectileSpeedBonusPercentage`
     */
    PROJECTILE_SPEED_BONUS_PERCENTAGE = 105,
    /**
     * Method Name: `GetModifierProjectileName`
     */
    PROJECTILE_NAME = 106,
    /**
     * Method Name: `ReincarnateTime`
     */
    REINCARNATION = 107,
    /**
     * Method Name: `GetModifierConstantRespawnTime`
     */
    RESPAWNTIME = 108,
    /**
     * Method Name: `GetModifierPercentageRespawnTime`
     */
    RESPAWNTIME_PERCENTAGE = 109,
    /**
     * Method Name: `GetModifierStackingRespawnTime`
     */
    RESPAWNTIME_STACKING = 110,
    /**
     * Method Name: `GetModifierPercentageCooldown`
     */
    COOLDOWN_PERCENTAGE = 111,
    /**
     * Method Name: `GetModifierPercentageCooldownOngoing`
     */
    COOLDOWN_PERCENTAGE_ONGOING = 112,
    /**
     * Method Name: `GetModifierPercentageCasttime`
     */
    CASTTIME_PERCENTAGE = 113,
    /**
     * Method Name: `GetModifierPercentageManacost`
     */
    MANACOST_PERCENTAGE = 114,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierPercentageManacostStacking`.
     */
    MANACOST_PERCENTAGE_STACKING = 115,
    /**
     * Method Name: `GetModifierConstantDeathGoldCost`
     */
    DEATHGOLDCOST = 116,
    /**
     * Method Name: `GetModifierPercentageExpRateBoost`
     */
    EXP_RATE_BOOST = 117,
    /**
     * Method Name: `GetModifierPreAttack_CriticalStrike`
     */
    PREATTACK_CRITICALSTRIKE = 118,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierPreAttack_Target_CriticalStrike`.
     */
    PREATTACK_TARGET_CRITICALSTRIKE = 119,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierMagical_ConstantBlock`.
     */
    MAGICAL_CONSTANT_BLOCK = 120,
    /**
     * Method Name: `GetModifierPhysical_ConstantBlock`
     */
    PHYSICAL_CONSTANT_BLOCK = 121,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierPhysical_ConstantBlockSpecial`.
     */
    PHYSICAL_CONSTANT_BLOCK_SPECIAL = 122,
    /**
     * Method Name: `GetModifierPhysical_ConstantBlockUnavoidablePreArmor`
     */
    TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR = 123,
    /**
     * Method Name: `GetModifierTotal_ConstantBlock`
     */
    TOTAL_CONSTANT_BLOCK = 124,
    /**
     * Method Name: `GetOverrideAnimation`
     */
    OVERRIDE_ANIMATION = 125,
    /**
     * Method Name: `GetOverrideAnimationWeight`
     */
    OVERRIDE_ANIMATION_WEIGHT = 126,
    /**
     * Method Name: `GetOverrideAnimationRate`
     */
    OVERRIDE_ANIMATION_RATE = 127,
    /**
     * Method Name: `GetAbsorbSpell`
     */
    ABSORB_SPELL = 128,
    /**
     * Method Name: `GetReflectSpell`
     */
    REFLECT_SPELL = 129,
    /**
     * Method Name: `GetDisableAutoAttack`
     */
    DISABLE_AUTOATTACK = 130,
    /**
     * Method Name: `GetBonusDayVision`
     */
    BONUS_DAY_VISION = 131,
    /**
     * Method Name: `GetBonusNightVision`
     */
    BONUS_NIGHT_VISION = 132,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetBonusNightVisionUnique`.
     */
    BONUS_NIGHT_VISION_UNIQUE = 133,
    /**
     * Method Name: `GetBonusVisionPercentage`
     */
    BONUS_VISION_PERCENTAGE = 134,
    /**
     * Method Name: `GetFixedDayVision`
     */
    FIXED_DAY_VISION = 135,
    /**
     * Method Name: `GetFixedNightVision`
     */
    FIXED_NIGHT_VISION = 136,
    /**
     * Method Name: `GetMinHealth`
     */
    MIN_HEALTH = 137,
    /**
     * Method Name: `GetAbsoluteNoDamagePhysical`
     */
    ABSOLUTE_NO_DAMAGE_PHYSICAL = 138,
    /**
     * Method Name: `GetAbsoluteNoDamageMagical`
     */
    ABSOLUTE_NO_DAMAGE_MAGICAL = 139,
    /**
     * Method Name: `GetAbsoluteNoDamagePure`
     */
    ABSOLUTE_NO_DAMAGE_PURE = 140,
    /**
     * Method Name: `GetIsIllusion`
     */
    IS_ILLUSION = 141,
    /**
     * Method Name: `GetModifierIllusionLabel`
     */
    ILLUSION_LABEL = 142,
    /**
     * Method Name: `GetModifierStrongIllusion`
     */
    STRONG_ILLUSION = 143,
    /**
     * Method Name: `GetModifierSuperIllusion`
     */
    SUPER_ILLUSION = 144,
    /**
     * Method Name: `GetModifierSuperIllusionWithUltimate`
     */
    SUPER_ILLUSION_WITH_ULTIMATE = 145,
    /**
     * Method Name: `GetModifierTurnRate_Percentage`
     */
    TURN_RATE_PERCENTAGE = 146,
    /**
     * Method Name: `GetModifierTurnRate_Override`
     */
    TURN_RATE_OVERRIDE = 147,
    /**
     * Method Name: `GetDisableHealing`
     */
    DISABLE_HEALING = 148,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetAlwaysAllowAttack`.
     */
    ALWAYS_ALLOW_ATTACK = 149,
    /**
     * Method Name: `GetAllowEtherealAttack`
     */
    ALWAYS_ETHEREAL_ATTACK = 150,
    /**
     * Method Name: `GetOverrideAttackMagical`
     */
    OVERRIDE_ATTACK_MAGICAL = 151,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierUnitStatsNeedsRefresh`.
     */
    UNIT_STATS_NEEDS_REFRESH = 152,
    BOUNTY_CREEP_MULTIPLIER = 153,
    BOUNTY_OTHER_MULTIPLIER = 154,
    /**
     * Method Name: `GetModifierUnitDisllowUpgrading`
     */
    UNIT_DISALLOW_UPGRADING = 155,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierDodgeProjectile`.
     */
    DODGE_PROJECTILE = 156,
    /**
     * Method Name: `GetTriggerCosmeticAndEndAttack`
     */
    TRIGGER_COSMETIC_AND_END_ATTACK = 157,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `OnSpellTargetReady`.
     */
    ON_SPELL_TARGET_READY = 158,
    /**
     * Method Name: `OnAttackRecord`
     */
    ON_ATTACK_RECORD = 159,
    /**
     * Method Name: `OnAttackStart`
     */
    ON_ATTACK_START = 160,
    /**
     * Method Name: `OnAttack`
     */
    ON_ATTACK = 161,
    /**
     * Method Name: `OnAttackLanded`
     */
    ON_ATTACK_LANDED = 162,
    /**
     * Method Name: `OnAttackFail`
     */
    ON_ATTACK_FAIL = 163,
    /**
     * Happens even if attack can't be issued.
     *
     *
     *
     * Method Name: `OnAttackAllied`.
     */
    ON_ATTACK_ALLIED = 164,
    /**
     * Method Name: `OnProjectileDodge`
     */
    ON_PROJECTILE_DODGE = 165,
    /**
     * Method Name: `OnOrder`
     */
    ON_ORDER = 166,
    /**
     * Method Name: `OnUnitMoved`
     */
    ON_UNIT_MOVED = 167,
    /**
     * Method Name: `OnAbilityStart`
     */
    ON_ABILITY_START = 168,
    /**
     * Method Name: `OnAbilityExecuted`
     */
    ON_ABILITY_EXECUTED = 169,
    /**
     * Method Name: `OnAbilityFullyCast`
     */
    ON_ABILITY_FULLY_CAST = 170,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `OnBreakInvisibility`.
     */
    ON_BREAK_INVISIBILITY = 171,
    /**
     * Method Name: `OnAbilityEndChannel`
     */
    ON_ABILITY_END_CHANNEL = 172,
    ON_PROCESS_UPGRADE = 173,
    ON_REFRESH = 174,
    /**
     * Method Name: `OnTakeDamage`
     */
    ON_TAKEDAMAGE = 175,
    /**
     * Method Name: `OnDamagePrevented`
     */
    ON_DEATH_PREVENTED = 176,
    /**
     * Method Name: `OnStateChanged`
     */
    ON_STATE_CHANGED = 177,
    ON_ORB_EFFECT = 178,
    /**
     * Method Name: `OnProcessCleave`
     */
    ON_PROCESS_CLEAVE = 179,
    /**
     * Method Name: `OnDamageCalculated`
     */
    ON_DAMAGE_CALCULATED = 180,
    /**
     * Method Name: `OnAttacked`
     */
    ON_ATTACKED = 181,
    /**
     * Method Name: `OnDeath`
     */
    ON_DEATH = 182,
    /**
     * Method Name: `OnRespawn`
     */
    ON_RESPAWN = 183,
    /**
     * Method Name: `OnSpentMana`
     */
    ON_SPENT_MANA = 184,
    /**
     * Method Name: `OnTeleporting`
     */
    ON_TELEPORTING = 185,
    /**
     * Method Name: `OnTeleported`
     */
    ON_TELEPORTED = 186,
    /**
     * Method Name: `OnSetLocation`
     */
    ON_SET_LOCATION = 187,
    /**
     * Method Name: `OnHealthGained`
     */
    ON_HEALTH_GAINED = 188,
    /**
     * Method Name: `OnManaGained`
     */
    ON_MANA_GAINED = 189,
    /**
     * Method Name: `OnTakeDamageKillCredit`
     */
    ON_TAKEDAMAGE_KILLCREDIT = 190,
    /**
     * Method Name: `OnHeroKilled`
     */
    ON_HERO_KILLED = 191,
    /**
     * Method Name: `OnHealReceived`
     */
    ON_HEAL_RECEIVED = 192,
    /**
     * Method Name: `OnBuildingKilled`
     */
    ON_BUILDING_KILLED = 193,
    /**
     * Method Name: `OnModelChanged`
     */
    ON_MODEL_CHANGED = 194,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `OnModifierAdded`.
     */
    ON_MODIFIER_ADDED = 195,
    /**
     * Method Name: `OnTooltip`
     */
    TOOLTIP = 196,
    /**
     * Method Name: `GetModifierModelChange`
     */
    MODEL_CHANGE = 197,
    /**
     * Method Name: `GetModifierModelScale`
     */
    MODEL_SCALE = 198,
    /**
     * Always applies scepter when this property is active
     *
     *
     *
     * Method Name: `GetModifierScepter`.
     */
    IS_SCEPTER = 199,
    /**
     * Method Name: `GetModifierRadarCooldownReduction`
     */
    RADAR_COOLDOWN_REDUCTION = 200,
    /**
     * Method Name: `GetActivityTranslationModifiers`
     */
    TRANSLATE_ACTIVITY_MODIFIERS = 201,
    /**
     * Method Name: `GetAttackSound`
     */
    TRANSLATE_ATTACK_SOUND = 202,
    /**
     * Method Name: `GetUnitLifetimeFraction`
     */
    LIFETIME_FRACTION = 203,
    /**
     * Method Name: `GetModifierProvidesFOWVision`
     */
    PROVIDES_FOW_POSITION = 204,
    /**
     * Method Name: `GetModifierSpellsRequireHP`
     */
    SPELLS_REQUIRE_HP = 205,
    /**
     * Method Name: `GetForceDrawOnMinimap`
     */
    FORCE_DRAW_MINIMAP = 206,
    /**
     * Method Name: `GetModifierDisableTurning`
     */
    DISABLE_TURNING = 207,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierIgnoreCastAngle`.
     */
    IGNORE_CAST_ANGLE = 208,
    /**
     * Method Name: `GetModifierChangeAbilityValue`
     */
    CHANGE_ABILITY_VALUE = 209,
    /**
     * Method Name: `GetModifierOverrideAbilitySpecial`
     */
    OVERRIDE_ABILITY_SPECIAL = 210,
    /**
     * Method Name: `GetModifierOverrideAbilitySpecialValue`
     */
    OVERRIDE_ABILITY_SPECIAL_VALUE = 211,
    /**
     * Method Name: `GetModifierAbilityLayout`
     */
    ABILITY_LAYOUT = 212,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `OnDominated`.
     */
    ON_DOMINATED = 213,
    /**
     * Method Name: `GetModifierTempestDouble`
     */
    TEMPEST_DOUBLE = 214,
    /**
     * Method Name: `PreserveParticlesOnModelChanged`
     */
    PRESERVE_PARTICLES_ON_MODEL_CHANGE = 215,
    /**
     * Method Name: `OnAttackFinished`
     */
    ON_ATTACK_FINISHED = 216,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierIgnoreCooldown`.
     */
    IGNORE_COOLDOWN = 217,
    /**
     * Not working.
     *
     *
     *
     * Method Name: `GetModifierCanAttackTrees`.
     */
    CAN_ATTACK_TREES = 218,
    /**
     * Method Name: `GetVisualZDelta`
     */
    VISUAL_Z_DELTA = 219,
    INCOMING_DAMAGE_ILLUSION = 220,
    /**
     * Method Name: `GetModifierNoVisionOfAttacker`
     */
    DONT_GIVE_VISION_OF_ATTACKER = 221,
    /**
     * Method Name: `OnTooltip2`
     */
    TOOLTIP2 = 222,
    /**
     * Method Name: `OnAttackRecordDestroy`
     */
    ON_ATTACK_RECORD_DESTROY = 223,
    /**
     * Method Name: `OnProjectileObstructionHit`
     */
    ON_PROJECTILE_OBSTRUCTION_HIT = 224,
    /**
     * Method Name: `GetSuppressTeleport`
     */
    SUPPRESS_TELEPORT = 225,
    /**
     * Method Name: `OnAttackCancelled`
     */
    ON_ATTACK_CANCELLED = 226,
    /**
     * Method Name: `GetSuppressCleave`
     */
    SUPPRESS_CLEAVE = 227,
    /**
     * Method Name: `BotAttackScoreBonus`
     */
    BOT_ATTACK_SCORE_BONUS = 228,
    /**
     * Method Name: `GetModifierAttackSpeedReductionPercentage`
     */
    ATTACKSPEED_REDUCTION_PERCENTAGE = 229,
    /**
     * Method Name: `GetModifierMoveSpeedReductionPercentage`
     */
    MOVESPEED_REDUCTION_PERCENTAGE = 230,
    ATTACK_WHILE_MOVING_TARGET = 231,
    INVALID = 255,
}

declare const MODIFIER_STATE_LAST: 44;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type modifierstate = ModifierState;

declare enum ModifierState {
    ROOTED = 0,
    DISARMED = 1,
    ATTACK_IMMUNE = 2,
    SILENCED = 3,
    MUTED = 4,
    STUNNED = 5,
    HEXED = 6,
    INVISIBLE = 7,
    INVULNERABLE = 8,
    MAGIC_IMMUNE = 9,
    PROVIDES_VISION = 10,
    NIGHTMARED = 11,
    BLOCK_DISABLED = 12,
    EVADE_DISABLED = 13,
    UNSELECTABLE = 14,
    CANNOT_TARGET_ENEMIES = 15,
    CANNOT_MISS = 16,
    SPECIALLY_DENIABLE = 17,
    FROZEN = 18,
    COMMAND_RESTRICTED = 19,
    NOT_ON_MINIMAP = 20,
    LOW_ATTACK_PRIORITY = 21,
    NO_HEALTH_BAR = 22,
    FLYING = 23,
    NO_UNIT_COLLISION = 24,
    NO_TEAM_MOVE_TO = 25,
    NO_TEAM_SELECT = 26,
    PASSIVES_DISABLED = 27,
    DOMINATED = 28,
    BLIND = 29,
    OUT_OF_GAME = 30,
    FAKE_ALLY = 31,
    FLYING_FOR_PATHING_PURPOSES_ONLY = 32,
    TRUESIGHT_IMMUNE = 33,
    UNTARGETABLE = 34,
    IGNORING_MOVE_AND_ATTACK_ORDERS = 35,
    ALLOW_PATHING_TROUGH_TREES = 36,
    NOT_ON_MINIMAP_FOR_ENEMIES = 37,
    UNSLOWABLE = 38,
    TETHERED = 39,
    IGNORING_STOP_ORDERS = 40,
    FEARED = 41,
    TAUNTED = 42,
    CANNOT_BE_MOTION_CONTROLLED = 43,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAModifierAttribute_t = ModifierAttribute;

declare enum ModifierAttribute {
    NONE = 0,
    PERMANENT = 1,
    MULTIPLE = 2,
    IGNORE_INVULNERABLE = 4,
    AURA_PRIORITY = 8,
}

declare enum Attributes {
    STRENGTH = 0,
    AGILITY = 1,
    INTELLECT = 2,
    MAX = 3,
}

declare const MAX_PATTACH_TYPES: 16;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type ParticleAttachment_t = ParticleAttachment;

declare enum ParticleAttachment {
    ABSORIGIN = 0,
    ABSORIGIN_FOLLOW = 1,
    CUSTOMORIGIN = 2,
    CUSTOMORIGIN_FOLLOW = 3,
    POINT = 4,
    POINT_FOLLOW = 5,
    EYES_FOLLOW = 6,
    OVERHEAD_FOLLOW = 7,
    WORLDORIGIN = 8,
    ROOTBONE_FOLLOW = 9,
    RENDERORIGIN_FOLLOW = 10,
    MAIN_VIEW = 11,
    WATERWAKE = 12,
    CENTER_FOLLOW = 13,
    CUSTOM_GAME_STATE_1 = 14,
    HEALTHBAR = 15,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_MOTION_CONTROLLER_PRIORITY = MotionControllerPriority;

declare enum MotionControllerPriority {
    LOWEST = 0,
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    HIGHEST = 4,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTASpeechType_t = SpeechType;

declare enum SpeechType {
    USER_INVALID = 0,
    USER_SINGLE = 1,
    USER_TEAM = 2,
    USER_TEAM_NEARBY = 3,
    USER_NEARBY = 4,
    USER_ALL = 5,
    GOOD_TEAM = 6,
    BAD_TEAM = 7,
    SPECTATOR = 8,
    RECIPIENT_TYPE_MAX = 9,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAAbilitySpeakTrigger_t = AbilitySpeakTrigger;

declare enum AbilitySpeakTrigger {
    START_ACTION_PHASE = 0,
    CAST = 1,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DotaCustomUIType_t = CustomUiType;

declare enum CustomUiType {
    HUD = 0,
    HERO_SELECTION = 1,
    GAME_INFO = 2,
    GAME_SETUP = 3,
    FLYOUT_SCOREBOARD = 4,
    HUD_TOP_BAR = 5,
    END_SCREEN = 6,
    COUNT = 7,
}

declare const DOTA_DEFAULT_UI_ELEMENT_COUNT: 29;

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DotaDefaultUIElement_t = DefaultUiElement;

declare enum DefaultUiElement {
    TOP_TIMEOFDAY = 0,
    TOP_HEROES = 1,
    FLYOUT_SCOREBOARD = 2,
    ACTION_PANEL = 3,
    ACTION_MINIMAP = 4,
    INVENTORY_PANEL = 5,
    INVENTORY_SHOP = 6,
    INVENTORY_ITEMS = 7,
    INVENTORY_QUICKBUY = 8,
    INVENTORY_COURIER = 9,
    INVENTORY_PROTECT = 10,
    INVENTORY_GOLD = 11,
    SHOP_SUGGESTEDITEMS = 12,
    SHOP_COMMONITEMS = 13,
    HERO_SELECTION_TEAMS = 14,
    HERO_SELECTION_GAME_NAME = 15,
    HERO_SELECTION_CLOCK = 16,
    TOP_MENU_BUTTONS = 17,
    TOP_BAR_BACKGROUND = 18,
    TOP_BAR_RADIANT_TEAM = 19,
    TOP_BAR_DIRE_TEAM = 20,
    TOP_BAR_SCORE = 21,
    ENDGAME = 22,
    ENDGAME_CHAT = 23,
    QUICK_STATS = 24,
    PREGAME_STRATEGYUI = 25,
    KILLCAM = 26,
    TOP_BAR = 27,
    CUSTOMUI_BEHIND_HUD_ELEMENTS = 28,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type PlayerUltimateStateOrTime_t = PlayerUltimateStateOrTime;

declare enum PlayerUltimateStateOrTime {
    PLAYER_ULTIMATE_STATE_READY = 0,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type PlayerOrderIssuer_t = PlayerOrderIssuer;

declare enum PlayerOrderIssuer {
    SELECTED_UNITS = 0,
    CURRENT_UNIT_ONLY = 1,
    HERO_ONLY = 2,
    PASSED_UNIT_ONLY = 3,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type OrderQueueBehavior_t = OrderQueueBehavior;

declare enum OrderQueueBehavior {
    DEFAULT = 0,
    NEVER = 1,
    ALWAYS = 2,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type CLICK_BEHAVIORS = ClickBehaviors;

declare enum ClickBehaviors {
    NONE = 0,
    MOVE = 1,
    ATTACK = 2,
    CAST = 3,
    DROP_ITEM = 4,
    DROP_SHOP_ITEM = 5,
    DRAG = 6,
    LEARN_ABILITY = 7,
    PATROL = 8,
    VECTOR_CAST = 9,
    UNUSED = 10,
    RADAR = 11,
    LAST = 12,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type AbilityLearnResult_t = AbilityLearnResult;

declare enum AbilityLearnResult {
    CAN_BE_UPGRADED = 0,
    CANNOT_BE_UPGRADED_NOT_UPGRADABLE = 1,
    CANNOT_BE_UPGRADED_AT_MAX = 2,
    CANNOT_BE_UPGRADED_REQUIRES_LEVEL = 3,
    NOT_LEARNABLE = 4,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTAKeybindCommand_t = KeybindCommand;

declare enum KeybindCommand {
    KEYBIND_NONE = 0,
    KEYBIND_FIRST = 1,
    KEYBIND_CAMERA_UP = 1,
    KEYBIND_CAMERA_DOWN = 2,
    KEYBIND_CAMERA_LEFT = 3,
    KEYBIND_CAMERA_RIGHT = 4,
    KEYBIND_CAMERA_GRIP = 5,
    KEYBIND_CAMERA_YAW_GRIP = 6,
    KEYBIND_CAMERA_SAVED_POSITION_1 = 7,
    KEYBIND_CAMERA_SAVED_POSITION_2 = 8,
    KEYBIND_CAMERA_SAVED_POSITION_3 = 9,
    KEYBIND_CAMERA_SAVED_POSITION_4 = 10,
    KEYBIND_CAMERA_SAVED_POSITION_5 = 11,
    KEYBIND_CAMERA_SAVED_POSITION_6 = 12,
    KEYBIND_CAMERA_SAVED_POSITION_7 = 13,
    KEYBIND_CAMERA_SAVED_POSITION_8 = 14,
    KEYBIND_CAMERA_SAVED_POSITION_9 = 15,
    KEYBIND_CAMERA_SAVED_POSITION_10 = 16,
    KEYBIND_HERO_ATTACK = 17,
    KEYBIND_HERO_MOVE = 18,
    KEYBIND_HERO_MOVE_DIRECTION = 19,
    KEYBIND_PATROL = 20,
    KEYBIND_HERO_STOP = 21,
    KEYBIND_HERO_HOLD = 22,
    KEYBIND_HERO_SELECT = 23,
    KEYBIND_COURIER_SELECT = 24,
    KEYBIND_COURIER_DELIVER = 25,
    KEYBIND_COURIER_BURST = 26,
    KEYBIND_COURIER_SHIELD = 27,
    KEYBIND_PAUSE = 28,
    SELECT_ALL = 29,
    SELECT_ALL_OTHERS = 30,
    RECENT_EVENT = 31,
    KEYBIND_CHAT_TEAM = 32,
    KEYBIND_CHAT_GLOBAL = 33,
    KEYBIND_CHAT_TEAM_2 = 34,
    KEYBIND_CHAT_GLOBAL_2 = 35,
    KEYBIND_CHAT_VOICE_PARTY = 36,
    KEYBIND_CHAT_VOICE_TEAM = 37,
    KEYBIND_CHAT_WHEEL = 38,
    KEYBIND_CHAT_WHEEL_2 = 39,
    KEYBIND_CHAT_WHEEL_CARE = 40,
    KEYBIND_CHAT_WHEEL_BACK = 41,
    KEYBIND_CHAT_WHEEL_NEED_WARDS = 42,
    KEYBIND_CHAT_WHEEL_STUN = 43,
    KEYBIND_CHAT_WHEEL_HELP = 44,
    KEYBIND_CHAT_WHEEL_GET_PUSH = 45,
    KEYBIND_CHAT_WHEEL_GOOD_JOB = 46,
    KEYBIND_CHAT_WHEEL_MISSING = 47,
    KEYBIND_CHAT_WHEEL_MISSING_TOP = 48,
    KEYBIND_CHAT_WHEEL_MISSING_MIDDLE = 49,
    KEYBIND_CHAT_WHEEL_MISSING_BOTTOM = 50,
    KEYBIND_HERO_CHAT_WHEEL = 51,
    KEYBIND_SPRAY_WHEEL = 52,
    KEYBIND_ABILITY_PRIMARY_1 = 53,
    KEYBIND_ABILITY_PRIMARY_2 = 54,
    KEYBIND_ABILITY_PRIMARY_3 = 55,
    KEYBIND_ABILITY_SECONDARY_1 = 56,
    KEYBIND_ABILITY_SECONDARY_2 = 57,
    KEYBIND_ABILITY_ULTIMATE = 58,
    KEYBIND_ABILITY_PRIMARY_1_QUICKCAST = 59,
    KEYBIND_ABILITY_PRIMARY_2_QUICKCAST = 60,
    KEYBIND_ABILITY_PRIMARY_3_QUICKCAST = 61,
    KEYBIND_ABILITY_SECONDARY_1_QUICKCAST = 62,
    KEYBIND_ABILITY_SECONDARY_2_QUICKCAST = 63,
    KEYBIND_ABILITY_ULTIMATE_QUICKCAST = 64,
    KEYBIND_ABILITY_PRIMARY_1_EXPLICIT_AUTOCAST = 65,
    KEYBIND_ABILITY_PRIMARY_2_EXPLICIT_AUTOCAST = 66,
    KEYBIND_ABILITY_PRIMARY_3_EXPLICIT_AUTOCAST = 67,
    KEYBIND_ABILITY_SECONDARY_1_EXPLICIT_AUTOCAST = 68,
    KEYBIND_ABILITY_SECONDARY_2_EXPLICIT_AUTOCAST = 69,
    KEYBIND_ABILITY_ULTIMATE_EXPLICIT_AUTOCAST = 70,
    KEYBIND_ABILITY_PRIMARY_1_QUICKCAST_AUTOCAST = 71,
    KEYBIND_ABILITY_PRIMARY_2_QUICKCAST_AUTOCAST = 72,
    KEYBIND_ABILITY_PRIMARY_3_QUICKCAST_AUTOCAST = 73,
    KEYBIND_ABILITY_SECONDARY_1_QUICKCAST_AUTOCAST = 74,
    KEYBIND_ABILITY_SECONDARY_2_QUICKCAST_AUTOCAST = 75,
    KEYBIND_ABILITY_ULTIMATE_QUICKCAST_AUTOCAST = 76,
    KEYBIND_ABILITY_PRIMARY_1_AUTOMATIC_AUTOCAST = 77,
    KEYBIND_ABILITY_PRIMARY_2_AUTOMATIC_AUTOCAST = 78,
    KEYBIND_ABILITY_PRIMARY_3_AUTOMATIC_AUTOCAST = 79,
    KEYBIND_ABILITY_SECONDARY_1_AUTOMATIC_AUTOCAST = 80,
    KEYBIND_ABILITY_SECONDARY_2_AUTOMATIC_AUTOCAST = 81,
    KEYBIND_ABILITY_ULTIMATE_AUTOMATIC_AUTOCAST = 82,
    KEYBIND_INVENTORY_1 = 83,
    KEYBIND_INVENTORY_2 = 84,
    KEYBIND_INVENTORY_3 = 85,
    KEYBIND_INVENTORY_4 = 86,
    KEYBIND_INVENTORY_5 = 87,
    KEYBIND_INVENTORY_6 = 88,
    KEYBIND_INVENTORYTP = 89,
    KEYBIND_INVENTORYNEUTRAL = 90,
    KEYBIND_INVENTORY_1_QUICKCAST = 91,
    KEYBIND_INVENTORY_2_QUICKCAST = 92,
    KEYBIND_INVENTORY_3_QUICKCAST = 93,
    KEYBIND_INVENTORY_4_QUICKCAST = 94,
    KEYBIND_INVENTORY_5_QUICKCAST = 95,
    KEYBIND_INVENTORY_6_QUICKCAST = 96,
    KEYBIND_INVENTORYTP_QUICKCAST = 97,
    KEYBIND_INVENTORYNEUTRAL_QUICKCAST = 98,
    KEYBIND_INVENTORY_1_AUTOCAST = 99,
    KEYBIND_INVENTORY_2_AUTOCAST = 100,
    KEYBIND_INVENTORY_3_AUTOCAST = 101,
    KEYBIND_INVENTORY_4_AUTOCAST = 102,
    KEYBIND_INVENTORY_5_AUTOCAST = 103,
    KEYBIND_INVENTORY_6_AUTOCAST = 104,
    KEYBIND_INVENTORYTP_AUTOCAST = 105,
    KEYBIND_INVENTORYNEUTRAL_AUTOCAST = 106,
    KEYBIND_INVENTORY_1_QUICKAUTOCAST = 107,
    KEYBIND_INVENTORY_2_QUICKAUTOCAST = 108,
    KEYBIND_INVENTORY_3_QUICKAUTOCAST = 109,
    KEYBIND_INVENTORY_4_QUICKAUTOCAST = 110,
    KEYBIND_INVENTORY_5_QUICKAUTOCAST = 111,
    KEYBIND_INVENTORY_6_QUICKAUTOCAST = 112,
    KEYBIND_INVENTORYTP_QUICKAUTOCAST = 113,
    KEYBIND_INVENTORYNEUTRAL_QUICKAUTOCAST = 114,
    KEYBIND_CONTROL_GROUP_1 = 115,
    KEYBIND_CONTROL_GROUP_2 = 116,
    KEYBIND_CONTROL_GROUP_3 = 117,
    KEYBIND_CONTROL_GROUP_4 = 118,
    KEYBIND_CONTROL_GROUP_5 = 119,
    KEYBIND_CONTROL_GROUP_6 = 120,
    KEYBIND_CONTROL_GROUP_7 = 121,
    KEYBIND_CONTROL_GROUP_8 = 122,
    KEYBIND_CONTROL_GROUP_9 = 123,
    KEYBIND_CONTROL_GROUP_10 = 124,
    KEYBIND_CONTROL_GROUPCYCLE = 125,
    KEYBIND_SELECT_ALLY_1 = 126,
    KEYBIND_SELECT_ALLY_2 = 127,
    KEYBIND_SELECT_ALLY_3 = 128,
    KEYBIND_SELECT_ALLY_4 = 129,
    KEYBIND_SELECT_ALLY_5 = 130,
    KEYBIND_SHOP_TOGGLE = 131,
    KEYBIND_SCOREBOARD_TOGGLE = 132,
    KEYBIND_SCREENSHOT = 133,
    KEYBIND_ESCAPE = 134,
    KEYBIND_CONSOLE = 135,
    KEYBIND_DEATH_SUMMARY = 136,
    KEYBIND_LEARN_ABILITIES = 137,
    KEYBIND_LEARN_STATS = 138,
    KEYBIND_ACTIVATE_GLYPH = 139,
    KEYBIND_ACTIVATE_RADAR = 140,
    KEYBIND_PURCHASE_QUICKBUY = 141,
    KEYBIND_PURCHASE_STICKY = 142,
    KEYBIND_GRAB_STASH_ITEMS = 143,
    KEYBIND_TOGGLE_AUTOATTACK = 144,
    KEYBIND_TAUNT = 145,
    KEYBIND_SHOP_CONSUMABLES = 146,
    KEYBIND_SHOP_ATTRIBUTES = 147,
    KEYBIND_SHOP_ARMAMENTS = 148,
    KEYBIND_SHOP_ARCANE = 149,
    KEYBIND_SHOP_BASICS = 150,
    KEYBIND_SHOP_SUPPORT = 151,
    KEYBIND_SHOP_CASTER = 152,
    KEYBIND_SHOP_WEAPONS = 153,
    KEYBIND_SHOP_ARMOR = 154,
    KEYBIND_SHOP_ARTIFACTS = 155,
    KEYBIND_SHOP_SIDE_PAGE_1 = 156,
    KEYBIND_SHOP_SIDE_PAGE_2 = 157,
    KEYBIND_SHOP_SECRET = 158,
    KEYBIND_SHOP_SEARCHBOX = 159,
    KEYBIND_SHOP_SLOT_1 = 160,
    KEYBIND_SHOP_SLOT_2 = 161,
    KEYBIND_SHOP_SLOT_3 = 162,
    KEYBIND_SHOP_SLOT_4 = 163,
    KEYBIND_SHOP_SLOT_5 = 164,
    KEYBIND_SHOP_SLOT_6 = 165,
    KEYBIND_SHOP_SLOT_7 = 166,
    KEYBIND_SHOP_SLOT_8 = 167,
    KEYBIND_SHOP_SLOT_9 = 168,
    KEYBIND_SHOP_SLOT_10 = 169,
    KEYBIND_SHOP_SLOT_11 = 170,
    KEYBIND_SHOP_SLOT_12 = 171,
    KEYBIND_SHOP_SLOT_13 = 172,
    KEYBIND_SHOP_SLOT_14 = 173,
    KEYBIND_SPEC_CAMERA_UP = 174,
    KEYBIND_SPEC_CAMERA_DOWN = 175,
    KEYBIND_SPEC_CAMERA_LEFT = 176,
    KEYBIND_SPEC_CAMERA_RIGHT = 177,
    KEYBIND_SPEC_CAMERA_GRIP = 178,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_1 = 179,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_2 = 180,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_3 = 181,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_4 = 182,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_5 = 183,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_6 = 184,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_7 = 185,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_8 = 186,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_9 = 187,
    KEYBIND_SPEC_CAMERA_SAVED_POSITION_10 = 188,
    KEYBIND_SPEC_UNIT_SELECT = 189,
    KEYBIND_SPEC_HERO_SELECT = 190,
    KEYBIND_SPEC_PAUSE = 191,
    KEYBIND_SPEC_CHAT = 192,
    KEYBIND_SPEC_SCOREBOARD = 193,
    KEYBIND_SPEC_INCREASE_REPLAY_SPEED = 194,
    KEYBIND_SPEC_DECREASE_REPLAY_SPEED = 195,
    KEYBIND_SPEC_STATS_HARVEST = 196,
    KEYBIND_SPEC_STATS_ITEM = 197,
    KEYBIND_SPEC_STATS_GOLD = 198,
    KEYBIND_SPEC_STATS_XP = 199,
    KEYBIND_SPEC_STATS_FANTASY = 200,
    KEYBIND_SPEC_STATS_WINCHANCE = 201,
    KEYBIND_SPEC_FOW_TOGGLEBOTH = 202,
    KEYBIND_SPEC_FOW_TOGGLERADIENT = 203,
    KEYBIND_SPEC_FOW_TOGGLEDIRE = 204,
    KEYBIND_SPEC_OPEN_BROADCASTER_MENU = 205,
    KEYBIND_SPEC_DROPDOWN_KDA = 206,
    KEYBIND_SPEC_DROPDOWN_LASTHITS_DENIES = 207,
    KEYBIND_SPEC_DROPDOWN_LEVEL = 208,
    KEYBIND_SPEC_DROPDOWN_XP_PER_MIN = 209,
    KEYBIND_SPEC_DROPDOWN_GOLD = 210,
    KEYBIND_SPEC_DROPDOWN_TOTALGOLD = 211,
    KEYBIND_SPEC_DROPDOWN_GOLD_PER_MIN = 212,
    KEYBIND_SPEC_DROPDOWN_BUYBACK = 213,
    KEYBIND_SPEC_DROPDOWN_NETWORTH = 214,
    KEYBIND_SPEC_DROPDOWN_FANTASY = 215,
    KEYBIND_SPEC_DROPDOWN_SORT = 216,
    KEYBIND_SPEC_DROPDOWN_CLOSE = 217,
    KEYBIND_SPEC_FOCUS_PLAYER_1 = 218,
    KEYBIND_SPEC_FOCUS_PLAYER_2 = 219,
    KEYBIND_SPEC_FOCUS_PLAYER_3 = 220,
    KEYBIND_SPEC_FOCUS_PLAYER_4 = 221,
    KEYBIND_SPEC_FOCUS_PLAYER_5 = 222,
    KEYBIND_SPEC_FOCUS_PLAYER_6 = 223,
    KEYBIND_SPEC_FOCUS_PLAYER_7 = 224,
    KEYBIND_SPEC_FOCUS_PLAYER_8 = 225,
    KEYBIND_SPEC_FOCUS_PLAYER_9 = 226,
    KEYBIND_SPEC_FOCUS_PLAYER_10 = 227,
    KEYBIND_SPEC_COACH_VIEWTOGGLE = 228,
    KEYBIND_INSPECTHEROINWORLD = 229,
    KEYBIND_CAMERA_ZOOM_IN = 230,
    KEYBIND_CAMERA_ZOOM_OUT = 231,
    KEYBIND_CONTROL_GROUPCYCLEPREV = 232,
    KEYBIND_DOTA_ALT = 233,
    KEYBIND_COUNT = 234,
}

/**
 * @deprecated Non-normalized enum name. Defined only for library compatibility.
 */
type DOTA_SHOP_TYPE = ShopType;

declare enum ShopType {
    HOME = 0,
    SIDE = 1,
    SECRET = 2,
    GROUND = 3,
    SIDE_2 = 4,
    SECRET_2 = 5,
    CUSTOM = 6,
    NEUTRALS = 7,
    NONE = 8,
}
