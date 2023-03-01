if GetResourceState('qb-core') ~= 'started' then return end

QBCore = exports['qb-core']:GetCoreObject()

function RegisterCallback(name, cb)
    QBCore.Functions.CreateCallback(name, cb)
end

function RegisterUsableItem(...)
    QBCore.Functions.CreateUseableItem(...)
end

function ShowNotification(target, text)
	TriggerClientEvent(GetCurrentResourceName()..":showNotification", target, text)
end

function GetWeapon(source, name)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local item = xPlayer.Functions.GetItemByName(name)
    if item ~= nil then 
        return item.amount
    else
        return 0
    end
end

function AddWeapon(source, name) 
    local xPlayer = QBCore.Functions.GetPlayer(source)
    return xPlayer.Functions.AddItem(name, 1)
end

function RemoveWeapon(source, name) 
    local xPlayer = QBCore.Functions.GetPlayer(source)
    return xPlayer.Functions.RemoveItem(name, 1)
end