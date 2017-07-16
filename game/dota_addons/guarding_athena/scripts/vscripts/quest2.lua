if Quest == nil then
  	Quest = {}
  	Quest.__index = Quest
end
-- 初始化
function Quest:Init()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Quest, 'OnUnitKilled'), self)
	self.questInfo = LoadKeyValues("scripts/kv/quest_info.kv")
end

function Quest:OnUnitKilled(t)
    local victim = EntIndexToHScript(t.entindex_killed)
	local killer = EntIndexToHScript(t.entindex_attacker)
    local playerID
    if killer:isIllusion() then
        if killer.caster_hero then
            killer = killer.caster_hero
        end
    end
    if killer:isRealHero() then
        playerID = killer:GetPlayerID()
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
function Quest:finish()
	self["Count"] = -1
	--这里写给玩家啥东西啥东西的
end

function Quest:deCount()
	if self["Count"] == -1 then
		return
	end
	self["Count"] = self["Count"] - 1
	if self["Count"] <= 0 then
	self:finish()
	end
end

function Quest:new(data)
	if(data["Type"] == "Kill") then
		local obj = {
			["Type"] = data["Type"],
			["Name"] = data["Name"],
			["Monster"] = data["Monster"],
			["Count"] = data["Count"],
			["RewardItem"] = data["RewardItem"],
			["RewardMoney"] = data["RewardMoney"],
			["RewardScore"] = data["RewardScore"]
		}
		setmetatable(obj,self);
		return obj;
	end
end

function Quest:delete()
	for k,v in pairs(self) do
		self[k] = nil;
	end
end

function QuestEasy( trigger )
	local caster = trigger.activator;
	local playerID = caster:GetPlayerID()
	local npc = Entities:FindByName( nil, "quest_easy" )
	local quest1 = {
		["Type"] = "Kill",
		["Name"] = "杀死恶魔",
		["Monster"] = "Devil",
		["Count"] = 1,
		["RewardItem"] = nil,
		["RewardMoney"] = 1000,
		["RewardScore"] = 0
	}
	QuestManager:addQuest(playerID,quest1)
end