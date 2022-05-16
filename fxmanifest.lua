--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Manifest ]]--
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_*.lua',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'locale.lua',
    'locales/*.lua',
    'config.lua'
}

client_script {
	'client/cl_*.lua',
}