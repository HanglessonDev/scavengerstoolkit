-- STK Backpack Upgrade TimedAction
-- Ação temporizada para aplicar ou remover upgrades de mochilas

require("TimedActions/ISBaseTimedAction")

ISSTKBackpackUpgradeAction = ISBaseTimedAction:derive("ISSTKBackpackUpgradeAction")

function ISSTKBackpackUpgradeAction:isValid()
	print("[STK ACTION] isValid() chamado, retornando:", self.StartValid)
	return self.StartValid
end

function ISSTKBackpackUpgradeAction:update()
	self.item:setJobDelta(self:getJobDelta())
	for i, v in pairs(self.ExtraItems) do
		v:setJobDelta(self:getJobDelta())
	end
	self.character:setMetabolicTarget(Metabolics.UsingTools)
end

function ISSTKBackpackUpgradeAction:start()
	print("[STK ACTION] start() chamado!")
	print("[STK ACTION] item:", self.item:getType())
	print("[STK ACTION] iteminfo:", self.iteminfo)

	self.item:setJobType(self.JobType)
	self.item:setJobDelta(0.0)

	for i, v in pairs(self.ExtraItems) do
		v:setJobType(self.JobType)
		v:setJobDelta(0.0)
	end

	-- Validação inicial
	local imd = self.item:getModData()

	if instanceof(self.iteminfo, "InventoryItem") then
		-- ADICIONAR upgrade
		local UpgradesValid = imd.STK_MaxUpgrades > 0 and #imd.STK_Upgrades < imd.STK_MaxUpgrades
		local ItemsLocationValid = self.character:getInventory():contains(self.item)
			and self.character:getInventory():contains(self.iteminfo)
		local HasTools = self.character:getInventory():getFirstTypeRecurse("Needle")
			and self.character:getInventory():getFirstTypeRecurse("Thread")

		self.StartValid = UpgradesValid and ItemsLocationValid and HasTools
	else
		-- REMOVER upgrade
		local HasTool = false
		if self.character:getInventory():getFirstTypeRecurse("Scissors") then
			HasTool = true
		end

		local UpgradesValid = false
		for i, v in pairs(imd.STK_Upgrades) do
			if v == self.iteminfo then
				UpgradesValid = true
			end
		end

		local BagRemovalValid = RemoveValid(self.item, self.iteminfo)
		self.StartValid = HasTool and BagRemovalValid and UpgradesValid
	end

	self:setActionAnim(CharacterActionAnims.Craft)
end

function ISSTKBackpackUpgradeAction:stop()
	self.item:setJobDelta(0.0)
	for i, v in pairs(self.ExtraItems) do
		v:setJobDelta(0.0)
	end
	ISBaseTimedAction.stop(self)
end

function ISSTKBackpackUpgradeAction:perform()
	self.item:setJobDelta(0.0)
	for i, v in pairs(self.ExtraItems) do
		v:setJobDelta(0.0)
		if v:getType() == "Thread" then
			v:UseAndSync()
		end
	end

	self.onComplete(self.item, self.iteminfo, self.character)

	ISBaseTimedAction.perform(self)
end

function ISSTKBackpackUpgradeAction:new(character, onComplete, item, info, jobtype, extraitems)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.onComplete = onComplete
	o.item = item
	o.iteminfo = info
	o.StartValid = true
	o.JobType = jobtype
	o.ExtraItems = extraitems
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = 70

	if character:isTimedActionInstant() then
		-- o.maxTime = 1
	end
	o.forceProgressBar = true
	return o
end
