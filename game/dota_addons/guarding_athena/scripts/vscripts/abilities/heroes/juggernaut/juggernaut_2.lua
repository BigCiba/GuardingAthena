LinkLuaModifier( "modifier_juggernaut_2", "abilities/heroes/juggernaut/juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_2 == nil then
	juggernaut_2 = class({})
end
function juggernaut_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local images_count = self:GetSpecialValueFor("images_count")
	local output_damage = self:GetSpecialValueFor("output_damage")
	local input_damage = self:GetSpecialValueFor("input_damage")
	local duration = self:GetSpecialValueFor("duration")
	local invuln_duration = self:GetSpecialValueFor("invuln_duration")

	hCaster:Purge(false, true, false, false, false)

	local manta_illusion_table = Load(hCaster, "manta_illusion_table") or {}
	for i = #manta_illusion_table, 1, -1 do
		local hIllusion = manta_illusion_table[i]
		if IsValid(hIllusion) then
			hIllusion:ForceKill(false)
			table.remove(manta_illusion_table, i)
		end
	end
	Save(hCaster, "manta_illusion_table", manta_illusion_table)

	local illusions = CreateIllusions( hCaster, hCaster, {duration = duration, outgoing_damage = output_damage, incoming_damage = input_damage}, images_count, 100, true, true )

	for _, hIllusion in pairs(illusions) do
		hIllusion.caster_hero = hCaster
		HeroState:InitIllusion(hIllusion)
		table.insert(manta_illusion_table, hIllusion)
		Save(hCaster, "manta_illusion_table", manta_illusion_table)
		hIllusion:AddNewModifier(hCaster, self, "modifier_juggernaut_2", {duration = invuln_duration})
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_2", {duration = invuln_duration})

	hCaster:EmitSound("DOTA_Item.Manta.Activate")

	hCaster:SwapAbilities("juggernaut_2", "juggernaut_2_1", false, true)
	hCaster:FindAbilityByName("juggernaut_2_1"):SetLevel(self:GetLevel())
	self:GameTimer(self:GetCooldownTimeRemaining(), function ()
		hCaster:SwapAbilities("juggernaut_2", "juggernaut_2_1", true, false)
		self:SetLevel(hCaster:FindAbilityByName("juggernaut_2_1"):GetLevel())
	end)
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_2 == nil then
	modifier_juggernaut_2 = class({}, nil, ModifierHidden)
end
function modifier_juggernaut_2:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_2:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end