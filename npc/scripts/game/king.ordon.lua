local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)                  npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)               npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)          npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                              npcHandler:onThink()                                    end

function saySpecialPermission(cid, message, keywords, parameters, node)

	local npcHandler = parameters.npcHandler
	local talkState = parameters.talk_state

    if(not npcHandler:isFocused(cid)) then
        return false
    end 
	

    if(darghos_world_configuration ~= WORLD_CONF_CHANGE_ALLOWED) then
	    return false		
    end
    
    local lastChangePvp = getPlayerStorageValue(cid, sid.LAST_CHANGE_PVP)
    
     if(talkState == 1) then 	
        	if(lastChangePvp ~= -1 and lastChangePvp + (darghos_change_pvp_days_cooldown * 60 * 60 * 24) > os.time()) then
    	
	    		local leftDays = math.floor(((lastChangePvp + (darghos_change_pvp_days_cooldown * 60 * 60 * 24)) - os.time()) / 60 / 60 / 24)
	    	
	    		if(leftDays > 0 and leftDays < darghos_change_pvp_days_cooldown - darghos_change_pvp_premdays_cooldown) then
    				npcHandler:say("Eu posso lhe conceder a permiss�o de uma unica mudan�a de PvP mais curta, que pode ser feita a cada 10 dias, assim voc� poder� imediatamente trocar seu PvP com os funcionarios dos templos, e mais! Voc� gostaria de obter esta permiss�o?", cid)
					node:addChildKeyword({'sim', 'yes'}, saySpecialPermission, {npcHandler = npcHandler, onlyFocus = true, talk_state = 2})
					node:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Tudo bem, volte se mudar de ideia!', reset = true})
					return true
				else
					npcHandler:say("Eu posso lhe conceder a permiss�o de uma unica mudan�a de PvP mais curta, que pode ser feita a cada 10 dias, por�m ainda n�o se passaram 10 dias desde a sua ultima mudan�a... ", cid)
				end
			else
				npcHandler:say("Ora! Voc� est� livre para fazer uma nova mudan�a de PvP, voc� n�o precisa de minha permiss�o especial!", cid)
			end
	 elseif(talkState == 2) then
	 	npcHandler:say("Saiba que est� permiss�o tem um grande custo! Para obter-la voc� precisar� sacrificar " .. darghos_change_pvp_premdays_cost .. " dias de sua Conta Premium, voc� tem certeza que quer isto mesmo??", cid)
     	node:addChildKeyword({'sim', 'yes'}, saySpecialPermission, {npcHandler = npcHandler, onlyFocus = true, talk_state = 3})
     	node:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Uhmm, prefere pensar melhor? Me procure se mudar de ideia', reset = true})
     	return true
	 elseif(talkState == 3) then
	 	if(isPremium(cid) and getPlayerPremiumDays(cid) >= darghos_change_pvp_premdays_cost) then
		 	npcHandler:say("VOC� TEM CERTEZA DISTO? VOC� DESEJA PERDER " .. darghos_change_pvp_premdays_cost .. " DIAS DE SUA CONTA PREMIUM EM TROCA DE MINHA PERMISS�O ESPECIAL DE MUDAN�A DE PVP??", cid)
	     	node:addChildKeyword({'sim', 'yes'}, saySpecialPermission, {npcHandler = npcHandler, onlyFocus = true, talk_state = 4})
	     	node:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Eu sabia que n�o estava completamente certo disto!!', reset = true})
	     	return true     	
     	else
     		npcHandler:say("Desculpe, voc� n�o possui os " .. darghos_change_pvp_premdays_cost .. " dias de Conta Premium necess�rios para este sacrificio...", cid)
     	end
 	 elseif(talkState == 4) then
 	 	setPlayerStorageValue(cid, sid.CHANGE_PVP_PERMISSION, 1)
 	 	doPlayerAddPremiumDays(cid, -darghos_change_pvp_premdays_cost)
 	 	changeLog.onBuySpecialPermission(cid)
	 	npcHandler:say("FEITO! Voc� abriu m�o de " .. darghos_change_pvp_premdays_cost .. " dias de sua conta premium em troca de minha permiss�o especial! Agora voc� pode falar com o funcion�rio do templo e ele n�o ir� negar seu pedido de mudan�a de PvP!!", cid)
     end

	npcHandler:resetNpc(cid)
	return true 
