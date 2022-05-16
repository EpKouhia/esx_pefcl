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

local ox_inventory = exports.ox_inventory

if GetResourceState('pefcl') ~= 'missing' then
    AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
        repeat Wait(0) until GetResourceState('pefcl') == 'started'

		exports.pefcl:loadPlayer(xPlayer.source ,{
			source = xPlayer.source,
			identifier = xPlayer.identifier,
			name = xPlayer.variables.firstName..' '..xPlayer.variables.lastName,
		})
    end)

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

					print(xPlayer.source)
					print(xPlayer.identifier)
					print(xPlayer.variables.firstName..' '..xPlayer.variables.lastName)

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

	createInvoice(tPlayer.source, xPlayer.variables.firstName..' '..xPlayer.variables.lastName, tPlayer.variables.firstName..' '..tPlayer.variables.lastName, amount, label, expiresAt)

	TriggerClientEvent('ox_lib:notify', xPlayer.source, {
		type = 'inform',
		description = Locale("person_invoiced")..'  \n  '..label..'  \n   '..Locale("total")..tostring(amount)
	})

	TriggerClientEvent('ox_lib:notify', tPlayer.source, {
		type = 'inform',
		description = Locale("received_invoice")..'  \n  '..label..'  \n  '..Locale("total")..tostring(amount)
	})
end)

---@param source number
---@param from string
---@param to string
---@param amount number
---@param message string
---@param expiresAt? string
--- Sending a invoice
createInvoice = function(source, from, to, amount, message, expiresAt)
	exports.pefcl:createInvoice(source, {from = from, to = to, amount = amount, message = message, expiresAt = expiresAt})
end
exports("createInvoice", createInvoice)

---@param source number
--- Get all invoices
RegisterServerEvent("esx_pefcl:sv:getInvoices" , function(source)
	return getInvoices(source)
end)

---@param source number
--- Get all invoices
getInvoices = function(source)
	return exports.pefcl:getInvoices(source)
end
exports("getInvoices", getInvoices)

---@param source number
-- Returns players cash amount to pefcl
function getCash(source)
	print("Trigger getCash")
	return ox_inventory:GetItem(source, 'money', false, true)
end
exports("getCash", getCash)

---@param source number
---@param amount number
-- Removes cash from the player
function removeCash(source, amount)
	print("Trigger removeCash")
	ox_inventory:RemoveItem(source, 'money', amount)
end
exports("removeCash", removeCash)

---@param source number
---@param amount number
-- Adds cash for the player
function addCash(source, amount)
	print("Trigger addCash")
	ox_inventory:AddItem(source, 'money', amount)
end
exports("addCash", addCash)

--[[ -- Get Playername
function getPlayerName(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local name = xPlayer.variables.firstName..' '..xPlayer.variables.lastName
	return name
end
exports("getPlayerName", getPlayerName)

-- Get Player Identifier
function getPlayerIdentifier(source)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	return xPlayer.identifier
end
exports("getPlayerIdentifier", getPlayerIdentifier) ]]

