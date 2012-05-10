----------------------------------------------------------
-- DATA LOG
-- Battlegrounds
PH_LOG_BATTLEGROUND_WIN = 1
PH_LOG_BATTLEGROUND_LOST = 2
PH_LOG_BATTLEGROUND_DRAW = 3

-- Dungeons
PH_LOG_DUNGEON_ARIADNE_TROLLS_ATTEMPS = 4
PH_LOG_DUNGEON_ARIADNE_TROLLS_COMPLETED = 5

----------------------------------------------------------
-- ACHIEVEMENTS
-- Battlegrounds (1 a 999)
PH_ACH_BATTLEGROUND_RANK_VETERAN = 1
PH_ACH_BATTLEGROUND_RANK_LEGEND = 2
PH_ACH_BATTLEGROUND_INSANE_KILLER = 3
PH_ACH_BATTLEGROUND_PERFECT = 4
PH_ACH_BATTLEGROUND_RANK_BRAVE = 5

-- Dungeons (1000 a 1999)
PH_ACH_DUNGEON_ARIADNE_TROLLS_GOT_ALL_TOTEMS = 1000
PH_ACH_DUNGEON_ARIADNE_TROLLS_GOT_GHAZRAN_TONGUE = 1001
PH_ACH_DUNGEON_ARIADNE_TROLLS_COMPLETE_IN_ONLY_ONE_ATTEMP = 1002
PH_ACH_DUNGEON_ARIADNE_TROLLS_COMPLETE_WITHOUT_ANYONE_DIE = 1003

-- Misc (2000 a 2999)
PH_ACH_MISC_GOT_LEVEL_100 = 2000
PH_ACH_MISC_GOT_LEVEL_200 = 2001
PH_ACH_MISC_GOT_LEVEL_300 = 2002
PH_ACH_MISC_GOT_LEVEL_400 = 2003
PH_ACH_MISC_GOT_LEVEL_500 = 2004

PH_TYPE_LOG = 1
PH_TYPE_ACHIEVEMENT = 2

playerAchievements = {

	[PH_ACH_BATTLEGROUND_RANK_BRAVE] = {
		notifyText = "[Façanha alcançada] Rank - Bravo: Conquistou 1.000 pontos (rating) de classificação em Battlegrounds!"
	}
	
	,[PH_ACH_BATTLEGROUND_RANK_VETERAN] = {
		notifyText = "[Façanha alcançada] Rank - Veterano: Conquistou 1.500 pontos (rating) de classificação em Battlegrounds!"
	}
	
	,[PH_ACH_BATTLEGROUND_RANK_LEGEND] = {
		notifyText = "[Façanha alcançada] Rank - Lenda: Conquistou 2.000 pontos (rating) de classificação em Battlegrounds!"
	}
	
	,[PH_ACH_BATTLEGROUND_INSANE_KILLER] = {
		notifyText = "[Façanha alcançada] Matador insano! Derrotou 25 oponentes sem ser derrotado nenhuma vez em Battlegrounds!"
	}
	
	,[PH_ACH_BATTLEGROUND_PERFECT] = {
		notifyText = "[Façanha alcançada] Efetuou a Battleground perfeita ao vencer pelo placar de 50 pontos a 0!"
	}
	
	,[PH_ACH_DUNGEON_ARIADNE_TROLLS_GOT_ALL_TOTEMS] = {
		notifyText = "[Façanha alcançada] Você obteve os 12 totems que liberam o acesso ao lar do Ghazran!"
	}
	
	,[PH_ACH_DUNGEON_ARIADNE_TROLLS_GOT_GHAZRAN_TONGUE] = {
		notifyText = "[Façanha alcançada] Você derrotou e obteve a lingua do boss Ghazran da Ariadne Trolls Wing!"
	}
	
	,[PH_ACH_DUNGEON_ARIADNE_TROLLS_COMPLETE_IN_ONLY_ONE_ATTEMP] = {
		notifyText = "[Façanha alcançada] Você completou a Ariadne Trolls Wing obtendo os 12 totems e derrotando o boss em apénas uma tentativa!"
	}
	
	,[PH_ACH_DUNGEON_ARIADNE_TROLLS_COMPLETE_WITHOUT_ANYONE_DIE] = {
		notifyText = "[Façanha alcançada] Você completou a Ariadne Trolls Wing derrotando o boss sem que ninguem do seu time morresse!"
	}
	
	,[PH_ACH_MISC_GOT_LEVEL_100] = {
		notifyText = "[Façanha alcançada] Você atingiu o level 100!"
	}
	
	,[PH_ACH_MISC_GOT_LEVEL_200] = {
		notifyText = "[Façanha alcançada] Você atingiu o level 200!"
	}
	
	,[PH_ACH_MISC_GOT_LEVEL_300] = {
		notifyText = "[Façanha alcançada] Você atingiu o level 300!"
	}
	
	,[PH_ACH_MISC_GOT_LEVEL_400] = {
		notifyText = "[Façanha alcançada] Você atingiu o level 400!"
	}
	
	,[PH_ACH_MISC_GOT_LEVEL_500] = {
		notifyText = "[Façanha alcançada] Você atingiu o level 500!"
	}
}

