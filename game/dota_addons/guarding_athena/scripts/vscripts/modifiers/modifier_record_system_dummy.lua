modifier_record_system_dummy = eom_modifier({})

local public = modifier_record_system_dummy

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
function public:GetPriority()
	return MODIFIER_PRIORITY_LOW
end
function public:OnCreated(params)
	if IsServer() then
		self:GetParent().iLastRecord = 0
	end
end
function public:OnDestroy()
	if IsServer() then
		self:GetParent():Remove()
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
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function public:OnAttackRecord(params)
	self:GetParent().iLastRecord = params.record

	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackRecord then
				hModifier:OnAttackRecord(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackRecordDestroy(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackRecordDestroy then
				hModifier:OnAttackRecordDestroy(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if self:GetParent().ATTACK_SYSTEM ~= nil then
		self:GetParent().ATTACK_SYSTEM[params.record] = nil
	end
end
function public:OnTakeDamage(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnTakeDamage then
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTakeDamage then
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTakeDamage then
				hModifier:OnTakeDamage(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if self:GetParent().DAMAGE_SYSTEM ~= nil then
		self:GetParent().DAMAGE_SYSTEM[params.record] = nil
	end
end