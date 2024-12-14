if GetResourceState('qb-inventory') == 'started' then
    RegisterNetEvent('inventory:client:UseWeapon', function(weaponData, shootbool)
        TriggerServerEvent("pickle_weaponthrowing:SetCurrentWeapon", weaponData)
    end)
end

if GetResourceState('core_inventory') == 'started' then
    RegisterNetEvent('core_inventory:client:handleWeapon', function(currentWeapon, currentWeaponData, currentWeaponInventory)
        TriggerServerEvent("pickle_weaponthrowing:SetCurrentWeapon", currentWeaponData, currentWeaponInventory)
    end)
end
