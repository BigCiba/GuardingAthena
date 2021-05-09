if modifier_events == nil then
	modifier_events = class({})
end

local public = modifier_events

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
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
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
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_SPELL_TARGET_READY,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ATTACK_FAIL,
		-- MODIFIER_EVENT_ON_ATTACK_ALLIED,
		-- MODIFIER_EVENT_ON_PROJECTILE_DODGE,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_EVENT_ON_ABILITY_START,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		-- MODIFIER_EVENT_ON_BREAK_INVISIBILITY,
		-- MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,
		-- MODIFIER_EVENT_ON_PROCESS_UPGRADE,
		-- MODIFIER_EVENT_ON_REFRESH,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		-- MODIFIER_EVENT_ON_STATE_CHANGED,
		-- MODIFIER_EVENT_ON_ORB_EFFECT,
		-- MODIFIER_EVENT_ON_PROCESS_CLEAVE,
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_SPENT_MANA,
		-- MODIFIER_EVENT_ON_TELEPORTING,
		MODIFIER_EVENT_ON_TELEPORTED,
		-- MODIFIER_EVENT_ON_SET_LOCATION,
		-- MODIFIER_EVENT_ON_HEALTH_GAINED,
		-- MODIFIER_EVENT_ON_MANA_GAINED,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,
		-- MODIFIER_EVENT_ON_HERO_KILLED,
		-- MODIFIER_EVENT_ON_HEAL_RECEIVED,
		-- MODIFIER_EVENT_ON_BUILDING_KILLED,
		-- MODIFIER_EVENT_ON_MODEL_CHANGED,
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		-- MODIFIER_EVENT_ON_DOMINATED,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		-- MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		-- MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT,
		MODIFIER_EVENT_ON_ATTACK_CANCELLED,
	}
end
function public:OnSpellTargetReady(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SPELL_TARGET_READY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSpellTargetReady then
				hModifier:OnSpellTargetReady(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackRecord(params)
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
function public:OnAttackStart(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackStart then
				hModifier:OnAttackStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttack(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttack then
				hModifier:OnAttack(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackLanded(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_LANDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackLanded then
				hModifier:OnAttackLanded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackFail(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FAIL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackFail then
				hModifier:OnAttackFail(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackAllied(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_ALLIED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackAllied then
				hModifier:OnAttackAllied(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnProjectileDodge(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_DODGE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProjectileDodge then
				hModifier:OnProjectileDodge(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnOrder(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ORDER] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ORDER]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnOrder then
				hModifier:OnOrder(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnUnitMoved(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnUnitMoved then
				hModifier:OnUnitMoved(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_UNIT_MOVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnUnitMoved then
				hModifier:OnUnitMoved(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAbilityStart(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_START] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_START]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityStart then
				hModifier:OnAbilityStart(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAbilityExecuted(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_EXECUTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityExecuted then
				hModifier:OnAbilityExecuted(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	-- 只触发有效的技能（去除toggle、没有冷却和不计算魔棒等）
	if IsValid(params.ability) and not params.ability:IsItem() and not params.ability:IsToggle() and params.ability:ProcsMagicStick() then
		local newParams = vlua.clone(params)
		newParams.event_name = MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED
		FireModifierEvent(newParams)
	end
end
function public:OnAbilityFullyCast(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityFullyCast then
				hModifier:OnAbilityFullyCast(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnBreakInvisibility(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_BREAK_INVISIBILITY] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_BREAK_INVISIBILITY]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnBreakInvisibility then
				hModifier:OnBreakInvisibility(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAbilityEndChannel(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAbilityEndChannel then
				hModifier:OnAbilityEndChannel(params)
			else
				table.remove(tModifiers, i)
			end
		end
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
end
function public:OnStateChanged(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnStateChanged then
				hModifier:OnStateChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_STATE_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnStateChanged then
				hModifier:OnStateChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnProcessCleave(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROCESS_CLEAVE] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROCESS_CLEAVE]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProcessCleave then
				hModifier:OnProcessCleave(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnDamageCalculated(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DAMAGE_CALCULATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDamageCalculated then
				hModifier:OnDamageCalculated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttacked(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACKED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACKED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttacked then
				hModifier:OnAttacked(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnDeath(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DEATH] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DEATH]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDeath then
				hModifier:OnDeath(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnRespawn(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_RESPAWN] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_RESPAWN]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnRespawn then
				hModifier:OnRespawn(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_RESPAWN] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_RESPAWN]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnRespawn then
				hModifier:OnRespawn(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnSpentMana(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnSpentMana then
				hModifier:OnSpentMana(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SPENT_MANA]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSpentMana then
				hModifier:OnSpentMana(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnTeleporting(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTING] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTING]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTeleporting then
				hModifier:OnTeleporting(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TELEPORTING] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TELEPORTING]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTeleporting then
				hModifier:OnTeleporting(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnTeleported(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTeleported then
				hModifier:OnTeleported(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTeleported then
				hModifier:OnTeleported(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnSetLocation(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_SET_LOCATION] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_SET_LOCATION]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnSetLocation then
				hModifier:OnSetLocation(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnHealthGained(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHealthGained then
				hModifier:OnHealthGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HEALTH_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHealthGained then
				hModifier:OnHealthGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnManaGained(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnManaGained then
				hModifier:OnManaGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MANA_GAINED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnManaGained then
				hModifier:OnManaGained(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnTakeDamageKillCredit(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnTakeDamageKillCredit then
				hModifier:OnTakeDamageKillCredit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnHeroKilled(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.unit) and params.unit.tTargetModifierEvents and params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = params.unit.tTargetModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HERO_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHeroKilled then
				hModifier:OnHeroKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnHealReceived(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnHealReceived then
				hModifier:OnHealReceived(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_HEAL_RECEIVED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnHealReceived then
				hModifier:OnHealReceived(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnBuildingKilled(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_BUILDING_KILLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_BUILDING_KILLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnBuildingKilled then
				hModifier:OnBuildingKilled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnModelChanged(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MODEL_CHANGED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MODEL_CHANGED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnModelChanged then
				hModifier:OnModelChanged(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnModifierAdded(params)
	if IsValid(params.unit) and params.unit.tSourceModifierEvents and params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED] then
		local tModifiers = params.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.unit) and IsValid(hModifier) and hModifier.OnModifierAdded then
				hModifier:OnModifierAdded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_MODIFIER_ADDED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnModifierAdded then
				hModifier:OnModifierAdded(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnDominated(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_DOMINATED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_DOMINATED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnDominated then
				hModifier:OnDominated(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackFinished(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_FINISHED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackFinished then
				hModifier:OnAttackFinished(params)
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
end
function public:OnProjectileObstructionHit(params)
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnProjectileObstructionHit then
				hModifier:OnProjectileObstructionHit(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end
function public:OnAttackCancelled(params)
	if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED] then
		local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_CANCELLED]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier.OnAttackCancelled then
				hModifier:OnAttackCancelled(params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end