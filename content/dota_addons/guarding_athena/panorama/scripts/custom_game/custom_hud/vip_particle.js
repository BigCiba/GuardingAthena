var select_id = $('#VipParticleDrop').GetSelected().id;
function OnDropDownChanged(){
	select_id = $('#VipParticleDrop').GetSelected().id;
}
function CreateParticle(){
	GameEvents.SendCustomGameEventToServer("vip_particle", { "id": select_id });
}
function RemoveParticle(){
	GameEvents.SendCustomGameEventToServer("vip_particle", { "id": false });
}