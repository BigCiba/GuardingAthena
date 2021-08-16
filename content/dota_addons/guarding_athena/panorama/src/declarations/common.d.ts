declare interface Panel {
	FindAncestor(arg0: string): Panel;
	readonly actualuiscale_x: number;
	readonly actualuiscale_y: number;
}

declare function GetPlayerPrice(sPlayerID: number): number;
declare function GetPlayerShard(sPlayerID: number): number;

declare function GetPaytypes(): any;
declare function GetPayTypeImg(paytype: string): string;


declare interface Table {
	[x: string]: any;
}

declare interface LuaVector {
	x: number;
	y: number;
	z: number;
}

/**
 * notification库所用的数据格式
 */
declare interface NotificationData {
	message: string;
	player_id: PlayerID | undefined;
	player_id2: PlayerID | undefined;
	teamnumber: DOTATeam_t | undefined;
	team_only: 0 | 1 | undefined;
	[x: string]: any;
}

/**
 * 打印
 * @param args 
 */
declare function print(...args: any[]): void;

/**
 * 在对象里寻找值
 * @param o 对象
 * @param v 值
 * @returns 返回值的key，无此值则返回undefined
 */
declare function FindKey(o: object, v: any): string | undefined;

/**
 * 四舍五入
 * @param fNumber 数值
 * @param prec 精确到小数点几位，选填，默认0
 */
declare function Round(fNumber: number, prec?: number): number;

/**
 * 播放音效
 * @param sSoundName 音效名字
 */
declare function PlaySoundEffect(sSoundName: string): void;

/**
 * 区间限定函数
 * @param num 数值
 * @param min 最大值
 * @param max 最小值
 * @returns 返回限定区间的值
 */
declare function Clamp(num: number, min: number, max: number): number;

/**
 * 重映射区间限定函数
 * @param num 数值
 * @param a 初始区间最小值
 * @param b 初始区间最大值
 * @param c 最终区间最小值
 * @param d 最终区间最大值
 * @returns 返回重映射区间的值
 */
declare function RemapValClamped(num: number, a: number, b: number, c: number, d: number): number;

/**
 * 判断点是否在点集形成的多边形区域内
 * @param point 
 * @param polygon 顶点位置集，按顶点位置顺序划线，线之间不能交叉
 * @returns 返回点是否在区域内
 */
declare function IsPointInPolygon(point: [number, number, number], polygon: LuaVector[]): boolean;

/**
 * 深度打印对象信息
 * @param obj 对象
 */
declare function DeepPrint(obj: object | Array<any>): void;

/**
 * $里的自定义函数
 */
declare interface DollarStatic {
	/**
	 * 获取一个随机整数
	 * @param n 最小值
	 * @param m 最大值
	 * @returns 返回一个[n, m]区间的随机整数
	 */
	RandomInt(n: number, m: number): number;
	/**
	 * 获取一个随机浮点数
	 * @param n 最小值
	 * @param m 最大值
	 * @returns 返回一个[n, m]区间的随机浮点数
	 */
	RandomFloat(n: number, m: number): number;
}

/**
 * 自定义鼠标事件表
 */
declare type MouseEvents = { fCallback: (tData: { event_name: MouseEvent, value: MouseButton | MouseScrollDirection, result: boolean; }) => boolean | void, iPriority: number; };

declare interface CustomUIConfig {
	PlayerItemsKV: Table;
	PetsKv: Table;

	UnsubscribeMouseEvent: (sName: string) => void;
	tMouseEvents: { [sName: string]: MouseEvents; };

	SubscribeMouseEvent(sName: string, fCallback: (tData: { event_name: MouseEvent, value: MouseButton | MouseScrollDirection, result: boolean; }) => boolean | void, iPriority?: number): void;

	/**
	 * 显示自定义技能Tooltip
	 * @param panel 目标面板
	 * @param abilityname 技能名字，必填
	 * @param entityindex 单位，选填，默认
	 * @param inventoryslot 物品槽位，选填，默认
	 * @param level 等级，选填，默认-1
	 */
	ShowAbilityTooltip(panel: Panel, abilityname: string, entityindex?: EntityIndex, inventoryslot?: number, level?: number): void;

	/**
	 * 隐藏自定义技能Tooltip
	 * @param panel 目标面板
	 */
	HideAbilityTooltip(panel: Panel): void;

