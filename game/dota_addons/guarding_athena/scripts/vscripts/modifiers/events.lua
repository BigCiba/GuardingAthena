--[[	自定义modifier事件
]]
---@type _G
_eom_modifier_events = {
	MODIFIER_EVENT_ON_ATTACK_START_CUSTOM		= "OnAttackStartCustom",
	MODIFIER_EVENT_ON_SUMMONNED					= "OnSummonned",
	MODIFIER_EVENT_ON_ENEMY_SPAWN				= "OnEnemySpawn",
	MODIFIER_EVENT_ON_DASH						= "OnDash",
	MODIFIER_EVENT_ON_DASH_END					= "OnDashEnd",
	MODIFIER_EVENT_ON_CUSTOM_ATTACK				= "OnCustomAttack",
	MODIFIER_EVENT_ON_CHAPTER_START				= "OnChapterStart",
	MODIFIER_EVENT_ON_CHAPTER_END				= "OnChapterEnd",
	MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED	= "OnValidAbilityExecuted",
	MODIFIER_EVENT_ON_ROOM_START				= "OnRoomStart",
	MODIFIER_EVENT_ON_ROOM_END					= "OnRoomEnd",
}

_G.EOM_MODIFIER_EVENT_NAME = {}
_G.EOM_MODIFIER_EVENT_FUNCTIONS = {}
_G.EOM_MODIFIER_EVENT_INDEXES = {}

local _iIndex = MODIFIER_FUNCTION_LAST + 1
---@private
function _InitModifierEvent(sEventName, sFunctionName)
	_G[sEventName] = _iIndex
	EOM_MODIFIER_EVENT_INDEXES[sEventName] = _iIndex
	EOM_MODIFIER_EVENT_NAME[_iIndex] = sEventName
	EOM_MODIFIER_EVENT_FUNCTIONS[_iIndex] = sFunctionName
	_iIndex = _iIndex + 1
end

for k, v in pairs(_eom_modifier_events) do
	_InitModifierEvent(k, v)
end


function AddModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			table.insert(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			table.insert(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		table.insert(tModifierEvents[iModifierEvent], hModifier)
	end
end

function RemoveModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		ArrayRemove(tModifierEvents[iModifierEvent], hModifier)
	end
end

---发起召唤事件
---@param params {unit : 召唤者, target : 被召唤者, refresh: 是否为刷新召唤}
function Fire_OnSummonned(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SUMMONNED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SUMMONNED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnSummonned then
				hModifier:OnSummonned(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SUMMONNED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SUMMONNED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSummonned then
				hModifier:OnSummonned(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end

---@param params {event_name:事件名, unit:单位, target:目标, abiltiy:技能}
---发起modifier事件
function FireModifierEvent(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[params.event_name] then
		local tModifiers = params.unit.tSourceModifierEvents[params.event_name]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[params.event_name]] then
				hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[params.event_name]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[params.event_name] then
		local tModifiers = tModifierEvents[params.event_name]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[params.event_name]] then
				PrintTable(params)
				hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[params.event_name]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end