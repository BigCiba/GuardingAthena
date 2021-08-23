item_summon_dummy = class({})
function item_summon_dummy:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:IsRealHero() then
		local vPosition = self:GetCursorPosition()
		local hDummy = CreateUnitByName("npc_dota_hero_target_dummy", vPosition, true, hCaster, hCaster, DOTA_TEAM_BADGUYS)

		-- hDummy:AddNewModifier(hDummy, nil, "modifier_dummy_damage", nil)
		-- hDummy:SetAbilityPoints(0)
		-- hDummy:SetControllableByPlayer(tData.PlayerID, false)
		hDummy:Hold()
		hDummy:SetIdleAcquire(false)
		hDummy:SetAcquisitionRange(0)
		-- hDummy:AddNewModifier(hCaster, self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") * self:GetCurrentCharges() })
		GameTimer(self:GetSpecialValueFor("duration") * self:GetCurrentCharges(), function()
			UTIL_Remove(hDummy)
		end)
		UTIL_Remove(self)
	end
end