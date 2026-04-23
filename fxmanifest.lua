fx_version 'adamant'
game 'gta5'
lua54 'yes'


shared_scripts {
    '@vrp/lib/utils.lua',
    'lib/**',
    'config.lua',
}

server_scripts {
    'server/core.lua',
    'server/server.lua',
}  

client_scripts {
    'client/*.lua',
}   

ui_page 'web/build/index.html'

files {
	'web/build/**/*',
    'web/build/*',
}

-- Adicione as dependências
dependencies {
    'ox_target',
    'ox_lib'
}

-- Dependências opcionais por framework
-- Descomente a que você usa:

-- Para VRP:
-- dependency 'vrp'

-- Para QBCore:
-- dependency 'qb-core'

-- Para ESX:
-- dependency 'es_extended'

-- Para inventários (descomente o que você usa):
-- dependency 'ox_inventory'
-- dependency 'qs-inventory'