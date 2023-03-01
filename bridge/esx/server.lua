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
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(name)
    if item ~= nil then 
        return item.count
    else
        return 0
    end
end

function AddWeapon(source, name) 
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.addInventoryItem(name, 1)
end

function RemoveWeapon(source, name) 
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.removeInventoryItem(name, 1)
end