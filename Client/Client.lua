local ROVELT = exports["RO_Lib"]:GetData()
if Config.Framework == "ESX" then
    ESX = exports[Config.PrefixCore]:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerLoaded = true
    end)

    
    RegisterNetEvent('esx:setJob', function(job)
        JobName = job.name
        GangName = job.name
    end)

elseif Config.Framework == "QB" then
    QBCore = exports[Config.PrefixCore]:GetCoreObject()
    
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        JobName = JobInfo.name
    end)

    RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
        GangName = GangInfo.name
    end)
end

local Labs = {}
local Lang = EN
local currentLab = {}
local Knocking = false
local nearLabID = nil
local Targets = {}
local inDruglab = false

--#########################################
--#########        EVENTS         #########
--#########################################
RegisterNetEvent('ROVELT_FreeLabs:Client:UpdateLabs', function() -- DONE
    ROVELT.TriggerServerCallback("ROVELT_FreeLabs:server:getFreeLabs",function(info)
        Labs = info
        if not inDruglab then
            nearLabID = nil
        end
    end)
    if Config.Target == "qb-target" or Config.Target == "ox_target" then
        for k,v in ipairs(Config.Labs) do
            exports['qb-target']:RemoveZone("lab-Entry"..v.Lab..""..k)
        end
    end
    updated = true
end)

AddEventHandler('onResourceStart', function(resourceName) -- DONE
    ROVELT.TriggerServerCallback("ROVELT_FreeLabs:server:getFreeLabs",function(info)
        Labs = info
        if not inDruglab then
            nearLabID = nil
        end
    end)
    updated = true
    TriggerServerEvent("ROVELT_FreeLabs:Server:CheckLabsInDB")
end)

RegisterNetEvent('ROVELT_FreeLabs:Client:Notify')
AddEventHandler('ROVELT_FreeLabs:Client:Notify', function(text, type, time)
    ROVELT.Functions.notify(text, type, time, Config.Notify)
end)

--#########################################
--#########        THREADS        #########
--#########################################
Citizen.CreateThread(function() -- Done
    local EnterText = string.format("Press [~g~%s~w~] to enter lab", Config.InteractKey)
    if Config.Target == "qb-target" or Config.Target == "ox_target" then
        if not Labs or #Labs < 0 then
            ROVELT.TriggerServerCallback("ROVELT_FreeLabs:server:getFreeLabs",function(info)
                Labs = info
                if not inDruglab then
                    nearLabID = nil
                end
            end)
            updated = true
        end
        Wait(1000)
        for k,v in ipairs(Config.Labs) do
            for a, d in pairs(Labs) do
                if a == k then
                    exports['qb-target']:AddCircleZone("lab-Entry"..v.Lab..""..k, vector3(v.pos[1],v.pos[2], v.pos[3]), 1.0, 
                    {
                        name="lab-Entry"..v.Lab..""..k,
                        debugPoly=false,
                        useZ=true,
                    },{ 
                        options = {
                            { 
                                action = function()
                                    nearLabID = {data2 = k, data3 = v, OtherData = d}
                                    if Config.Locks then
                                        if not d.code then
                                            d.code = v.Code
                                        end
                                        local Access = exports['RO_Keypad']:CheckCode(d.code, function(Access)
                                            if Access == true then
                                                currentLab = {id = k, data = v, OtherData = d}
                                                SpawnDrugLab(k, v, d)
                                                inDruglab = true
                                            elseif tonumber(Access) then
                                                if IsAccepted(v.GangOrJob) then
                                                    TriggerServerEvent("ROVELT_FreeLabs:server:EditCode", k, Access)
                                                    TriggerEvent("ROVELT_FreeLabs:Client:Notify", "You changed the code to "..Access, "success", 5000)
                                                else
                                                    TriggerEvent("ROVELT_FreeLabs:Client:Notify", "You are not authorized to do this!", "error", 5000)
                                                end
                                            elseif Access == "CANCEL" then
                                                TriggerEvent("ROVELT_FreeLabs:Client:Notify", "CANCELLED", "error", 2500)
                                            else
                                                TriggerEvent("ROVELT_FreeLabs:Client:Notify", "WRONG CODE", "error", 2500)
                                            end
                                        end)
                                    else
                                        currentLab = {id = k, data = v, OtherData = d}
                                        SpawnDrugLab(k, v, d)
                                        inDruglab = true
                                    end
                                end, 
                                icon = "fa-solid fa-flask", 
                                label = "ENTER LAB"
                            },
                        },
                        distance = 2
                    })
                end

            end
        end
    else
        while true do
            if CitizenID then
                if not Labs or #Labs < 0 then
                    ROVELT.TriggerServerCallback("ROVELT_FreeLabs:server:getFreeLabs",function(info)
                        Labs = info
                        if not inDruglab then
                            nearLabID = nil
                        end
                    end)
                    updated = true
                end
                if updated == true then
                    nearLabID = nil
                    updated = false
                end
                if not Knocking then
                    local player = GetPlayerPed(-1)
                    local coords =  GetEntityCoords(player)
                    if nearLabID == nil then
                        for k,v in ipairs(Config.Labs) do
                            local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
                            if distance <= Config.ViewDistance then
                                Wait(100)
                                for a, d in pairs(Labs) do
                                    if a == k then
                                        if not d.code then
                                            d.code = v.Code
                                        end
                                        nearLabID = {data2 = k, data3 = v, OtherData = d}
                                        break
                                    end

                                end
                                if nearLabID then
                                    break
                                end
                            else
                                if not insideShell then
                                    nearLabID = nil
                                end
                            end

                        end
                    else
                        local k = nearLabID.data2
                        local v = nearLabID.data3
                        local OtherData = nearLabID.OtherData
                        local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
                        if distance <= Config.ViewDistance then
                            DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], EnterText)
                            if IsControlJustPressed(0, Keybinds[Config.InteractKey]) then
                                local Access = nil
                                if Config.Locks then
                                    local Access = exports['RO_Keypad']:CheckCode(OtherData.code, function(Access)
                                        if Access == true then
                                            currentLab = {id = k, data = v, OtherData = OtherData}
                                            SpawnDrugLab(k, v, OtherData)
                                            inDruglab = true
                                        elseif tonumber(Access) then
                                            if IsAccepted(v.GangOrJob) then
                                                TriggerServerEvent("ROVELT_FreeLabs:server:EditCode", k, Access)
                                                TriggerEvent("ROVELT_FreeLabs:Client:Notify", "You changed the code to "..Access, "success", 5000)
                                            else
                                                TriggerEvent("ROVELT_FreeLabs:Client:Notify", "You are not authorized to do this!", "error", 5000)
                                            end
                                        elseif Access == "CANCEL" then
                                            TriggerEvent("ROVELT_FreeLabs:Client:Notify", "CANCELLED", "error", 2500)
                                        else
                                            TriggerEvent("ROVELT_FreeLabs:Client:Notify", "WRONG CODE", "error", 2500)
                                        end
                                    end)
                                else
                                    currentLab = {id = k, data = v, OtherData = OtherData}
                                    SpawnDrugLab(k, v, OtherData)
                                    inDruglab = true
                                end
                            end       
                        else
                            if not insideShell then
                                nearLabID = nil
                            end
                        end
                    end
                end
            end
            Wait(1)
        end
    end
