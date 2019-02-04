LINK_INITPLAYER = "http://bigciba.applinzi.com/dota2api/initPlayerInfo.php"
LINK_GETPLAYERINFO = "http://bigciba.applinzi.com/dota2api/getPlayerInfo.php"
LINK_UPDATASCORE = "http://bigciba.applinzi.com/dota2api/updataScore.php"
LINK_GETSCORE = "http://bigciba.applinzi.com/dota2api/getScore.php"
if Server == nil then
	_G.Server = class({})
end
function Server:GetPlayerInfo(playerID,callback)
    local player = PlayerResource:GetPlayer(playerID)
    local steamid = PlayerResource:GetSteamAccountID(playerID)
    local url = LINK_GETPLAYERINFO.."?steamid="..tostring(steamid)
    local req = CreateHTTPRequestScriptVM("GET",url)
    req:Send(function(res)
        if res.Body ~= "null" then
            player.ServerInfo = JSON:decode(res.Body)
            --PrintTable(JSON:decode(res.Body))
            callback()
        else
            self:InitPlayerInfo(playerID,callback)
        end
    end)
end
function Server:InitPlayerInfo(playerID,callback)
    local player = PlayerResource:GetPlayer(playerID)
    local steamid = PlayerResource:GetSteamAccountID(playerID)
    local url = LINK_INITPLAYER.."?steamid="..tostring(steamid)
    local req = CreateHTTPRequestScriptVM("GET",url)
    req:Send(function(res) 
        if res.Body == 200 then
            self:GetPlayerInfo(playerID,callback)
        end
    end)
end
function Server:GetScore(playerID)
    local player = PlayerResource:GetPlayer(playerID)
    local steamid = PlayerResource:GetSteamAccountID(playerID)
    local url = LINK_GETSCORE.."?steamid="..tostring(steamid)
    local req = CreateHTTPRequestScriptVM("GET",url)
    req:Send(function(res)
        if res.Body ~= "null" then
            local ScoreInfo = JSON:decode(res.Body)
            player.Score = ScoreInfo.score
            --PrintTable(JSON:decode(res.Body))
        end
    end)
end
function Server:UpdataScore()
    local ent = Entities:FindByName( nil, "athena" )
    ent:FireOutput("OnUser1", ent, ent, nil, 0)
end