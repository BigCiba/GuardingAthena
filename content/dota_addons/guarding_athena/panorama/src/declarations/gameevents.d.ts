declare interface CustomGameEventDeclarations {
	[key: string]: any;
	service_events_req: { eventName: string, data: string, queueIndex: string; };
	service_events_res: { queueIndex: string, result: string; };
}