function onLogout(cid, forceLogout)
	
	if(isPlayerInDungeon(cid)) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "N�o pode sair do jogo no meio de uma Dungeon!")
		return false
	end	
	
	return true
end 