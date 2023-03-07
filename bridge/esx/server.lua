if GetResourceState('es_extended') ~= 'started' then return end

ESX = exports.es_extended:getSharedObject()

function RegisterCallback(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

function RegisterUsableItem(...)
    ESX.RegisterUsableItem(...)
end

function ShowNotification(target, text)
	TriggerClientEvent(GetCurrentResourceName()..":showNotification", target, text)
end

function GetWeapon(source, name)
    if Inventory.GetWeapon then return Inventory.GetWeapon(source, name) end
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(name)
    if item ~= nil then 
        return item.count
    else
        return 0
    end
end

function AddWeapon(source, data) 
    if Inventory.AddWeapon then return Inventory.AddWeapon(source, data) end
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.addInventoryItem(data.weapon, 1)
end

function RemoveWeapon(source, data) 
    if Inventory.RemoveWeapon then return Inventory.RemoveWeapon(source, data) end
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.removeInventoryItem(data.weapon, 1)
end

function CreateWeaponData(source, data, weaponData)
    if Inventory.CreateWeaponData then return Inventory.CreateWeaponData(source, data, weaponData) end
    return data
end