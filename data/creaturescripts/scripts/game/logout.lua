function onLogout(cid, forceLogout)
	
	if(isPlayerInDungeon(cid) and not forceLogout) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "N?o pode sair do jogo no meio de uma Dungeon!")
		return false
	end	
	
	local onLoginLevel = tonumber(getPlayerStorageValue(cid, sid.LOGIN_LEVEL))
	local onLoginExperience = tonumber(getPlayerStorageValue(cid, sid.LOGIN_EXPERIENCE))
	
	if(onLoginLevel ~= -1 and onLoginExperience ~= -1) then
		local queryStr = "INSERT INTO `player_activities` VALUES ("
			
		queryStr = queryStr .. getPlayerGUID(cid)
		queryStr = queryStr .. ", " .. getPlayerLastLogin(cid)
		queryStr = queryStr .. ", " .. os.time() - getPlayerLastLogin(cid)
		queryStr = queryStr .. ", " .. onLoginExperience
		queryStr = queryStr .. ", " .. getPlayerExperience(cid)
		queryStr = queryStr .. ", " .. onLoginLevel
		queryStr = queryStr .. ", " .. getPlayerLevel(cid)
		queryStr = queryStr .. ", " .. getPlayerIp(cid)
		
		queryStr = queryStr .. ");"
		
		db.executeQuery(queryStr)
	end
	
	return true
end 