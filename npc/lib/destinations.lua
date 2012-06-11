-----------
-- BOATS
-----------

boatDestiny = {
	pvpChangedList = {}
}

function boatDestiny.addQuendor(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'quendor'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to quendor for 110 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = false, level = 0, cost = 110, destination = BOAT_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addAracura(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'aracura'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to aracura for 160 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 160, destination = BOAT_DESTINY_ARACURA, pvpEnabledOnly = true})
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addAaragon(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'aaragon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to aaragon for 130 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 130, destination = BOAT_DESTINY_AARAGON })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addSalazart(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'salazart'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to salazart for 130 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 130, destination = BOAT_DESTINY_SALAZART })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addNorthrend(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'northrend'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to northrend for 240 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 240, destination = BOAT_DESTINY_NORTHREND })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addKashmir(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'kashmir'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to kashmir for 150 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 150, destination = BOAT_DESTINY_KASHMIR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addThaun(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'thaun'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to sail to island of thaun for 110 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, level = 0, cost = 110, destination = BOAT_DESTINY_THAUN })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addSeaSerpentArea(keywordHandler, npcHandler, module)

	module = (module == nil) and StdModule.travel or module

	local travelNode = keywordHandler:addKeyword({'sea serpent', 'sea serpent area'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to be taken to sea serpent area for 800 gold coins?'})
	travelNode:addChildKeyword({'yes'}, module, {npcHandler = npcHandler, premium = true, cost = 800, destination = BOAT_DESTINY_SEA_SERPENT_AREA })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function boatDestiny.addIslandOfPeace(keywordHandler, npcHandler)

	local function onAsk(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(darghos_world_configuration == WORLD_CONF_CHANGE_ALLOWED) then
			if(doPlayerIsPvpEnable(cid)) then
				npcHandler:say('Desculpe, mas voc� � um jogador agressivo! Torne-se um jogadores pacificos primeiro se quiser viajar para Island of Peace!', cid)
				npcHandler:resetNpc(cid)
				return false
			end
			
			npcHandler:say('Voc� gostaria de pagar 200 moedas de ouro pela passagem de volta a tranquilidade de Island of Peace?', cid)
		elseif(darghos_world_configuration == WORLD_CONF_WEECLY_CHANGE) then
			local today = os.date("*t")
			local hasMadeWeeclyChange = getPlayerStorageValue(cid, sid.HAS_MADE_WEECLY_CHANGE) == 1
			
			if(hasMadeWeeclyChange) then
				npcHandler:say('Lamento mas voc� acabou de voltar de Island of Peace! Voc� dever� permanecer em Quendor ate a proxima ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '!', cid)
				npcHandler:resetNpc(cid)
				return false			
			elseif(getPlayerLevel(cid) <= darghos_weecly_change_max_level_any_day) then
				npcHandler:say('Voc� gostaria de viajar a Island of Peace? Lembre-se que ate atingir o nivel ' .. (darghos_weecly_change_max_level_any_day + 1) .. ' voc� podera fazer essa viagem a qualquer instante e de gra�a!', cid)
			elseif(today.wday == darghos_weecly_change_day) then
				npcHandler:say('Voc� gostaria de viajar a Island of Peace? Lembre-se que para o seu level somente ser� permitido voltar a Quendor na proxima ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '! VOC� TEM CERTEZA QUE REALMENTE QUER IR PARA ISLAND OF PEACE?', cid)
			else
				npcHandler:say('Lamento, mas para o seu n�vel somente e permitido viajar para Island of Peace na ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '!', cid)
				npcHandler:resetNpc(cid)
				return false	
			end
		end
		
		
		return true
	end
	
	local function onAccept(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(darghos_world_configuration == WORLD_CONF_CHANGE_ALLOWED) then	
			if(not doPlayerRemoveMoney(cid, parameters.cost)) then
				npcHandler:say('Oh, infelizmente voc� n�o possui o dinheiro necessario para embarcar...', cid)
				npcHandler:resetNpc(cid)
				return true
			end
		elseif(darghos_world_configuration == WORLD_CONF_WEECLY_CHANGE) then
			if(getPlayerLevel(cid) > darghos_weecly_change_max_level_any_day) then
				setPlayerStorageValue(cid, sid.HAS_MADE_WEECLY_CHANGE, 1)
			end
			
			doPlayerSetTown(cid, towns.ISLAND_OF_PEACE)
			doPlayerDisablePvp(cid)
		end
		
		npcHandler:say('Seja bem vindo de volta a Island of Peace caro ' .. getPlayerName(cid) .. '!', cid)
		doTeleportThing(cid, parameters.destination, false)
		doSendMagicEffect(parameters.destination, CONST_ME_TELEPORT)
		return true		
	end

	local travelNode = keywordHandler:addKeyword({'island of peace', 'isle of peace'}, onAsk, {npcHandler = npcHandler, onlyFocus = true})
	travelNode:addChildKeyword({'yes', 'sim'}, onAccept, {npcHandler = npcHandler, cost = 200, destination = BOAT_DESTINY_ISLAND_OF_PEACE })
	travelNode:addChildKeyword({'no', 'n�o', 'nao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Mas que pena... Mas tenha um bom dia!!'})
end

function boatDestiny.addQuendorFromIslandOfPeace(keywordHandler, npcHandler)

	local function onAsk(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(darghos_world_configuration == WORLD_CONF_CHANGE_ALLOWED) then
			local hasFirstChangePvpArea = getPlayerStorageValue(cid, sid.FIRST_CHANGE_PVP_AREA) == 1
			
			if(not hasFirstChangePvpArea) then
				npcHandler:say('Vejo que voc� nunca viajou para Quendor, este barco pode levar-lo para l�, por ser sua primeira viagem, n�o lhe ser� cobrado nada, por�m saiba que fora de Island of Peace voc� poder� ativar ou desativar <...>', cid)
				npcHandler:say('a habilidade de entrar em combate com outros jogadores, isto �, seu pvp. Inicialmente o seu pvp est� desativado, caso voc� deseje o ativar converse com o NPC\'s que ficam no templo de todas cidades. <...>', cid)
				npcHandler:say('Saiba tamb�m que somente � permitido voltar para Island of Peace jogadores que estiverem com seu pvp desativado, se voc� o ativar-lo, n�o poder� voltar. <...>', cid)			
				npcHandler:say('E ent�o, deseja mesmo embarcar para Quendor?', cid)
				
				return true
			end
			
			npcHandler:say('Voc� gostaria de pagar 200 moedas de ouro para viajar para Quendor?', cid)
		elseif(darghos_world_configuration == WORLD_CONF_WEECLY_CHANGE) then
			
			local today = os.date("*t")
			local hasMadeWeeclyChange = getPlayerStorageValue(cid, sid.HAS_MADE_WEECLY_CHANGE) == 1
			
			if(hasMadeWeeclyChange) then
				npcHandler:say('Lamento mas voc� acabou de jogar de Quendor! Voc� dever� permanecer em Island of Peace ate a proxima ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '!', cid)
				npcHandler:resetNpc(cid)
				return false
			elseif(getPlayerLevel(cid) <= darghos_weecly_change_max_level_any_day) then
				npcHandler:say('Voc� gostaria de viajar a Quendor? Lembre-se que ate atingir o nivel ' .. (darghos_weecly_change_max_level_any_day + 1) .. ' voc� podera fazer essa viagem a qualquer instante e de gra�a!', cid)
			elseif(today.wday == darghos_weecly_change_day) then
				npcHandler:say('Voc� gostaria de viajar a Quendor? Lembre-se que para o seu level somente ser� permitido voltar a Island of Peace na proxima ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '! VOC� TEM CERTEZA QUE REALMENTE QUER IR QUENDOR?', cid)
			else
				npcHandler:say('Lamento, mas para o seu n�vel somente e permitido viajar para Quendor na ' .. WEEKDAY_STRING[darghos_weecly_change_day] .. '!', cid)
				npcHandler:resetNpc(cid)
				return false	
			end
		elseif(darghos_world_configuration == WORLD_CONF_AGRESSIVE_ONLY) then
			npcHandler:say('Quendor � uma maravilhosa cidade! Mais saiba que por l� e por todo o resto do mundo do Darghos o seu PvP e de todos outras � sempre ativo, assim voc� poder�  <...>', cid)
			npcHandler:say('atacar e ser atacado por outras pessoas... Tamb�m esteja ciente que uma vez abandonando esta ilha voc� se tornar� cidad�o de Quendor n�o ser� mais possivel retornar <...>', cid)
			npcHandler:say('E ent�o, deseja mesmo embarcar para Quendor?', cid)		
		end
		
		return true
	end
	
	local function onAccept(cid, message, keywords, parameters, node)
		local npcHandler = parameters.npcHandler
		if(npcHandler == nil) then
			print('[Warning - ' .. getCreatureName(getNpcId()) .. '] NpcSystem:', 'StdModule.travel - Call without any npcHandler instance.')
			return false
		end
	
		if(not npcHandler:isFocused(cid)) then
			return false
		end	
		
		if(darghos_world_configuration == WORLD_CONF_CHANGE_ALLOWED) then
			local hasFirstChangePvpArea = getPlayerStorageValue(cid, sid.FIRST_CHANGE_PVP_AREA) == 1
			
			if(hasFirstChangePvpArea and not doPlayerRemoveMoney(cid, parameters.cost)) then
				npcHandler:say('Oh, infelizmente voc� n�o possui o dinheiro necessario para embarcar...', cid)
				npcHandler:resetNpc(cid)
				return true
			end	
			
			if(not hasFirstChangePvpArea) then
				npcHandler:say('Seja bem vindo a Quendor caro ' .. getPlayerName(cid) .. '! Para chegar na cidade, siga para o sul e tenha cuidado com as criatura!', cid)		
				setPlayerStorageValue(cid, sid.FIRST_CHANGE_PVP_AREA, 1)
			else		
				npcHandler:say('Seja bem vindo de volta a Quendor caro ' .. getPlayerName(cid) .. '!', cid)
			end
			
			if(getConfigInfo("worldId") == WORLD_AARAGON) then
				doPlayerSetTown(cid, towns.QUENDOR)
				doPlayerEnablePvp(cid)
				setStageOnChangePvp(cid)
			end
		elseif(darghos_world_configuration == WORLD_CONF_WEECLY_CHANGE) then
			
			doPlayerSetTown(cid, towns.QUENDOR)
			doPlayerEnablePvp(cid)
			
			if(getPlayerLevel(cid) > darghos_weecly_change_max_level_any_day) then
				setPlayerStorageValue(cid, sid.HAS_MADE_WEECLY_CHANGE, 1)
			end
			
			npcHandler:say('Seja bem vindo de volta a Quendor caro ' .. getPlayerName(cid) .. '!', cid)
		elseif(darghos_world_configuration == WORLD_CONF_AGRESSIVE_ONLY) then
			doPlayerSetTown(cid, towns.QUENDOR)
			doPlayerEnablePvp(cid)
			setStageOnChangePvp(cid)
			
			npcHandler:say('Seja bem vindo a Quendor caro ' .. getPlayerName(cid) .. '!', cid)
		end
		
		doTeleportThing(cid, parameters.destination, false)
		doSendMagicEffect(parameters.destination, CONST_ME_TELEPORT)		
		return true
	end

	local travelNode = keywordHandler:addKeyword({'quendor'}, onAsk, {npcHandler = npcHandler, onlyFocus = true})
	travelNode:addChildKeyword({'yes', 'sim'}, onAccept, {npcHandler = npcHandler, cost = 200, destination = BOAT_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no', 'n�o', 'nao'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Mas que pena... Mas tenha um bom dia!!'})
end

-----------
-- CARPETS
-----------

carpetDestiny = {}

function carpetDestiny.addAaragon(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'aaragon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Aaragon for 60 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 60, destination = CARPET_DESTINY_AARAGON })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function carpetDestiny.addHills(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'hills'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Hills for 60 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 60, destination = CARPET_DESTINY_HILLS })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function carpetDestiny.addSalazart(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'salazart'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to fly in my magic carpet to Salazart for 40 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 40, destination = CARPET_DESTINY_SALAZART })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

-----------
-- TRAINS
-----------

trainDestiny = {}

function trainDestiny.addQuendor(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'quendor'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to board in this train to Quendor for 330 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 330, destination = TRAIN_DESTINY_QUENDOR })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

function trainDestiny.addThorn(keywordHandler, npcHandler)

	local travelNode = keywordHandler:addKeyword({'thorn'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Do you want to board in this train to Quendor for 270 gold coins?'})
	travelNode:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = true, level = 0, cost = 270, destination = TRAIN_DESTINY_THORN })
	travelNode:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, reset = true, text = 'Then stay here!'})
end

