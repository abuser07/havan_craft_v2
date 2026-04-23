Config = {}

-- ============================================================================
-- CONFIGURAÇÃO DO FRAMEWORK E INVENTÁRIO
-- ============================================================================

-- Framework options: 'vrp', 'qbcore', 'esx'
Config.Framework = 'vrp'  -- Mude para 'qbcore' ou 'esx' conforme seu servidor

-- Inventory options: 'vrp', 'ox_inventory', 'qs_inventory', 'custom'
Config.Inventory = 'vrp'  -- Mude conforme seu sistema de inventário

-- Custom inventory functions (se Config.Inventory = 'custom')
-- Você precisa implementar essas funções de acordo com seu inventário customizado
Config.CustomInventory = {
    getItemAmount = function(source, itemName)
        -- Retorna a quantidade do item no inventário do jogador
        return 0
    end,
    removeItem = function(source, itemName, amount)
        -- Remove itens do inventário, retorna true se conseguiu
        return true
    end,
    addItem = function(source, itemName, amount)
        -- Adiciona itens ao inventário, retorna true se conseguiu
        return true
    end,
    getWeight = function(source)
        -- Retorna peso atual do inventário
        return 0
    end,
    getMaxWeight = function(source)
        -- Retorna peso máximo do inventário
        return 0
    end,
    getItemWeight = function(itemName)
        -- Retorna o peso do item
        return 0
    end
}

-- ============================================================================
-- CONFIGURAÇÃO DE PERMISSÕES POR FRAMEWORK
-- ============================================================================

-- Mapeamento de permissões para cada framework
Config.Permissions = {
    ['vrp'] = {
        policePermission = "policia.permision",
        adminPermission = "admin.permissao",
        -- Permissões das bancadas
        japones = "japones.permissao",
        armas = "armas.permissao",
        municao = "municao.permissao",
        desmanche = "desmanche.permissao",
        mecanica = "mecanica.permissao",
        drogas = "drogas.permissao",
        lavagem = "lavagem.permissao",
    },
    ['qbcore'] = {
        policePermission = "police",
        adminPermission = "admin",
        -- Permissões das bancadas (groups ou jobs)
        japones = "japones",
        armas = "armas",
        municao = "municao",
        desmanche = "desmanche",
        mecanica = "mecanica",
        drogas = "drogas",
        lavagem = "lavagem",
    },
    ['esx'] = {
        policePermission = "police",
        adminPermission = "admin",
        -- Permissões das bancadas (jobs ou groups)
        japones = "japones",
        armas = "armas",
        municao = "municao",
        desmanche = "desmanche",
        mecanica = "mecanica",
        drogas = "drogas",
        lavagem = "lavagem",
    }
}

-- ============================================================================
-- MOEDA SUCJA POR FRAMEWORK
-- ============================================================================

Config.DirtyMoneyByFramework = {
    ['vrp'] = 'dinheirosujo',
    ['qbcore'] = 'dirtymoney',  -- ou 'black_money' dependendo do seu QBCore
    ['esx'] = 'black_money',
}

Config.dirtymoney = Config.DirtyMoneyByFramework[Config.Framework] or 'dinheirosujo'

-- ============================================================================
-- CONFIGURAÇÕES GERAIS
-- ============================================================================

Config.images = 'https://orbitrp.top/itens/'
Config.storeLink = 'https://orbitrp.top/'

-- ============================================================================
-- TABELAS DE CRAFT
-- ============================================================================

