local Lang = EN
local ROVELT = exports["RO_Lib"]:GetData()
if Config.Framework == "ESX" then
    ESX = exports[Config.PrefixCore]:getSharedObject()

    RegisterServerEvent('Rovelt_FreeLab_finish')
    AddEventHandler('Rovelt_FreeLab_finish', function(lab, stage, target)
        local Player = ESX.GetPlayerFromId(source)
        local Drug = Config.Process[lab].Targets[target]
        local missingItems = {}
        if Drug then
            if #Drug.items[stage] > 0 then
                for k, v in pairs(Drug.items[stage]) do
                    if Player.getInventoryItem(v) == nil then
                        local TheItemMissing = Drug.amount[stage][k].. "x "..v
                        table.insert(missingItems, TheItemMissing)
                    else
                        if not (Player.getInventoryItem(v).count >= Drug.amount[stage][k]) then
                            local TheItemMissing = (Drug.amount[stage][k] - Player.getInventoryItem(v).count).. "x "..v
                            table.insert(missingItems, TheItemMissing)
                        end
                    end
                end
            end
            if #missingItems > 0 then
                TriggerClientEvent("ROVELT_FreeLabs:Client:Notify", source, "You are missing " ..table.concat(missingItems, ", "), "error", 5000)
            else
                for k, v in pairs(Drug.items[stage]) do
                    Player.removeInventoryItem(v, Drug.amount[stage][k])
                end
                for a, b in pairs(Drug.items[stage+1]) do
                    Player.addInventoryItem(b, Drug.amount[stage+1][a])
                end
                TriggerClientEvent("ROVELT_FreeLabs:Client:Notify", source, "Removed "..table.concat(Drug.items[stage], ", ").." for "..table.concat(Drug.items[stage+1], ", "), "success", 2000)
            end
        else
            print("NO DRUG SELECTED - MIGHT BE A CHEATER?")
        end
    end)
elseif Config.Framework == "QB" then
    QBCore = exports[Config.PrefixCore]:GetCoreObject()

    RegisterServerEvent('Rovelt_FreeLab_finish')
    AddEventHandler('Rovelt_FreeLab_finish', function(lab, stage, target)
        local Player = QBCore.Functions.GetPlayer(source)
        local Drug = Config.Process[lab].Targets[target]
        local missingItems = {}
        if Drug then
            if #Drug.items[stage] > 0 then
                for k, v in pairs(Drug.items[stage]) do
                    if Player.Functions.GetItemByName(v) == nil then
                        local TheItemMissing = Drug.amount[stage][k].. "x "..v
                        table.insert(missingItems, TheItemMissing)
                    else
                        if not (Player.Functions.GetItemByName(v).amount >= Drug.amount[stage][k]) then
                            local TheItemMissing = (Drug.amount[stage][k] - Player.Functions.GetItemByName(v).amount).. "x "..v
                            table.insert(missingItems, TheItemMissing)
                        end
                    end
                end
            end
            if #missingItems > 0 then
                TriggerClientEvent("ROVELT_FreeLabs:Client:Notify", source, "You are missing " ..table.concat(missingItems, ", "), "error", 5000)
            else
                for k, v in pairs(Drug.items[stage]) do
                    Player.Functions.RemoveItem(v, Drug.amount[stage][k])
                end
                for a, b in pairs(Drug.items[stage+1]) do
                    Player.Functions.AddItem(b, Drug.amount[stage+1][a])
                end
                TriggerClientEvent("ROVELT_FreeLabs:Client:Notify", source, "Removed "..table.concat(Drug.items[stage], ", ").." for "..table.concat(Drug.items[stage+1], ", "), "success", 2000)
            end
        else
            print("NO DRUG SELECTED - MIGHT BE A CHEATER?")
        end
    end)
end


--###########################################
--#########        CALLBACKS        #########
--###########################################
ROVELT.RegisterServerCallback('ROVELT_FreeLabs:server:getFreeLabs', function(source, cb)
    local info = 
    MySQL.query("SELECT * FROM rolabs", {}, function(info)
        cb(info)
    end)
end)

ROVELT.RegisterServerCallback('ROVELT_FreeLabs:server:getFreeLab', function(source, cb, id)
    local info = 
    MySQL.query("SELECT * FROM rolabs WHERE id = @id", {["@id"] = id}, function(info)
        cb(info)
    end)
end)


--###########################################
--##########        EVENTS        ###########
--###########################################
RegisterServerEvent('ROVELT_FreeLabs:Server:CheckLabsInDB')
AddEventHandler('ROVELT_FreeLabs:Server:CheckLabsInDB', function()
    for k, v in pairs(Config.Labs) do
        MySQL.query("SELECT * FROM rolabs WHERE id = ?", {k}, function(Exist)
            if not Exist[1] then
                MySQL.insert("INSERT INTO rolabs (id, code, stash) VALUES (?, ?, ?)",{
                    k,
                    nil,
                    nil
                }, function()
                    TriggerClientEvent("ROVELT_FreeLabs:Client:UpdateLabs", -1)
                end)

            end
        end)
        Wait(0)
    end
end)

RegisterServerEvent('ROVELT_FreeLabs:server:EditCode')
AddEventHandler('ROVELT_FreeLabs:server:EditCode', function(id, Code)
    MySQL.update('UPDATE rolabs SET code = @code WHERE id = @id', {["@id"] = id, ["@code"] = Code})
    TriggerClientEvent("ROVELT_FreeLabs:Client:UpdateLabs", -1)
end)

RegisterServerEvent('ROVELT_FreeLabs:Server:EnterLab')
AddEventHandler('ROVELT_FreeLabs:Server:EnterLab', function(id, entity)
    SetPlayerRoutingBucket(source, id)
end)