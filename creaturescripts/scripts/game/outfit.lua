function onOutfit(cid, old, current)

	if(changeOutfitIsLocked(cid) or doPlayerIsInBattleground(cid)) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voc� n�o pode alterar o seu outfit neste momento.")
		return false
	end
	
	return true
end