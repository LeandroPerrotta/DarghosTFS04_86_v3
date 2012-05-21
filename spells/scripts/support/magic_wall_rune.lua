local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
setCombatParam(combat, COMBAT_PARAM_CREATEITEM, 1497)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

function onCastSpell(cid, var)
	
	local COOLDOWN = 8
	
	if(doPlayerIsInBattleground(cid)) then
		local v = getPlayerStorageValue(cid, sid.BATTLEGROUND_LAST_MAGIC_WALL)
		local inCooldown = (v == -1 or v + COOLDOWN <= os.time()) and false or true
		if(inCooldown) then
			local cooldownLeft = os.time() - (v + COOLDOWN)
			doPlayerSendCancel(cid, "Voc� est� exausto para usar novamente esta runa, aguarde mais " .. cooldownLeft .. " segundos.")
			doSendMagicEffect(getPlayerPosition(cid), CONST_ME_POFF)
			return false
		end
		
		setPlayerStorageValue(cid, sid.BATTLEGROUND_LAST_MAGIC_WALL, os.time())
	end
	
	return doCombat(cid, combat, var)
end