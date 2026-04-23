local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local vSERVER = Tunnel.getInterface("vrp_craft")

local DelayTimer = GetGameTimer()
local type = nil
local id = nil
local segundos = 0

local blips = {}
local in_rota = false
local itemRoute = ""
local direction = ''
local itemNumRoute = 0
local delay = 0
local textName = ''

-- Inicializar ox_lib
local lib = exports.ox_lib

-- Função para notificações com ox_lib
local function notify(message, msgType)
    lib.notify({
        title = 'Sistema de Craft',
        description = message,
        type = msgType or 'info',
        duration = 5000,
        position = 'top-right'
    })
end

formatCollect = function(table)
    local newtable = {}
    if not table.list then return {} end
    for k,v in pairs(table.list) do
        local itens = {}
        for i = 1, #v.itensList do
            itens[#itens+1] = { name = v.itensList[i].item, img = Config.images..""..v.itensList[i].item..".png", qtdMin = v.itensList[i].minAmount, qtdMax = v.itensList[i].maxAmount  }
        end
        newtable[#newtable+1] = { callPolice = v.dangerRoute.status, percentualPolice = v.dangerRoute.percentualPolice, bonus = v.dominationBonus.bonus, status = v.dominationBonus.status, qtdPoints = #Config.Locations['SUL'], parts = itens }  
    end
    return newtable
end

formatDelivery = function(table)
    local newtable = {}
    if not table.list then return {} end
    for k,v in pairs(table.list) do
        local itens = {}
        for i = 1, #v.itensList do
            itens[#itens+1] = { name = v.itensList[i].item, img = Config.images..""..v.itensList[i].item..".png", qtdMin = v.itensList[i].minAmount, qtdMax = v.itensList[i].maxAmount, payment = v.itensList[i].payment, type = v.itensList[i].type  }
        end
        newtable[#newtable+1] = { callPolice = v.dangerRoute.status, percentualPolice = v.dangerRoute.percentualPolice, qtdPoints = #Config.DeliveryLocations, parts = itens }  
    end
    return newtable
end

formatItens = function(table)
    local newtable = {}
    for k,v in pairs(table) do
        local itens = {}
        for i = 1,#v.requires do
            itens[i] = { name = v.requires[i].item, img = Config.images..""..v.requires[i].item..".png", qtdNecessary = v.requires[i].amount }
        end
        newtable[#newtable+1] = {
            name = v.item,
            id = k,
            qtd = v.amount,
            img = Config.images..""..v.item..".png",
            timer = v.itemTime,
            components = itens,
        }
    end
    return newtable
end

-- Função para abrir a NUI
local function openCraftUI(craftType, craftId)
    local info = Config.Tables[craftType]
    local location = info.locations[craftId]
    
    if not location then
        notify('Erro ao carregar bancada.', 'error')
        return false
    end
    
    -- Verificar permissão (se houver)
    if location.tablePermission and not vSERVER.checkPerm(location.tablePermission) then
        notify('Você não tem permissão para acessar esta bancada.', 'error')
        return false
    end
    
    type = craftType
    id = craftId
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        show = true,
        storeLink = Config.storeLink,
        itens = formatItens(info.craft),
        storage = vSERVER.getStorage(location.requireStorage),
        delivery = formatDelivery(info.delivery),
        collect = formatCollect(info.farm)
    })
    return true
end

-- Criar targets com ox_target
CreateThread(function()
    -- Aguardar ox_target carregar
    Wait(2000)
    
    if not exports.ox_target then
        print('[ERRO] ox_target não encontrado! Verifique se o recurso está iniciado.')
        return
    end
    
    for k,v in pairs(Config.Tables) do
        if v and v.locations then
            for l,w in pairs(v.locations) do
                local coords = w.coords
                local zoneName = 'craft_'..k..'_'..l
                
                -- Determinar se é pública
                local isPublic = w.craftPermission == nil
                local labelText = isPublic and ('🔧 Acessar Bancada de '..k..' (Público)') or ('🔧 Acessar Bancada de '..k)
                local iconColor = isPublic and 'green' or 'purple'
                
                exports.ox_target:addBoxZone({
                    name = zoneName,
                    coords = coords,
                    size = vec3(1.5, 1.5, 1.5),
                    rotation = 0,
                    debug = false,
                    options = {
                        {
                            name = 'acessar_bancada_'..k..'_'..l,
                            label = labelText,
                            icon = 'fa-solid fa-cogs',
                            iconColor = iconColor,
                            distance = 1.5,
                            onSelect = function()
                                print('[DEBUG] Abrindo bancada: '..k..' - ID: '..l)
                                openCraftUI(k, l)
                            end
                        }
                    }
                })
                
                -- Adicionar blip no mapa
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, 566)
                SetBlipColour(blip, isPublic and 2 or 50)
                SetBlipScale(blip, 0.7)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(w.name or 'Bancada de '..k)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
    
    print('[CRAFT] Sistema carregado. '..#Config.Tables.. ' bancadas configuradas.')
end)

-- Criar targets para rotas de coleta
CreateThread(function()
    Wait(3000)
    
    -- Pontos de coleta Sul
    if Config.Locations['SUL'] then
        for i, coords in pairs(Config.Locations['SUL']) do
            exports.ox_target:addBoxZone({
                name = 'coleta_sul_'..i,
                coords = vec3(coords.x, coords.y, coords.z),
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0,
                options = {
                    {
                        name = 'coletar_sul',
                        label = '📦 Coletar Item',
                        icon = 'fa-solid fa-box',
                        distance = 2.0,
                        onSelect = function()
                            if not in_rota then
                                -- Função de coleta será implementada
                                notify('Sistema de coleta em desenvolvimento.', 'info')
                            end
                        end
                    }
                }
            })
        end
    end
    
    -- Pontos de coleta Norte
    if Config.Locations['NORTE'] then
        for i, coords in pairs(Config.Locations['NORTE']) do
            exports.ox_target:addBoxZone({
                name = 'coleta_norte_'..i,
                coords = vec3(coords.x, coords.y, coords.z),
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0,
                options = {
                    {
                        name = 'coletar_norte',
                        label = '📦 Coletar Item',
                        icon = 'fa-solid fa-box',
                        distance = 2.0,
                        onSelect = function()
                            if not in_rota then
                                notify('Sistema de coleta em desenvolvimento.', 'info')
                            end
                        end
                    }
                }
            })
        end
    end
    
    -- Pontos de entrega
    if Config.DeliveryLocations then
        for i, coords in pairs(Config.DeliveryLocations) do
            exports.ox_target:addBoxZone({
                name = 'entrega_'..i,
                coords = vec3(coords.x, coords.y, coords.z),
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0,
                options = {
                    {
                        name = 'entregar',
                        label = '💰 Entregar Itens',
                        icon = 'fa-solid fa-hand-holding-usd',
                        distance = 2.0,
                        onSelect = function()
                            if not in_rota then
                                notify('Sistema de entrega em desenvolvimento.', 'info')
                            end
                        end
                    }
                }
            })
        end
    end
end)

-- NUI Callbacks
RegisterNUICallback('storageItem', function(data, cb)
    local request = vSERVER.storageItem(data.storedItem, type, id)
    cb(request)
    if request then
        notify('Item depositado com sucesso!', 'success')
    end
end)

RegisterNUICallback('startCrafting', function(data, cb)
    local request = vSERVER.startCrafting(data.item, data.qtdSelected, type, id)
    if request then
        if segundos > 0 then
            local value = data.item.timer - segundos
            segundos = data.item.timer + value
        else
            segundos = segundos + data.item.timer
        end
        ExecuteCommand('e mexer')
        FreezeEntityPosition(PlayerPedId(), true)
        notify('Iniciando craft de '..data.item.name..', aguarde '..data.item.timer..' segundos...', 'info')
    else
        notify('Falha ao iniciar craft, verifique os materiais no armazém.', 'error')
    end
    cb(request)
end)

RegisterNUICallback('producedItem', function(data, cb)
    local request = vSERVER.producedItem(data.item)
    cb(request)
    if request then
        notify('Item craftado recebido com sucesso!', 'success')
    end
end)

RegisterNUICallback('storageAllItens', function(data, cb)
    local request = vSERVER.storageItemAll(type, id)
    cb(request)
    if request then
        notify('Todos os itens foram depositados!', 'success')
    end
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb("Ok")
end)

-- Thread do timer de craft
CreateThread(function()
    while true do
        if segundos > 0 then
            if segundos == 1 then
                vRP.stopAnim(true)
                FreezeEntityPosition(PlayerPedId(), false)
                notify('Craft finalizado! Clique em "Produzir Item" para retirar.', 'success')
            end
            segundos = segundos - 1
        end

        if delay >= 0 then
            delay = delay - 1
            if delay <= 0 then
                delay = 0
            end
        end

        Wait(1000)
    end
end)

-- Thread para rotas de coleta/entrega
CreateThread(function()
    while true do
        if in_rota then
            local time = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            
            if direction == "norte" then
                routeIndexed = Config.Locations['NORTE']
                indexedCoords = Config.Locations['NORTE'][parseInt(itemNumRoute)]
                distance = #(pedCoords - vec3(indexedCoords.x, indexedCoords.y, indexedCoords.z))
            elseif direction == "sul" then
                routeIndexed = Config.Locations['SUL']
                indexedCoords = Config.Locations['SUL'][parseInt(itemNumRoute)]
                distance = #(pedCoords - vec3(indexedCoords.x, indexedCoords.y, indexedCoords.z))
            elseif direction == 'delivery' then
                routeIndexed = Config.DeliveryLocations
                indexedCoords = Config.DeliveryLocations[parseInt(itemNumRoute)]
                distance = #(pedCoords - vec3(indexedCoords.x, indexedCoords.y, indexedCoords.z))
            end
            
            if distance <= 15.0 then
                time = 5
                DrawMarker(21, indexedCoords.x, indexedCoords.y, indexedCoords.z, 0, 0, 0, 0, 180.0, 130.0, 1.0, 1.0, 0.5, 130, 109, 255, 180, 1, 0, 0, 1)
                
                if distance <= 2.0 then
                    if IsControlJustReleased(1, 51) and delay <= 0 and not IsPedInAnyVehicle(PlayerPedId()) then
                        delay = 5
                        
                        if direction == 'delivery' then
                            if vSERVER.sellItem(itemRoute) then
                                vRP._playAnim(false, {{"pickup_object","pickup_low"}}, false)
                                itemNumRoute = itemNumRoute + 1
                                if itemNumRoute > #routeIndexed then
                                    itemNumRoute = 1
                                end
                                RemoveBlip(blips)
                                CriandoBlip(itemNumRoute, direction)
                            end
                        else
                            if vSERVER.giveItem(itemRoute) then
                                vRP._playAnim(false, {{"pickup_object","pickup_low"}}, false)
                                itemNumRoute = itemNumRoute + 1
                                if itemNumRoute > #routeIndexed then
                                    itemNumRoute = 1
                                end
                                RemoveBlip(blips)
                                CriandoBlip(itemNumRoute, direction)
                            end
                        end
                    end
                end
            end
            
            Citizen.Wait(time)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- Thread para texto de finalizar rota
CreateThread(function()
    while true do
        local time = 1000
        if in_rota then
            time = 5
            drawTxt("~w~Aperte ~r~F7~w~ se deseja finalizar a "..textName..".", 0.215, 0.94)
            
            if IsControlJustPressed(0, 168) and not IsPedInAnyVehicle(PlayerPedId()) then
                in_rota = false
                itemRoute = ""
                itemNumRoute = 0
                RemoveBlip(blips)
            end
        end
        
        Citizen.Wait(time)
    end
end)

function DrawText3Ds2(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text))/370
    DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

function drawTxt(text,x,y)
    local res_x, res_y = GetActiveScreenResolution()
    SetTextFont(4)
    SetTextScale(0.3,0.3)
    SetTextColour(255,255,255,255)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    
    if res_x >= 2000 then
        DrawText(x+0.076,y)
    else
        DrawText(x,y)
    end
end

function CriandoBlip(selecionado, direction)
    if direction == 'delivery' then
        blips = AddBlipForCoord(Config.DeliveryLocations[parseInt(selecionado)].x, Config.DeliveryLocations[parseInt(selecionado)].y, Config.DeliveryLocations[parseInt(selecionado)].z)
        SetBlipSprite(blips, 1)
        SetBlipColour(blips, 50)
        SetBlipScale(blips, 0.4)
        SetBlipAsShortRange(blips, false)
        SetBlipRoute(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Entrega")
        EndTextCommandSetBlipName(blips)
    else
        blips = AddBlipForCoord(Config.Locations[string.upper(direction)][parseInt(selecionado)].x, Config.Locations[string.upper(direction)][parseInt(selecionado)].y, Config.Locations[string.upper(direction)][parseInt(selecionado)].z)
        SetBlipSprite(blips, 1)
        SetBlipColour(blips, 50)
        SetBlipScale(blips, 0.4)
        SetBlipAsShortRange(blips, false)
        SetBlipRoute(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Coleta")
        EndTextCommandSetBlipName(blips)
    end
end

-- Função auxiliar para async
local function async(callback)
    Citizen.CreateThread(callback)
end

-- Comando de debug para testar target
RegisterCommand('testtarget', function()
    local coords = GetEntityCoords(PlayerPedId())
    exports.ox_target:addBoxZone({
        name = 'test_zone',
        coords = coords,
        size = vec3(2.0, 2.0, 2.0),
        options = {
            {
                name = 'test',
                label = '🧪 Teste Target',
                icon = 'fa-solid fa-flask',
                onSelect = function()
                    notify('Target está funcionando corretamente!', 'success')
                end
            }
        }
    })
    notify('Zona de teste criada na sua localização!', 'info')
end, false)

print('[CRAFT] Client iniciado com sucesso!')