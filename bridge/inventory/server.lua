Inventory = {}

-- Framework
function GetPlayerFromId(source)
    if GetResourceState('es_extended') == 'started' then
        return ESX.GetPlayerFromId(source)
    elseif GetResourceState('qb-core') == 'started' then
        return QBCore.Functions.GetPlayer(source)
    end
end

function getInventory(player)
    if GetResourceState('es_extended') == 'started' then
        return player.getInventory()
    elseif GetResourceState('qb-core') == 'started' then
        return player.PlayerData.items
    end
end

if GetResourceState('ox_inventory') == 'started' then
    Inventory.GetWeapon = function(source, name)
        local data = exports.ox_inventory:GetCurrentWeapon(source)
        if data then
            return 1, data
        else
            return 0
        end
    end

    Inventory.AddWeapon = function(source, data)
        -- Assuming 'data.metadata' contains the weapon's ammo count
        exports.ox_inventory:AddItem(source, data.weapon, 1, data.metadata)
    end

    Inventory.RemoveWeapon = function(source, data)
        exports.ox_inventory:RemoveItem(source, data.weapon, 1, data.metadata, data.slot)
    end

    Inventory.CreateWeaponData = function(source, data, weaponData)
        for k, v in pairs(weaponData) do
            data[k] = v
        end
        return data
    end
elseif GetResourceState('qb-inventory') == 'started' then
    Inventory.PlayerWeapons = {}

    Inventory.GetWeapon = function(source, name)
        local data = Inventory.PlayerWeapons[source]

        local Player = QBCore.Functions.GetPlayer(source)
        local items = Player.PlayerData.items
        if items[data.slot] then
            if items[data.slot].name == data.name then
                return 1, items[data.slot]
            end
        end
        return 0
    end

    Inventory.AddWeapon = function(source, data)
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem(data.name, 1, data.slot, data.info)
    end

    Inventory.RemoveWeapon = function(source, data)
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveItem(data.name, 1, data.slot)
    end

    Inventory.CreateWeaponData = function(source, data, weaponData)
        for k, v in pairs(weaponData) do
            data[k] = v
        end
        return data
    end

    RegisterNetEvent('pickle_weaponthrowing:SetCurrentWeapon', function(weaponData)
        local source = source
        Inventory.PlayerWeapons[source] = weaponData
    end)
elseif GetResourceState('qs-inventory') == 'started' then
    Inventory.PlayerWeapons = {}

    Inventory.GetWeapon = function(source, name)
        local data = exports['qs-inventory']:GetCurrentWeapon(source)
        if data then
            return 1, data
        else
            return 0
        end
    end

    Inventory.AddWeapon = function(source, data)
        exports['qs-inventory']:AddItem(source, data.name, 1, data.slot, data.info)
    end

    Inventory.RemoveWeapon = function(source, data)
        exports['qs-inventory']:RemoveItem(source, data.name, 1, data.slot, nil)
    end

    Inventory.CreateWeaponData = function(source, data, weaponData)
        for k, v in pairs(weaponData) do
            data[k] = v
        end
        return data
    end
elseif GetResourceState('core_inventory') == 'started' then
    Inventory.PlayerWeapons = {}

    Inventory.GetWeapon = function(source, name)
        local data = Inventory.PlayerWeapons[source]
        if data then
             return 1, data
        else
            return 0
        end
    end

    Inventory.CreateWeaponData = function(source, data, weaponData)
        for k,v in pairs(weaponData) do
            data[k] = v
        end
        return data
    end

    Inventory.AddWeapon = function(source, data)
        local result = exports.core_inventory:addItem(source, data.name, 1, data.metadata, 'content')
        if result then
            TriggerClientEvent('core_inventory:client:notification', source, data.name, 'add', 1)
        end
        return result
    end

    Inventory.RemoveWeapon = function(source, data)
        local result = exports.core_inventory:removeItem(data.currentInventory, data.name, 1, nil)
        if result then
            TriggerClientEvent('core_inventory:client:notification', source, data.name, 'remove', 1)
            TriggerClientEvent('core_inventory:client:inventoryCleared', source, data.currentInventory)
        end
        return result
    end

    RegisterNetEvent('pickle_weaponthrowing:SetCurrentWeapon', function(weaponData, weaponInventory)
        local source = source
        if weaponData then
            weaponData.defaultData = weaponData
            weaponData.currentInventory = weaponInventory
            weaponData.weapon = weaponData.name
        end
        Inventory.PlayerWeapons[source] = weaponData
    end)
end
