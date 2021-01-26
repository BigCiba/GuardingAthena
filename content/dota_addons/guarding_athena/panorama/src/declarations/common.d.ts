declare interface Panel {
	FindAncestor(arg0: string): Panel;
	readonly actualuiscale_x: number;
	readonly actualuiscale_y: number;
}

declare interface CustomUIConfig {
	PlayerItemsKV: any;
	PetsKv: any;
	HeroesKv: any;
	tMouseEvents: [];
}
declare function GetPlayerPrice(sPlayerID: number): number;
declare function GetPlayerShard(sPlayerID: number): number;