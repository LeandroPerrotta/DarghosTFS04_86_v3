local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

local condition = createConditionObject(CONDITION_HASTE)
setConditionParam(condition, CONDITION_PARAM_TICKS, 5000)
setConditionFormula(condition, 0.9, -81, 0.9, -81)
setCombatCondition(combat, condition)

function onCastSpell(cid, var)
	
	local flagCarrying = getPlayerStorageValue(cid, sid.BATTLEGROUND_CARRYING_FLAG) == 1	
	
	if(flagCarrying) then
		doPlayerSendCancel(cid, "Voc� n�o pode usar magias que alterem a sua velocidade enquanto estiver carregando a bandeira.")
		doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
		return false
	end		
	
	return doCombat(cid, combat, var)
end