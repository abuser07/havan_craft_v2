local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- Criar a interface para o client
src = {}
Tunnel.bindInterface("vrp_craft", src)
vSERVER = Tunnel.getInterface("vrp_craft")

-- Tabelas globais
local craftingItem = {}
local policePermission = "policia.permision"
local logWebhook = "https://discord.com/api/webhooks/1195352561356656671/M3KO_6fud2VrgB7JRjhIf9OEXyeDGcOzX0ydtaU4C6bJyTKP8lqBEX5zAgOg_zc5Rjjy"

-- Preparar queries SQL
vRP.prepare('sjr/setItens', 'REPLACE INTO sjr_farmsystem(user_id, itens, day) VALUES(@user_id, @itens, @day)')
vRP.prepare('sjr/getItens', 'SELECT * from sjr_farmsystem WHERE user_id = @user_id')

-- Funções auxiliares locais
local function notifyPlayer(source, type, message)
    local _type = type == 'sucesso' and 'success' or (type == 'negado' and 'error' or 'info')
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Sistema de Craft',
        description = message,
        type = _type,
        duration = 5000,
        position = 'top-right'
    })
end

local function sendLog(message)
    vRP.sendLog(logWebhook, message)
end

local function alertPolice(coords, title, description)
    local police = vRP.getUsersByPermission(policePermission) 
    for _,v in pairs(police) do
        local nsource = vRP.getUserSource(parseInt(v))
        if nsource then
            TriggerClientEvent("NotifyPush", nsource, {
                x = coords.x, y = coords.y, z = coords.z,
                blipID = 161, blipColor = 63, blipScale = 0.5,
                time = 20, code = "911", title = title, name = description
            })
        end
    end
end

-- Funções principais
src.checkPerm = function(perm)
    local source = source
    if not perm then
        return true  -- Sem permissão definida = acesso liberado
    end
    local user_id = vRP.getUserId(source)
    return user_id and vRP.hasPermission(user_id, perm)
end

src.getStorage = function(data)
    local source = source
    if not Config.Storages[data.name] or not Config.Storages[data.name].itens then 
        return {} 
    end
    
    local storage = vRP.getSData('Storage:'..data.name)
    if not storage then 
        return {} 
    end
    
    local itens = json.decode(storage) or {}
    local result = {}
    
    for k,v in pairs(Config.Storages[data.name].itens) do
        table.insert(result, {
            name = k,
            qtdStock = itens[k] or 0,
            img = Config.images..k..".png",
            qtdMax = v
        })
    end
    
    return result
end

src.storageItem = function(data, type, id)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then 
        notifyPlayer(source, 'negado', "Usuário não encontrado.")
        return false 
    end

    local info = Config.Tables[type]
    if not info or not info.locations or not info.locations[id] or not info.locations[id].requireStorage or not info.locations[id].requireStorage.name then
        notifyPlayer(source, 'negado', "Armazém não encontrado, abra e feche e tente novamente.")
        return false
    end

    local storageName = info.locations[id].requireStorage.name
    local datatable = vRP.getSData('Storage:'..storageName)
    local storage = json.decode(datatable) or {}
    local amount = vRP.getInventoryItemAmount(user_id, data.name)

    if amount <= 0 then
        notifyPlayer(source, 'negado', "Você não possui esse item para depositar.")
        return false
    end
    
    if not vRP.tryGetInventoryItem(user_id, data.name, amount) then
        notifyPlayer(source, 'negado', "Erro ao retirar item do inventário.")
        return false
    end

    -- Atualizar armazenamento
    storage[data.name] = (storage[data.name] or 0) + amount
    vRP.setSData('Storage:'..storageName, json.encode(storage))

    -- Atualizar banco de dados
    local query = vRP.query('sjr/getItens', { user_id = user_id })
    local temp = os.date("*t", os.time())
    local value = #query > 0 and json.decode(query[1].itens) or {}
    
    value[data.name] = (value[data.name] or 0) + amount
    vRP.execute('sjr/setItens', { user_id = user_id, itens = json.encode(value), day = temp.day })

    -- Log e notificação
    sendLog("O ID "..user_id.." depositou o item: "..data.name.." na quantidade de "..amount)
    notifyPlayer(source, 'sucesso', "Item guardado com sucesso.")
    return true
end

