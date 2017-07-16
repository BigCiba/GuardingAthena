if QuestManager == nil then
    QuestManager = {}
    QuestManager.__index = QuestManager
end

function QuestManager:init()
    ListenToGameEvent('entity_killed', Dynamic_Wrap(QuestManager, 'OnUnitKilled'), self)
end

function QuestManager:OnUnitKilled(e)
    local entity = EntIndexToHScript(e.entindex_killed)
	local killer = EntIndexToHScript(e.entindex_attacker)
    local playerID
    if killer:isIllusion() then
        if killer.caster_hero then
            killer = killer.caster_hero
        end
    end
    if killer:isRealHero() then
        playerID = killer.GetPlayerID()
    end
    if entity then
        local entityName = entity:GetUnitName()
        local playerQuests = QuestManager:getQuests(playerID)
        for k,v in pairs(playerQuests) do
            if v["Monster"] == entityName then
                v:deCount()
            end
        end
    end

end

function QuestManager:getQuests(playerID)
    local playerEntity = PlayerResource:GetPlayer(playerID)
    local playerHero = playerEntity:GetAssignedHero()
    return playerHero.Quests
end

function QuestManager:addQuest(playerID,data)
    local quest = Quest:new(data)
    local playerEntity = PlayerResource:GetPlayer(playerID)
    local playerHero = playerEntity:GetAssignedHero()
    if playerHero.Quests == nil then
		playerHero.Quests = {}
	end
    if playerHero.Quests[quest] == nil then
        playerHero.Quests[quest] = {}
    end
	if playerHero.Quests[quest["Name"]]~=nil then
		return false
	end
    --if playerHero.Quests[quest["Name"]]["Count"] <= 0 then
    --    return false
    --end
	playerHero.Quests[quest["Name"]] = quest
    return true
end

function QuestManager:removeQuest(playerID,questName)
    local playerEntity = PlayerResource:GetPlayer(playerID)
    local playerHero = playerEntity:GetAssignedHero()
    if playerHero.Quests == nil then
		playerHero.Quests = {}
        return false
	end
    playerHero.Quests[questName] = nil
end