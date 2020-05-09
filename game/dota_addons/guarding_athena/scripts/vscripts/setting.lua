if Settings == nil then
	Settings = {}
end
local public = Settings

sGameVersion = "v1.34"

MODIFIER_EVENT_ON_ABILITY_LEARNED = MODIFIER_FUNCTION_LAST + 1 -- OnAbilityLearned

CUSTOM_MODIFIER_EVENT_FUNCTIONS = {}
CUSTOM_MODIFIER_EVENT_FUNCTIONS[MODIFIER_EVENT_ON_ABILITY_LEARNED] = "OnAbilityLearned"

if IsServer() then
	DOTA_DAMAGE_FLAG_NO_SPELL_CRIT = DOTA_DAMAGE_FLAG_PROPERTY_FIRE * 2
end
-------------------------------------------------------
-- 服务器相关
-------------------------------------------------------
PLAYER_XP_PER_LEVEL = 10			-- 玩家每级经验
-------------------------------------------------------
-- 英雄属性相关
-------------------------------------------------------
MAX_LEVEL = 500						-- 英雄最大等级

-- 定义经验表
XP_PER_LEVEL_TABLE = {}
local exp = 0 
for i=1,100 do 
	XP_PER_LEVEL_TABLE[i] = exp 
	exp = exp + 200 + i * 200
end
exp = exp + 1000000
for i=101,200 do 
	XP_PER_LEVEL_TABLE[i] = exp 
	exp = exp + 200 + (i-100) * 300
end
exp = exp + 1000000
for i=201,300 do 
	XP_PER_LEVEL_TABLE[i] = exp 
	exp = exp + 200 + (i-200) * 400
end
exp = exp + 1000000
for i=301,400 do 
	XP_PER_LEVEL_TABLE[i] = exp 
	exp = exp + 200 + (i-300) * 500
end
exp = exp + 1000000
for i=401,500 do 
	XP_PER_LEVEL_TABLE[i] = exp 
	exp = exp + 200 + (i-400) * 600
end

MAXIMUM_ATTACK_SPEED = 800								-- 设置最大攻击速度
MINIMUM_ATTACK_SPEED = 20								-- 设置最小攻击速度
ATTRIBUTE_AGILITY_ARMOR = 0								-- 每点敏捷提供护甲
ATTRIBUTE_AGILITY_ATTACK_SPEED = 0.05					-- 每点敏捷提供攻速
ATTRIBUTE_AGILITY_DAMAGE = 1							-- 每点敏捷提供攻击力
ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT = 0.00001			-- 每点敏捷提供移速
ATTRIBUTE_INTELLIGENCE_DAMAGE = 3						-- 每点智力提供攻击力
ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT = 0		-- 每点智力提供魔抗
ATTRIBUTE_INTELLIGENCE_MANA = 12						-- 每点智力提供魔法
ATTRIBUTE_INTELLIGENCE_MANA_REGEN = 0.04				-- 每点智力提供魔法回复
ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT = 0.002		-- 每点智力提供技能增强
ATTRIBUTE_STRENGTH_DAMAGE = 2							-- 每点力量提供攻击力
ATTRIBUTE_STRENGTH_HP = 20								-- 每点力量提供生命
ATTRIBUTE_STRENGTH_HP_REGEN = 0.06						-- 每点力量提供生命回复
ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT = 0			-- 每点力量提供魔抗
ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT = 0		-- 每点力量提供状态抗性

