local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
D_CustomNpcModules.parseCustomParameters(keywordHandler, npcHandler)

function onCreatureAppear(cid)                          npcHandler:onCreatureAppear(cid)                        end
function onCreatureDisappear(cid)                       npcHandler:onCreatureDisappear(cid)                     end
function onCreatureSay(cid, type, msg)                  npcHandler:onCreatureSay(cid, type, msg)                end
function onThink()                                      npcHandler:onThink()                                    end
function onPlayerEndTrade(cid)                          npcHandler:onPlayerEndTrade(cid)                        end
function onPlayerCloseChannel(cid)                      npcHandler:onPlayerCloseChannel(cid)            		end

function greetCallback(cid)
	
	if(not isPremium(cid)) then
		npcHandler:say('Eu compro uma grande variedade de armas e equipamentos por um bom pre�o! Mas somente negocio com jogadores que disponham de uma Conta Premium...', cid)
		npcHandler:resetNpc(cid)
		return false		
	end
	
	if(playerHistory.hasAchievBattlegroundRankLegend(cid)) then
		npcHandler:say('Oh! Possui o nobre titulo de Lenda nos campos de batalha! O Rei Ordon ordena que sua dedica��o e lealdade seja re-compensada! Irei pagar 70% mais nos itens que voc� tem para mim!', cid)
	elseif(playerHistory.hasAchievBattlegroundRankVeteran(cid)) then
		npcHandler:say('Veterano hein? Voc� deve ter se esfor�ado muito para atingir tal posi��o! O Rei Ordon ordena que sua dedica��o seja re-compensada! Irei pagar 40% mais nos itens que voc� tem para mim!', cid)
	elseif(playerHistory.hasAchievBattlegroundRankBrave(cid)) then
		npcHandler:say('Voc� tem se dedicado muito em aperfei�oar as suas tecnicas de batalha! Por isso lhe pagarei 20% mais nos itens que voc� tem para mim!', cid)
	else
		npcHandler:say('Eu compro uma grande variedade de itens. Mas saiba que ao se dedicar a aperfei�oar as suas tecnicas de combate no {campo de batalha} eu posso lhe pagar ainda mais por estes itens!', cid)
	end
	
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

keywordHandler:addKeyword({'campo de batalha', 'battleground'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, 
		text = 'Sim... Voc� pode acessar-la digitando o comando {!bg entrar}, nela voc� ir� participar de disputadas partidas em busca de gl�rias! Conforme voc� melhorar o seu desempenho voc� conquitar� titulos. Conforme melhor for o seu titulo mais eu lhe pagarei pelos itens que voc� me vender!'})

npcHandler:addModule(FocusModule:new())