-- Export Reference - pefcl
-- AddCash = 'addCash',
-- RemoveCash = 'removeCash',
-- AddBankBalance = 'addBankBalance',
-- RemoveBankBalance = 'removeBankBalance',
-- WithdrawMoney = 'withdrawMoney',
-- DepositMoney = 'depositMoney',
-- CreateInvoice = 'createInvoice',
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

---@param playerId number
---@param sharedAccountName string
---@param label string
---@param amount number
--- Sending a invoice
RegisterServerEvent("esx_pefcl:sv:CreateInvoice" , function(playerId, sharedAccountName, amount, label)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local xTarget = ESX.GetPlayerFromId(playerId)

	print(xTarget.source)
	print(label)
	print(amount)

	CreateInvoice(xPlayer.source, xTarget.source ,sharedAccountName, amount, label)

	TriggerClientEvent('ox_lib:notify', src, {
		type = 'inform',
		description = Locale("person_invoiced")..'  \n'..label..'  \n '..Locale("total")..tostring(amount)
	})

	TriggerClientEvent('ox_lib:notify', src, {
		type = 'inform',
		description = Locale("received_invoice")..'  \n'..label..'  \n '..Locale("total")..tostring(amount)
	})
end)

---@param target number
---@param sharedAccountName string
---@param label string
---@param amount number
--- Sending a invoice
CreateInvoice = function(source, target ,sharedAccountName, amount, label)
	exports.pefcl:createInvoice(source ,{target, amount, label})
	--TriggerEvent('pefcl:createInvoice', source, target, amount, label)
end
exports("CreateInvoice", CreateInvoice)

---@param playerId number
---@param sharedAccountName string
---@param label string
---@param amount number
--- Get a invoices
RegisterServerEvent("esx_pefcl:sv:getInvoices" , function(playerId, sharedAccountName, label, amount)

end)

-- Returns players cash amount to pefcl
function getCash(source)
	print("Trigger getCash")
	return ox_inventory:GetItem(source, 'money', false, true)
end
exports("getCash", getCash)

-- Removes cash from the player
function removeCash(source, amount)
	print("Trigger removeCash")
	ox_inventory:RemoveItem(source, 'money', amount)
end
exports("removeCash", removeCash)

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

