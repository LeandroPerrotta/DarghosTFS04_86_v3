local dialog = NpcDialog:new()
local npcSys = _NpcSystem:new()
npcSys:setDialog(dialog)

local shop = NpcShop:new(dialog, NPC_TRADETYPE_HONOR)

local itemList = {

	-- utils
	{ buy = 40, subType = 25, name = "infernal bolt" }
	,{ buy = 40, subType = 25, name = "burst arrow" }
	,{ buy = 50, name = "flask of rusty remover"}
	,{ id = 10511, buy = 300, name = "sneaky stabber of eliteness"}
	,{ id = 10513, buy = 300, name = "squeezing gear of girlpower"}
	,{ id = 10515, buy = 300, name = "whacking driller of fate"}
	,{ buy = 800, subType = 50, name = "demonic essence"}
	
	-- special backpacks
	,{ buy = 500, name = "dragon backpack"}
	,{ buy = 500, name = "moon backpack"}
	,{ buy = 500, name = "heart backpack"}
	,{ buy = 750, requireRating = 500, name = "jewelled backpack"}
	
	-- powerfull potions
	,{ buy = 250, requireRating = 500, name = "bullseye potion"}
	,{ buy = 200, requireRating = 500, name = "berserk potion"}
	,{ buy = 250, requireRating = 500, name = "mastermind potion"}	
	
	-- special rings
	,{ id = 12676, buy = 3200, requireRating = 750}
	,{ id = 12677, buy = 3200, requireRating = 750}
	,{ id = 12678, buy = 3200, requireRating = 750}
	,{ id = 12682, buy = 3000, requireRating = 750}
	,{ id = 12684, buy = 3400, requireRating = 750}
	,{ id = 12686, buy = 3200, requireRating = 750}
	,{ id = 12688, buy = 3400, requireRating = 750}
	
	-- outfit & addons items
	,{ buy = 6250, requireRating = 1200, name = "elane's crossbow"}
	,{ buy = 6250, requireRating = 1200, name = "huge chunk of crude iron"}
	,{ buy = 6250, requireRating = 1200, name = "soul stone"}
	,{ buy = 6250, requireRating = 1200, name = "nose ring"}
	,{ buy = 6250, subType = 100, requireRating = 1200, name = "turtle shell"}
	,{ buy = 6250, requireRating = 1200, name = "mandrake"}
	,{ buy = 6250, requireRating = 1200, name = "mermaid comb"}
	--,{ id = 12691, buy = 7500, setActionId = 22, requireRating = 1600, name = "warmaster outfit ticket"}
	--,{ id = 12691, buy = 7500, setActionId = 21, requireRating = 1600, name = "yalaharian outfit ticket"}
	--,{ id = 12691, buy = 7500, setActionId = 23, requireRating = 1600, name = "wayfarer outfit ticket"}
}

shop:addNegotiableListItems(itemList)

function onCreatureSay(cid, type, msg)
	msg = string.lower(msg)
	local distance = getDistanceTo(cid) or -1
	if((distance < npcSys:getTalkRadius()) and (distance ~= -1)) then
		if((msg == "hi" or msg == "hello" or msg == "ola") and not (npcSys:isFocused(cid))) then
			dialog:say("Ol� bravo " .. getCreatureName(cid) .."! Eu {troco} uma s�rie de poderosos itens por pontos de honra, que voc� pode conquistar participando de Battlegrounds.", cid)
			npcSys:addFocus(cid)
		elseif(npcSys:isFocused(cid) and (msg == "trade" or msg == "troco" or msg == "trocar")) then
			dialog:say("Otimo, aqui est�, sinta-se a vontade...", cid)					
			shop:onPlayerRequestTrade(cid)
			npcSys:setTopic(cid, 2)
		elseif(npcSys:isFocused(cid) and isInArray({"sim", "yes"}, msg) and npcSys:getTopic(cid) == 2) then
			shop:onPlayerConfirmBuy(cid)
		elseif(npcSys:isFocused(cid) and isInArray({"n�o", "nao", "no"}, msg)) then
			shop:onPlayerDeclineBuy(cid)
		elseif((npcSys:isFocused(cid)) and (msg == "bye" or msg == "goodbye" or msg == "cya" or msg == "adeus")) then
			dialog:say("At� mais!", cid)
			npcSys:removeFocus(cid)		
		end
	end
end

function onCreatureDisappear(cid) npcSys:onCreatureDisappear(cid) end
function onPlayerCloseChannel(cid) npcSys:onPlayerCloseChannel(cid) end
function onThink() npcSys:onThink() end