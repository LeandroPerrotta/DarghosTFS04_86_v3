function onBattlegroundLeave(cid)
	
	unregisterCreatureEvent(cid, "onBattlegroundFrag")
	unregisterCreatureEvent(cid, "onBattlegroundEnd")
	unregisterCreatureEvent(cid, "onBattlegroundLeave")
	unregisterCreatureEvent(cid, "onBattlegroundThink")
	unregisterCreatureEvent(cid, "OnChangeOutfit")
	
	unlockTeleportScroll(cid)
	doCreatureAddHealth(cid, getCreatureMaxHealth(cid) - getCreatureHealth(cid))
	pvpBattleground.setPlayerCarryingFlagState(cid, BG_FLAG_STATE_NONE)
end

function onBattlegroundEnd(cid, winner, timeIn, bgDuration, initIn)

	local points = getBattlegroundTeamsPoints()

	local winnerTeam = BATTLEGROUND_TEAM_NONE
	local loserTeam = nil

	if(points[BATTLEGROUND_TEAM_ONE] ~= points[BATTLEGROUND_TEAM_TWO]) then
		winnerTeam = (points[BATTLEGROUND_TEAM_ONE] > points[BATTLEGROUND_TEAM_TWO]) and BATTLEGROUND_TEAM_ONE or BATTLEGROUND_TEAM_TWO
		loserTeam = (winnerTeam == BATTLEGROUND_TEAM_ONE) and BATTLEGROUND_TEAM_TWO or BATTLEGROUND_TEAM_ONE
	end
	
	if(pvpBattleground.hasGain(initIn)) then
	
		-- calculando os ganhos de honor com base no damage/heal done
		pvpBattleground.damageDone2Honor(cid)
		pvpBattleground.healDone2Honor(cid)
	
		if(not winner and winnerTeam ~= BATTLEGROUND_TEAM_NONE) then
			local removedRating = pvpBattleground.removePlayerRating(cid, timeIn, bgDuration)
			local ratingMessage = "Você piorou a sua classificação (rating) em " .. removedRating .. " pontos por sua derrota na Battleground."
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, ratingMessage)		
			
			local gainHonor = pvpBattleground.doUpdateHonor(cid)
			local gainMoney = isPremium(cid) and BG_MONEY_LOST or math.ceil(BG_MONEY_LOST * (FREE_GAINS_PERCENT / 100))
			
			local msg = "Não foi dessa vez... Por derrotas não são concedido premios de experience, mas você recebeu " .. gainHonor .. " pontos de honra " .. ((BG_GIVE_MONEY) and "e " .. gainMoney .. " moedas de ouro " or "") .. "pela sua participação e coragem!"
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
			
			if(BG_GIVE_MONEY) then
				doPlayerAddMoney(cid, gainMoney)
			end
			
			pvpBattleground.storePlayerParticipation(cid, getPlayerBattlegroundTeam(cid), false, 0, -removedRating, gainHonor)
			playerHistory.logBattlegroundLost(cid, newRating)
		end
	
		if(winner or winnerTeam == BATTLEGROUND_TEAM_NONE) then
		
			pvpBattleground.onGainHonor(cid, BATTLEGROUND_HONOR_WIN)
			if(winner and points[winnerTeam] == BG_CONFIG_WINPOINTS	and points[loserTeam] == 0) then
				playerHistory.logBattlegroundPerfectMatche(cid)
				
				if(playerHistory.logBattlegroundPerfectMatchesCount(cid) == 10 and not playerHistory.hasAchievement(cid, PH_ACH_BATTLEGROUND_PERFECT_COLLECTOR)) then
					playerHistory.onAchiev(cid, PH_ACH_BATTLEGROUND_PERFECT_COLLECTOR)
				end
				
				if (not playerHistory.hasAchievement(cid, PH_ACH_BATTLEGROUND_PERFECT)) then
					playerHistory.onAchiev(cid, PH_ACH_BATTLEGROUND_PERFECT)
				end
			end		
					
			local expGain = pvpBattleground.getExperienceGain(cid)
			local staminaChange = timeIn / 60
			
			expGain = math.floor(expGain * (timeIn / bgDuration)) -- calculamo a exp obtida com base no tempo de participa??o do jogador
			expGain = math.floor(expGain * (bgDuration / BG_CONFIG_DURATION)) -- calculamo a exp obtida com base na dura??o da battleground
			
			-- iremos reduzir o ganho de exp conforme o player se afasta da m?dia de kills definida para o grupo at? um limite de 50% de redu??o
			local playerInfo = getPlayerBattlegroundInfo(cid)
			local killsAvg = math.ceil(pvpBattleground.getTeamFragPoints(getPlayerBattlegroundTeam(cid)) / BG_CONFIG_TEAMSIZE)
			local killsRate = math.random(math.min(killsAvg, playerInfo.kills) * 100, killsAvg * 100) / (killsAvg * 100)
			
			local diminush = math.max(0.5, killsRate)
			
			-- Para que Druids não sejam prejudicados, vamos incluir o Heal na conta
			-- baseando na representação em % do heal que o jogador causou com o total
			-- de heal do time
			local teamHeal = pvpBattleground.getTeamHealDone(getPlayerBattlegroundTeam(cid))
			if(teamHeal > 0) then
				diminush = math.min((((pvpBattleground.getHealDone(cid) * 100) / teamHeal) / 100) + diminush, 1.0)	
			end

			expGain = math.ceil(expGain * diminush)
		
			local gainHonor = pvpBattleground.doUpdateHonor(cid)
			local gainMoney = isPremium(cid) and BG_MONEY_WIN or math.ceil(BG_MONEY_WIN * (FREE_GAINS_PERCENT / 100))
			
			local msg = "Você adquiriu " .. expGain .. " pontos de experiência, " .. gainHonor .. " pontos de honra " .. ((BG_GIVE_MONEY) and "e " .. gainMoney .. " moedas de ouro " or "") .. "pela sua participação nesta vitoria!"
			
			local currentRating = getPlayerBattlegroundRating(cid)
			local changeRating = pvpBattleground.getChangeRating(cid, timeIn, bgDuration)
			local ratingMessage = "Você melhorou a sua classificação (rating) em " .. changeRating .. " pontos pela vitoria na Battleground."
		
			if(winnerTeam == BATTLEGROUND_TEAM_NONE) then
			
				staminaChange = math.floor(staminaChange / 2)
				expGain = math.floor(expGain / 2)
				gainMoney = math.floor(gainMoney / 2)
				
				msg = "Você adquiriu " .. expGain .. " pontos de experiencia, " .. gainHonor .. " pontos de honra " .. ((BG_GIVE_MONEY) and "e " .. gainMoney .. " moedas de ouro " or "") .. "pela sua participação neste empate!"
				
				changeRating = math.floor(changeRating / 2)
				ratingMessage = "Você melhorou a sua classificação (rating) em " .. changeRating .. " pontos por seu empate na Battleground."
				playerHistory.logBattlegroundDraw(cid, currentRating + changeRating)
			else
				playerHistory.logBattlegroundWin(cid, currentRating + changeRating)
			end		
			
			pvpBattleground.storePlayerParticipation(cid, getPlayerBattlegroundTeam(cid), false, expGain, changeRating, gainHonor, getPlayerStamina(cid) > 40 * 60)
	
			if(not playerHistory.hasAchievement(cid, PH_ACH_BATTLEGROUND_RANK_BRAVE)
				and currentRating < 1000
				and currentRating + changeRating >= 1000) then
				playerHistory.onAchiev(cid, PH_ACH_BATTLEGROUND_RANK_BRAVE)
			end			
			
			if(not playerHistory.hasAchievement(cid, PH_ACH_BATTLEGROUND_RANK_VETERAN)
				and currentRating < 1500
				and currentRating + changeRating >= 1500) then
				playerHistory.onAchiev(cid, PH_ACH_BATTLEGROUND_RANK_VETERAN)
			end
			
			if(not playerHistory.hasAchievement(cid, PH_ACH_BATTLEGROUND_RANK_LEGEND)
				and currentRating < 2000
				and currentRating + changeRating >= 2000) then
				playerHistory.onAchiev(cid, PH_ACH_BATTLEGROUND_RANK_LEGEND)
			end				
			
			if(BG_GIVE_MONEY) then
				doPlayerAddMoney(cid, gainMoney)
			end
			
			doPlayerSetStamina(cid, -staminaChange)
			doPlayerSetBattlegroundRating(cid, currentRating + changeRating)			
			doPlayerAddExp(cid, expGain)
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, msg)
			if(not isPremium(cid)) then
				doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Adquira já sua conta premium, ajude o Darghos a continuar inovando como com as Battlegrounds e ainda receba até três vezes mais recompensas! www.darghos.com.br/index.php?ref=account.premium")
			end			
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, ratingMessage)	
		end
	else
		if(BG_ENABLED_GAINS) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Recompensa de experiencia, dinheiro e rating não concedida. Recompensas só são concedidas entre as AM 11:00 (onze da manha) e as AM 01:00 (uma da manha), expeto aos sabados e domingos.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "A battleground esta passando por revisões e somente está funcionando no modo sem ganhos, por isso nenhum tipo de ganho ou perda foi concedido por esta partida.")
		end
	end
	
	pvpBattleground.showResult(cid, winnerTeam)
