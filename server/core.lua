-- server/core.lua
-- Sistema de compatibilidade para múltiplos frameworks e inventários

local Framework = Config.Framework
local InventoryType = Config.Inventory

-- ============================================================================
-- FRAMEWORK WRAPPERS
-- ============================================================================

-- Verificar se o arquivo de framework existe
local function checkFrameworkFile(file)
    local resourceName = GetCurrentResourceName()
    local path = string.format("%s/%s.lua", resourceName, file)
    return Citizen.InvokeNative(0xC197616D221FF4A4, path) -- IsResourceFile
end

-- VRP Functions
local VRPFunctions = {
    hasPermission = function(user_id, permission)
        if not vRP then return false end
        return vRP.hasPermission(user_id, permission)
    end,
    
    getUserId = function(source)
        if not vRP then return nil end
        return vRP.getUserId(source)
    end,
    
    getUserSource = function(user_id)
        if not vRP then return nil end
        return vRP.getUserSource(user_id)
    end,
    
    getUsersByPermission = function(permission)
        if not vRP then return {} end
        return vRP.getUsersByPermission(permission)
    end,
    
    getInventoryItemAmount = function(user_id, item)
        if not vRP then return 0 end
        return vRP.getInventoryItemAmount(user_id, item)
    end,
    
    tryGetInventoryItem = function(user_id, item, amount)
        if not vRP then return false end
        return vRP.tryGetInventoryItem(user_id, item, amount)
    end,
    
    giveInventoryItem = function(user_id, item, amount)
        if not vRP then return false end
        return vRP.giveInventoryItem(user_id, item, amount)
    end,
    
    getInventoryWeight = function(user_id)
        if not vRP then return 0 end
        return vRP.getInventoryWeight(user_id)
    end,
    
    getInventoryMaxWeight = function(user_id)
        if not vRP then return 0 end
        return vRP.getInventoryMaxWeight(user_id)
    end,
    
    getItemWeight = function(item)
        if not vRP then return 0 end
        return vRP.getItemWeight(item)
    end,
    
    sendLog = function(webhook, message)
        if not vRP then return end
        return vRP.sendLog(webhook, message)
    end,
    
    getSData = function(key)
        if not vRP then return nil end
        return vRP.getSData(key)
    end,
    
    setSData = function(key, value)
        if not vRP then return end
        return vRP.setSData(key, value)
    end,
    
    prepare = function(query, name)
        if not vRP then return end
        return vRP.prepare(query, name)
    end,
    
    query = function(query, params)
        if not vRP then return {} end
        return vRP.query(query, params)
    end,
    
    execute = function(query, params)
        if not vRP then return end
        return vRP.execute(query, params)
    end
}

