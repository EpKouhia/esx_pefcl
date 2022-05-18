CreateThread(function()
    exports['qtarget']:AddTargetModel(Config.AtmModels, {
        options = {
            {
                action = function()
                    exports.pefcl:openAtm()
                end,
                icon = "fas fa-wallet",
                label = Locale("open_atm"),
            },
        },
        distance = 2.0
    })

    for k,v in pairs(Config.Bank) do
		exports["qtarget"]:AddBoxZone(k.."_bank", vector3(v.x,v.y,v.z), 2, 4, {
		name=k.."_bank",
		heading=v.w,
		debugPoly=false,
		minZ=v.z-1,
		maxZ=v.z+1,
		}, {
			options = {
				{
                    action = function()
                        exports.pefcl:openBank()
                    end,
					icon = "fas fa-piggy-bank",
					label = Locale("open_bank"),
				},
			},
			distance = 1.5
		})
	end
end)

-- Test Commands
RegisterCommand("invoice", function()
    local input = lib.inputDialog('Invoice Person', {
        { type = "input", label = "Source", icon = 'user' },
        { type = "input", label = "Amount", icon = 'euro-sign' },
        { type = "input", label = "Message", icon = 'comment-dollar' },
        --{ type = "input", label = "Expiration (optional)", icon = 'calendar' },
    })

    if input[1] and input[2] and input[3] then
        TriggerServerEvent('esx_pefcl:sv:CreateInvoice', tonumber(input[1]), tonumber(input[2]), input[3], nil)
    end
end)

RegisterCommand("getinvoices", function()
    local options = {}

    local input = lib.inputDialog('Invoice Person', {
        { type = "input", label = "Source", icon = 'user' },
    })

    local invoices = lib.callback.await('esx_pefcl:sv:getInvoices', tonumber(input[1]))

    print(ESX.DumpTable(invoices))

    if not invoices.data then
        lib.registerContext({
            id = 'esx_pefcl:getInvoices',
            title = Locale('invoices'),
            options = {
                [Locale('no_invoices')] = {}
            }
        })

        return lib.showContext('esx_pefcl:getInvoices')
    else
        for i = 1, #invoices.data do
            print(i)
            options[i] = {
                metadata = {
                    [Locale('sender')] = invoices.data[i].sender,
                    [Locale('expires')] = invoices.data[i].expiresAt,
                    [Locale('status')] = invoices.data[i].status,
                    [Locale('amount')] = invoices.data[i].amount,
                    [Locale('message')] = invoices.data[i].message,
                }
            }
        end
    
        lib.registerContext({
            id = 'esx_pefcl:getInvoices',
            title = Locale('invoices'),
            options = options
        })
    
        lib.showContext('esx_pefcl:getInvoices')
    end
end)

