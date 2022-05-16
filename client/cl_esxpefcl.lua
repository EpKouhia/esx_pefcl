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
    })

    if input[1] and input[2] and input[3] then
        TriggerServerEvent('esx_pefcl:sv:CreateInvoice', tonumber(input[1]), nil , tonumber(input[2]), input[3])
    end
end)

