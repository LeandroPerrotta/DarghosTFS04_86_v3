local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HEALING)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, FALSE)

function onGetFormulaValues(cid, level, maglevel)
	local min = ((level/5)+(maglevel*18.5))
	local max = ((level/5)+(maglevel*25.0))
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(cid, var)
	
	if(not doPlayerIsFlagCarrier(cid)) then
		setCombatParam(combat, COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
	end	
	
	return doCombat(cid, combat, var)
end
