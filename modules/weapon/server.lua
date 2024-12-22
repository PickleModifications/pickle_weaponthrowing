local ThrownWeapons = {}

RegisterNetEvent("pickle_weaponthrowing:throwWeapon", function(data)
    local source = source
    local count, weaponData = GetWeapon(source, data.weapon)
    if count < 1 then return end
    local weaponID = nil
    repeat
        weaponID = os.time() .. "_" .. math.random(1000, 9999)
    until not ThrownWeapons[weaponID] 
    -- Now include ammo count in the weapon data
    local weaponInfo = CreateWeaponData(source, data, weaponData)
    weaponInfo.ammo = data.ammo -- Store ammo count from the client
    ThrownWeapons[weaponID] = weaponInfo
    RemoveWeapon(source, ThrownWeapons[weaponID])
    TriggerClientEvent("pickle_weaponthrowing:setWeaponData", -1, weaponID, data)
end)

RegisterNetEvent("pickle_weaponthrowing:pickupWeapon", function(weaponID) 
    local source = source
    if not ThrownWeapons[weaponID] then return end
    local entity = NetworkGetEntityFromNetworkId(ThrownWeapons[weaponID].net_id)
    DeleteEntity(entity)
    -- Ensure AddWeapon now accounts for the ammo count
    AddWeapon(source, ThrownWeapons[weaponID])
    ThrownWeapons[weaponID] = nil
    TriggerClientEvent("pickle_weaponthrowing:setWeaponData", -1, weaponID, nil)
end)


RegisterNetEvent("pickle_weaponthrowing:pickupWeapon", function(weaponID) 
    local source = source
    if not ThrownWeapons[weaponID] then return end
    local entity = NetworkGetEntityFromNetworkId(ThrownWeapons[weaponID].net_id)
    DeleteEntity(entity)
    AddWeapon(source, ThrownWeapons[weaponID])
    ThrownWeapons[weaponID] = nil
    TriggerClientEvent("pickle_weaponthrowing:setWeaponData", -1, weaponID, nil)
end)

AddEventHandler("onResourceStop", function(name) 
    if (GetCurrentResourceName() ~= name) then return end
    for k,v in pairs(ThrownWeapons) do 
        DeleteEntity(NetworkGetEntityFromNetworkId(v.net_id))
    end
end)