-------------------------------------------------------
-- 游戏机制
-------------------------------------------------------
DIFFICULTY_RESPAWN_TIME = {		-- 重生时间
	[1] = 5,
	[2] = 6,
	[3] = 7,
	[4] = 8,
	[5] = 10,
}
DIFFICULTY_GOLD_TICK = {		-- 每秒金钱
	[1] = 9,
	[2] = 6,
	[3] = 3,
	[4] = 0,
	[5] = 0,
}
DIFFICULTY_INIT_GOLD = {		-- 初始金钱
	[1] = 300,
	[2] = 200,
	[3] = 100,
	[4] = 0,
	[5] = 0,
}
TIME_BOSS_REBORN = 60			-- boss重生间隔
HERO_SELECTION_TIME = IsInToolsMode() and 5 or 20
-- 刷新排除技能
REFRESH_EXCLUDE_ABILITIES = {
}
-- 刷新排除物品
REFRESH_EXCLUDE_ITEMS = {
	["item_visage_1"] = 1, 		-- 倒转阴阳
	["item_visage_4"] = 1, 		-- 死神披风
	["item_longinus_spear"] = 1, 	-- 朗基努斯之枪
}

TEAM_COLORS = {}						-- 定义队伍颜色
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --	蓝绿色
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --	黄色
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --	粉红色
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --	橙色
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --	蓝色
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --	绿色
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --	棕色
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --	青色
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --	橄榄色
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --	紫色