end

function onBattlegroundDeath(cid, lastDamager, assistList)

	doSendAnimatedText(getPlayerPosition(lastDamager), "FRAG!", TEXTCOLOR_DARKRED)
	
	local teams = { "Time A", "Time B" }
	local points = getBattlegroundTeamsPoints()
	
	local msg = "[Battleground] |PLAYER_KILLER| matou |PLAYER_DEATH| pelo |KILLER_TEAM|!"
	
	if(doPlayerIsFlagCarrier(cid)) then
		msg = "[Battleground] |PLAYER_KILLER| matou |PLAYER_DEATH| que estava carregando a bandeira do |KILLER_TEAM|! A bandeira do |KILLER_TEAM| pode ser retornada!"
		pvpBattleground.putFlag(getPlayerBattlegroundTeam(lastDamager), getPlayerPosition(cid))
		pvpBattleground.setPlayerCarryingFlagState(cid, BG_FLAG_STATE_DROP)
		
		playerHistory.logBattlegroundFlagKilled(lastDamager)
		if(playerHistory.logBattlegroundFlagKilledCount(lastDamager) == 50 and not playerHistory.hasAchievement(lastDamager, PH_ACH_BATTLEGROUND_FLAG_KILLER)) then
			playerHistory.onAchiev(lastDamager, PH_ACH_BATTLEGROUND_FLAG_KILLER)
		end
		
		pvpBattleground.setLastFlagKiller(lastDamager)
	end
	
	pvpBattleground.updateLastTeamDeath(getPlayerBattlegroundTeam(cid))
	
	msg = string.gsub(msg, "|PLAYER_KILLER|", getPlayerName(lastDamager) .. " (" .. getPlayerLevel(lastDamager) .. ")")
	msg = string.gsub(msg, "|PLAYER_DEATH|", getPlayerName(cid) .. " (" .. getPlayerLevel(cid) .. ")")
	msg = string.gsub(msg, "|KILLER_TEAM|", teams[getPlayerBattlegroundTeam(lastDamager)])
	
	pvpBattleground.sendPvpChannelMessage(msg, PVPCHANNEL_MSGMODE_INBATTLE)

	if(pvpBattleground.hasGain()) then
		
		local totalHonor = BATTLEGROUND_DEATH_HONOR_GIVE
		local honorGain = math.floor(totalHonor * (BATTLEGROUND_FRAGGER_HONOR_PERCENT / 100))
		totalHonor = totalHonor - honorGain
		pvpBattleground.onGainHonor(lastDamager, honorGain, true)
		
		for k,v in pairs(assistList) do
			honorGain = math.floor(totalHonor / #assistList)
			pvpBattleground.onGainHonor(v, honorGain, true)
		end
		
		local playerInfo = getPlayerBattlegroundInfo(lastDamager)
		if(not playerHistory.hasAchievement(lastDamager, PH_ACH_BATTLEGROUND_INSANE_KILLER)
			and playerInfo.kills >= 25 and playerInfo.deaths == 0) then
			playerHistory.onAchiev(lastDamager, PH_ACH_BATTLEGROUND_INSANE_KILLER)
		end
	end
end

function onThink(cid, interval)

	if(doPlayerIsFlagCarrier(cid)) then
		if(not isPlayerPzLocked(cid)) then
			doPlayerSetPzLocked(cid, true)
		end
		
		if(not hasCondition(cid, CONDITION_PARALYZE)) then
			print("[Battleground] Player " .. getPlayerName(cid) .. " carregando a bandeira sem condição de paralizado.")
			local condition = createConditionObject(CONDITION_PARALYZE)
			setConditionParam(condition, CONDITION_PARAM_TICKS, 1000 * BG_CONFIG_DURATION)
			setConditionFormula(condition, -0.5, 0, -0.5, 0)
			doAddCondition(cid, condition)			
		end
		
		local canAnnimation = getPlayerStorageValue(cid, sid.BATTLEGROUND_CARRYING_LAST_ANI) == -1 or getPlayerStorageValue(cid, sid.BATTLEGROUND_CARRYING_LAST_ANI) + 2 < os.time()
		
		if(canAnnimation)  then
			doCreatureSay(cid, "Carregando a bandeira!", TALKTYPE_MONSTER_YELL)
			setPlayerStorageValue(cid, sid.BATTLEGROUND_CARRYING_LAST_ANI, os.time())
		end
	end
	
	-- TODO: Este trecho pode ser desativado, pois agora estaremos efetuando battleground somente de objetivo e ficar no pz
	-- não ira beneficiar nenhum dos times de nenhuma forma
	
	--[[	
	
	if(not doPlayerIsInBattleground(cid)) then
		return
	end

	local points = getBattlegroundTeamsPoints()
	local opponent = (getPlayerBattlegroundTeam(cid) == BATTLEGROUND_TEAM_ONE) and BATTLEGROUND_TEAM_TWO or BATTLEGROUND_TEAM_ONE
	if(points[getPlayerBattlegroundTeam(cid)] <= points[opponent]) then
		return
	end
	
	local lastCheck = getPlayerStorageValue(cid, sid.BATTLEGROUND_LAST_PZCHECK)
	
	local tile = getTileInfo(getCreaturePosition(cid))
	if(not tile.protection) then		
		return
	end	
	
	local pzTicks = incPlayerStorageValue(cid, sid.BATTLEGROUND_PZTICKS, interval)
	local inPzForLongTime = getPlayerStorageValue(cid, sid.BATTLEGROUND_LONG_TIME_PZ) == 1
	
	if(inPzForLongTime) then
		if(pzTicks > 1000 * BG_WINNER_INPZ_PUNISH_INTERVAL) then
			points[opponent] = points[opponent] + 1
			setBattlegroundTeamsPoints(opponent, points[opponent])
			setPlayerStorageValue(cid, sid.BATTLEGROUND_PZTICKS, 0)
			local teams = { "Time A", "Time B" }	
			pvpBattleground.sendPvpChannelMessage("[Battleground | (" .. teams[BATTLEGROUND_TEAM_ONE] .. ") " .. points[BATTLEGROUND_TEAM_ONE] .. " X " .. points[BATTLEGROUND_TEAM_TWO] .. " (" .. teams[BATTLEGROUND_TEAM_TWO] .. ")] " .. getPlayerName(cid).. " (" .. getPlayerLevel(cid) .. ") do " .. teams[getPlayerBattlegroundTeam(cid)] .. " ficou muito tempo dentro de area protegida enquanto seu time ganhava sem entrar em combate concedendo um ponto aos oponentes!", PVPCHANNEL_MSGMODE_INBATTLE)
		end
	else
		if(pzTicks > 1000 * BG_WINNER_INPZ_PUNISH_INTERVAL) then
			setPlayerStorageValue(cid, sid.BATTLEGROUND_LONG_TIME_PZ, 1)
			setPlayerStorageValue(cid, sid.BATTLEGROUND_PZTICKS, 0)
			doCreatureSay(cid, "Fugindo da batalha? Entre em combate com os inimigos ou seu time sofrerá penalidades!", TALKTYPE_ORANGE_1)		
		end	
	end
	]]
end
