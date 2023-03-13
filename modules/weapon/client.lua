local ThrownWeapons = {}
local throwingWeapon = nil

function GetDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

function PerformPhysics(entity)
    local power = 25
    FreezeEntityPosition(entity, false)
    local ped = PlayerPedId()
    local rot = GetGameplayCamRot(2)
    local dir = GetDirectionFromRotation(rot)
    SetEntityHeading(entity, rot.z + 90.0)
    SetEntityVelocity(entity, dir.x * power, dir.y * power, power * dir.z)
end

function GetWeaponString(weaponHash)
    for i=1, #Config.Weapons do
        if weaponHash == GetHashKey(Config.Weapons[i]) then return Config.Weapons[i] end
    end
end

function ThrowCurrentWeapon()
    if throwingWeapon then return end
    local ped = PlayerPedId()
    local equipped, weaponHash = GetCurrentPedWeapon(ped, 1)
    local weapon = GetWeaponString(weaponHash)
    if not equipped or not weapon then return end
    throwingWeapon = true
    CreateThread(function()
        PlayAnim(ped, "melee@thrown@streamed_core", "plyr_takedown_front", -8.0, 8.0, -1, 49)
        Wait(600)
        ClearPedTasks(ped)
    end)
    Wait(550)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
    local prop = GetWeaponObjectFromPed(ped, true)
    local model = GetEntityModel(prop)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    DeleteEntity(prop)
    prop = CreateProp(model, coords.x, coords.y, coords.z, true, false, true)
    SetEntityCoords(prop, coords.x, coords.y, coords.z)
    SetEntityHeading(prop, GetEntityHeading(ped) + 90.0)
    PerformPhysics(prop)
    TriggerServerEvent("pickle_weaponthrowing:throwWeapon", {weapon = weapon, net_id = ObjToNet(prop)})
    throwingWeapon = nil
end

function OnPlayerDeath()
    if not Config.DeathDropsWeapon then return end
    local ped = PlayerPedId()
    local equipped, weaponHash = GetCurrentPedWeapon(ped, 1)
    local weapon = GetWeaponString(weaponHash)
    if not equipped or not weapon then return end
    local prop = GetWeaponObjectFromPed(ped, true)
    local model = GetEntityModel(prop)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    DeleteEntity(prop)
    prop = CreateProp(model, coords.x, coords.y, coords.z, true, false, true)
    local off, rot = vector3(0.05, 0.0, -0.085), vector3(90.0, 90.0, 0.0)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false, true, 2, true)
    DetachEntity(prop)
    TriggerServerEvent("pickle_weaponthrowing:throwWeapon", {weapon = weapon, net_id = ObjToNet(prop)})
end

RegisterCommand("throwGun", function()
    local ped = PlayerPedId()
    local equipped, weaponHash = GetCurrentPedWeapon(ped, 1)
    local weapon = GetWeaponString(weaponHash)
    if not equipped or not weapon then return end
    ThrowCurrentWeapon()
end)

RegisterKeyMapping('throwGun', 'Throw Weapon', 'keyboard', 'e')

RegisterNetEvent("pickle_weaponthrowing:setWeaponData", function(weaponID, data)
    ThrownWeapons[weaponID] = data
end)

AddEventHandler('gameEventTriggered', function(event, args)
    if event ~= "CEventNetworkEntityDamage" or GetEntityType(args[1]) ~= 1 or NetworkGetPlayerIndexFromPed(args[1]) ~= PlayerId() then return end
    if not IsEntityDead(PlayerPedId()) then return end
    OnPlayerDeath()
end)

CreateThread(function()
    while true do
        local wait = 1000
        local ped = PlayerPedId()
        if not IsPlayerDead(ped) and not IsPedInAnyVehicle(ped, true) then 
            for k,v in pairs(ThrownWeapons) do 
                if NetworkDoesNetworkIdExist(v.net_id) then 
                    local entity = NetToObj(v.net_id)
                    local coords = GetEntityCoords(entity)
                    local dist = #(GetEntityCoords(ped) - coords)
                    if dist < 5.0 then 
                        wait = 0
                        if dist < 1.25 and not ShowInteractText(_L("pickup_weapon")) and IsControlJustPressed(1, 51) then 
                            ClearPedTasksImmediately(ped)
                            FreezeEntityPosition(ped, true)
                            PlayAnim(ped, "pickup_object", "pickup_low", -8.0, 8.0, -1, 49, 1.0)
                            Wait(800)
                            TriggerServerEvent("pickle_weaponthrowing:pickupWeapon", k)
                            Wait(800)
                            ClearPedTasks(ped)
                            FreezeEntityPosition(ped, false)
                        end
                    end
                end
            end 
        end
        Wait(wait)
    end
end)
