declare interface Panel {
	readonly actualuiscale_x: number;
	readonly actualuiscale_y: number;
}

declare interface CustomUIConfig {
	PetsKv: any;
	HeroesKv: any;
	tMouseEvents: [];
}
declare function GetPlayerPrice(sPlayerID: number): number;
declare function GetPlayerShard(sPlayerID: number): number;