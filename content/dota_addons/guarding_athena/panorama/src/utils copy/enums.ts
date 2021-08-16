export enum RoomType {
	ROOM_TYPE_INVALID = 0,		// 无效
	ROOM_TYPE_STARTING = 1,		// 开始房间
	ROOM_TYPE_ENEMY = 2,		// 主线的怪物房间
	ROOM_TYPE_SHOP = 3,			// 商店房间
	ROOM_TYPE_BOSS = 4,			// OSS房间
	ROOM_TYPE_BONUS = 6,		// 特殊奖励房间
	ROOM_TYPE_ENEMY_BONUS = 7,	// 支线的怪物房间
	ROOM_TYPE_TELEPORT = 8,		// 出口房间（连接下一关）
	ROOM_TYPE_ENEMY_ELITE = 9,	// 精英房间
	ROOM_TYPE_CHEST = 10,		// 宝箱房间
}
export enum RoomState {
	ROOM_STATE_INVALID = 0,		// 无效
	ROOM_STATE_HIDE = 1,		// 隐藏状态
	ROOM_STATE_ACTIVE = 2,		// 激活状态
	ROOM_STATE_USED = 3,		// 使用过
}