	/**
	 * 显示一个打造敲击特效在目标面板上
	 * @param pTargetPanel 目标面板
	 * @param iMaxCount 最大敲击次数
	 */
	FireForgeParticle(pTargetPanel: Panel, iMaxCount?: number): void;

	/**
	 * 显示一个改变金钱在目标面板上
	 * @param pTargetPanel 目标面板
	 * @param iChanged 变化值
	 * @param fDuration 持续时间，选填，默认1
	 */
	FireChangeGold(pTargetPanel: Panel, iChanged: number, fDuration?: number): void;

	/**
	 * 获取指定位置的物品容器
	 * @param aPosition 屏幕位置，选填，默认鼠标位置
	 */
	GetCursorPhysicalItem(aPosition?: [number, number]): ItemEntityIndex;

	/**
	 * 获取指定位置的实体
	 * @param aPosition 屏幕位置，选填，默认鼠标位置
	 */
	GetCursorEntity(aPosition?: [number, number]): EntityIndex;
	/**
	 * 拖拽开始
	 * @param panel 面板
	 */
	StartDrag(panel: Panel): void;
	/**
	 * 拖拽结束
	 */
	EndDrag(): void;

	/**
	 * 技能
	 */
	AbilitiesKv: Table;
	/**
	 * 充能modifier
	 */
	ChargeCounterKv: Table;
	/**
	 * 英雄
	 */
	HeroesKv: Table;
	/**
	 * 物品
	 */
	ItemsKv: Table;
	/**
	 * 单位
	 */
	UnitsKv: Table;
	/**
	 * 饰品
	 */
	WearablesKv: Table;
	/**
	 * 技能升级
	 */
	AbilityUpgradesKv: Table;
	/**
	 * 被动技能
	 */
	PassiveAbilitiesKv: Table;
	/**
	 * 信仰技能
	 */
	FaithAbilitiesKv: Table;
	/**
	 * 敌人kv
	 */
	EnemiesKV: Table;
	/**
	 * Bosskv
	 */
	BossKV: Table;
}