end)

-- Get player's data.
CreateThread(function()
    while true do 
        local loaded = playerloaded()
        if loaded then
            ROVELT.TriggerServerCallback("ROVELT_FreeLabs:server:getFreeLabs",function(info)
                Labs = info
                if not inDruglab then
                    nearLabID = nil
                end
            end)
            updated = true
            if Config.Framework == "ESX" then
                XPlayer = ESX.GetPlayerData()
                CitizenID = XPlayer.identifier
                JobName = XPlayer.job.name
                GangName = XPlayer.job.name
            elseif Config.Framework == "QB" then
                XPlayer = QBCore.Functions.GetPlayerData()
                CitizenID = XPlayer.citizenid
                JobName = XPlayer.job.name
                GangName = XPlayer.gang.name
            end
            break
        end
        Wait(5000)
    end
end)


--#########################################
--########        FUNCTIONS        ########
--#########################################

function playerloaded()
    if Config.Framework == "ESX" then
        if ESX.PlayerLoaded then
            return true
        else
            return false
        end
    elseif Config.Framework == "QB" then
        if LocalPlayer.state.isLoggedIn then
            return true
        else
            return false
        end
    end
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.32, 0.32)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function LeaveLab(id, data, OtherData)
    if not lab then
        lab = data.Lab
    end
    local player = GetPlayerPed(-1)
    local emoteDict = "timetable@jimmy@doorknock@"
    local emoteName = "knockdoor_idle"
    Knocking = true
    TaskPlayAnim(player, emoteDict, emoteName, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    local progressbar = ROVELT.Functions.progressbar("LEAVING", 5000, Config.Progressbar)
    if progressbar == true then
        if Config.Target == "qb-target" or Config.Target == "ox_target" then
            for k, v in pairs(Targets) do
                exports['qb-target']:RemoveZone(v)
            end
        end
        TaskPlayAnim(player, emoteDict, emoteName, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        Wait(2500)
        SetEntityCoords(player, data.pos[1], data.pos[2], data.pos[3]-0.975)
        insideShell = false
        inDruglab = false
        TriggerServerEvent("ROVELT_FreeLabs:Server:EnterLab", 0)
        Wait(500)
        DoScreenFadeIn(1250)
        ClearPedTasks(player)  
        Knocking = false
    else
        Knocking = false
    end
end

function SpawnDrugLab(id, data, Emote) 
    print("You entered a lab made by Rovelt")
    print("https://discord.gg/Fx5tNnm3gr")
    inDruglab = true
    local player = GetPlayerPed(-1)
    local playerID = GetPlayerFromServerId(player)
    local coords = GetEntityCoords(player)
    local lab = data.Lab
    local emoteDict = "timetable@jimmy@doorknock@"
    local emoteName = "knockdoor_idle"
    RequestAnimDict(emoteDict)

    while not HasAnimDictLoaded(emoteDict) do
        Citizen.Wait(100)
    end
    Knocking = true
    TaskPlayAnim(player, emoteDict, emoteName, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    local progressbar = ROVELT.Functions.progressbar("ENTERING", 5000, Config.Progressbar)
    if progressbar == true then
        progressbar = nil
        TaskPlayAnim(player, emoteDict, emoteName, 8.0, -8.0, -1, 0, 0, 0, 0, 0)
        DoScreenFadeOut(2000)
        Citizen.Wait(3500)  
        Wait(100)
        insideShell = true
        Citizen.Wait(500)
        local entry = Config.Process[lab].locations.entry
        TriggerServerEvent("ROVELT_FreeLabs:Server:EnterLab", id)
        SetEntityCoords(player, entry.x, entry.y, entry.z)
        SetEntityHeading(player, entry.h)
        Citizen.Wait(500)
        DoScreenFadeIn(1000)
        ClearPedTasks(player)  
        Knocking = false
        local LeaveText = string.format("Press [~g~%s~w~] to leave lab", Config.InteractKey)
        if Config.Target == "qb-target" or Config.Target == "ox_target" then
                table.insert(Targets, "lab-target"..lab..""..id)
                exports['qb-target']:AddCircleZone("lab-target"..lab..""..id, entry, 1.0, 
                {
                    name="lab-target"..lab..""..id,
                    debugPoly=false,
                    useZ=true,
                },{ 
                    options = {
                        { 
                            action = function()
                                LeaveLab(id, data, OtherData)
                            end, 
                            icon = "fa-solid fa-door-open", 
                            label = "EXIT LAB"
                        },
                    },
                    distance = 2
                })
            for id, process in pairs(Config.Process[lab].Targets) do
                process.Event(id, "lab-target"..lab..""..id, process.location)
                table.insert(Targets, "lab-target"..lab..""..id)
            end
        end
        while insideShell do
            local coords =  GetEntityCoords(player)
            if not Knocking then
                if Config.Target == "none" then
                    local PCDistance = GetDistanceBetweenCoords(coords, entry, false)
                    local EntryDistance = GetDistanceBetweenCoords(coords, entry, false)
                    if EntryDistance <= Config.ViewDistance then
                        DrawText3Ds(entry.x, entry.y, entry.z, LeaveText)
                        if IsControlJustPressed(0, Keybinds[Config.InteractKey]) then
                            LeaveLab(id, data, OtherData)
                        end
                    end
                    for id, process in pairs(Config.Process[lab].Targets) do
                        local ProcessDistance = GetDistanceBetweenCoords(coords, process.location, false)
                        if ProcessDistance <= Config.ViewDistance then
                            for targetid, text in pairs(process.TextHeader3D) do
                                DrawText3Ds(process.location.x, process.location.y, ( process.location.z + (targetid * 0.08)), text.header)
                                if IsControlJustPressed(0, Keybinds[text.Key]) then
                                    process.Event(text.ID)
                                end
                            end
                        end
                    end
                end

            end
            Wait(0)
        end
    else
        Knocking = false
    end
end

function DoEmote(Remove, lab, target, stage) 
    local PED = PlayerPedId(-1)
    if not Remove then
        local TheDrug = Config.Process[lab].Targets[target]
        local Emote = TheDrug.Emotes[stage]
        local coords = GetEntityCoords(PED)
        DeleteObject(EmoteObject)
        if Emote.EmoteDict then
            RequestAnimDict(Emote.EmoteDict)
            while not HasAnimDictLoaded(Emote.EmoteDict) do
                Citizen.Wait(100)
            end
            
            EmoteObject = CreateObject(GetHashKey(Emote.prop), coords.x, coords.y, coords.z, true, true, true)
            AttachEntityToEntity(EmoteObject, PED, Emote.pedbone, Emote.xyzPos[1], Emote.xyzPos[2], Emote.xyzPos[3], Emote.xyzRot[1],Emote.xyzRot[2],Emote.xyzRot[3], true, true, false, true, 1, true)
            TaskPlayAnim(PED, Emote.EmoteDict, Emote.EmoteName, 8.0, -1, -1, 1, 0, 0, 0, 0)
        else
            TaskStartScenarioInPlace(PED, Emote.EmoteName, 0, false)
        end
    else
        DeleteObject(EmoteObject)
        ClearPedTasks(PED)
    end
end

function IsAccepted(TheJob)
    AcceptedOrNot = nil
    while AcceptedOrNot == nil do
        if Config.GangOrJob == "job" then
            if JobName == TheJob then
                AcceptedOrNot = true
            else
                AcceptedOrNot = false
            end
        elseif Config.GangOrJob == "gang" then
            if GangName == TheJob then
                AcceptedOrNot = true
            else
                AcceptedOrNot = false
            end
        else
            AcceptedOrNot = true
        end
        Wait(100)
    end
    return AcceptedOrNot
end

-- Just for the methlab :)
EnableInteriorProp(247041, "meth_lab_upgrade")
RefreshInterior(247041)