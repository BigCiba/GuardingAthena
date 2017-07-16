if Quest == nil then
  	Quest = {}
  	Quest.__index = Quest
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
	caster = trigger.activator;
	local playerID = caster:GetPlayerID()
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