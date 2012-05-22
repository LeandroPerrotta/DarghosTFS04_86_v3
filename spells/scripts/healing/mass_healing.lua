local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_HEALING)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, FALSE)

function onGetFormulaValues(cid, level, maglevel)
	local min, max = getMinMaxClassicFormula(level, maglevel, 10.5, 14.2)
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local area = createCombatArea(AREA_CIRCLE3X3)
setCombatArea(combat, area)

function onCastSpell(cid, var)
	
	if(not doPlayerIsInBattleground(cid)) then
		setCombatParam(combat, COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
	end	
	
	return doCombat(cid, combat, var)
end