Config.Tables = {

    -- =========================================================================
    -- BURGUERSHOT (Restaurante de Hambúrguer)
    -- Localização: -1202.12, -895.95, 13.88
    -- =========================================================================
    ['BurguerShot'] = {
        craft = {
            -- Ingredientes Base
            {
                item = 'farinha-trigo',
                amount = 2,
                itemTime = 5,
                requires = {
                    { item = "trigo", amount = 1 }
                }
            },
            
            -- Carnes
            {
                item = 'hamburguer',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "musculo-cru", amount = 1 },
                    { item = "maminha-cru", amount = 1 },
                    { item = "picanha-cru", amount = 1 },
                    { item = "cupim-cru", amount = 1 },
                    { item = "costela-cru", amount = 1 }
                }
            },
            {
                item = 'pao-hamburguer',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "farinha-trigo", amount = 2 }
                }
            },
            
            -- Sanduíches
            {
                item = 'xburger',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "hamburguer", amount = 1 },
                    { item = "pao-hamburguer", amount = 1 },
                    { item = "queijo", amount = 1 },
                    { item = "manteiga", amount = 1 }
                }
            },
            {
                item = 'xsalada',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "hamburguer", amount = 1 },
                    { item = "pao-hamburguer", amount = 1 },
                    { item = "tomate", amount = 1 },
                    { item = "alface", amount = 1 },
                    { item = "queijo", amount = 1 },
                    { item = "manteiga", amount = 1 }
                }
            },
            {
                item = 'xtudo',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "hamburguer", amount = 1 },
                    { item = "pao-hamburguer", amount = 1 },
                    { item = "tomate", amount = 1 },
                    { item = "alface", amount = 1 },
                    { item = "camarao", amount = 1 },
                    { item = "queijo", amount = 1 },
                    { item = "manteiga", amount = 1 }
                }
            },
            
            -- Acompanhamentos
            {
                item = 'espetinho-camarao',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "camarao", amount = 2 }
                }
            },
            {
                item = 'caviar',
                amount = 2,
                itemTime = 10,
                requires = {
                    { item = "sardinha", amount = 2 }
                }
            },
            {
                item = 'milho',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "espiga-milho", amount = 2 }
                }
            },
            
            -- Bebidas Quentes
            {
                item = 'cha-camomila',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "camomila", amount = 1 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'cafe',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "graos-cafe", amount = 1 },
                    { item = "agua", amount = 1 }
                }
            },
            
            -- Bebidas Energéticas
            {
                item = 'energetico',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "graos-guarana", amount = 1 },
                    { item = "agua", amount = 1 }
                }
            },
            
            -- Sucos
            {
                item = 'suco-morango',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "morango", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-banana',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "banana", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-abacaxi',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "abacaxi", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-caju',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "caju", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-maracuja',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "maracuja", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-uva',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "uva", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-pessego',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "pessego", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            },
            {
                item = 'suco-kiwi',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "kiwi", amount = 2 },
                    { item = "agua", amount = 1 }
                }
            }
        },
        farm = { list = {} },
        delivery = { list = {} },
        locations = {
            {
                name = 'BurguerShot',
                coords = vec3(-1202.123047, -895.951660, 13.879150),
                requireStorage = { active = true, name = 'BurguerShot' },
                tablePermission = nil,
                craftPermission = nil,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~g~[E]~w~ para acessar o ~g~BurguerShot~w~')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 210, 105, 30, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Japones'] = {
        craft = {
            -- Sushis Simples
            {
                item = 'sushi-salmão',
                amount = 5,
                itemTime = 8,
                requires = {
                    { item = "salmão", amount = 3 },
                    { item = "arroz", amount = 5 },
                    { item = "alga", amount = 2 },
                    { item = "wasabi", amount = 1 }
                }
            },
            {
                item = 'sushi-camarao',
                amount = 5,
                itemTime = 8,
                requires = {
                    { item = "camarao", amount = 3 },
                    { item = "arroz", amount = 5 },
                    { item = "alga", amount = 2 },
                    { item = "wasabi", amount = 1 }
                }
            },
            
            -- Uramakis
            {
                item = 'uramaki-salmão',
                amount = 4,
                itemTime = 10,
                requires = {
                    { item = "salmão", amount = 2 },
                    { item = "arroz", amount = 6 },
                    { item = "alga", amount = 3 },
                    { item = "cream-cheese", amount = 2 },
                    { item = "gengibre", amount = 1 }
                }
            },
            {
                item = 'uramaki-camarao',
                amount = 4,
                itemTime = 10,
                requires = {
                    { item = "camarao", amount = 2 },
                    { item = "arroz", amount = 6 },
                    { item = "alga", amount = 3 },
                    { item = "cream-cheese", amount = 2 },
                    { item = "massa-tempura", amount = 1 }
                }
            },
            {
                item = 'uramaki-vegetariano',
                amount = 4,
                itemTime = 8,
                requires = {
                    { item = "arroz", amount = 6 },
                    { item = "alga", amount = 3 },
                    { item = "pepino", amount = 2 },
                    { item = "abacate", amount = 2 }
                }
            },
            
            -- Hot Rolls
            {
                item = 'hotroll-salmão',
                amount = 4,
                itemTime = 12,
                requires = {
                    { item = "salmão", amount = 3 },
                    { item = "arroz", amount = 6 },
                    { item = "alga", amount = 3 },
                    { item = "massa-tempura", amount = 2 },
                    { item = "oleo-gergelim", amount = 1 }
                }
            },
            {
                item = 'hotroll-camarao',
                amount = 4,
                itemTime = 12,
                requires = {
                    { item = "camarao", amount = 3 },
                    { item = "arroz", amount = 6 },
                    { item = "alga", amount = 3 },
                    { item = "massa-tempura", amount = 2 },
                    { item = "oleo-gergelim", amount = 1 }
                }
            },
            
            -- Temakis
            {
                item = 'temaki-salmão',
                amount = 3,
                itemTime = 10,
                requires = {
                    { item = "salmão", amount = 4 },
                    { item = "arroz", amount = 4 },
                    { item = "alga", amount = 4 },
                    { item = "abacate", amount = 1 }
                }
            },
            {
                item = 'temaki-camarao',
                amount = 3,
                itemTime = 10,
                requires = {
                    { item = "camarao", amount = 4 },
                    { item = "arroz", amount = 4 },
                    { item = "alga", amount = 4 },
                    { item = "cream-cheese", amount = 1 }
                }
            },
            
            -- Sashimi (Prato Nobre)
            {
                item = 'sashimi-salmao',
                amount = 3,
                itemTime = 6,
                requires = {
                    { item = "salmão", amount = 5 },
                    { item = "gengibre", amount = 2 },
                    { item = "wasabi", amount = 2 }
                }
            },
            
            -- Combo Especial
            {
                item = 'combo-japones',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "sushi-salmão", amount = 2 },
                    { item = "uramaki-salmão", amount = 2 },
                    { item = "temaki-salmão", amount = 1 },
                    { item = "sashimi-salmao", amount = 1 }
                }
            },
            
            -- Bebidas
            {
                item = 'cha-verde',
                amount = 5,
                itemTime = 5,
                requires = {
                    { item = "agua", amount = 5 },
                    { item = "acucar", amount = 2 }
                }
            },
            {
                item = 'sake',
                amount = 3,
                itemTime = 8,
                requires = {
                    { item = "arroz", amount = 10 },
                    { item = "acucar", amount = 5 },
                    { item = "agua", amount = 5 }
                }
            }
        },
        farm = { list = {} },
        delivery = { list = {} },
        locations = {
            {
                name = 'Japones',
                coords = vec3(-1842.751587, -1186.259399, 14.317261),
                requireStorage = { active = true, name = 'Japones' },
                tablePermission = Config.Permissions[Config.Framework].japones,
                craftPermission = Config.Permissions[Config.Framework].japones,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar o Restaurante Japonês')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 165, 0, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Ferramentas'] = {
        craft = {
            {
                item = 'pneu',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "borracha", amount = 15 },
                    { item = "ferro", amount = 5 }
                }
            },
            {
                item = 'weapon_wrench',
                amount = 1,
                itemTime = 8,
                requires = {
                    { item = "ferro", amount = 10 },
                    { item = "aluminio", amount = 5 }
                }
            },
            {
                item = 'weapon_crowbar',
                amount = 1,
                itemTime = 8,
                requires = {
                    { item = "ferro", amount = 12 },
                    { item = "aco", amount = 3 }
                }
            },
            {
                item = 'rastreador',
                amount = 1,
                itemTime = 12,
                requires = {
                    { item = "plastico", amount = 8 },
                    { item = "cobre", amount = 10 }
                }
            }
        },
        farm = { list = {} },
        delivery = { list = {} },
        locations = {
            {
                name = 'Ferramentas',
                coords = vec3(548.821960, -188.716476, 54.470337),
                requireStorage = { active = true, name = 'Ferramentas' },
                tablePermission = nil,
                craftPermission = nil,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~g~[E]~w~ para acessar a bancada de ~g~Ferramentas~w~')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 76, 175, 80, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Equipamentos'] = {
        craft = {
            {
                item = 'mochila',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "tecido", amount = 20 },
                    { item = "couro", amount = 10 }
                }
            },
            {
                item = 'colete-ilegal',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "tecido", amount = 12 },
                    { item = "ferro", amount = 15 }
                }
            },
            {
                item = 'capuz',
                amount = 1,
                itemTime = 8,
                requires = {
                    { item = "tecido", amount = 6 }
                }
            },
            {
                item = 'tecido',
                amount = 6,
                itemTime = 8,
                requires = {
                    { item = "couro", amount = 3 }
                }
            }
        },
        farm = { list = {} },
        delivery = { list = {} },
        locations = {
            {
                name = 'Equipamentos',
                coords = vec3(-3341.775879, 1159.833008, 5.252075),
                requireStorage = { active = true, name = 'Equipamentos' },
                tablePermission = nil,
                craftPermission = nil,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~g~[E]~w~ para acessar a bancada de ~g~Equipamentos~w~')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 76, 175, 80, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Armas'] = {
        craft = {
            {
                item = 'weapon_snspistol_mk2',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "pecadearma", amount = 20 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 6 },
                    { item = "metal", amount = 6 }
                }
            },
            {
                item = 'weapon_pistol_mk2',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "pecadearma", amount = 30 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 10 },
                    { item = "metal", amount = 10 }
                }
            },
            {
                item = 'weapon_machinepistol',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "pecadearma", amount = 150 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 20 },
                    { item = "metal", amount = 20 }
                }
            },
            {
                item = 'weapon_smg',
                amount = 1,
                itemTime = 30,
                requires = {
                    { item = "pecadearma", amount = 150 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 15 },
                    { item = "metal", amount = 15 }
                }
            },
            {
                item = 'weapon_assaultrifle',
                amount = 1,
                itemTime = 35,
                requires = {
                    { item = "pecadearma", amount = 150 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 15 },
                    { item = "metal", amount = 15 }
                }
            },
            {
                item = 'weapon_assaultrifle_mk2',
                amount = 1,
                itemTime = 40,
                requires = {
                    { item = "pecadearma", amount = 200 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 20 },
                    { item = "metal", amount = 20 }
                }
            },
            {
                item = 'weapon_specialcarbine_mk2',
                amount = 1,
                itemTime = 45,
                requires = {
                    { item = "pecadearma", amount = 200 },
                    { item = "gatilho", amount = 1 },
                    { item = "mola", amount = 20 },
                    { item = "metal", amount = 20 }
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = false, percentualPolice = 30 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'mola', minAmount = 20, maxAmount = 35 },
                        { item = 'metal', minAmount = 20, maxAmount = 35 },
                        { item = 'gatilho', minAmount = 20, maxAmount = 35 },
                    }
                },
                {
                    dangerRoute = { status = false, percentualPolice = 3 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'pecadearma', minAmount = 50, maxAmount = 60 }
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'Canada',
                coords = vec3(5000.492188, -5165.736328, 2.758301),
                requireStorage = { active = true, name = 'Canada' },
                tablePermission = Config.Permissions[Config.Framework].armas,
                craftPermission = Config.Permissions[Config.Framework].armas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Bratva',
                coords = vec3(4909.925293, -5834.584473, 28.201416),
                requireStorage = { active = true, name = 'Bratva' },
                tablePermission = Config.Permissions[Config.Framework].armas,
                craftPermission = Config.Permissions[Config.Framework].armas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Milicia',
                coords = vec3(977.907715, -100.918678, 74.841797),
                requireStorage = { active = true, name = 'Milicia' },
                tablePermission = Config.Permissions[Config.Framework].armas,
                craftPermission = Config.Permissions[Config.Framework].armas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Municao'] = {
        craft = {
            {
                item = 'ammo_9mm',
                amount = 50,
                itemTime = 15,
                requires = {
                    { item = "capsulas", amount = 40 },
                    { item = "polvora", amount = 40 }
                }
            },
            {
                item = 'ammo_5mm',
                amount = 50,
                itemTime = 20,
                requires = {
                    { item = "capsulas", amount = 50 },
                    { item = "polvora", amount = 50 }
                }
            },
            {
                item = 'ammo_762mm',
                amount = 50,
                itemTime = 15,
                requires = {
                    { item = "capsulas", amount = 60 },
                    { item = "polvora", amount = 60 }
                }
            },
            {
                item = 'ammo_12cbc',
                amount = 50,
                itemTime = 15,
                requires = {
                    { item = "capsulas", amount = 70 },
                    { item = "polvora", amount = 70 }
                }
            },
            {
                item = 'ammo_308cbc',
                amount = 50,
                itemTime = 15,
                requires = {
                    { item = "capsulas", amount = 80 },
                    { item = "polvora", amount = 80 }
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = false, percentualPolice = 3 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'capsulas', minAmount = 20, maxAmount = 35 },
                        { item = 'polvora', minAmount = 20, maxAmount = 35 }
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'MotoClub',
                coords = vec3(5141.433105, -4962.105469, 14.283569),
                requireStorage = { active = true, name = 'MotoClub' },
                tablePermission = Config.Permissions[Config.Framework].municao,
                craftPermission = Config.Permissions[Config.Framework].municao,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Crips',
                coords = vec3(5135.512207, -4613.578125, 2.438110),
                requireStorage = { active = true, name = 'Crips' },
                tablePermission = Config.Permissions[Config.Framework].municao,
                craftPermission = Config.Permissions[Config.Framework].municao,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Tuquia',
                coords = vec3(-1585.859375, 773.973633, 189.184570),
                requireStorage = { active = true, name = 'Turquia' },
                tablePermission = Config.Permissions[Config.Framework].municao,
                craftPermission = Config.Permissions[Config.Framework].municao,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Desmanche'] = {
        craft = {
            {
                item = 'lockpick',
                amount = 1,
                itemTime = 10,
                requires = {
                    { item = "ferro", amount = 50 },
                    { item = "aluminio", amount = 25 }
                }
            },
            {
                item = 'colete',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "m-malha", amount = 45 },
                    { item = "ferro", amount = 30 }
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = true, percentualPolice = 3 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'ferro', minAmount = 20, maxAmount = 35 },
                        { item = 'm-malha', minAmount = 20, maxAmount = 35 },
                        { item = 'aluminio', minAmount = 20, maxAmount = 35 },
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'Hells',
                coords = vec3(1037.8, -2518.47, 28.3),
                requireStorage = { active = true, name = 'Hells' },
                tablePermission = Config.Permissions[Config.Framework].desmanche,
                craftPermission = Config.Permissions[Config.Framework].desmanche,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'thelost',
                coords = vec3(904.31, 3575.19, 33.44),
                requireStorage = { active = true, name = 'thelost' },
                tablePermission = Config.Permissions[Config.Framework].desmanche,
                craftPermission = Config.Permissions[Config.Framework].desmanche,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Brasil',
                coords = vec3(659.44, 2428.3, 64.95),
                requireStorage = { active = true, name = 'Brasil' },
                tablePermission = Config.Permissions[Config.Framework].desmanche,
                craftPermission = Config.Permissions[Config.Framework].desmanche,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'b13',
                coords = vec3(472.02, -1310.5, 29.23),
                requireStorage = { active = true, name = 'b13' },
                tablePermission = Config.Permissions[Config.Framework].desmanche,
                craftPermission = Config.Permissions[Config.Framework].desmanche,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['MECANICA'] = {
        craft = {
            {
                item = 'kit-reparo',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "plastico", amount = 15 },
                    { item = "cobre", amount = 15 }
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = true, percentualPolice = 3 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'plastico', minAmount = 20, maxAmount = 35 },
                        { item = 'cobre', minAmount = 20, maxAmount = 35 }
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'StreetRacing',
                coords = vec3(842.452759, -985.978027, 26.482788),
                requireStorage = { active = true, name = 'StreetRacing' },
                tablePermission = Config.Permissions[Config.Framework].mecanica,
                craftPermission = Config.Permissions[Config.Framework].mecanica,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    },

    ['Drogas'] = {
        craft = {
            {
                item = 'placa',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "ferro", amount = 50 },
                    { item = "aluminio", amount = 35 }
                }
            },
            {
                item = 'c4',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "cobre", amount = 30 },
                    { item = "polvora", amount = 35 },
                    { item = "aluminio", amount = 40 }
                }
            },
            {
                item = 'maconha',
                amount = 1,
                itemTime = 15,
                requires = {
                    { item = "folhamaconha", amount = 5 },
                    { item = "plastico", amount = 5 }
                }
            },
            {
                item = 'pendrive',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "plastico", amount = 25 },
                    { item = "cobre", amount = 30 }
                }
            },
            {
                item = 'keycard',
                amount = 1,
                itemTime = 20,
                requires = {
                    { item = "plastico", amount = 25 }
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = true, percentualPolice = 3 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'ferro', minAmount = 20, maxAmount = 35 },
                        { item = 'cobre', minAmount = 20, maxAmount = 35 },
                        { item = 'aluminio', minAmount = 20, maxAmount = 35 },
                        { item = 'folhamaconha', minAmount = 20, maxAmount = 35 },
                    }
                },
                {
                    dangerRoute = { status = false, percentualPolice = 30 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'polvora', minAmount = 10, maxAmount = 15 },
                        { item = 'plastico', minAmount = 10, maxAmount = 15 },
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'Cv',
                coords = vec3(491.53, -1525.46, 29.28),
                requireStorage = { active = true, name = 'Cv' },
                tablePermission = Config.Permissions[Config.Framework].drogas,
                craftPermission = Config.Permissions[Config.Framework].drogas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Vagos',
                coords = vec3(324.94, -2039.45, 20.89),
                requireStorage = { active = true, name = 'Vagos' },
                tablePermission = Config.Permissions[Config.Framework].drogas,
                craftPermission = Config.Permissions[Config.Framework].drogas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'portugal',
                coords = vec3(-2679.33, 1326.91, 144.26),
                requireStorage = { active = true, name = 'portugal' },
                tablePermission = Config.Permissions[Config.Framework].drogas,
                craftPermission = Config.Permissions[Config.Framework].drogas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                    end
                end
            },
            {
                name = 'aztecas',
                coords = vec3(-2279.88, -284.81, 54.39),
                requireStorage = { active = true, name = 'aztecas' },
                tablePermission = Config.Permissions[Config.Framework].drogas,
                craftPermission = Config.Permissions[Config.Framework].drogas,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                    end
                end
            }
        }
    },

    -- =========================================================================
    -- LAVAGEM (Bancada de Lavagem de Dinheiro)
    -- Permissão: lavagem.permissao
    -- =========================================================================
    ['Lavagem'] = {
        craft = {
            {
                item = 'dinheiro',
                amount = 80000,
                itemTime = 15,
                requires = {
                    { item = Config.dirtymoney, amount = 100000 },
                    { item = "l-alvejante", amount = 25 }
                }
            },
            {
                item = 'dinheiro',
                amount = 180000,
                itemTime = 15,
                requires = {
                    { item = Config.dirtymoney, amount = 200000 },
                    { item = "l-alvejante", amount = 25 }
                }
            },
            {
                item = 'dinheiro',
                amount = 280000,
                itemTime = 20,
                requires = {
                    { item = Config.dirtymoney, amount = 300000 },
                    { item = "l-alvejante", amount = 40 }
                }
            },
            {
                item = 'dinheiro',
                amount = 800000,
                itemTime = 30,
                requires = {
                    { item = Config.dirtymoney, amount = 1000000 },
                    { item = "l-alvejante", amount = 60 }
                }
            },
            {
                item = 'capuz',
                amount = 1,
                itemTime = 25,
                requires = {
                    { item = "pacote_tecido", amount = 40 },
                }
            },
            {
                item = 'algemas',
                amount = 1,
                itemTime = 25,
                requires = {
                    { item = "c-ferro", amount = 40 },
                    { item = "m-aco", amount = 40 }
                }
            },
            {
                item = 'corda',
                amount = 1,
                itemTime = 25,
                requires = {
                    { item = "pacote_tecido", amount = 40 },
                }
            }
        },
        farm = {
            list = {
                {
                    dangerRoute = { status = false, percentualPolice = 30 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'l-alvejante', minAmount = 20, maxAmount = 35 }
                    }
                },
                {
                    dangerRoute = { status = false, percentualPolice = 30 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'c-ferro', minAmount = 8, maxAmount = 15 },
                        { item = 'm-aco', minAmount = 8, maxAmount = 15 }
                    }
                },
                {
                    dangerRoute = { status = false, percentualPolice = 30 },
                    dominationBonus = { status = true, zone = false, bonus = 2 },
                    itensList = {
                        { item = 'pacote_tecido', minAmount = 3, maxAmount = 6 }
                    }
                }
            }
        },
        delivery = { list = {} },
        locations = {
            {
                name = 'Vanilla',
                coords = vec3(94.5, -1294.08, 29.27),
                requireStorage = { active = true, name = 'Vanilla' },
                tablePermission = Config.Permissions[Config.Framework].lavagem,
                craftPermission = Config.Permissions[Config.Framework].lavagem,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'camoradois',
                coords = vec3(-101.16, 823.25, 227.89),
                requireStorage = { active = true, name = 'camoradois' },
                tablePermission = Config.Permissions[Config.Framework].lavagem,
                craftPermission = Config.Permissions[Config.Framework].lavagem,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'camora',
                coords = vec3(1398.05, 1148.6, 108.15),
                requireStorage = { active = true, name = 'camora' },
                tablePermission = Config.Permissions[Config.Framework].lavagem,
                craftPermission = Config.Permissions[Config.Framework].lavagem,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Tequila',
                coords = vec3(-571.71, 288.94, 79.18),
                requireStorage = { active = true, name = 'Tequila' },
                tablePermission = Config.Permissions[Config.Framework].lavagem,
                craftPermission = Config.Permissions[Config.Framework].lavagem,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            },
            {
                name = 'Iluminatis',
                coords = vec3(977.18, 2085.13, 58.33),
                requireStorage = { active = true, name = 'Iluminatis' },
                tablePermission = Config.Permissions[Config.Framework].lavagem,
                craftPermission = Config.Permissions[Config.Framework].lavagem,
                drawMarker = function(coords, dist)
                    if dist <= 5.0 then
                        DrawText3Ds(coords.x, coords.y, coords.z + 0.1, 'Pressione ~p~[E]~w~ para acessar a bancada.')
                        DrawMarker(27, coords.x, coords.y, coords.z - 0.95, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 132, 102, 226, 180, 0, 0, 0, 1)
                    end
                end
            }
        }
    }
},

