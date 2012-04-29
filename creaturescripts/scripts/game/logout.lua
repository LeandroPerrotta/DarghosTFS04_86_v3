function onLogout(cid, forceLogout)
	
	local dungeonId = getPlayerStorageValue(cid, sid.ON_DUNGEON)
	
	if(dungeonId ~= -1) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Não pode sair no meio de uma Dungeon!")
		return false
	end	
	
	return true
end 