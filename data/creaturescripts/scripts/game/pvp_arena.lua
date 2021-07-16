function onKill(cid, target, damage, flags)

	instancePvpArena:finishGame(cid, target)
	return true
end

function onLogout(cid, forceLogout)
	
	instancePvpArena:onPlayerLogout(cid)
	return true
end 