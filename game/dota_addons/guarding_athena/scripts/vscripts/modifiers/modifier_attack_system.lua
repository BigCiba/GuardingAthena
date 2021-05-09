if modifier_attack_system == nil then
    modifier_attack_system = class({})
end

local public = modifier_attack_system

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT+MODIFIER_ATTRIBUTE_MULTIPLE+MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function public:OnCreated(params)
	if IsServer() then
		self.iAttackState = params.iAttackState
		self.record = params.iRecord
		self.hAttacker = EntIndexToHScript(params.iAttacker)
		if IsValid(self.hAttacker) then
			AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self.hAttacker)
			AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self.hAttacker)
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		if IsValid(self.hAttacker) then
			RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self.hAttacker)
			RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self.hAttacker)
		end
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD,
	}
end
function public:OnAttackRecordDestroy(params)
	if self.record == params.record then
		params.attacker.ATTACK_SYSTEM[params.record] = nil
		self:Destroy()
		-- print("OnAttackRecordDestroy:", params.record)
	end
end
function public:OnAttackRecord(params)
	if self.record == nil then
		if params.attacker.ATTACK_SYSTEM == nil then params.attacker.ATTACK_SYSTEM = {} end
		params.attacker.ATTACK_SYSTEM[params.record] = self.iAttackState
		self.record = params.record
		-- print("OnAttackRecord:", self.record)
	end
end