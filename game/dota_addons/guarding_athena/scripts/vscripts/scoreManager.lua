    SCORELINK_GETSCORE = "http://q-w-q.com/GuardingAthena/ScoreSystem/getScore.php"
SCORELINK_GIVESCORE = "http://q-w-q.com/GuardingAthena/ScoreSystem/giveScore.php"
SCORELINK_GETSECRETCODE = "http://q-w-q.com/GuardingAthena/ScoreSystem/getSecretCode.php"
SCORELINK_TAKESCORE = "http://q-w-q.com/GuardingAthena/ScoreSystem/takeScore.php"
Scoretbl = {}
----------------------------------------------------------------------------------------------------------------------------------
--  setScore(playerID,score) : void                                                         初始化玩家分数(本地分数不会影响服务器端的分数，将在更新后自动变成服务器端的分数)
--  getPlayerScore(playerID) : int                                                          获取玩家分数
--  giveScore() : void                                                                      发放此难度的奖励
--  updateScore(function CallBackFunction()) : void                                         更新玩家分数
--  takeScore(playerID,Count,function callBackFunction(boolean)) : void                     扣除玩家分数
--  removePlayer(playerID) : void                                                           从表中移除玩家
--  giveScoreSingle(playerID) : void                                                        给予单个玩家此难度的奖励
----------------------------------------------------------------------------------------------------------------------------------
function init(tblp)
    Scoretbl = tblp
    return true
end
function removePlayer(playerID)
    local SteamID = PlayerResource:GetSteamAccountID(playerID)
    table.remove(Scoretbl,SteamID)
end
function getPlayerScore(playerID)
    local SteamID = PlayerResource:GetSteamAccountID(playerID)
    --printc("getPlayerScore/")
    return Scoretbl[SteamID]
end
function setScore(playerID,score)
    local SteamID = PlayerResource:GetSteamAccountID(playerID)
    --printc("setScore/")
    Scoretbl[SteamID] = score
end
function updateScore(updateScore_callback)
    ScoreSystemUpdateCount = 0;
    --printc("updateScore/")
    for key,value in pairs(Scoretbl) do
        local req = CreateHTTPRequestScriptVM("POST",SCORELINK_GETSCORE)
        ScoreSystemUpdateCount = ScoreSystemUpdateCount + 1
        --print(tostring(key))
        req:SetHTTPRequestGetOrPostParameter("SteamId",tostring(key))
        --printc(tostring(key).."/")
        req:Send(
            function(result)
                if(string.len(result.Body) < 1) then
                    result.Body = 0
                end
                updatePlayerScore(key,result.Body)
                --printc("resultbody:"..result.Body.."/")
                --printc("resultKey:"..key.."/")
                ScoreSystemUpdateCount = ScoreSystemUpdateCount - 1
                --printc("ScoreCount:"..ScoreSystemUpdateCount.."/")
                if(ScoreSystemUpdateCount == 0) then
                    updateScore_callback()
                    --printc("updateScore_callback/")
                end

            end
        )
    end
end
function updatePlayerScore(SteamID,score)
    Scoretbl[SteamID] = score
    --printc("updatePlayerScore/")
end
function giveScore()
    for key,value in pairs(Scoretbl) do
        updateScoreSecretCode(tostring(key));
        --printc("giveScore/")
    end
end
function giveScoreSingle(playerID)
    local SteamID = PlayerResource:GetSteamAccountID(playerID)
    updateScoreSecretCode(tostring(SteamID))
end
function takeScore(playerID,Count,callBackFunc)
    local SteamID = PlayerResource:GetSteamAccountID(playerID)
    updateScoreSecretCode2(SteamID,Count,callBackFunc)
end
function giveScoreToPlayer(SteamID,GameType,secretCodew)
    local req2 = CreateHTTPRequestScriptVM("POST",SCORELINK_GIVESCORE);
    req2:SetHTTPRequestGetOrPostParameter("SteamId",tostring(SteamID));
    req2:SetHTTPRequestGetOrPostParameter("GameType",tostring(GameType));
    req2:SetHTTPRequestGetOrPostParameter("Password",tostring(secretCodew));
    req2:Send(
        function(result)
            if(result.Body == "Wrong") then
                updateScoreSecretCode(SteamID);
                --printc("giveScoreTo" ..key.."/")
            else
            end
            print(result.Body)
        end
    );
end
function takeScoreFromPlayer(SteamID,Count,SecretCodee,callBackFunc)
    local req2 = CreateHTTPRequestScriptVM("POST",SCORELINK_GIVESCORE);
    req2:SetHTTPRequestGetOrPostParameter("SteamId",tostring(SteamID));
    req2:SetHTTPRequestGetOrPostParameter("GameType",tostring(GameType));
    req2:SetHTTPRequestGetOrPostParameter("Password",tostring(ScoreSystemSecretCode));
    req2:Send(
        function(result)
            if(result.Body == "Wrong") then
                updateScoreSecretCode2(SteamID,Count)
            elseif(result.Body == "failed") then
                --玩家分数不够
                callBackFunc(false)
            elseif(result.Body == "Done") then
                callbackFunc(true)
            end
            print(result.Body)
        end
    );
end
function updateScoreSecretCode(SteamID)
    local req3 = CreateHTTPRequestScriptVM("POST",SCORELINK_GETSECRETCODE)
    req3:SetHTTPRequestGetOrPostParameter("SteamID",tostring(SteamID))
    req3:Send(
        function(result)
            ScoreSystemSecretCode = result.Body;
            giveScoreToPlayer(SteamID,GameRules:GetDifficulty(),result.Body)
            print(SteamID)
        end
    );
end
function updateScoreSecretCode2(SteamID,Count,callBackFunc)
    local req3 = CreateHTTPRequestScriptVM("POST",SCORELINK_GETSECRETCODE)
    req3:SetHTTPRequestGetOrPostParameter("SteamID",tostring(SteamID))
    req3:Send(
        function(result)
            takeScoreFromPlayer(SteamID,Count,result.Body,callBackFunc);
            print(SteamID)
        end
    );
end
function printc(content)
    local req = CreateHTTPRequestScriptVM("POST","http://q-w-q.com/GuardingAthena/ScoreSystem/haha3.php")
    req:SetHTTPRequestGetOrPostParameter("Content",content)
    req:Send(function(result) end)
end
function printtbl()
    for key,value in pairs(Scoretbl) do
        printc("/ID: "..key)
        printc("/score: "..value)
    end
end