function public:init(bReload)
	-- 设置游戏系统规则
	CustomNetTables:SetTableValue( "difficulty", "setting", {hero_selection_time = HERO_SELECTION_TIME} )
	GameRules:SetHeroRespawnEnabled( true )								-- 是否允许英雄重生
	GameRules:SetSameHeroSelectionEnabled( true )						-- 是否允许相同英雄
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )								-- 英雄选择时间
	GameRules:SetStrategyTime( 0 )										-- 英雄选择策略时间
	GameRules:SetHeroSelectPenaltyTime( 0 )								-- 英雄选择惩罚时间
	GameRules:SetShowcaseTime( 0 )										-- 英雄展示时间
	GameRules:SetPreGameTime( 30 )										-- 游戏开始前的准备时间
	GameRules:SetPostGameTime( 120 )									-- 游戏结束后自动退出的时间
	GameRules:SetTreeRegrowTime( 60 )									-- 树木重生时间
	GameRules:SetUseCustomHeroXPValues( true )							-- 是否使用自定义经验表
	GameRules:SetGoldPerTick( 1 )										-- 固定金钱获得
	GameRules:SetGoldTickTime( 1 )										-- 固定金钱获得间隔
	GameRules:SetUseBaseGoldBountyOnHeroes( false )						-- 使用dota的英雄击杀金钱设定
	GameRules:SetFirstBloodActive( false )								-- 是否启用第一滴血
	GameRules:SetHideKillMessageHeaders( true )							-- 是否隐藏击杀标语
	GameRules:SetUseUniversalShopMode( true )							-- 是否在一个商店出售所有商店的物品
	GameRules:SetHeroMinimapIconScale( 1 )								-- 英雄小地图图标大小
	GameRules:SetCreepMinimapIconScale( 1 )								-- 普通单位小地图图标大小
	GameRules:SetCustomGameEndDelay( -1 )								-- 游戏胜利后显示计分板所等待的时间(-1使用默认10秒)
	GameRules:SetCustomVictoryMessageDuration( 30 )						-- How long should we wait after the victory message displays to show the End Screen?  Use 
	GameRules:SetStartingGold( 0 )										-- 设置初始金钱
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)		-- 设置队伍人数
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)			-- 设置队伍人数
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )					-- 队伍选择时间
	GameRules:LockCustomGameSetupTeamAssignment( true )					-- 是否自动锁定队伍
	GameRules:EnableCustomGameSetupAutoLaunch( true )					-- 是否在队伍选择时间结束后自动开始游戏
	GameRules.ItemInfoKV = LoadKeyValues("scripts/kv/item_info.kv")
	GameRules.sandking = true
	SetTeamCustomHealthbarColor(DOTA_TEAM_GOODGUYS, 61, 210, 150)		-- 自定义队伍颜色
	SetTeamCustomHealthbarColor(DOTA_TEAM_BADGUYS, 243, 201, 9)			-- 自定义队伍颜色

	-- 设置游戏规则
	GameMode = GameRules:GetGameModeEntity()		
	-- GameMode:SetCustomGameForceHero( "npc_dota_hero_wisp" )				-- 强制所有玩家选择一个英雄(e.g. "npc_dota_hero_axe")
	GameMode:SetRecommendedItemsDisabled( false )						-- 是否禁止打开英雄的推荐物品界面
	GameMode:SetTopBarTeamValuesOverride ( true )						-- 是否使用自定义的顶部计分数值
	GameMode:SetTopBarTeamValuesVisible( true )							-- 是否显示顶部计分板
	GameMode:SetUseCustomHeroLevels ( true )							-- 使用自定义英雄等级
	GameMode:SetTowerBackdoorProtectionEnabled( false )					-- 是否开启偷塔保护
	GameMode:SetGoldSoundDisabled( true )								-- 是否取消玩家获得金钱时的音效
	GameMode:SetRemoveIllusionsOnDeath( false )							-- 是否幻象死亡时立即消失
	GameMode:SetAnnouncerDisabled( true )								-- 是否禁用播音员
	GameMode:SetAlwaysShowPlayerInventory( false )						-- 是否只显示玩家自身的背包
	GameMode:SetLoseGoldOnDeath( false )								-- 英雄死亡时是否掉落金钱
	GameMode:SetCameraDistanceOverride( 1200 )							-- 镜头的距离，输入-1来使用默认的1134距离
	GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )	-- 使用自定义经验表
	GameMode:SetFogOfWarDisabled( true )								-- 是否取消战争迷雾
	GameMode:SetUnseenFogOfWarEnabled( false )							-- 是否使得战争迷雾区域完全黑直到探索过
	GameMode:SetCustomHeroMaxLevel ( MAX_LEVEL )						-- 英雄最大等级
	GameMode:SetFixedRespawnTime(15)									-- 设置自定义复活时间(-1使用默认值)
	GameMode:SetFountainConstantManaRegen( -1 )							-- 设置泉水固定值的魔法回复量(-1使用默认值)
	GameMode:SetFountainPercentageHealthRegen( -1 )						-- 设置泉水百分比的生命回复量(-1使用默认值)
	GameMode:SetFountainPercentageManaRegen( -1 )						-- 设置泉水固定值的魔法回复量(-1使用默认值)
	GameMode:SetBuybackEnabled( true )									-- 是否允许买活
	GameMode:SetCustomBuybackCooldownEnabled( true )					-- 是否使用自定义买活冷却
	GameMode:SetCustomBuybackCostEnabled( true )						-- 是否使用自定义买活费用
	GameMode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )				-- 设置最大攻击速度
	GameMode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )				-- 设置最小攻击速度
	GameMode:SetStashPurchasingDisabled ( false )						-- 当玩家不在商店范围内购物时是否禁用自动存放在储藏室
	GameMode:SetBotThinkingEnabled( false )								-- 是否使用dota的ai设定(适合三线对抗)
	GameMode:SetDaynightCycleDisabled( false )							-- 是否禁用自然发生的昼夜循环
	GameMode:SetKillingSpreeAnnouncerDisabled( false )					-- 是否禁用击杀播音员
	GameMode:SetStickyItemDisabled( false )								-- 是否禁用快速购买处的物品
	GameMode:SetThink("DetectCheatsThinker")
	-- 设定平衡常数
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR, ATTRIBUTE_AGILITY_ARMOR)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED, ATTRIBUTE_AGILITY_ATTACK_SPEED)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE, ATTRIBUTE_AGILITY_DAMAGE)
	-- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT, ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE, ATTRIBUTE_INTELLIGENCE_DAMAGE)
	-- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT, ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA, ATTRIBUTE_INTELLIGENCE_MANA)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN, ATTRIBUTE_INTELLIGENCE_MANA_REGEN)
	-- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT, ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE, ATTRIBUTE_STRENGTH_DAMAGE)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP, ATTRIBUTE_STRENGTH_HP)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN, ATTRIBUTE_STRENGTH_HP_REGEN)
	-- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT, ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT)
	-- GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT, ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT)
	-- 玩家可买物品最大数目，不限制
	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
end

return public