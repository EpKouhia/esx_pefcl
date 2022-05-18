-- Export Reference - pefcl
-- AddCash = 'addCash',
-- GetCash = 'getCash',
-- RemoveCash = 'removeCash',
-- GetAccounts = 'getAccounts',
-- GetTotalBalance = 'getTotalBalance',
-- AddBankBalance = 'addBankBalance',
-- RemoveBankBalance = 'removeBankBalance',
-- WithdrawMoney = 'withdrawMoney',
-- DepositMoney = 'depositMoney',
-- CreateInvoice = 'createInvoice',
-- GetInvoices = 'getInvoices',
-- LoadPlayer = 'loadPlayer',

if GetResourceState('pefcl') ~= 'missing' then
    AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
        repeat Wait(0) until GetResourceState('pefcl') == 'started'

		exports.pefcl:loadPlayer(xPlayer.source ,{
			source = xPlayer.source,
			identifier = xPlayer.identifier,
			name = xPlayer.variables.firstName..' '..xPlayer.variables.lastName,
		})
    end)

	-- PEFCL will deal with player disconnecting (playerdropped) but if there is framework which supports relogging this could be a necessary feature
	-- More Features discussed here: https://github.com/project-error/pefcl/issues/15
    -- AddEventHandler('esx:playerLogout', function(playerId)
    --     exports['pefcl']:unloadPlayer(playerId)
    -- end)

    AddEventHandler('onServerResourceStart', function(resource)
        if resource == 'pefcl' then
            repeat Wait(500) until GetResourceState('pefcl') == 'started'
            local xPlayers = ESX.GetExtendedPlayers()
            if next(xPlayers) then
                for i=1, #xPlayers do
                    local xPlayer = xPlayers[i]

					exports.pefcl:loadPlayer(xPlayer.source ,{
						source = xPlayer.source,
						identifier = xPlayer.identifier,
						name = xPlayer.variables.firstName..' '..xPlayer.variables.lastName,
					})
                end
            end
        end
    end)
end

---@param source number
---@param label string
---@param amount number
---@param expiresAt? string
--- Sending a invoice
RegisterServerEvent("esx_pefcl:sv:CreateInvoice" , function(source, amount, label, expiresAt)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local tPlayer = ESX.GetPlayerFromId(source)

	createInvoice(xPlayer.source, xPlayer.identifier, tPlayer.identifier, amount, label, expiresAt)

	-- Would maybe do notifications with NPWD app notifications but the current notification refactor branch is not merged yet into develop
	-- https://github.com/project-error/npwd/tree/refactor/notifications
	-- https://github.com/project-error/npwd
	
	TriggerClientEvent('ox_lib:notify', xPlayer.source, {
		type = 'inform',
		description = Locale("person_invoiced")..' '..label..' '..Locale("total")..' '..tostring(amount)..Locale("currency"),
		duration = 8000
	})

	TriggerClientEvent('ox_lib:notify', tPlayer.source, {
		type = 'inform',
		description = Locale("received_invoice")..' '..label..' '..Locale("total")..' '..tostring(amount)..Locale("currency"),
		duration = 8000
	})
end)

---@param source number
---@param from string --Identifier
---@param to string --Identifier
---@param amount number
---@param message string
---@param expiresAt? string --2019-06-11
--- Sending a invoice
createInvoice = function(source, from, to, amount, message, expiresAt)
	exports.pefcl:createInvoice(source, {from = from, to = to, amount = amount, message = message, expiresAt = expiresAt})
end
exports("createInvoice", createInvoice)

---@param source number
--- Get all invoices
lib.callback.register('esx_pefcl:sv:getInvoices', function(source)
	local playerInvoices = getInvoices(source)
	return playerInvoices
end)

getInvoices = function(source)
	return exports.pefcl:getInvoices(source)
end
exports("getInvoices", getInvoices)

---@param source number
-- Returns players cash amount to pefcl
function getCash(source)
	return exports.ox_inventory:GetItem(source, 'money', false, true)
end
exports("getCash", getCash)

---@param source number
---@param amount number
-- Removes cash from the player
function removeCash(source, amount)
	exports.ox_inventory:RemoveItem(source, 'money', amount)
end
exports("removeCash", removeCash)

---@param source number
---@param amount number
-- Adds cash for the player
function addCash(source, amount)
	exports.ox_inventory:AddItem(source, 'money', amount)
end
exports("addCash", addCash)