-- QBCore Functions
local QBCore = nil
local QBCoreFunctions = {
    hasPermission = function(source, permission)
        if not QBCore then return false end
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return false end
        -- Verificar se é grupo/job
        if Player.PlayerData.job and Player.PlayerData.job.name == permission then
            return true
        end
        if Player.PlayerData.gang and Player.PlayerData.gang.name == permission then
            return true
        end
        -- Verificar se tem permissão (group)
        if Player.PlayerData.group and Player.PlayerData.group == permission then
            return true
        end
        return false
    end,
    
    getUserId = function(source)
        if not QBCore then return nil end
        local Player = QBCore.Functions.GetPlayer(source)
        return Player and Player.PlayerData.citizenid or nil
    end,
    
    getUserSource = function(user_id)
        if not QBCore then return nil end
        local players = QBCore.Functions.GetPlayers()
        for _, source in pairs(players) do
            local Player = QBCore.Functions.GetPlayer(source)
            if Player and Player.PlayerData.citizenid == user_id then
                return source
            end
        end
        return nil
    end,
    
    getUsersByPermission = function(permission)
        if not QBCore then return {} end
        local users = {}
        local players = QBCore.Functions.GetPlayers()
        for _, source in pairs(players) do
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                if (Player.PlayerData.job and Player.PlayerData.job.name == permission) or
                   (Player.PlayerData.gang and Player.PlayerData.gang.name == permission) or
                   (Player.PlayerData.group and Player.PlayerData.group == permission) then
                    table.insert(users, Player.PlayerData.citizenid)
                end
            end
        end
        return users
    end,
    
    getInventoryItemAmount = function(user_id, item)
        if not QBCore then return 0 end
        local src = QBCoreFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return 0 end
        local amount = Player.Functions.GetItemByName(item)
        return amount and amount.amount or 0
    end,
    
    tryGetInventoryItem = function(user_id, item, amount)
        if not QBCore then return false end
        local src = QBCoreFunctions.getUserSource(user_id)
        if not src then return false end
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
        return Player.Functions.RemoveItem(item, amount)
    end,
    
    giveInventoryItem = function(user_id, item, amount)
        if not QBCore then return false end
        local src = QBCoreFunctions.getUserSource(user_id)
        if not src then return false end
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
        return Player.Functions.AddItem(item, amount)
    end,
    
    getInventoryWeight = function(user_id)
        if not QBCore then return 0 end
        local src = QBCoreFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return 0 end
        return Player.PlayerData.money.load or 0
    end,
    
    getInventoryMaxWeight = function(user_id)
        if not QBCore then return 0 end
        local src = QBCoreFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return 0 end
        return Player.PlayerData.money.maxweight or 100000
    end,
    
    getItemWeight = function(item)
        if not QBCore then return 0 end
        -- Buscar peso do item no QBCore
        local items = QBCore.Shared.Items
        return items[item] and items[item].weight or 0
    end,
    
    sendLog = function(webhook, message)
        -- Implementar webhook para QBCore
        local embed = {
            {
                ["color"] = 3447003,
                ["title"] = "Sistema de Craft",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = os.date("%d/%m/%Y %H:%M:%S")
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Craft System", embeds = embed}), {['Content-Type'] = 'application/json'})
    end,
    
    getSData = function(key)
        if not QBCore then return nil end
        local result = MySQL.scalar.await('SELECT value FROM storage WHERE `key` = ?', {key})
        return result or nil
    end,
    
    setSData = function(key, value)
        if not QBCore then return end
        MySQL.Async.execute('REPLACE INTO storage (`key`, `value`) VALUES (?, ?)', {key, value})
    end,
    
    prepare = function(query, name)
        -- MySQL preparado para QBCore
        return true
    end,
    
    query = function(query, params)
        if not QBCore then return {} end
        return MySQL.query.await(query, params)
    end,
    
    execute = function(query, params)
        if not QBCore then return end
        MySQL.Async.execute(query, params)
    end
}

-- ESX Functions
local ESX = nil
local ESXFunctions = {
    hasPermission = function(source, permission)
        if not ESX then return false end
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return false end
        -- Verificar se é job
        if xPlayer.job and xPlayer.job.name == permission then
            return true
        end
        -- Verificar se tem group
        if xPlayer.getGroup and xPlayer.getGroup() == permission then
            return true
        end
        return false
    end,
    
    getUserId = function(source)
        if not ESX then return nil end
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.identifier or nil
    end,
    
    getUserSource = function(user_id)
        if not ESX then return nil end
        local xPlayer = ESX.GetPlayerFromIdentifier(user_id)
        return xPlayer and xPlayer.source or nil
    end,
    
    getUsersByPermission = function(permission)
        if not ESX then return {} end
        local users = {}
        local players = ESX.GetPlayers()
        for _, source in pairs(players) do
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                if (xPlayer.job and xPlayer.job.name == permission) or
                   (xPlayer.getGroup and xPlayer.getGroup() == permission) then
                    table.insert(users, xPlayer.identifier)
                end
            end
        end
        return users
    end,
    
    getInventoryItemAmount = function(user_id, item)
        if not ESX then return 0 end
        local src = ESXFunctions.getUserSource(user_id)
        if not src then return 0 end
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return 0 end
        local count = xPlayer.getInventoryItem(item).count
        return count or 0
    end,
    
    tryGetInventoryItem = function(user_id, item, amount)
        if not ESX then return false end
        local src = ESXFunctions.getUserSource(user_id)
        if not src then return false end
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
        local xItem = xPlayer.getInventoryItem(item)
        if xItem.count >= amount then
            xPlayer.removeInventoryItem(item, amount)
            return true
        end
        return false
    end,
    
    giveInventoryItem = function(user_id, item, amount)
        if not ESX then return false end
        local src = ESXFunctions.getUserSource(user_id)
        if not src then return false end
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
        xPlayer.addInventoryItem(item, amount)
        return true
    end,
    
    getInventoryWeight = function(user_id)
        if not ESX then return 0 end
        local src = ESXFunctions.getUserSource(user_id)
        if not src then return 0 end
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return 0 end
        return xPlayer.getInventoryWeight()
    end,
    
    getInventoryMaxWeight = function(user_id)
        if not ESX then return 0 end
        local src = ESXFunctions.getUserSource(user_id)
        if not src then return 0 end
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return 0 end
        return xPlayer.getMaxWeight()
    end,
    
    getItemWeight = function(item)
        if not ESX then return 0 end
        -- Retornar peso padrão ou buscar da config
        return 0.5
    end,
    
    sendLog = function(webhook, message)
        local embed = {
            {
                ["color"] = 3447003,
                ["title"] = "Sistema de Craft",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = os.date("%d/%m/%Y %H:%M:%S")
                }
            }
        }
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "Craft System", embeds = embed}), {['Content-Type'] = 'application/json'})
    end,
    
    getSData = function(key)
        if not ESX then return nil end
        local result = MySQL.scalar.await('SELECT value FROM storage WHERE `key` = ?', {key})
        return result or nil
    end,
    
    setSData = function(key, value)
        if not ESX then return end
        MySQL.Async.execute('REPLACE INTO storage (`key`, `value`) VALUES (?, ?)', {key, value})
    end,
    
    prepare = function(query, name)
        return true
    end,
    
    query = function(query, params)
        if not ESX then return {} end
        return MySQL.query.await(query, params)
    end,
    
    execute = function(query, params)
        if not ESX then return end
        MySQL.Async.execute(query, params)
    end
}