end

function sayPunishment(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	local talkState = parameters.talk_state

    if(not npcHandler:isFocused(cid)) then
        return false
    end
	
    if(darghos_world_configuration ~= WORLD_CONF_CHANGE_ALLOWED) then
	    return false		
    end	
    
    local changePvpDebuffExpire = getPlayerStorageValue(cid, sid.CHANGE_PVP_EXP_DEBUFF)
    
    if(changePvpDebuffExpire == nil or changePvpDebuffExpire < os.time()) then
    	npcHandler:say("Voc� n�o est� sob o efeito desta penalidade!", cid)
    	npcHandler:resetNpc(cid)		
    	return false
    end
    
    if(not isPremium(cid)) then
     	npcHandler:say("Isto so � permitido a jogadores com uma conta premium...", cid)
    	npcHandler:resetNpc(cid)		
    	return false       
    end
    
    if(getPlayerPremiumDays(cid) < darghos_remove_change_pvp_debuff_cost) then
     	npcHandler:say("Para a remo��o desta penalidade voc� precisar� sacrificar " .. darghos_remove_change_pvp_debuff_cost .. " dias de sua conta premium, na qual voc� n�o possui!", cid)
    	npcHandler:resetNpc(cid)
    	return false   
    end
    
    doPlayerAddPremiumDays(cid, -darghos_remove_change_pvp_debuff_cost)
    setPlayerStorageValue(cid, sid.CHANGE_PVP_EXP_DEBUFF, 0)
    setStageType(cid, SKILL__LEVEL)
    changeLog.onCleanExpDebuff(cid)
    npcHandler:say("Esta feito! Voc� n�o esta mais sob o efeito da penalidade de redu��o de experiencia ganha!", cid)
    return true
end

STATE_NONE = -1
STATE_ACCEPT = 0

EVENT_ITEMS = {
	2743, -- heaven blossom
	2680, -- strawberrys
	1746, -- treasure chest
	2472, -- magic plate armor
	3967 -- tribal mask
}

function facebookEventCallback(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	local talkState = parameters.talk_state

    if(not npcHandler:isFocused(cid)) then
        return false
    end
	
	if(getStorage(gid.FACEBOOK_ORDON_EVENT_WINNER) ~= -1) then
		return false
	end
	
	local state = getPlayerStorageValue(cid, sid.FACEBOOK_EVENT_STATE)
	if(talkState == 0) then
		if(state == STATE_NONE) then
			npcHandler:say("O Dark General roubou alguns de meus mais valiosos pertences e os escondeu nos lugares mais remotos de Darghos. Voc� gostaria de ajudar procurando os pertences roubados?", cid)
			
			node:clearChildrenNodes()
			
			node:addChildKeyword({'sim', 'yes'}, facebookEventCallback, {npcHandler = npcHandler, talk_state = 1})
			node:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Que rude! Tu n�o deverias fazer parte deste reino!", reset = true})
		elseif(state == STATE_ACCEPT) then
			npcHandler:say("Seja bem vindo de volta " .. getPlayerName(cid).. "! Eu estava ancioso por noticias suas. E ent�o, conseguiu encontrar meus pertences?" , cid)
		
			node:clearChildrenNodes()
			
			node:addChildKeyword({'sim', 'yes'}, facebookEventCallback, {npcHandler = npcHandler, talk_state = 2})
			node:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Oh, que pena... Seja breve! Tenho pressa em recuperar-los!", reset = true})
		end
	elseif(talkState == 1) then
		
		npcHandler:say("Otimo! Como dito, os pertences foram escondidos pelo Darghos, sua miss�o ser� encontrar-los, juntar-los e trazer-los para mim. Por motivos de seguran�a informa��es sobre os items ser�o divulgados fora do jogo, no website: www.darghos.com.br! Boa sorte!", cid)
		setPlayerStorageValue(cid, sid.FACEBOOK_EVENT_STATE, STATE_ACCEPT)
	elseif(talkState == 2) then
		
		local foundAllItems = true
		
		for _,v in pairs(EVENT_ITEMS) do
			if(getPlayerItemCount(cid, v) == 0) then
				foundAllItems = false
				break
			end
		end
		
		if (not foundAllItems) then
			npcHandler:say("Algo esta errado, voc� n�o possui os meus pertences, volte aqui quando estiver com todos meus pertences!", cid)
			npcHandler:resetNpc(cid)
			return false
		else
			for _,v in pairs(EVENT_ITEMS) do
				if(not doPlayerRemoveItem(cid, v, 1)) then
					error("Cannot remove item: " .. v .. " of player " .. getPlayerName(cid))
					break
				end
			end
			
			npcHandler:say("Bravo guerreiro, tenho certeza que voc� vagou muito pelas terras Darghonianas para conseguir os meus pertences de volta! Voc� foi corajoso e valente, e como prova de minha gratid�o, aceite meu presente.", cid)
			
			local vocationName = "sorcerer"
			
			if (isDruid(cid)) then
				vocationName = "druid"
			elseif(isPaladin(cid)) then
				vocationName = "paladin"
			elseif(isKnight(cid)) then
				vocationName = "knight"
			end
			
			doBroadcastMessage("Rei Ordon: Meus pertences finalmente foram encontrados pelo bravo e valente " .. vocationName .. " chamado " .. getPlayerName(cid) .. " e ele receber� a minha generosa recompensa! Obrigado a todos Darghonianos que prestaram a sua ajuda nesta miss�o!", MESSAGE_EVENT_ADVANCE)
			doPlayerAddItem(cid, CUSTOM_ITEMS.ORDON_DESTRUCTION_AMULET)
			
			doSetStorage(gid.FACEBOOK_ORDON_EVENT_WINNER, getPlayerGUID(cid))
			
			npcHandler:resetNpc(cid)
		end
	end
	
	return true
end

talkState = {}

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	
	if(msgcontains(msg, {"mission", "task", "miss�o", "missao", "tarefa"})) then
		local ariadneState = getPlayerStorageValue(cid, QUESTLOG.ARIADNE.LAIR)
		local ghazranWingStatus = getPlayerStorageValue(cid, QUESTLOG.ARIADNE.GHAZRAN_WING)
		
		if(ariadneState == -1) then
			npcHandler:say("A velha bruxa Ariadne est� a assombrar a paz em Thorn, sua ultima vitima foi a {princesa}! Como pode!!", cid)
			talkState[cid] = 1
		elseif(ariadneState == 2) then
			npcHandler:say("Encontre a entrada do Lair de Ariadne, um de meus Guardas o espera l�!", cid)
		elseif(ghazranWingStatus >= 1 and ghazranWingStatus < 4) then
			npcHandler:say("Est� em posse da l�ngua de Ghazran?", cid)
			talkState[cid] = 5
		end
	elseif(msgcontains(msg, {"princesa"}) and talkState[cid] == 1) then
		npcHandler:say("Minha querida filha, a princesa Elione foi vitima de um {feiti�o} da velha Ariadne enquanto passeava pelo pantano. Desde ent�o eu ordenei que meus guardas proibissem que as pessoas fossem para o pantano para evitar novas vitimas...", cid)
		talkState[cid] = 2
	elseif(msgcontains(msg, {"feiti�o"}) and talkState[cid] == 2) then
		npcHandler:say("O feiti�o que a princesa Elione sofreu transformou minha bela filha em um horrozo sapo! Thorn precisa de bravos guerreiros que se comprometam a entrar no pantano para me ajudar a buscar os ingredientes necessarios para se fazer o {antidoto} que anula o feiti�o sofrido!", cid)
		talkState[cid] = 3
	elseif(msgcontains(msg, {"antidoto"}) and talkState[cid] == 3) then
		npcHandler:say("Para ser feito o antidoto � necessario conseguir 3 raros ingredientes, al�m de um recipiente especial que somente pode ser obtido vencendo a velha Ariadne. Os ingredientes especiais est�o sob os cuidados de mal�ficos seguidos de Ariadne! Voc� gostaria de tentar ajudar a conseguir o antidoto para recuperar a doce Elione?", cid)
		talkState[cid] = 4
	elseif(msgcontains(msg, {"yes", "sim"})) then
		if(talkState[cid] == 4) then
			local level = getPlayerLevel(cid)
							
			if(level < 220) then
				npcHandler:say("Estou impressionado com sua brava coragem meu rapaz, mas esta miss�o requer maior conhecimento e habilidade.", cid)
			else
				npcHandler:say("Otimo! Estou profundamente contente que voc� ir� nos ajudar! Meus guardas j� recebam ordens para que permitam voc� a entrar no Pantano. Muito cuidado, este lugar � trai�oeiro! Consigas o antidoto e lhe re-compensarei por esta brava atitude!", cid)	
				doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Nova Quest aberta em seu QuestLog: Ariadne's Quest.")
				
				setPlayerStorageValue(cid, QUESTLOG.ARIADNE.LAIR, 2)
			end
			
			talkState[cid] = nil
		elseif(talkState[cid] == 5) then
			local haveGhazranTongue = (getPlayerStorageValue(cid, sid.ARIADNE_GHAZRAN_TONGUE) == 1)
			
			if not(haveGhazranTongue) then
				
				npcHandler:say("Voc� ainda n�o conseguiu a l�ngua de Ghazran, seja r�pido em conseguir-la!", cid)
			else
				npcHandler:say("Magnifico! Esta l�ngua ser� guardada para fazermos o antidoto quando tivermos os outros ingredientes. Aqui est� sua recompensa!", cid)	
				
				local reward = nil 
				
				if(isKnight(cid)) then
					reward = CUSTOM_ITEMS.VENGEANCE_SEAL_RING
				elseif(isPaladin(cid)) then
					reward = CUSTOM_ITEMS.CROOKED_EYE_RING
				elseif(isDruid(cid) or isSorcerer(cid)) then
					reward = CUSTOM_ITEMS.PETRIFIED_STONEHEARTH
				end
				
				doPlayerAddItem(cid, reward, 1)
				
				setPlayerStorageValue(cid, QUESTLOG.ARIADNE.GHAZRAN_WING, 4)
				setPlayerStorageValue(cid, QUESTLOG.ARIADNE.CULTISTS_WING, 1)
			end
		end
		
		talkState[cid] = nil
	end
	
	return true
end

function onFarewell(cid)
	talkState[cid] = nil
end

--keywordHandler:addKeyword({'pertences'}, facebookEventCallback, {npcHandler = npcHandler, talk_state = 0, nlyFocus = true})
keywordHandler:addKeyword({'permiss�o especial', 'permissao especial'}, saySpecialPermission, {npcHandler = npcHandler, onlyFocus = true, talk_state = 1})

local node4 = keywordHandler:addKeyword({'puni��o', 'punicao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Ap�s uma mudan�a de PvP voc� fica sob o efeito da puni��o que reduz a experiencia obtida em 50%. Com os poderes concedidos a mim eu posso remover este efeito, POREM AO CUSTO DE ' .. darghos_remove_change_pvp_debuff_cost .. ' DIAS DE SUA CONTA PREMIUM! Voc� gostaria?'})
				node4:addChildKeyword({'sim', 'yes'}, sayPunishment, {npcHandler = npcHandler, onlyFocus = true})
				node4:addChildKeyword({'n�o', 'nao', 'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ok, em que mais posso lhe ajudar?", reset = true})

D_CustomNpcModules.addPromotionHandler(keywordHandler, npcHandler)

keywordHandler:addKeyword({'ajuda', 'ajudar'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'A jogadores que j� tiverem atingido level 20 e possuirem uma Conta Premium eu posso conceder a {promo��o}! Tamb�m foi me dado alguns poderes especiais para auxiliar jogadores pacificos ou agressivos que mudaram o {pvp}.'})
keywordHandler:addKeyword({'pvp'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Se voc� tiver mudado o seu PvP e tiver se arrependido, eu posso lhe conceder a {permiss�o especial}, com ela, os funcionarios dos templos n�o ir�o recusar uma nova mudan�a de pvp. Apos uma mudan�a os jogadores ficam sob efeito de {puni��o}, que eu tamb�m posso cancelar.'})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_FAREWELL, onFarewell)
npcHandler:addModule(FocusModule:new())