src.startCrafting = function(data, qtd, type, id)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then 
        notifyPlayer(source, 'negado', "Usuário não encontrado.")
        return false 
    end

    local info = Config.Tables[type]
    if not info or not info.locations or not info.locations[id] then
        notifyPlayer(source, 'negado', "Configuração de craft não encontrada.")
        return false
    end

    -- Verificar se já está craftando
    if craftingItem[user_id] and craftingItem[user_id][data.name] then
        notifyPlayer(source, 'negado', "Você já está craftando esse item, aguarde finalizar.")
        return false
    end

    -- Verificar permissão (apenas se craftPermission existir)
    if info.locations[id].craftPermission and not vRP.hasPermission(user_id, info.locations[id].craftPermission) then
        notifyPlayer(source, 'negado', "Você não tem permissão para craftar.")
        return false
    end

    local craftData = info.craft[data.id]
    if not craftData then
        notifyPlayer(source, 'negado', "Item não encontrado na bancada.")
        return false
    end
    
    -- Verificar se o storage existe
    if not info.locations[id].requireStorage or not info.locations[id].requireStorage.name then
        notifyPlayer(source, 'negado', "Armazém não configurado.")
        return false
    end
    
    local storageName = info.locations[id].requireStorage.name
    local datatable = vRP.getSData('Storage:'..storageName)
    local storage = json.decode(datatable) or {}
    local hasEnoughItems = true
    local removed = {}

    -- Verificar itens necessários
    for _,v in pairs(craftData.requires) do
        local requiredAmount = v.amount * qtd
        if not storage[v.item] or storage[v.item] < requiredAmount then
            hasEnoughItems = false
            break
        end
        removed[v.item] = requiredAmount
    end

    if not hasEnoughItems then
        notifyPlayer(source, 'negado', "Não possui itens suficientes no armazém.")
        return false
    end

    -- Remover itens do armazenamento
    for item, amount in pairs(removed) do
        storage[item] = storage[item] - amount
    end
    vRP.setSData('Storage:'..storageName, json.encode(storage))

    -- Iniciar processo de craft
    if not craftingItem[user_id] then
        craftingItem[user_id] = {}
    end

    local totalAmount = craftData.amount * qtd
    craftingItem[user_id][data.name] = {
        amount = totalAmount,
        type = type,
        id = id,
        itens = removed,
        itemName = data.name,
        startTime = os.time()
    }

    -- Log do craft
    sendLog("O ID "..user_id.." iniciou craft do item: "..data.name.." (Quantidade: "..totalAmount..")")
    notifyPlayer(source, 'sucesso', "Craft iniciado! Aguarde "..craftData.itemTime.." segundos.")
    return true
end

src.producedItem = function(data)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then 
        notifyPlayer(source, 'negado', "Usuário não encontrado.")
        return false 
    end

    if not craftingItem[user_id] or not craftingItem[user_id][data.name] then
        notifyPlayer(source, 'negado', "Você não está craftando esse item.")
        return false
    end

    local craftData = craftingItem[user_id][data.name]
    
    -- Verificar se o tempo já passou (opcional, pode remover se quiser)
    -- local elapsedTime = os.time() - craftData.startTime
    -- local requiredTime = -- você precisa armazenar o itemTime
    
    vRP.giveInventoryItem(user_id, data.name, craftData.amount)
    
    -- Log do item recebido
    sendLog("O ID "..user_id.." recebeu o item craftado: "..data.name.." (Quantidade: "..craftData.amount..")")
    notifyPlayer(source, 'sucesso', "Você recebeu "..craftData.amount.."x "..data.name)
    
    craftingItem[user_id][data.name] = nil
    return true
end

src.storageItemAll = function(type, id)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then 
        notifyPlayer(source, 'negado', "Usuário não encontrado.")
        return false 
    end

    local info = Config.Tables[type]
    if not info or not info.locations or not info.locations[id] or not info.locations[id].requireStorage or not info.locations[id].requireStorage.name then
        notifyPlayer(source, 'negado', "Armazém não encontrado.")
        return false
    end

    local storageName = info.locations[id].requireStorage.name
    if not Config.Storages[storageName] or not Config.Storages[storageName].itens then
        notifyPlayer(source, 'negado', "Configuração de armazém inválida.")
        return false
    end

    local datatable = vRP.getSData('Storage:'..storageName)
    local storage = json.decode(datatable) or {}
    local query = vRP.query('sjr/getItens', { user_id = user_id })
    local temp = os.date("*t", os.time())
    local value = #query > 0 and json.decode(query[1].itens) or {}
    local deposited = false

    -- Processar todos os itens do armazém
    for item, _ in pairs(Config.Storages[storageName].itens) do
        local amount = vRP.getInventoryItemAmount(user_id, item)
        if amount > 0 and vRP.tryGetInventoryItem(user_id, item, amount) then
            storage[item] = (storage[item] or 0) + amount
            value[item] = (value[item] or 0) + amount
            deposited = true
            
            -- Log para cada item depositado
            sendLog("O ID "..user_id.." depositou o item: "..item.." (Quantidade: "..amount..")")
        end
    end

    if deposited then
        vRP.setSData('Storage:'..storageName, json.encode(storage))
        vRP.execute('sjr/setItens', { user_id = user_id, itens = json.encode(value), day = temp.day })
        notifyPlayer(source, 'sucesso', "Itens guardados com sucesso.")
        return true
    end

    notifyPlayer(source, 'negado', "Nenhum item para depositar.")
    return false
