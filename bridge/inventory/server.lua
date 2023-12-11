Inventory = {}

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
        exports.ox_inventory:AddItem(source, data.weapon, 1, data.metadata, data.slot)
    end

    Inventory.RemoveWeapon = function(source, data) 
        exports.ox_inventory:RemoveItem(source, data.weapon, 1, data.metadata, data.slot)
    end

    Inventory.CreateWeaponData = function(source, data, weaponData)
        for k,v in pairs(weaponData) do 
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
        for k,v in pairs(weaponData) do 
            data[k] = v
        end
        return data
    end
	
    RegisterNetEvent('pickle_weaponthrowing:SetCurrentWeapon', function(weaponData)
        local source = source
        Inventory.PlayerWeapons[source] = weaponData
    end)	
	
elseif GetResourceState('qs-inventory') == 'started' then

    Inventory.GetWeapon = function(source, name)
		local data = exports['qs-inventory']:GetCurrentWeapon(source)	
        if data then								
			local item = exports['qs-inventory']:GetItemBySlot(source, data.slot)
			if item and item.name:lower() == name:lower() then
				exports['qs-inventory']:useItemSlot(source, item)
				return 1, item
			end	
        end
		return 0
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

end
