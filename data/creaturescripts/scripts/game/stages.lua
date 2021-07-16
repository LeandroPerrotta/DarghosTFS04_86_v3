function onAdvance(cid, type, oldlevel, newlevel)
		
	setStageOnAdvance(cid, type)
	
	if(type == SKILL__LEVEL and canReceivePremiumTest(cid, newlevel)) then
		addPremiumTest(cid)
	end
	
	if(type == SKILL__LEVEL) then
	
		if(newlevel == 100 and not playerHistory.hasAchievement(cid, PH_ACH_MISC_GOT_LEVEL_100)) then
			playerHistory.onAchiev(cid, PH_ACH_MISC_GOT_LEVEL_100)
		elseif(newlevel == 200 and not playerHistory.hasAchievement(cid, PH_ACH_MISC_GOT_LEVEL_200)) then
			playerHistory.onAchiev(cid, PH_ACH_MISC_GOT_LEVEL_200)
		elseif(newlevel == 300 and not playerHistory.hasAchievement(cid, PH_ACH_MISC_GOT_LEVEL_300)) then
			playerHistory.onAchiev(cid, PH_ACH_MISC_GOT_LEVEL_300)
		elseif(newlevel == 400 and not playerHistory.hasAchievement(cid, PH_ACH_MISC_GOT_LEVEL_400)) then
			playerHistory.onAchiev(cid, PH_ACH_MISC_GOT_LEVEL_400)
		elseif(newlevel == 500 and not playerHistory.hasAchievement(cid, PH_ACH_MISC_GOT_LEVEL_500)) then
			playerHistory.onAchiev(cid, PH_ACH_MISC_GOT_LEVEL_500)
		end
	
	end
	
	return LUA_TRUE
end