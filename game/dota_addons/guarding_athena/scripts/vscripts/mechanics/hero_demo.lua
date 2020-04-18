LinkLuaModifier("lm_take_no_damage", "modifiers/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)

if CHeroDemo == nil then
	_G.CHeroDemo = class({})
end

local public = CHeroDemo

function public:OnRefreshButtonPressed(eventSourceIndex)
	local heroes = HeroList:GetAllHeroes()
	for n, hHero in pairs(heroes) do
		for i = 0, hHero:GetAbilityCount() - 1 do
			local hAbility = hHero:GetAbilityByIndex(i)
			if hAbility then
				hAbility:EndCooldown()
				hAbility:RefreshCharges()
			end
		end

		for i = 0, DOTA_ITEM_MAX - 1, 1 do
			local hItem = hHero:GetItemInSlot(i)
			if hItem then
				hItem:EndCooldown()
				hItem:SetCurrentCharges(hItem:GetInitialCharges())
			end
		end

		hHero:SetHealth(hHero:GetMaxHealth())
		hHero:SetMana(hHero:GetMaxMana())
	end
	-- SendToServerConsole( "dota_dev hero_refresh" )
end

function public:OnLevelUpButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end
	hPlayerHero:HeroLevelUp(false)
	-- SendToServerConsole( "dota_dev hero_level 1" )
end

function public:OnMaxLevelButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end
	for i = 1, MAX_LEVEL - 1 do
		hPlayerHero:HeroLevelUp(false)
	end
	-- hPlayerHero:AddExperience(59900, false, false)

	for i = 0, hPlayerHero:GetAbilityCount() - 1 do
		local hAbility = hPlayerHero:GetAbilityByIndex(i)
		if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
			while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
				hPlayerHero:UpgradeAbility(hAbility)
			end
		end
	end

	hPlayerHero:SetAbilityPoints(0)
end

function public:OnFreeSpellsButtonPressed(eventSourceIndex)
	SendToServerConsole("toggle dota_ability_debug")
	if self.m_bFreeSpellsEnabled == false then
		-- SendToServerConsole( "dota_dev hero_refresh" )
		self.m_bFreeSpellsEnabled = true
		self:OnRefreshButtonPressed(eventSourceIndex)
	elseif self.m_bFreeSpellsEnabled == true then
		self.m_bFreeSpellsEnabled = false
	end
	self:UpdateSettings()
end

function public:OnInvulnerabilityButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local hAllPlayerUnits = {}
	hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
	hAllPlayerUnits[#hAllPlayerUnits + 1] = hPlayerHero

	if self.m_bInvulnerabilityEnabled == false then
		for _, hUnit in pairs(hAllPlayerUnits) do
			hUnit:AddNewModifier(hPlayerHero, nil, "lm_take_no_damage", nil)
		end
		self.m_bInvulnerabilityEnabled = true
	elseif self.m_bInvulnerabilityEnabled == true then
		for _, hUnit in pairs(hAllPlayerUnits) do
			hUnit:RemoveModifierByName("lm_take_no_damage")
		end
		self.m_bInvulnerabilityEnabled = false
	end
end

function public:OnSelectHeroButtonPressed(eventSourceIndex, data)
	self.m_sHeroToSpawn = DOTAGameManager:GetHeroUnitNameByID(tonumber(data.str))
end

function public:OnSpawnAllyButtonPressed(eventSourceIndex, data)
	if #self.m_tAlliesList >= 100 then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	CreateUnitByNameAsync(
		self.m_sHeroToSpawn,
		hPlayerHero:GetAbsOrigin(),
		true,
		hPlayerHero,
		hPlayerHero,
		hPlayerHero:GetTeamNumber(),
		function(hUnit)
			table.insert(self.m_tAlliesList, hUnit)
			hUnit:SetControllableByPlayer(data.PlayerID, false)
			hUnit:SetRespawnPosition(hPlayerHero:GetAbsOrigin())
			FindClearSpaceForUnit(hUnit, hPlayerHero:GetAbsOrigin(), false)
			hUnit:Hold()
			hUnit:SetIdleAcquire(false)
			hUnit:SetAcquisitionRange(0)
		end
	)
end

function public:OnLevelUpAllyButtonPressed(eventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		if self.m_tAlliesList[k]:IsRealHero() then
			self.m_tAlliesList[k]:HeroLevelUp(false)
		end
	end
end

function public:OnAllyMaxLevelButtonPressed(eventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		if self.m_tAlliesList[k]:IsRealHero() then
			local hHero = self.m_tAlliesList[k]
			hHero:AddExperience(59900, false, false) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced

			for i = 0, hHero:GetAbilityCount() - 1 do
				local hAbility = hHero:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
					while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
						hHero:UpgradeAbility(hAbility)
					end
				end
			end

			hHero:SetAbilityPoints(0)
		end
	end
end

function public:OnSwitchHeroButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	hPlayerHero.pet:RemoveSelf()
	PlayerResource:ReplaceHeroWith(data.PlayerID, self.m_sHeroToSpawn, PlayerResource:GetGold(data.PlayerID), 0)
	hPlayerHero:RemoveSelf()
end

function public:OnSpawnEnemyButtonPressed(eventSourceIndex, data)
	if #self.m_tEnemiesList >= 100 then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local nEnemiesTeam = hPlayerHero:GetTeamNumber() == DOTA_TEAM_BADGUYS and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS

	CreateUnitByNameAsync(
		self.m_sHeroToSpawn,
		hPlayerHero:GetAbsOrigin(),
		true,
		hPlayerHero,
		hPlayerHero,
		nEnemiesTeam,
		function(hEnemy)
			table.insert(self.m_tEnemiesList, hEnemy)
			hEnemy:SetControllableByPlayer(data.PlayerID, false)
			hEnemy:SetRespawnPosition(hPlayerHero:GetAbsOrigin())
			FindClearSpaceForUnit(hEnemy, hPlayerHero:GetAbsOrigin(), false)
			hEnemy:Hold()
			hEnemy:SetIdleAcquire(false)
			hEnemy:SetAcquisitionRange(0)
		end
	)
end

function public:OnLevelUpEnemyButtonPressed(eventSourceIndex)
	for k, v in pairs(self.m_tEnemiesList) do
		if self.m_tEnemiesList[k]:IsRealHero() then
			self.m_tEnemiesList[k]:HeroLevelUp(false)
		end
	end
end

function public:OnEnemyMaxLevelButtonPressed(eventSourceIndex)
	for k, v in pairs(self.m_tEnemiesList) do
		if self.m_tEnemiesList[k]:IsRealHero() then
			local hHero = self.m_tEnemiesList[k]
			hHero:AddExperience(59900, false, false) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced

			for i = 0, hHero:GetAbilityCount() - 1 do
				local hAbility = hHero:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
					while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
						hHero:UpgradeAbility(hAbility)
					end
				end
			end

			hHero:SetAbilityPoints(0)
		end
	end
end

function public:OnDummyTargetButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local nEnemiesTeam = hPlayerHero:GetTeamNumber() == DOTA_TEAM_BADGUYS and DOTA_TEAM_GOODGUYS or DOTA_TEAM_BADGUYS

	local hDummy = CreateUnitByName("npc_dota_hero_target_dummy", hPlayerHero:GetAbsOrigin(), true, hPlayerHero, hPlayerHero, nEnemiesTeam)
	table.insert(self.m_tEnemiesList, hDummy)

	hDummy:SetAbilityPoints(0)
	hDummy:SetControllableByPlayer(data.PlayerID, false)
	hDummy:Hold()
	hDummy:SetIdleAcquire(false)
	hDummy:SetAcquisitionRange(0)
end

function public:OnRemoveSpawnedUnitsButtonPressed(eventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		self.m_tAlliesList[k]:MakeIllusion()
		self.m_tAlliesList[k]:ForceKill(false)
		self.m_tAlliesList[k]:Destroy()
		self.m_tAlliesList[k] = nil
	end
	for k, v in pairs(self.m_tEnemiesList) do
		self.m_tEnemiesList[k]:MakeIllusion()
		self.m_tEnemiesList[k]:ForceKill(false)
		self.m_tEnemiesList[k]:Destroy()
		self.m_tEnemiesList[k] = nil
	end
end

function public:OnLaneCreepsButtonPressed(eventSourceIndex)
	SendToServerConsole("toggle dota_creeps_no_spawning")
	if self.m_bCreepsEnabled == false then
		self.m_bCreepsEnabled = true
	elseif self.m_bCreepsEnabled == true then
		-- if we're disabling creep spawns, then also kill existing creep waves
		SendToServerConsole("dota_kill_creeps radiant")
		SendToServerConsole("dota_kill_creeps dire")
		self.m_bCreepsEnabled = false
	end
	self:UpdateSettings()
end
function public:OnReloadScriptButtonPressed(eventSourceIndex)
	SendToConsole("cl_script_reload")
	SendToConsole("script_reload")
end
function public:OnUpdateAbilityButtonPressed(eventSourceIndex, data)
	local tJson = json.decode(data.str)
	local hUnit = EntIndexToHScript(tJson.entid)
	if not IsValid(hUnit) then
		return
	end

	if tJson.ablt_name_new then
		-- if tJson.ablt_name_new and tJson.ablt_name_new ~= 'generic_hidden' then
		if not hUnit:HasAbility(tJson.ablt_name_new) then
			local hAbltNew = hUnit:AddAbility(tJson.ablt_name_new)
			hUnit:SetAbilityPoints(hAbltNew:GetMaxLevel())
			if tJson.ablt_name_old then
				hUnit:SwapAbilities(tJson.ablt_name_old, tJson.ablt_name_new, false, true)
			end
		end
	end

	if tJson.ablt_name_old and tJson.ablt_name_old ~= "generic_hidden" then
		local hAblt = hUnit:FindAbilityByName(tJson.ablt_name_old)
		if hAblt then
			if hAblt:GetIntrinsicModifierName() then
				hUnit:RemoveModifierByName(hAblt:GetIntrinsicModifierName())
			end
			hUnit:RemoveAbility(tJson.ablt_name_old)
		end
	end
end

function public:OnSetWinnerPressed(eventSourceIndex, data)
	local iTeam = PlayerResource:GetTeam(data.PlayerID)
	GameRules:SetGameWinner(iTeam)
end

function public:OnItemPurchased(event)
	local hBuyer = PlayerResource:GetPlayer(event.PlayerID)
	local hBuyerHero = hBuyer:GetAssignedHero()
	if hBuyerHero ~= nil then
		hBuyerHero:ModifyGold(event.itemcost, true, 0)
	end
end

function public:UpdateSettings()
	local settings = {
		free_spells = self.m_bFreeSpellsEnabled and 1 or 0,
		creeps = self.m_bCreepsEnabled and 1 or 0
	}
	CustomNetTables:SetTableValue("common", "hero_demo_settings", settings)
end

function public:init(bReload)
	if not GameRules:IsCheatMode() then
		return
	end

	if not bReload then
		SendToServerConsole("sv_cheats 1")
		SendToServerConsole("dota_hero_god_mode 0")
		SendToServerConsole("dota_ability_debug 0")
		-- SendToServerConsole("dota_creeps_no_spawning 0")
		SendToServerConsole("dota_easybuy 1")

		self.m_sHeroToSpawn = "npc_dota_hero_axe"

		self.m_tAlliesList = {}

		self.m_tEnemiesList = {}

		self.m_bFreeSpellsEnabled = false
		self.m_bInvulnerabilityEnabled = false
		self.m_bCreepsEnabled = true
	end

	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetFixedRespawnTime(4)
	-- GameRules:SetPreGameTime(GAME_MODE_PREGAMETIME)
	GameRules:SetStartingGold(99999)
	GameRules:SetUseUniversalShopMode(true)

	GameEvent("dota_item_purchased", Dynamic_Wrap(public, "OnItemPurchased"), public)

	CustomUIEvent("RefreshButtonPressed", Dynamic_Wrap(public, "OnRefreshButtonPressed"), public)
	CustomUIEvent("LevelUpButtonPressed", Dynamic_Wrap(public, "OnLevelUpButtonPressed"), public)
	CustomUIEvent("MaxLevelButtonPressed", Dynamic_Wrap(public, "OnMaxLevelButtonPressed"), public)
	CustomUIEvent("FreeSpellsButtonPressed", Dynamic_Wrap(public, "OnFreeSpellsButtonPressed"), public)
	CustomUIEvent("InvulnerabilityButtonPressed", Dynamic_Wrap(public, "OnInvulnerabilityButtonPressed"), public)
	CustomUIEvent("SelectHeroButtonPressed", Dynamic_Wrap(public, "OnSelectHeroButtonPressed"), public)
	CustomUIEvent("SpawnAllyButtonPressed", Dynamic_Wrap(public, "OnSpawnAllyButtonPressed"), public)
	CustomUIEvent("LevelUpAllyButtonPressed", Dynamic_Wrap(public, "OnLevelUpAllyButtonPressed"), public)
	CustomUIEvent("AllyMaxLevelButtonPressed", Dynamic_Wrap(public, "OnAllyMaxLevelButtonPressed"), public)
	CustomUIEvent("SwitchHeroButtonPressed", Dynamic_Wrap(public, "OnSwitchHeroButtonPressed"), public)
	-- CustomUIEvent("SpawnEnemyButtonPressed", Dynamic_Wrap(public, "OnSpawnEnemyButtonPressed"), public)
	-- CustomUIEvent("LevelUpEnemyButtonPressed", Dynamic_Wrap(public, "OnLevelUpEnemyButtonPressed"), public)
	-- CustomUIEvent("EnemyMaxLevelButtonPressed", Dynamic_Wrap(public, "OnEnemyMaxLevelButtonPressed"), public)
	CustomUIEvent("DummyTargetButtonPressed", Dynamic_Wrap(public, "OnDummyTargetButtonPressed"), public)
	CustomUIEvent("RemoveSpawnedUnitsButtonPressed", Dynamic_Wrap(public, "OnRemoveSpawnedUnitsButtonPressed"), public)
	-- CustomUIEvent("LaneCreepsButtonPressed", Dynamic_Wrap(public, "OnLaneCreepsButtonPressed"), public)
	CustomUIEvent("ReloadScriptButtonPressed", Dynamic_Wrap(public, "OnReloadScriptButtonPressed"), public)
	-- CustomUIEvent("UpdateAbilityButtonPressed", Dynamic_Wrap(public, "OnUpdateAbilityButtonPressed"), public)
	-- CustomUIEvent("SetWinnerPressed", Dynamic_Wrap(public, "OnSetWinnerPressed"), public)
end

return public
