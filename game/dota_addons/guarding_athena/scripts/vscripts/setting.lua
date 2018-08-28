ENABLE_HERO_RESPAWN = true              -- 是否允许英雄重生
UNIVERSAL_SHOP_MODE = true              -- 是否在一个商店出售所有商店的物品
ALLOW_SAME_HERO_SELECTION = true        -- 是否允许相同英雄

HERO_SELECTION_TIME = 20.0              -- 英雄选择时间
PRE_GAME_TIME = 50.0                    -- 游戏开始前的准备时间
POST_GAME_TIME = 120.0                  -- 游戏结束后自动退出的时间
TREE_REGROW_TIME = 60.0                 -- 树木重生时间

GOLD_PER_TICK = 1                       -- 固定金钱获得
GOLD_TICK_TIME = 1                      -- 固定金钱获得间隔

RECOMMENDED_BUILDS_DISABLED = false     -- 是否禁止打开英雄的推荐物品界面
CAMERA_DISTANCE_OVERRIDE = 1200         -- 镜头的距离，输入-1来使用默认的1134距离

MINIMAP_ICON_SIZE = 1                   -- 英雄小地图图标大小
MINIMAP_CREEP_ICON_SIZE = 1             -- 普通单位小地图图标大小

CUSTOM_BUYBACK_COST_ENABLED = true      -- 是否使用自定义买活费用
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- 是否使用自定义买活冷却
BUYBACK_ENABLED = true                  -- 是否允许买活

DISABLE_FOG_OF_WAR_ENTIRELY = true      -- 是否取消战争迷雾
USE_UNSEEN_FOG_OF_WAR = false           -- 是否使得战争迷雾区域完全黑直到探索过
                                            -- Note: DISABLE_FOG_OF_WAR_ENTIRELY must be false for USE_UNSEEN_FOG_OF_WAR to work
USE_STANDARD_DOTA_BOT_THINKING = false  -- 是否使用dota的ai设定(适合三线对抗)
USE_STANDARD_HERO_GOLD_BOUNTY = false   -- 使用dota的英雄击杀金钱设定

USE_CUSTOM_TOP_BAR_VALUES = true        -- 是否使用自定义的顶部计分数值
TOP_BAR_VISIBLE = true                  -- 是否显示顶部计分板

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- 是否开启偷塔保护
REMOVE_ILLUSIONS_ON_DEATH = false       -- 是否幻象死亡时立即消失
DISABLE_GOLD_SOUNDS = true              -- 是否取消玩家获得金钱时的音效

USE_CUSTOM_HERO_LEVELS = true           -- 使用自定义英雄等级
MAX_LEVEL = 500                         -- 英雄最大等级
USE_CUSTOM_XP_VALUES = true             -- 是否使用自定义经验表

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

ENABLE_FIRST_BLOOD = false              -- 是否启用第一滴血
HIDE_KILL_BANNERS = true                -- 是否隐藏击杀标语
LOSE_GOLD_ON_DEATH = false              -- 英雄死亡时是否掉落金钱
SHOW_ONLY_PLAYER_INVENTORY = false      -- 是否只显示玩家自身的背包
DISABLE_STASH_PURCHASING = false        -- 当玩家不在商店范围内购物时是否禁用自动存放在储藏室
DISABLE_ANNOUNCER = true                -- 是否禁用播音员
FORCE_PICKED_HERO = "npc_dota_hero_wisp"                 -- 是否强制所有玩家选择一个英雄(e.g. "npc_dota_hero_axe")

FIXED_RESPAWN_TIME = 15                 -- 设置自定义复活时间(-1使用默认值)
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- 设置泉水固定值的魔法回复量(-1使用默认值)
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- 设置泉水百分比的魔法回复量(-1使用默认值)
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- 设置泉水百分比的生命回复量(-1使用默认值)
MAXIMUM_ATTACK_SPEED = 800              -- 设置最大攻击速度
MINIMUM_ATTACK_SPEED = 20               -- 设置最小攻击速度

GAME_END_DELAY = -1                     -- 游戏胜利后显示计分板所等待的时间(-1使用默认10秒)
VICTORY_MESSAGE_DURATION = 30           -- How long should we wait after the victory message displays to show the End Screen?  Use 
STARTING_GOLD = 0                       -- 设置初始金钱
DISABLE_DAY_NIGHT_CYCLE = false         -- 是否禁用自然发生的昼夜循环
DISABLE_KILLING_SPREE_ANNOUNCER = false -- 是否禁用击杀播音员
DISABLE_STICKY_ITEM = false             -- 是否禁用快速购买处的物品
SKIP_TEAM_SETUP = true                  -- 是否完全跳过队伍设置
ENABLE_AUTO_LAUNCH = true               -- 是否在队伍选择时间结束后自动开始游戏
AUTO_LAUNCH_DELAY = 5                   -- 队伍选择时间
LOCK_TEAM_SETUP = true                  -- 是否自动锁定队伍


USE_CUSTOM_TEAM_COLORS = true           -- 是否使用自定义队伍颜色

TEAM_COLORS = {}                        -- 定义队伍颜色
TEAM_COLORS[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    蓝绿色
TEAM_COLORS[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    黄色
TEAM_COLORS[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    粉红色
TEAM_COLORS[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    橙色
TEAM_COLORS[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    蓝色
TEAM_COLORS[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    绿色
TEAM_COLORS[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    棕色
TEAM_COLORS[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    青色
TEAM_COLORS[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    橄榄色
TEAM_COLORS[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    紫色


CUSTOM_TEAM_PLAYER_COUNT = {}							-- 设置队伍人数
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 4
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 0
--CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 0