-- Selecionar o framework ativo
local FrameworkFunctions = nil

if Framework == 'vrp' then
    FrameworkFunctions = VRPFunctions
    print('[CRAFT] Framework VRP detectado e configurado.')
elseif Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
    if QBCore then
        FrameworkFunctions = QBCoreFunctions
        print('[CRAFT] Framework QBCore detectado e configurado.')
    else
        print('[CRAFT] ERRO: QBCore não encontrado!')
    end
elseif Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
    if ESX then
        FrameworkFunctions = ESXFunctions
        print('[CRAFT] Framework ESX detectado e configurado.')
    else
        print('[CRAFT] ERRO: ESX não encontrado!')
    end
else
    print('[CRAFT] ERRO: Framework desconhecido! Usando VRP como fallback.')
    FrameworkFunctions = VRPFunctions
end

-- ============================================================================
-- INVENTORY WRAPPERS
-- ============================================================================

local InventoryFunctions = {}

-- VRP Inventory (padrão)
local VRPIventory = {
    getAmount = function(user_id, item)
        return FrameworkFunctions.getInventoryItemAmount(user_id, item)
    end,
    removeItem = function(user_id, item, amount)
        return FrameworkFunctions.tryGetInventoryItem(user_id, item, amount)
    end,
    addItem = function(user_id, item, amount)
        return FrameworkFunctions.giveInventoryItem(user_id, item, amount)
    end,
    getWeight = function(user_id)
        return FrameworkFunctions.getInventoryWeight(user_id)
    end,
    getMaxWeight = function(user_id)
        return FrameworkFunctions.getInventoryMaxWeight(user_id)
    end,
    getItemWeight = function(item)
        return FrameworkFunctions.getItemWeight(item)
    end
}

-- ox_inventory
local OxInventory = {
    getAmount = function(user_id, item)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local exportsOx = exports.ox_inventory
        if exportsOx then
            local items = exportsOx:GetInventoryItems(src)
            for _, invItem in pairs(items) do
                if invItem.name == item then
                    return invItem.count or 0
                end
            end
        end
        return 0
    end,
    removeItem = function(user_id, item, amount)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return false end
        local exportsOx = exports.ox_inventory
        if exportsOx then
            return exportsOx:RemoveItem(src, item, amount)
        end
        return false
    end,
    addItem = function(user_id, item, amount)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return false end
        local exportsOx = exports.ox_inventory
        if exportsOx then
            return exportsOx:AddItem(src, item, amount)
        end
        return false
    end,
    getWeight = function(user_id)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local exportsOx = exports.ox_inventory
        if exportsOx then
            local weight = exportsOx:GetWeight(src)
            return weight or 0
        end
        return 0
    end,
    getMaxWeight = function(user_id)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local exportsOx = exports.ox_inventory
        if exportsOx then
            local maxWeight = exportsOx:GetMaxWeight(src)
            return maxWeight or 100000
        end
        return 100000
    end,
    getItemWeight = function(item)
        local exportsOx = exports.ox_inventory
        if exportsOx then
            local items = exportsOx:Items()
            if items[item] and items[item].weight then
                return items[item].weight
            end
        end
        return 0.5
    end
}

