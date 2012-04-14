local exhaust = createConditionObject(CONDITION_EXHAUST)
setConditionParam(exhaust, CONDITION_PARAM_TICKS, 1000)
setConditionParam(exhaust, CONDITION_PARAM_SUBID, EXHAUSTED_ESPECIAL)

function onCastSpell(cid, var)

		local target = getSpellTargetCreature(var)
		if(not target) then
			error("Invalid target: " .. table.show(var))
			return false
		end
		
		local pos = getCreaturePosition(cid)
		
		if(hasCondition(cid, CONDITION_EXHAUST, EXHAUSTED_ESPECIAL)) then
                doPlayerSendCancel(cid, "Você está exausto de mais para isto.")
                doSendMagicEffect(pos, CONST_ME_POFF)		
                return false		
		end		
		
		if(not isPlayer(target)) then
                doPlayerSendCancel(cid, "Esta runa so poder ser usada em jogadores.")
                doSendMagicEffect(pos, CONST_ME_POFF)		
                return false
		end		

		if(doPlayerIsInBattleground(cid)) then
                doPlayerSendCancel(cid, "Você não pode usar esta runa dentro de uma Battleground.")
                doSendMagicEffect(pos, CONST_ME_POFF)
                return false		
		end				

		if(not hasCondition(target, CONDITION_IGNORE_DEATH_LOSS )) then
                doPlayerSendCancel(cid, "O seu alvo  não está com o efeito de uma Holy Rune.")
                doSendMagicEffect(pos, CONST_ME_POFF)
                return false
		end

        if(not doRemoveCondition(target, CONDITION_IGNORE_DEATH_LOSS) or not doAddCondition(cid, exhaust)) then
                return false
        end

		local target_pos = getCreaturePosition(target)
		sendEnvolveEffect(target, CONST_ME_MORTAREA)
        return true
end