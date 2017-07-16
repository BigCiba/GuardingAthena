if Quest == nil then
  	Quest = {}
  	Quest.__index = Quest
end
-- 初始化
function Quest:Init()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Quest, 'OnUnitKilled'), self)
end
function Quest:OnUnitKilled(t)
	local killedUnit = EntIndexToHScript(t.entindex_killed)
	local killerUnit = EntIndexToHScript(t.entindex_attacker)
	local playerID
	if killerUnit:IsIllusion() then
		if killerUnit.caster_hero then
			killerUnit = killerUnit.caster_hero
		end
	end
	if killerUnit:IsRealHero() then
		playerID = killerUnit:GetPlayerID()
	end
	if killedUnit and string.find(killedUnit:GetUnitName(), "boss_kobold") and killerUnit.onQuestKobold and not killerUnit.completeQuestKobold then
    	if killerUnit.KoboldCount == 3 then
    		killerUnit.completeQuestKobold = true
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableKobold",count=3,create=false,finish=false} )
		else 
			if killerUnit.KoboldCount == nil then
				killerUnit.KoboldCount = 1
			end
			killerUnit.KoboldCount = killerUnit.KoboldCount + 1
			print(killerUnit.KoboldCount)
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableKobold",count=killerUnit.KoboldCount-1,create=false,finish=false} )
		end
    end
    if killedUnit and string.find(killedUnit:GetUnitName(), "boss_beast") and killerUnit.onQuestBeast and not killerUnit.completeQuestBeast then
    	if killerUnit.BeastCount == 2 then
    		killerUnit.completeQuestBeast = true
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableBeast",count=killerUnit.BeastCount,create=false,finish=false} )
		else 
			if killerUnit.BeastCount == nil then
				killerUnit.BeastCount = 1
			end
			killerUnit.BeastCount = killerUnit.BeastCount + 1
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableBeast",count=killerUnit.BeastCount-1,create=false,finish=false} )
		end
    end
    if killedUnit and string.find(killedUnit:GetUnitName(), "boss_golem") and killerUnit.onQuestGolem and not killerUnit.completeQuestGolem then
    	killerUnit.completeQuestGolem = true
    	CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableGolem",count=1,create=false,finish=false} )
    end
    if killedUnit and string.find(killedUnit:GetUnitName(), "boss_fire_demon") and killerUnit.onQuestDemon and not killerUnit.completeQuestDemon then
    	killerUnit.completeQuestDemon = true
    	CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableDemon",count=1,create=false,finish=false} )
    end
	-- QuestOnly
    if killedUnit and string.find(killedUnit:GetUnitName(), "dragon_") and killerUnit.onQuestOnly and not killerUnit.completedQuestOnly then
    	if killerUnit.DragonCount == 15 then
    		killerUnit.completeQuestOnly = true
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableOnly",count=killerUnit.DragonCount,create=false,finish=false} )
    		SetQuestKillCount(playerID,killerUnit.DragonCount+1,15,5)
		else 
			if killerUnit.DragonCount == nil then
				killerUnit.DragonCount = 1
			end
			killerUnit.DragonCount = killerUnit.DragonCount + 1
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableOnly",count=killerUnit.DragonCount-1,create=false,finish=false} )
			--SetQuestKillCount(playerID,killerUnit.DragonCount,15,5)
		end
    end
end
function QuestSolo( trigger )
	local caster = trigger.activator
	local playerID = caster:GetPlayerID()
	local quester = Entities:FindByName( nil, "quest_solo" )
	if caster.completedQuestDemon then
		--quester:DestroyAllSpeechBubbles()
		--quester:AddSpeechBubble(1,'#CompleteQuestSolo',5,0,0)
		CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestSolo',duration=5})
	else
		if caster.onQuestDemon then
			if caster.completeQuestDemon then
				-- 满格
				if IsFullSolt(caster,12,true) then
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestFulSolt',duration=5})
					return
				end
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#CompleteQuestDemon',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestDemon',duration=5})
				caster.completedQuestDemon = true
				local newItem = CreateItem("item_yunshizhaohuan", caster, caster)
	            caster:AddItem(newItem)
	            caster.questcount = caster.questcount - 1
				CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableDemon",count=1,create=false,finish=true} )
	            --CloseQuest(playerID,4,caster.questcount)
			else
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#OnQuestDemon',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='OnQuestDemon',duration=5})
			end
		else
			caster.onQuestDemon = true
			--quester:DestroyAllSpeechBubbles()
			--quester:AddSpeechBubble(1,'#QuestDemon',5,0,0)
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestDemon',duration=5})
			local questCount = caster.questcount or 0
			caster.questcount = questCount + 1
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableDemon",count=0,create=true,finish=false} )
			--SetQuest(playerID,"QuestTableDemon",1,caster.questcount,4)
		end
	end