declare interface CScriptBindingPR_Entities {
	/**
	 * 从lua client获取单位数据
	 * @param iUnitEntIndex 单位
	 * @param sFuncName lua client函数名字
	 */
	GetUnitData(iUnitEntIndex: EntityIndex, sFuncName: string): void;
	/**
	 * 获取单位物理防御
	 * @param iUnitEntIndex 单位
	 * @returns 返回物理防御
	 */
	GetPhysicalArmor(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础物理防御
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础物理防御
	 */
	GetBasePhysicalArmor(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位魔法防御
	 * @param iUnitEntIndex 单位
	 * @returns 返回魔法防御
	 */
	GetMagicalArmor(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础魔法防御
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础魔法防御
	 */
	GetBaseMagicalArmor(iUnitEntIndex: EntityIndex): number;
	/**
	 * 判断单位是否有英雄属性
	 * @param iUnitEntIndex 单位
	 * @returns 返回是否有英雄属性
	 */
	HasHeroAttribute(iUnitEntIndex: EntityIndex): boolean;
	/**
	 * 获取单位力量
	 * @param iUnitEntIndex 单位
	 * @returns 返回力量
	 */
	GetStrength(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础力量
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础力量
	 */
	GetBaseStrength(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位敏捷
	 * @param iUnitEntIndex 单位
	 * @returns 返回敏捷
	 */
	GetAgility(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础敏捷
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础敏捷
	 */
	GetBaseAgility(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位智力
	 * @param iUnitEntIndex 单位
	 * @returns 返回智力
	 */
	GetIntellect(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础智力
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础智力
	 */
	GetBaseIntellect(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位主属性
	 * @param iUnitEntIndex 单位
	 * @returns 返回主属性
	 */
	GetPrimaryAttribute(iUnitEntIndex: EntityIndex): Attributes;
	/**
	 * 获取单位攻击速度百分比
	 * @param iUnitEntIndex 单位
	 * @returns 返回攻击速度百分比
	 */
	GetAttackSpeedPercent(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位移动速度
	 * @param iUnitEntIndex 单位
	 * @returns 返回移动速度
	 */
	GetMoveSpeed(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位技能伤害
	 * @param iUnitEntIndex 单位
	 * @returns 返回技能伤害
	 */
	GetSpellAmplify(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位冷却减少
	 * @param iUnitEntIndex 单位
	 * @returns 返回冷却减少
	 */
	GetCooldownReduction(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位魔法回复
	 * @param iUnitEntIndex 单位
	 * @returns 返回魔法回复
	 */
	GetManaRegen(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位闪避
	 * @param iUnitEntIndex 单位
	 * @returns 返回闪避
	 */
	GetEvasion(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位状态抗性
	 * @param iUnitEntIndex 单位
	 * @returns 返回状态抗性
	 */
	GetStatusResistance(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位生命回复
	 * @param iUnitEntIndex 单位
	 * @returns 返回生命回复
	 */
	GetHealthRegen(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位警戒范围
	 * @param iUnitEntIndex 单位
	 * @returns 返回警戒范围
	 */
	GetAcquisitionRange(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位基础警戒范围
	 * @param iUnitEntIndex 单位
	 * @returns 返回基础警戒范围
	 */
	GetBaseAcquisitionRange(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位最大怒气
	 * @param iUnitEntIndex 单位
	 * @returns 返回最大怒气
	 */
	GetMaxEnergy(iUnitEntIndex: EntityIndex): number;
	/**
	 * 获取单位怒气
	 * @param iUnitEntIndex 单位
	 * @returns 返回怒气
	 */
	GetEnergy(iUnitEntIndex: EntityIndex): number;

	/**
	 * 获取单位的技能槽位
	 * @param iEntityIndex 单位
	 * @param iAbilityEntIndex 技能
	 * @returns 返回技能所在槽位，-1则不存在
	 */
	GetAbilityIndex(iEntityIndex: EntityIndex, iAbilityEntIndex: AbilityEntityIndex): number;

	/**
	 * 判断单位是否拥有modifier
	 * @param unitEntIndex 单位
	 * @param buffName modifier名字
	 * @returns 返回是否拥有
	 */
	HasBuff(unitEntIndex: EntityIndex, buffName: string): boolean;
}

declare interface CScriptBindingPR_Abilities {
	/**
	 * 获取技能对应等级的金钱消耗
	 * @param iEntityIndex 技能
	 * @param iLevel 等级，选填，默认-1
	 */
	GetLevelGoldCost(iEntityIndex: AbilityEntityIndex, iLevel?: number): number;
	/**
	 * 获取技能对应等级的冷却时间
	 * @param iEntityIndex 技能
	 * @param iLevel 等级，选填，默认-1
	 */
	GetLevelCooldown(iEntityIndex: AbilityEntityIndex, iLevel?: number): number;
	/**
	 * 获取技能对应等级的魔法消耗
	 * @param iEntityIndex 技能
	 * @param iLevel 等级，选填，默认-1
	 */
	GetLevelManaCost(iEntityIndex: AbilityEntityIndex, iLevel?: number): number;
	/**
	 * 获取技能对应等级的怒气消耗
	 * @param iEntityIndex 技能
	 * @param iLevel 等级，选填，默认-1
	 */
	GetLevelEnergyCost(iEntityIndex: AbilityEntityIndex, iLevel?: number): number;
}

declare interface CScriptBindingPR_Players {
	/**
	 * 清除本地玩家选择的某个单位
	 * @param iRemoveEntIndex 单位
	 */
	RemoveSelection(iRemoveEntIndex: EntityIndex): void;

	/**
	 * 判断单位是否被玩家选择
	 * @param iEntIndex 单位
	 */
	IsEntitySelected(iEntIndex: EntityIndex): boolean;
}

declare interface CDOTA_PanoramaScript_GameUI {
	MoveCameraToEntity(nTargetEntIndex: EntityIndex): void;
}

/**
 * 发送错误信息
 * @param msg 错误信息
 * @param sound 音效，选填，默认"General.CastFail_Custom"
 */
declare function ErrorMessage(msg: string, sound?: string): void;

/**
 * 计算技能升级数值结果
 * @param iEntityIndex 单位
 * @param sAbilityName 技能名字
 * @param sSpecialValueName 数值名字
 * @param fValue 计算前数值
 * @returns 计算后的数值
 */
declare function CalcSpecialValueUpgrade(iEntityIndex: EntityIndex, sAbilityName: string, sSpecialValueName: string, fValue: number): number;

/**
 * 获取物品稀有度
 * @param sItemName 物品名字
 * @returns 返回物品稀有度
 */
declare function GetItemRarity(sItemName: string): number;

/**
 * 获取物品价格
 * @param sItemName 物品名字
 * @returns 返回物品价格
 */
declare function GetItemCost(sItemName: string): number;

/**
 * 处理错误Float
 * @param f 浮点数
 */
declare function Float(f: number): number;

/**
 * 将矢量转化为字符串（方便lua端和js端通讯）
 * @param vec 矢量
 * @returns 返回以空格分隔坐标的字符串
 */
declare function VectorToString(vec: [number, number, number]): string;

/**
 * 将字符串转化为矢量（方便lua端和js端通讯）
 * @param str 空格分隔坐标的字符串
 * @returns 返回矢量
 */
declare function StringToVector(str: string): [number, number, number];

/**
 * 通过英雄ID获取DOTA2英雄名字
 * @param iHeroID 英雄ID
 * @returns DOTA2英雄名字
 */
declare function GetHeroNameByHeroID(iHeroID: HeroID): string;

/**
 * 将技能kv里定义的AbilityBehavior转化为枚举
 * @param sBehaviors 
 */
declare function SBehavior2IBehavior(sBehaviors: string): DOTA_ABILITY_BEHAVIOR;

/**
 * 将技能kv里定义的AbilityUnitTargetTeam转化为枚举
 * @param sTeam 
 */
declare function STeam2ITeam(sTeam: string): DOTA_UNIT_TARGET_TEAM;

/**
 * 将技能kv里定义的AbilityUnitTargetType转化为枚举
 * @param sType 
 */
declare function SType2IType(sType: string): DOTA_UNIT_TARGET_TYPE;

/**
 * 将技能kv里定义的AbilityUnitDamageType转化为枚举
 * @param sDamageType 
 */
declare function SDamageType2IDamageType(sDamageType: string): DAMAGE_TYPES;

/**
 * 将技能kv里定义的SpellImmunityType转化为枚举
 * @param sSpellImmunityType 
 */
declare function SSpellImmunityType2ISpellImmunityType(sSpellImmunityType: string): SPELL_IMMUNITY_TYPES;

/**
 * 特殊值对应的函数
 */
declare const tAddedProperties: { [x: string]: keyof CScriptBindingPR_Entities; };

/**
 * 将数据简化
 * @param aValues 数据数组
 */
declare function SimplifyValuesArray(aValues: number[]): number[];

/**
 * 将一串字符串以空格分隔的数值转化为数组
 * @param sValues 字符串数值
 * @returns 返回数值数组
 */
declare function StringToValues(sValues: string): number[];

/**
 * 获取技能的所有Special键
 * @param sAbilityName 技能名字
 * @param iEntityIndex 单位，选填，默认-1
 * @returns 返回Special键的数组
 */
declare function GetSpecialNames(sAbilityName: string, iEntityIndex?: EntityIndex): string[];

/**
 * 获取技能Special经过处理后的所有键值
 * @param sAbilityName 技能名字
 * @param sName 键名字
 * @param iEntityIndex 单位，选填，默认-1
 * @returns 返回一个对象：aValues-键值最终值数组;aOriginalValues-键值原值数组;aMinValues-键值最小值，可为undefined;tAddedFactors-所有附加值系数数组的对象;tAddedValues-所有附加值数值数组的对象
 */
declare function GetSpecialValuesWithCalculated(sAbilityName: string, sName: string, iEntityIndex?: EntityIndex): {
	aValues: number[],
	aOriginalValues: number[],
	aMinValues: number[] | undefined,
	aMaxValues: number[] | undefined,
	tAddedFactors: { [x: string]: number[] | undefined; },
	tAddedValues: { [x: string]: number[] | undefined; },
};

/**
 * 获取技能Special键的附加值
 * @param sAbilityName 技能名字
 * @param sName 键名字
 * @param sPropertyName 附加值名字
 * @param iEntityIndex 单位，选填，默认-1
 * @returns 返回Special键的附加值字符串
 */
declare function GetSpecialValueProperty(sAbilityName: string, sName: string, sPropertyName: string, iEntityIndex?: EntityIndex): string;

/**
 * 将官方获取的颜色integer转化为十六进制表示的颜色字符串
 * @param i 颜色integer
 * @returns 返回十六进制颜色字符串
 */
declare function intToARGB(i: number): string;

/**
 * 格式化数字显示
 * @param fNumber 数值
 * @param bSeparate 是否数值和单位分开返回，默认false
 * @param bUseScientific 是否使用科学计数法，默认false
 * @param iFixNum 小数点精度，默认2
 * @returns bSeparate为false时返回数值字符串；bSeparate为true的时候返回{ 数值, 单位字符串 }
 */
declare function formatNumByLanguage(fNumber: number, bSeparate?: boolean, bUseScientific?: boolean, iFixNum?: number): string;

/**
 * 判断物品是否被锁定
 * @param iItemEntIndex 物品EntIndex
 */
declare function IsItemLocked(iItemEntIndex: ItemEntityIndex): boolean;

/**
 * 获取物品的合成配方
 * @param sItemName 物品名字
 * @returns 返回物品所有的合成配方
 */
declare function GetItemRecipes(sItemName: string): string[][];

/**
 * 获取物品的所在的合成配方
 * @param sItemName 物品名字
 * @returns 返回物品所有所在的合成配方
 */
declare function GetItemRelatedRecipes(sItemName: string): string[][];

/**
 * 获取物品的所在的合成配方并附带结果
 * @param sItemName 物品名字
 * @returns 返回物品所有所在的合成配方以及配方的合成物品
 */
declare function GetItemRelatedRecipesWithResults(sItemName: string): [string[][], string[]];

/**
 * 切换UI窗口
 * @param sName 名字
 */
declare function ToggleWindows(sName: string): void;

interface Console {
	memory: any;
	assert(condition?: boolean, ...data: any[]): void;
	clear(): void;
	count(label?: string): void;
	countReset(label?: string): void;
	debug(...data: any[]): void;
	dir(item?: any, options?: any): void;
	dirxml(...data: any[]): void;
	error(...data: any[]): void;
	exception(message?: string, ...optionalParams: any[]): void;
	group(...data: any[]): void;
	groupCollapsed(...data: any[]): void;
	groupEnd(): void;
	info(...data: any[]): void;
	log(...data: any[]): void;
	table(tabularData?: any, properties?: string[]): void;
	time(label?: string): void;
	timeEnd(label?: string): void;
	timeLog(label?: string, ...data: any[]): void;
	timeStamp(label?: string): void;
	trace(...data: any[]): void;
	warn(...data: any[]): void;
}
declare var console: Console;

declare interface WearablesData {
	"dummy"?: string,
	"used_by_heroes": string,
	"bundle": string,
	"item_slot": string,
	"item_rarity": string,
	"model_player"?: string,
	"item_name"?: string,
	"itemdef"?: string,
	"item_description"?: string,
	"visuals"?: {
		[key: string]: AssetModifierData | number;
	},
}
declare interface PlayerWearableData {
	sPlayerWearableIndex: string,
	sSlot: string,
	sWearableIndex: string,
	tPropertyData: { [x: string]: PlayerWearablePropertyData; },
	tGemData: { [x: string]: string; },
}

declare interface PlayerWearablePropertyData {
	attribute: string;
	value: number;
}

declare interface AssetModifierData {
	type: "activity" | "particle" | "particle_create" | "ability_icon" | "sound" | "particle_snapshot" | "entity_model" | "buff_modifier" | "response_criteria" | "portrait_background_model" | "icon_replacement_hero" | "particle_control_point" | "arcana_level" | "icon_replacement_hero_minimap";
	asset?: string,
	modifier?: string,
	style?: number,
	force_display?: number,
	force_dispawn_in_loadout_onlysplay?: number,
	minimum_priority?: number,
}

/**
 * 获取饰品信息
 * @param sHeroName 英雄名
 * @param sSlot 槽位
 */
declare function GetWearableDataByIndex(index: string): WearablesData;
/**
 * 获取英雄某个槽位的饰品列表
 * @param sHeroName 英雄名
 * @param sSlot 槽位
 */
declare function GetHeroWearableListBySlot(sHeroName: string, sSlot: string): string[];
/**
 * 获取英雄某个槽位的饰品列表
 * @param iPlayerID 玩家id
 * @param iEntIndex 单位
 * @param sPlayerWearableIndex 玩家饰品索引
 */
declare function GetPlayerWearableData(iPlayerID: PlayerID, iEntIndex: EntityIndex, sPlayerWearableIndex: string): PlayerWearableData;

declare function Transform(obj: Table, sTagName: string): any;