end

-- Evento para limpar crafts quando o jogador sai
AddEventHandler('vRP:playerLeave', function(user_id, source)
    if not user_id or not craftingItem[user_id] then return end

    for itemName, craftData in pairs(craftingItem[user_id]) do
        local info = Config.Tables[craftData.type]
        if info and info.locations and info.locations[craftData.id] and info.locations[craftData.id].requireStorage then
            local storageName = info.locations[craftData.id].requireStorage.name
            local datatable = vRP.getSData('Storage:'..storageName)
            local storage = json.decode(datatable) or {}

            for item, amount in pairs(craftData.itens) do
                storage[item] = (storage[item] or 0) + amount
            end

            vRP.setSData('Storage:'..storageName, json.encode(storage))
            sendLog("O ID "..user_id.." saiu e teve o craft cancelado, itens devolvidos ao armazém.")
        end
        craftingItem[user_id][itemName] = nil
    end
end)

-- Funções para o sistema de rota
src.giveItem = function(data)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return false end

    local changed = false
    for _,v in pairs(data.parts) do
        local random = math.random(v.qtdMin, v.qtdMax)
        
        local policiais = vRP.getUsersByPermission("policia.permissao")

        if #policiais > 5 then
            random = random * 3
        elseif #policiais > 1 then
            random = random * 2
        end

        -- Verificar espaço no inventário
        local itemWeight = vRP.getItemWeight(v.name) * random
        if vRP.getInventoryWeight(user_id) + itemWeight <= vRP.getInventoryMaxWeight(user_id) then
            vRP.giveInventoryItem(user_id, v.name, random)
            changed = true
        else
            notifyPlayer(source, "negado", "Mochila cheia para o item "..v.name)
        end
    end

    -- Chance de alertar a polícia
    if data.callPolice and math.random(0,100) <= data.percentualPolice then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        alertPolice(coords, 'Denúncia de coleta', 'Uma pessoa avistou alguém coletando itens ilícitos.')
    end

    return changed
end

src.sellItem = function(data)
    local source = source
    local user_id = vRP.getUserId(source)
    if not user_id then return false end

    local changed = false
    for _,v in pairs(data.parts) do
        local random = math.random(v.qtdMin, v.qtdMax)
        
        if vRP.tryGetInventoryItem(user_id, v.name, random) then
            local paymentType = v.type == 'legal' and 'dinheiro' or Config.dirtymoney
            vRP.giveInventoryItem(user_id, paymentType, v.payment)
            changed = true
            notifyPlayer(source, "sucesso", "Você vendeu "..random.."x "..v.name.." por R$"..v.payment)
        else
            notifyPlayer(source, "negado", "Você não possui "..random.."x "..v.name.." para vender")
        end
    end

    -- Chance de alertar a polícia
    if data.callPolice and math.random(0,100) <= data.percentualPolice then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        alertPolice(coords, 'Denúncia de venda', 'Uma pessoa avistou alguém vendendo itens suspeitos.')
    end

    return changed
end

-- Comando para recarregar configuração (admin)
RegisterCommand('reloadcraft', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id, "admin.permissao") then
        local success = pcall(function()
            Config = nil
            Citizen.Wait(100)
            Config = dofile("config.lua")
        end)
        if success then
            notifyPlayer(source, 'sucesso', "Configuração do craft recarregada com sucesso!")
        else
            notifyPlayer(source, 'negado', "Erro ao recarregar configuração.")
        end
    else
        notifyPlayer(source, 'negado', "Você não tem permissão para usar este comando.")
    end
end, false)

print('[CRAFT] Server iniciado com sucesso!')