-- qs_inventory
local QSInventory = {
    getAmount = function(user_id, item)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            local itemData = Player.Functions.GetItemByName(item)
            return itemData and itemData.amount or 0
        end
        return 0
    end,
    removeItem = function(user_id, item, amount)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return false end
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.RemoveItem(item, amount)
        end
        return false
    end,
    addItem = function(user_id, item, amount)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return false end
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.Functions.AddItem(item, amount)
        end
        return false
    end,
    getWeight = function(user_id)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.money.load or 0
        end
        return 0
    end,
    getMaxWeight = function(user_id)
        local src = FrameworkFunctions.getUserSource(user_id)
        if not src then return 0 end
        local Player = QBCore and QBCore.Functions.GetPlayer(src)
        if Player then
            return Player.PlayerData.money.maxweight or 100000
        end
        return 100000
    end,
    getItemWeight = function(item)
        local items = QBCore and QBCore.Shared.Items
        return items and items[item] and items[item].weight or 0.5
    end
}

-- Selecionar o inventário ativo
if InventoryType == 'vrp' then
    InventoryFunctions = VRPIventory
    print('[CRAFT] Inventário VRP detectado e configurado.')
elseif InventoryType == 'ox_inventory' then
    InventoryFunctions = OxInventory
    print('[CRAFT] Inventário ox_inventory detectado e configurado.')
elseif InventoryType == 'qs_inventory' then
    InventoryFunctions = QSInventory
    print('[CRAFT] Inventário qs_inventory detectado e configurado.')
elseif InventoryType == 'custom' then
    InventoryFunctions = Config.CustomInventory
    print('[CRAFT] Inventário Custom configurado.')
else
    print('[CRAFT] Aviso: Inventário não configurado! Usando VRP como padrão.')
    InventoryFunctions = VRPIventory
end

-- ============================================================================
-- EXPORTAR FUNÇÕES PARA USO NO SISTEMA
-- ============================================================================

-- Framework Functions
function GetFramework()
    return {
        hasPermission = function(user_id, permission)
            return FrameworkFunctions.hasPermission(user_id, permission)
        end,
        getUserId = function(source)
            return FrameworkFunctions.getUserId(source)
        end,
        getUserSource = function(user_id)
            return FrameworkFunctions.getUserSource(user_id)
        end,
        getUsersByPermission = function(permission)
            return FrameworkFunctions.getUsersByPermission(permission)
        end,
        sendLog = function(webhook, message)
            return FrameworkFunctions.sendLog(webhook, message)
        end,
        prepare = function(query, name)
            return FrameworkFunctions.prepare(query, name)
        end,
        query = function(query, params)
            return FrameworkFunctions.query(query, params)
        end,
        execute = function(query, params)
            return FrameworkFunctions.execute(query, params)
        end,
        getSData = function(key)
            return FrameworkFunctions.getSData(key)
        end,
        setSData = function(key, value)
            return FrameworkFunctions.setSData(key, value)
        end
    }
end

-- Inventory Functions
function GetInventory()
    return {
        getAmount = function(user_id, item)
            return InventoryFunctions.getAmount(user_id, item)
        end,
        removeItem = function(user_id, item, amount)
            return InventoryFunctions.removeItem(user_id, item, amount)
        end,
        addItem = function(user_id, item, amount)
            return InventoryFunctions.addItem(user_id, item, amount)
        end,
        getWeight = function(user_id)
            return InventoryFunctions.getWeight(user_id)
        end,
        getMaxWeight = function(user_id)
            return InventoryFunctions.getMaxWeight(user_id)
        end,
        getItemWeight = function(item)
            return InventoryFunctions.getItemWeight(item)
        end
    }
end

print('[CRAFT] Core de compatibilidade carregado! Framework: ' .. Framework .. ' | Inventário: ' .. InventoryType)