declare interface CustomGameEventDeclarations {
	[key: string]: any;
	service_events_req: { eventName: string, data: string, queueIndex: string; };
	service_events_res: { queueIndex: string, result: string; };
	toggle_window: { name: string; };
}
declare interface GameEventDeclarations {
	toggle_window: { name: string; };
}