end
function QuestEasy( trigger )
	local caster = trigger.activator
	local playerID = caster:GetPlayerID()
	local quester = Entities:FindByName( nil, "quest_easy" )
	if caster.completedQuestKobold then
		if caster.completedQuestBeast then
			if caster.completedQuestGolem then
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#CompleteQuestEasy',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestEasy',duration=5})
			else
				if caster.onQuestGolem then
					if caster.completeQuestGolem then
						-- 满格
						if IsFullSolt(caster,12,true) then
							--quester:DestroyAllSpeechBubbles()
							--quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
							CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestFulSolt',duration=5})
							return
						end
						--quester:DestroyAllSpeechBubbles()
						--quester:AddSpeechBubble(1,'#CompleteQuestGolem',5,0,0)
						CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestGolem',duration=5})
						caster.completedQuestGolem = true
						local newItem = CreateItem("item_hexin", caster, caster)
                    	caster:AddItem(newItem)
						caster.questcount = caster.questcount - 1
						CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableGolem",count=1,create=false,finish=true} )
                    	--CloseQuest(playerID,3,caster.questcount)
					else
						--quester:DestroyAllSpeechBubbles()
						--quester:AddSpeechBubble(1,'#OnQuestGolem',5,0,0)
						CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='OnQuestGolem',duration=5})
					end
				else
					caster.onQuestGolem = true
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#QuestGolem',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestGolem',duration=5})
					local questCount = caster.questcount or 0
					caster.questcount = questCount + 1
					CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableGolem",count=0,create=true,finish=false} )
					--SetQuest(playerID,"QuestTableGolem",1,caster.questcount,3)
				end
			end
		else
			if caster.onQuestBeast then
				if caster.completeQuestBeast then
					-- 满格
					if IsFullSolt(caster,12,true) then
						--quester:DestroyAllSpeechBubbles()
						--quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
						CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestFulSolt',duration=5})
						return
					end
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#CompleteQuestBeast',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestBeast',duration=5})
					caster.completedQuestBeast = true
					local newItem = CreateItem("item_xiongpi", caster, caster)
                    caster:AddItem(newItem)
                    caster.questcount = caster.questcount - 1
					CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableBeast",count=2,create=false,finish=true} )
                    --CloseQuest(playerID,2,caster.questcount)
				else
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#OnQuestBeast',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='OnQuestBeast',duration=5})
				end
			else
				caster.onQuestBeast = true
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#QuestBeast',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestBeast',duration=5})
				local questCount = caster.questcount or 0
				caster.questcount = questCount + 1
				CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableBeast",count=0,create=true,finish=false} )
				--SetQuest(playerID,"QuestTableBeast",2,caster.questcount,2)
			end
		end
	else
		if caster.onQuestKobold then
			if caster.completeQuestKobold then
				if IsFullSolt(caster,12,true) then
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestFulSolt',duration=5})
					return
				end
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#CompleteQuestKobold',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestKobold',duration=5})
				caster.completedQuestKobold = true
				local newItem = CreateItem("item_zhanqi", caster, caster)
                caster:AddItem(newItem)
                caster.questcount = caster.questcount - 1
				CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableKobold",count=3,create=false,finish=true} )
                --CloseQuest(playerID,1,caster.questcount)
			else
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#OnQuestKobold',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='OnQuestKobold',duration=5})
			end
		else
			caster.onQuestKobold = true
			--quester:DestroyAllSpeechBubbles()
			--quester:AddSpeechBubble(1,'#QuestKobold',3,0,0)
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestKobold',duration=5})
			local questCount = caster.questcount or 0
			caster.questcount = questCount + 1
			CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableKobold",count=0,create=true,finish=false} )
			--SetQuest(playerID,"QuestTableKobold",3,caster.questcount,1)
		end
	end