-- ============================================================================
-- STORAGES
-- ============================================================================

Config.Storages = {
    -- Storage para o Restaurante Japonês
    ['Japones'] = { 
        itens = { 
            ['salmão'] = 9999999,
            ['camarao'] = 9999999,
            ['tilapia'] = 9999999,
            ['robalo'] = 9999999,
            ['arroz'] = 9999999,
            ['alga'] = 9999999,
            ['gengibre'] = 9999999,
            ['wasabi'] = 9999999,
            ['molho-shoyu'] = 9999999,
            ['vinagre'] = 9999999,
            ['acucar'] = 9999999,
            ['sal'] = 9999999,
            ['oleo-gergelim'] = 9999999,
            ['cream-cheese'] = 9999999,
            ['pepino'] = 9999999,
            ['abacate'] = 9999999,
            ['ovo'] = 9999999,
            ['massa-tempura'] = 9999999,
            ['agua'] = 9999999
        } 
    },

    -- Storage para o BurguerShot
    ['BurguerShot'] = { 
        itens = { 
            ['musculo-cru'] = 9999999,
            ['maminha-cru'] = 9999999,
            ['picanha-cru'] = 9999999,
            ['cupim-cru'] = 9999999,
            ['costela-cru'] = 9999999,
            ['camarao'] = 9999999,
            ['sardinha'] = 9999999,
            ['trigo'] = 9999999,
            ['farinha-trigo'] = 9999999,
            ['queijo'] = 9999999,
            ['manteiga'] = 9999999,
            ['tomate'] = 9999999,
            ['alface'] = 9999999,
            ['espiga-milho'] = 9999999,
            ['camomila'] = 9999999,
            ['graos-cafe'] = 9999999,
            ['graos-guarana'] = 9999999,
            ['agua'] = 9999999,
            ['morango'] = 9999999,
            ['banana'] = 9999999,
            ['abacaxi'] = 9999999,
            ['caju'] = 9999999,
            ['maracuja'] = 9999999,
            ['uva'] = 9999999,
            ['pessego'] = 9999999,
            ['kiwi'] = 9999999,
            ['hamburguer'] = 9999999,
            ['pao-hamburguer'] = 9999999,
            ['xburger'] = 9999999,
            ['xsalada'] = 9999999,
            ['xtudo'] = 9999999,
            ['espetinho-camarao'] = 9999999,
            ['caviar'] = 9999999,
            ['milho'] = 9999999,
            ['cha-camomila'] = 9999999,
            ['energetico'] = 9999999,
            ['cafe'] = 9999999
        } 
    },

    -- ARMAS
    ['Grota'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['Ballas'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['Bratva'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['Milicia'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['Croacia'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['Canada'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },
    ['argentina'] = { itens = { ['pecadearma'] = 9999999, ['gatilho'] = 9999999, ['mola'] = 9999999, ['metal'] = 9999999 } },

    -- DROGAS
    ['Cv'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['cobre'] = 9999999, ['polvora'] = 9999999, ['plastico'] = 9999999, ['folhamaconha'] = 9999999 } },
    ['Vagos'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['cobre'] = 9999999, ['polvora'] = 9999999, ['plastico'] = 9999999, ['folhamaconha'] = 9999999 } },
    ['portugal'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['cobre'] = 9999999, ['polvora'] = 9999999, ['plastico'] = 9999999, ['folhamaconha'] = 9999999 } },
    ['aztecas'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['cobre'] = 9999999, ['polvora'] = 9999999, ['plastico'] = 9999999, ['folhamaconha'] = 9999999 } },

    -- MUNIÇÃO
    ['Mafia'] = { itens = { ['capsulas'] = 9999999, ['polvora'] = 9999999 } },
    ['Turquia'] = { itens = { ['capsulas'] = 9999999, ['polvora'] = 9999999 } },
    ['MotoClub'] = { itens = { ['capsulas'] = 9999999, ['polvora'] = 9999999 } },
    ['Crips'] = { itens = { ['capsulas'] = 9999999, ['polvora'] = 9999999 } },
    ['croacia'] = { itens = { ['capsulas'] = 9999999, ['polvora'] = 9999999 } },

    -- LAVAGEM
    ['Iluminatis'] = { itens = { [Config.dirtymoney] = 9999999, ['l-alvejante'] = 9999999, ['pacote_tecido'] = 9999999, ['c-ferro'] = 9999999, ['m-aco'] = 9999999 } },
    ['Vanilla'] = { itens = { [Config.dirtymoney] = 9999999, ['l-alvejante'] = 9999999, ['pacote_tecido'] = 9999999, ['c-ferro'] = 9999999, ['m-aco'] = 9999999 } },
    ['camora'] = { itens = { [Config.dirtymoney] = 9999999, ['l-alvejante'] = 99999999, ['pacote_tecido'] = 9999999, ['c-ferro'] = 9999999, ['m-aco'] = 9999999 } },
    ['camoradois'] = { itens = { [Config.dirtymoney] = 9999999, ['l-alvejante'] = 999999, ['pacote_tecido'] = 9999999, ['c-ferro'] = 9999999, ['m-aco'] = 9999999 } },
    ['Tequila'] = { itens = { [Config.dirtymoney] = 9999999, ['l-alvejante'] = 999999, ['pacote_tecido'] = 9999999, ['c-ferro'] = 9999999, ['m-aco'] = 9999999 } },

    -- DESMANCHE
    ['Bennys'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },
    ['b13'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },
    ['Brasil'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },
    ['Cartel'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },
    ['Hells'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },
    ['thelost'] = { itens = { ['ferro'] = 9999999, ['aluminio'] = 9999999, ['m-malha'] = 9999999, ['mola'] = 9999999, ['plastico'] = 9999999 } },

    -- MECÂNICA
    ['HavanaCustom'] = { itens = { ['plastico'] = 9999999, ['metal'] = 9999999, ['cobre'] = 9999999 } },
    ['StreetRacing'] = { itens = { ['plastico'] = 9999999, ['metal'] = 9999999, ['cobre'] = 9999999 } },
    ['HospitalCopacabana'] = { itens = { ['fita_de_pano'] = 9999999, ['elastico'] = 9999999 } },

    ["Equipamentos"] = {itens = { ['tecido'] = 99999, ['couro'] = 99999, ['ferro'] = 99999 }},
    ['Ferramentas'] = { itens = { ['pneu'] = 9999, ['weapon_wrench'] = 9999, ['weapon_crowbar'] = 9999, ['rastreador'] = 9999} }
}

-- ============================================================================
-- LOCALIZAÇÕES
-- ============================================================================

Config.Locations = {
    ['SUL'] = {
        {['x'] = -1681.02, ['y'] = -290.99, ['z'] = 51.89, ['h'] = 238.73},
        {['x'] = -1660.63, ['y'] = -534.24, ['z'] = 36.03, ['h'] = 153.13},
        {['x'] = -1162.72, ['y'] = -321.17, ['z'] = 38.09, ['h'] = 186.68},
        {['x'] = -874.91, ['y'] = -309.11, ['z'] = 39.54, ['h'] = 357.54},
        {['x'] = 161.1, ['y'] = -254.6, ['z'] = 51.4, ['h'] = 160.59},
        {['x'] = 552.56, ['y'] = -192.78, ['z'] = 54.49, ['h'] = 272.65},
        {['x'] = 1070.65, ['y'] = -780.43, ['z'] = 58.35, ['h'] = 95.95},
        {['x'] = 1231.51, ['y'] = -1083.15, ['z'] = 38.53, ['h'] = 131.28},
        {['x'] = 961.7, ['y'] = -1557.72, ['z'] = 30.81, ['h'] = 273.75},
        {['x'] = 957.17, ['y'] = -1864.57, ['z'] = 31.24, ['h'] = 101.54},
        {['x'] = 819.01, ['y'] = -2365.03, ['z'] = 30.18, ['h'] = 270.27},
        {['x'] = 689.96, ['y'] = -2920.01, ['z'] = 6.0, ['h'] = 91.66},
        {['x'] = 595.49, ['y'] = -3240.6, ['z'] = 6.07, ['h'] = 277.69},
        {['x'] = 464.97, ['y'] = -2743.0, ['z'] = 6.07, ['h'] = 60.88},
        {['x'] = 263.53, ['y'] = -2506.79, ['z'] = 6.45, ['h'] = 297.41},
        {['x'] = -720.23, ['y'] = -2235.39, ['z'] = 7.24, ['h'] = 0.88},
        {['x'] = -873.66, ['y'] = -2735.87, ['z'] = 13.95, ['h'] = 55.83},
        {['x'] = -905.67, ['y'] = -2338.32, ['z'] = 6.71, ['h'] = 336.81},
        {['x'] = -638.73, ['y'] = -1249.86, ['z'] = 11.82, ['h'] = 173.14},
        {['x'] = -759.41, ['y'] = -1515.06, ['z'] = 4.98, ['h'] = 33.36}
    },
    ['NORTE'] = {
        {['x'] = -1507.65, ['y'] = 1505.27, ['z'] = 115.29, ['h'] = 259.63},
        {['x'] = -1314.2, ['y'] = 2507.56, ['z'] = 21.93, ['h'] = 268.46},
        {['x'] = -296.42, ['y'] = 2786.23, ['z'] = 61.1, ['h'] = 57.41},
        {['x'] = 304.81, ['y'] = 2821.06, ['z'] = 43.44, ['h'] = 5.78},
        {['x'] = 699.31, ['y'] = 3114.94, ['z'] = 44.09, ['h'] = 276.95},
        {['x'] = 1611.65, ['y'] = 3573.32, ['z'] = 35.56, ['h'] = 301.31},
        {['x'] = 2440.27, ['y'] = 4068.28, ['z'] = 38.07, ['h'] = 70.91},
        {['x'] = 1966.76, ['y'] = 5189.94, ['z'] = 48.12, ['h'] = 354.29},
        {['x'] = 1504.6, ['y'] = 6324.68, ['z'] = 24.38, ['h'] = 342.31},
        {['x'] = 174.68, ['y'] = 6642.73, ['z'] = 31.58, ['h'] = 316.87},
        {['x'] = -182.69, ['y'] = 6551.21, ['z'] = 11.1, ['h'] = 58.29},
        {['x'] = -354.41, ['y'] = 6066.41, ['z'] = 31.5, ['h'] = 46.93},
        {['x'] = -258.34, ['y'] = 6247.19, ['z'] = 31.49, ['h'] = 325.34},
        {['x'] = 80.74, ['y'] = 6644.32, ['z'] = 31.92, ['h'] = 149.49},
        {['x'] = 90.38, ['y'] = 6340.4, ['z'] = 31.38, ['h'] = 120.42},
        {['x'] = -1490.5, ['y'] = 4981.6, ['z'] = 63.35, ['h'] = 90.68},
        {['x'] = -2175.15, ['y'] = 4294.56, ['z'] = 49.06, ['h'] = 246.92},
        {['x'] = -2566.14, ['y'] = 2307.26, ['z'] = 33.22, ['h'] = 90.28},
        {['x'] = -1126.1, ['y'] = 2694.59, ['z'] = 18.81, ['h'] = 66.85},
        {['x'] = -1553.03, ['y'] = 1369.89, ['z'] = 126.69, ['h'] = 220.24}
    }
}

Config.DeliveryLocations = {
    {['x'] = 727.77172851563, ['y'] = 216.70178222656, ['z'] = 87.030082702637},
    {['x'] = 200.47122192383, ['y'] = 495.94183349609, ['z'] = 140.99989318848},
    {['x'] = -184.89025878906, ['y'] = 502.69140625, ['z'] = 134.91850280762},
    {['x'] = -355.51943969727, ['y'] = 343.93936157227, ['z'] = 109.34753417969},
    {['x'] = -568.55474853516, ['y'] = 494.0881652832, ['z'] = 106.95864105225},
    {['x'] = -836.76580810547, ['y'] = 454.63809204102, ['z'] = 88.595893859863},
    {['x'] = -1161.8542480469, ['y'] = 480.41220092773, ['z'] = 86.093757629395},
    {['x'] = -1455.5434570313, ['y'] = 413.61660766602, ['z'] = 109.88622283936},
    {['x'] = -1481.2939453125, ['y'] = -7.4827694892883, ['z'] = 55.236015319824},
    {['x'] = -1149.9549560547, ['y'] = -388.05087280273, ['z'] = 36.635585784912},
    {['x'] = -895.76831054688, ['y'] = -779.05114746094, ['z'] = 15.910481452942},
    {['x'] = -870.94580078125, ['y'] = -1129.8197021484, ['z'] = 7.0695457458496},
    {['x'] = -1138.6221923828, ['y'] = -1410.21484375, ['z'] = 5.2557005882263},
    {['x'] = -1351.5860595703, ['y'] = -1216.1368408203, ['z'] = 5.944146156311},
    {['x'] = -1012.6721801758, ['y'] = -1138.9058837891, ['z'] = 2.1586010456085},
    {['x'] = -1315.2711181641, ['y'] = -903.45721435547, ['z'] = 11.322186470032},
    {['x'] = -1586.9901123047, ['y'] = -571.14691162109, ['z'] = 34.97908782959},
    {['x'] = -1997.5615234375, ['y'] = -334.21292114258, ['z'] = 48.106292724609},
    {['x'] = -1630.5080566406, ['y'] = -361.54281616211, ['z'] = 48.140926361084},
    {['x'] = -2235.0270996094, ['y'] = -362.39163208008, ['z'] = 13.311479568481},
    {['x'] = -2819.4743652344, ['y'] = 64.266174316406, ['z'] = 14.754144668579},
    {['x'] = -3031.900390625, ['y'] = 516.42614746094, ['z'] = 7.3950986862183},
    {['x'] = -3224.7846679688, ['y'] = 1098.7489013672, ['z'] = 10.571074485779},
    {['x'] = -3008.2175292969, ['y'] = 1912.2239990234, ['z'] = 28.482349395752},
    {['x'] = -2520.0417480469, ['y'] = 2315.4816894531, ['z'] = 33.216365814209},
    {['x'] = -2351.4899902344, ['y'] = 3994.7272949219, ['z'] = 26.699678421021},
    {['x'] = -1491.5766601563, ['y'] = 4980.5122070313, ['z'] = 63.323047637939},
    {['x'] = -581.72552490234, ['y'] = 5621.5712890625, ['z'] = 38.658626556396},
    {['x'] = -182.99453735352, ['y'] = 6311.8110351563, ['z'] = 31.489393234253},
    {['x'] = 756.95104980469, ['y'] = 6461.7241210938, ['z'] = 31.427434921265},
    {['x'] = 1745.1613769531, ['y'] = 6411.2065429688, ['z'] = 35.239028930664},
    {['x'] = 2559.6745605469, ['y'] = 5241.7177734375, ['z'] = 44.855991363525},
    {['x'] = 1959.9293212891, ['y'] = 5172.603515625, ['z'] = 47.927612304688},
    {['x'] = 1819.3823242188, ['y'] = 4588.7680664063, ['z'] = 36.047267913818},
    {['x'] = 2667.91015625, ['y'] = 4763.7509765625, ['z'] = 34.724266052246},
    {['x'] = 2845.0456542969, ['y'] = 3436.298828125, ['z'] = 50.762619018555},
    {['x'] = 2538.9609375, ['y'] = 2572.9411621094, ['z'] = 37.944816589355},
    {['x'] = 2333.9645996094, ['y'] = 1196.4398193359, ['z'] = 64.543518066406},
    {['x'] = 2276.1181640625, ['y'] = -487.01263427734, ['z'] = 81.982582092285},
    {['x'] = 1001.8076171875, ['y'] = -813.86273193359, ['z'] = 33.975234985352},
    {['x'] = 91.650726318359, ['y'] = -1209.86328125, ['z'] = 37.548927307129},
    {['x'] = 474.55722045898, ['y'] = -1062.0173339844, ['z'] = 29.211532592773},
    {['x'] = 493.51379394531, ['y'] = -583.89660644531, ['z'] = 24.714595794678},
    {['x'] = 633.35852050781, ['y'] = -291.8196105957, ['z'] = 39.99861907959},
    {['x'] = 936.87609863281, ['y'] = -875.10345458984, ['z'] = 43.794380187988},
    {['x'] = 767.81390380859, ['y'] = -1318.5142822266, ['z'] = 27.275230407715},
    {['x'] = 765.59387207031, ['y'] = -1901.9017333984, ['z'] = 29.173307418823},
    {['x'] = 421.52984619141, ['y'] = -1543.0887451172, ['z'] = 29.249750137329},
    {['x'] = 26.712888717651, ['y'] = -1458.2862548828, ['z'] = 30.478290557861},
    {['x'] = -425.20614624023, ['y'] = -1699.0222167969, ['z'] = 19.079179763794},
    {['x'] = -76.685134887695, ['y'] = -1313.3244628906, ['z'] = 29.260971069336},
    {['x'] = -253.92417907715, ['y'] = -944.14013671875, ['z'] = 31.219984054565},
    {['x'] = -663.40991210938, ['y'] = -890.51904296875, ['z'] = 24.578384399414},
    {['x'] = -703.26116943359, ['y'] = -1390.6459960938, ['z'] = 5.1502690315247},
    {['x'] = -549.00323486328, ['y'] = -939.03460693359, ['z'] = 23.852233886719},
    {['x'] = -829.84509277344, ['y'] = -623.87945556641, ['z'] = 29.026956558228},
    {['x'] = -900.43634033203, ['y'] = -195.82566833496, ['z'] = 38.067127227783},
    {['x'] = -352.57220458984, ['y'] = 14.588917732239, ['z'] = 47.854736328125},
    {['x'] = -33.800872802734, ['y'] = -23.058477401733, ['z'] = 68.997619628906},
    {['x'] = 290.91644287109, ['y'] = -293.37322998047, ['z'] = 53.981533050537}
}

-- ============================================================================
-- FUNÇÃO DE TEXTO 3D
-- ============================================================================
if not SERVER then
    function DrawText3Ds(x, y, z, text)
        local onScreen, _x, _y = World3dToScreen2d(x, y, z)
        SetTextFont(4)
        SetTextScale(0.35, 0.35)
        SetTextColour(255, 255, 255, 200)
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end