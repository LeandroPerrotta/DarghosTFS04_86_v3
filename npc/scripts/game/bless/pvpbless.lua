local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid) 			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid) 		end
function onCreatureSay(cid, type, msg) 		npcHandler:onCreatureSay(cid, type, msg) 	end
function onThink() 							npcHandler:onThink() 						end

function process(cid, message, keywords, parameters, node)
	local npcHandler = parameters.npcHandler
	local talkState = parameters.talk_state
	
    if(not npcHandler:isFocused(cid)) then
        return false
    end 

	if(getConfigInfo("worldId") == WORLD_AARAGON) then
    	npcHandler:say("Voc� n�o pode efetuar uma mudan�a de PvP neste mundo...", cid)
		npcHandler:resetNpc(cid)
		return false		
	end
	
    if(hasCondition(cid, CONDITION_INFIGHT)) then
    	npcHandler:say("Ohh por Deus! Voc� est� muito agressivo! Volte quando estiver mais calmo...", cid)
		npcHandler:resetNpc(cid)		
		return false
    end
    
    local nonPermitedSkulls = { SKULL_RED, SKULL_BLACK }
    local skull = getCreatureSkullType(cid)
    if(isInArray(nonPermitedSkulls, skull)) then
    	npcHandler:say("Voc� � sujo! N�o teve nenhuma compaix�o por suas vitimas! Para voc� n�o darei este beneficio!", cid)
		npcHandler:resetNpc(cid)		
		return false    
    end
    
    local lastChangePvp = getPlayerStorageValue(cid, sid.LAST_CHANGE_PVP)
    local hasPermission = getPlayerStorageValue(cid, sid.CHANGE_PVP_PERMISSION) == 1
    
    if(talkState == 1) then 	
    	if(not hasPermission and lastChangePvp ~= -1 and lastChangePvp + (darghos_change_pvp_days_cooldown * 60 * 60 * 24) > os.time()) then
    	
    		local leftDays = math.floor(((lastChangePvp + (darghos_change_pvp_days_cooldown * 60 * 60 * 24)) - os.time()) / 60 / 60 / 24)
    	
    		if(leftDays > 0) then
    			if(leftDays < darghos_change_pvp_days_cooldown - darghos_change_pvp_premdays_cooldown and isPremium(cid) and getPlayerPremiumDays(cid) >= darghos_change_pvp_premdays_cost) then
    				npcHandler:say("Voc� alterou a sua habilidade de entrar em combate a muito pouco tempo! Voc� deve aguardar por mais " .. leftDays .. " dias para uma nova mudan�a!", cid)
    				npcHandler:say("Porem se voc� estiver disposto a sacrificar " .. darghos_change_pvp_premdays_cost .. " dias de sua Conta Premium para fazer esta mudan�a procure o Rei Ordon e solicite uma {permiss�o especial}!", cid)
    			else
					npcHandler:say("Voc� alterou a sua habilidade de entrar em combate a muito pouco tempo! Voc� deve aguardar por mais " .. leftDays .. " dias para uma nova mudan�a!", cid)
				end
			else
				npcHandler:say("Em mais algumas horas voc� poder� alterar a sua habilidade de entrar em combate!", cid)
			end
			
			npcHandler:resetNpc(cid)		
			return false
		else
		
			local debuffExpMsg = nil
		
			if(lastChangePvp ~= -1) then
				debuffExpMsg = "COMO PUNI��O VOC� TAMB�M RECEBERA 50% MENOS EXPERIENCIA PELOS PROXIMOS " .. darghos_change_pvp_days_cooldown .. " DIAS!"
			end
		
			if(doPlayerIsPvpEnable(cid)) then
				npcHandler:say("Voc� ATUALMENTE est� com o seu PVP ATIVO! Ao DESATIVAR O PVP voc� N�O PODERA ATACAR OU SER ATACADO POR QUALQUER JOGADOR, exepto quando voc� estiver participando de uma guild war, arena ou battleground.", cid)
				npcHandler:say("PRESTE MUITA ATEN��O!! AO FAZER ESTA MUDAN�A VOC� N�O PODER� ATIVAR NOVAMENTE O SEU PVP DE NENHUMA FORMA PELOS PROXIMOS " .. darghos_change_pvp_days_cooldown .. " DIAS!", cid)
				
				if(debuffExpMsg ~= nil) then
					npcHandler:say(debuffExpMsg, cid)
				end
				
				npcHandler:say("VOC� TAMB�M SER� LEVADO PARA QUENDOR QUE PASSAR� A SER A SUA CIDADE!", cid)
				npcHandler:say("VOC� TEM CERTEZA QUE DESEJA DESATIVAR O SEU PVP???", cid)
			else
				npcHandler:say("Voc� ATUALMENTE est� com o seu PVP DESATIVO! Ao ATIVAR O PVP voc� PODER� ATACAR, MATAR, SER ATACADO E AT� MORTO POR OUTROS JOGADORES QUE TAMB�M ESTEJAM COM PVP ATIVO!!!", cid)
				npcHandler:say("PRESTE MUITA ATEN��O!! AO FAZER ESTA MUDAN�A VOC� N�O PODER� DESATIVAR NOVAMENTE O SEU PVP DE NENHUMA FORMA PELOS PROXIMOS " .. darghos_change_pvp_days_cooldown .. " DIAS!", cid)
				
				if(debuffExpMsg ~= nil) then
					npcHandler:say(debuffExpMsg, cid)
				end
				
				npcHandler:say("VOC� TAMB�M SER� LEVADO PARA QUENDOR QUE PASSAR� A SER A SUA CIDADE!", cid)
				npcHandler:say("VOC� TEM CERTEZA QUE DESEJA ATIVAR O SEU PVP???", cid)
			end
    	end
    elseif(talkState == 2) then
    	npcHandler:say("N�O ESTOU SEGURO QUE VOC� QUER REALMENTE ISTO!! LEMBRE-SE!! VOC� N�O PODER� MUDAR NOVAMENTE SEU PVP NOS PROXIMOS " .. darghos_change_pvp_days_cooldown .. " DIAS!!! TEM CERTEZA??? DIGITE {tenho certeza}!!", cid)
    	npcHandler:say("!!! E SUA ULTIMA CHANCE !!!", cid)
    elseif(talkState == 3) then
    	if(doPlayerIsPvpEnable(cid)) then
    		npcHandler:say("EST� FEITO!! Seu PvP agora est� DESATIVADO!! Espero que n�o se arrependa de sua decis�o...", cid)
    		doPlayerDisablePvp(cid)
    	else
    		npcHandler:say("EST� FEITO!! Seu PvP agora est� ATIVO!! Espero que n�o se arrependa de sua decis�o...", cid)
    		doPlayerEnablePvp(cid)
    	end
    	
    	setPlayerStorageValue(cid, sid.LAST_CHANGE_PVP, os.time())
    	
    	if(hasPermission) then
    		setPlayerStorageValue(cid, sid.CHANGE_PVP_PERMISSION, -1)
    	end
    	
    	if(lastChangePvp ~= -1) then
    		setPlayerStorageValue(cid, sid.CHANGE_PVP_EXP_DEBUFF, os.time() + (60 * 60 * 24 * darghos_change_pvp_days_cooldown)) 
		end
    	
    	local oldpos = getPlayerPosition(cid) 	
    	doTeleportThing(cid, getTownTemplePosition(towns.QUENDOR))
    	doPlayerSetTown(cid, towns.QUENDOR)
    	doSendMagicEffect(oldpos, CONST_ME_MAGIC_BLUE)
    	
    	setStageType(cid, SKILL__LEVEL)
    	npcHandler:resetNpc(cid)
    end
    
    return true