end
function QuestOnly( trigger )
	local caster = trigger.activator
	local playerID = caster:GetPlayerID()
	local quester = Entities:FindByName( nil, "quest_only" )
	local castername = caster:GetName()
	local questtype
	--print(castername)
	if castername == "npc_dota_hero_rubick" then
		questtype = "rubick"
	elseif castername == "npc_dota_hero_phantom_assassin" then
		questtype = "phantom_assassin"
	elseif castername == "npc_dota_hero_windrunner" then
		questtype = "windrunner"
	elseif castername == "npc_dota_hero_omniknight" then
		questtype = "omniknight"
	elseif castername == "npc_dota_hero_juggernaut" then
		questtype = "juggernaut"
	elseif castername == "npc_dota_hero_antimage" then
		questtype = "demonhunter"
	elseif castername == "npc_dota_hero_nevermore" then
		questtype = "nevermore"
	elseif castername == "npc_dota_hero_lina" then
		questtype = "lina"
	elseif castername == "npc_dota_hero_legion_commander" then
		questtype = "legion"
	elseif castername == "npc_dota_hero_ember_spirit" then
		questtype = "ember"
	elseif castername == "npc_dota_hero_templar_assassin" then
		questtype = "templar_assassin"
	elseif castername == "npc_dota_hero_crystal_maiden" then
		questtype = "crystal_maiden"
	end
	if caster.reborn then
		if caster.completedQuestOnly then
			--quester:DestroyAllSpeechBubbles()
			--quester:AddSpeechBubble(1,'#CompletedQuestOnly',5,0,0)
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompletedQuestOnly',duration=5})
		else
			if caster.onQuestOnly then
				if caster.completeQuestOnly then
					if IsFullSolt(caster,12,true) then
						--quester:DestroyAllSpeechBubbles()
						--quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
						CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestFulSolt',duration=5})
						return
					end
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#CompleteQuestOnly',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='CompleteQuestOnly',duration=5})
					caster.completedQuestOnly = true
					--print(questtype)
					if questtype == "phantom_assassin" then
						local newItem = CreateItem("item_zhuanshupa", caster, caster)
		            	caster:AddItem(newItem)
					elseif questtype == "windrunner" then
						local newItem = CreateItem("item_duochong", caster, caster)
		            	caster:AddItem(newItem)
					elseif questtype == "omniknight" then
						local newItem = CreateItem("item_zhuanshuok", caster, caster)
		            	caster:AddItem(newItem)
					elseif questtype == "rubick" then
						local newItem = CreateItem("item_zhuanshurb", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "juggernaut" then
						local newItem = CreateItem("item_zhuanshujugg", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "demonhunter" then
						local newItem = CreateItem("item_zhuanshudh", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "nevermore" then
						local newItem = CreateItem("item_zhuanshusf", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "lina" then
						local newItem = CreateItem("item_zhuanshulina", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "legion" then
						local newItem = CreateItem("item_zhuanshulegion", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "ember" then
						local newItem = CreateItem("item_zhuanshufs", caster, caster)
		            	caster:AddItem(newItem)
		            elseif questtype == "templar_assassin" then
						local newItem = CreateItem("item_zhuanshuta", caster, caster)
		            	caster:AddItem(newItem)
					elseif questtype == "crystal_maiden" then
						local newItem = CreateItem("item_zhuanshucm", caster, caster)
		            	caster:AddItem(newItem)
					end
					caster.questcount = caster.questcount - 1
					CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableOnly",count=15,create=false,finish=true} )
					--CloseQuest(playerID,5,caster.questcount)
				else
					--quester:DestroyAllSpeechBubbles()
					--quester:AddSpeechBubble(1,'#OnQuestOnly',5,0,0)
					CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='OnQuestOnly',duration=5})
				end
			else
				caster.onQuestOnly = true
				--quester:DestroyAllSpeechBubbles()
				--quester:AddSpeechBubble(1,'#QuestOnly',5,0,0)
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestOnly',duration=5})
				local questCount = caster.questcount or 0
				caster.questcount = questCount + 1
				CustomNetTables:SetTableValue( "quest", tostring(playerID), {name="QuestTableOnly",count=0,create=true,finish=false} )
				--SetQuest(playerID,"QuestTableOnly",15,caster.questcount,5)
			end
		end
	else
		--quester:DestroyAllSpeechBubbles()
		--quester:AddSpeechBubble(1,'#QuestOnlyReborn',5,0,0)
		CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(),"avalon_display_bubble", {unit=quester:GetEntityIndex(),text='QuestOnlyReborn',duration=5})
	end
end
function QuestFulSolt( caster,quester )
	local caster = keys.caster
	if IsFullSolt(caster,12,true) then
		quester:AddSpeechBubble(1,'#QuestFulSolt',5,0,0)
	end
end