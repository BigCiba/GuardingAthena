LinkLuaModifier("health", "modifiers/generic/health.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_world_editor", "modifiers/item/modifier_world_editor.lua", LUA_MODIFIER_MOTION_NONE)
function OnCreated(t)
	local caster = t.caster
	local ability = t.ability
	SetUnitDamagePercent(caster, ability:GetSpecialValueFor("magic_damage_increase"))
end
function OnDestroy(t)
	local caster = t.caster
	local ability = t.ability
	SetUnitDamagePercent(caster, -ability:GetSpecialValueFor("magic_damage_increase"))
end
function DebuffCreated(t)
	local ability = t.ability
	local target = t.target
	SetUnitDamagePercent(target, -ability:GetSpecialValueFor("damage_reduce"))
end
function DebuffDestroy(t)
	local ability = t.ability
	local target = t.target
	SetUnitDamagePercent(target, ability:GetSpecialValueFor("damage_reduce"))
end
function OnSpellStart(t)
	local caster = t.caster
	local ability = t.ability
	local duration = ability:GetSpecialValueFor("duration")
	local scale = ability:GetSpecialValueFor("health")
	local health = math.ceil(caster:GetMaxHealth() * scale * 0.9)
	caster:AddNewModifier(caster, ability, "modifier_world_editor", { duration = duration, health = health, health_regen_percent = 10, model_scale = 150 })
--[[caster:AddNewModifier(caster,ability,"health",{health=health,duration=duration,attribute=MODIFIER_ATTRIBUTE_MULTIPLE})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_world_editor_regen", {duration=duration})
	caster:CalculateStatBonus(true)
	SetModelScale(caster,caster:GetModelScale() + 0.5,true,duration)
	Timers:CreateTimer(duration + 0.05,function ()
		SetModelScale(caster,caster:GetModelScale() - 0.25,true,duration)
	end)]]
end