end

keywordHandler:addKeyword({'bless', 'ben��o', 'bencao'}, D_CustomNpcModules.offerBlessing, {npcHandler = npcHandler, onlyFocus = true, ispvp = true, baseCost = 2000, levelCost = 200, startLevel = 30, endLevel = 270})
keywordHandler:addKeyword({'job', 'trabalho', 'ajudar'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Eu ajudo os novatos que passam por aqui. Eu tamb�m sou autorizado a aben�oar com a {twist of fate}, a ben��o para o {pvp}.'})
keywordHandler:addKeyword({'permiss�o especial', 'permissao especial'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = "Ap�s uma mudan�a de PvP voc� n�o pode efetuar novas mudan�as por " .. darghos_change_pvp_days_cooldown .. " dias. Porem, quando j� tiverem se passado " .. darghos_change_pvp_premdays_cooldown .. " dias de sua �ltima mudan�a, caso voc� possua " .. darghos_change_pvp_premdays_cost .. " dias de premium ou mais em sua conta voc� poder� sacrificar-los e obter do {Rei Ordon} a permiss�o especial para trocar o seu PvP novamente mais cedo."})
keywordHandler:addKeyword({'rei ordon'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Ordon me parece um rei justo! Ele se encontra sempre em seu pal�cio real na cidade de Quendor. Com ele � possivel obter a promo��o al�m da {permiss�o especial} da mudan�a de PvP.'})
local node = keywordHandler:addKeyword({'pvp'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Foi me concedido pelos Deuses o poder de desligar ou ligar a sua habilidade de entrar em combate com outros jogadores. Voc� gostaria de fazer est� mudan�a?'})
	local node1 = node:addChildKeyword({'yes', 'sim'}, process, {npcHandler = npcHandler, onlyFocus = true, talk_state = 1})
	node:addChildKeyword({"nao", "n�o", "no"}, StdModule.say, {npcHandler = npcHandler, reset = true, onlyFocus = true, text = 'Volte se desejar fazer est� mudan�a!'})
		local node2 = node1:addChildKeyword({'yes', 'sim'}, process, {npcHandler = npcHandler, onlyFocus = true, talk_state = 2})
		node1:addChildKeyword({"nao", "n�o", "no"}, StdModule.say, {npcHandler = npcHandler, reset = true, onlyFocus = true, text = 'Volte se desejar fazer est� mudan�a!'})	
			node2:addChildKeyword({'tenho certeza'}, process, {npcHandler = npcHandler, onlyFocus = true, talk_state = 3})
			node2:addChildKeyword({"nao", "n�o", "no"}, StdModule.say, {npcHandler = npcHandler, reset = true, onlyFocus = true, text = 'Que bom que desistiu! Eu sabia que voc� n�o estava certo que realmente queria isto!!'})	
--local node1 = keywordHandler:addKeyword({'twist of fate'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Sorry, but the bless twist of fate are unavailable for now. Wait some time and back again.'})


npcHandler:addModule(FocusModule:new())