playerHistory = {}

--[[
	LOGS HANDLER
]]--

function playerHistory.log(cid, history, params)

	if(params ~= nil) then
		local json = require("json")	
		params = json.encode(params)
	else
		params = ""
	end
	
	db.executeQuery("INSERT `player_history` (`player_id`, `history`, `type`, `date`, `params`) VALUES (" .. getPlayerGUID(cid) .. ", " .. history .. ", " .. PH_TYPE_LOG .. ", " .. os.time() .. ", '" .. params .. "');")
end

--[[
	ACHIEVEMENTS HANDLER
]]--

function playerHistory.addAchievement(cid, history)

	db.executeQuery("INSERT `player_history` (`player_id`, `history`, `type`, `date`, `params`) VALUES (" .. getPlayerGUID(cid) .. ", " .. history .. ", " .. PH_TYPE_ACHIEVEMENT .. ", " .. os.time() .. ", '');")	
	return false	
end

function playerHistory.hasAchievement(cid, history)

	local result = db.getResult("SELECT `history` FROM `player_history` WHERE `player_id` = " .. getPlayerGUID(cid) .. " AND `history` = " .. history .. " AND `type` = " .. PH_TYPE_ACHIEVEMENT .. ";")
	
	if(result:getID() ~= -1) then
		result:free()
		return true
	end	
	
	return false	
end

function playerHistory.notifyAchievement(cid, message)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, message)
end

--[[
	LOGS
]]--

function playerHistory.logBattlegroundWin(cid, rating)
	playerHistory.log(cid, PH_LOG_BATTLEGROUND_WIN, {["rating"] = rating})
end

function playerHistory.logBattlegroundLost(cid, rating)
	playerHistory.log(cid, PH_LOG_BATTLEGROUND_LOST, {["rating"] = rating})
end

function playerHistory.logBattlegroundDraw(cid, rating)
	playerHistory.log(cid, PH_LOG_BATTLEGROUND_DRAW, {["rating"] = rating})
end

function playerHistory.logDungAriadneTrollsAttemp(cid)
	playerHistory.log(cid, PH_LOG_DUNGEON_ARIADNE_TROLLS_ATTEMPS)
end

function playerHistory.logDungAriadneTrollsCompleted(cid)
	playerHistory.log(cid, PH_LOG_DUNGEON_ARIADNE_TROLLS_COMPLETED)
end

--[[
	ACHIEVEMENTS
]]--

function playerHistory.onAchiev(cid, history)
	
	local data = playerAchievements[history]
	playerHistory.notifyAchievement(cid, data.notifyText)
	playerHistory.addAchievement(cid, history)
end