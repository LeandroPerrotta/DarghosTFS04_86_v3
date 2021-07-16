function onPrepareDeath(cid, deathList)
	
	if(isPlayer(cid)) then
	
		if(doRoyalBlessIsEnable() and not isPlayerInDungeon(cid)) then
			return useRoyalBless(cid)
		end
	
		local isInside = getPlayerStorageValue(cid, sid.INSIDE_MINI_GAME) == 1
		
		if(isInside) then			
			setPlayerStorageValue(cid, sid.INSIDE_MINI_GAME, -1)
		end
		
		--[[
		local ret = Dungeons.onPlayerDeath(cid)
		if(not ret) then
			return false
		end
		]]
	end
	
	return true
end

function useRoyalBless(cid)
	
	doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)))
	doRemoveCreature(cid, true)
	
	return false
end