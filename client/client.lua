--[[

██████  ██████  ██    ██  ██████  ███████ 
██   ██ ██   ██ ██    ██ ██       ██      
██   ██ ██████  ██    ██ ██   ███ ███████ 
██   ██ ██   ██ ██    ██ ██    ██      ██ 
██████  ██   ██  ██████   ██████  ███████ 
                      
            Drugs System
           Made By Andree.
  Lithe HUB: https://discord.gg/aUJq2A3EEG

]]--

-- Variables For Drugs
-- If you touch then you fucking chimpanzee
local currentAnimation = nil

-- ESX VERSION CHECK FUNCTION
-- Dont touch anything BOZO
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    if ServerConfig.ESX == 'old' then
        ESX = nil

        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        end)
    elseif ServerConfig.ESX == 'new' then
        ESX = exports["es_extended"]:getSharedObject()
    end
end)


-- Process

local drawZones = true -- Set to true to visualize zones for debugging

for drug, config in pairs(DrugsProcessConfig) do
    exports.ox_target:addBoxZone({
        coords = config.coords,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                icon = config.icon,
                label = 'Process ' .. drug,
                onSelect = function(data)
                    ExecuteCommand("_processanimazione")
                    ProcessProgressBar()
                    TriggerServerEvent('drugProcessing:process', drug)
                end,
            }
        }
    })
end
RegisterNetEvent('clearPedTasks')
AddEventHandler('clearPedTasks', function()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
end)



-- Pre-fissed Drugs
-- Dont touch dumb-ass
for drugName, config in pairs(DrugsHarvestConfig) do
    exports.ox_target:addBoxZone({
        coords = config.coords,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                icon = config.icon,
                label = 'Harvest ' .. drugName,
                onSelect = function(data)
                    ExecuteCommand("_druganimation")
                    HarvestingProgressBar()
                    TriggerServerEvent("lithe-drugs:harvest", config.item)
                end,
            }
        }
    })
end

-- Npc System 
-- If you touch then you a fat bastard monke-ass
local options = {
    {
        icon = 'fa-solid fa-mask',
        label = LangConfig.speak_with_drugdealer,
        onSelect = function(data)
            DrugDealerMenu() -- Registra il menu
            DrugDealerShopMenu() -- Registra il menu
            lib.showContext('drugdealer_menu') -- Mostra il menu
        end,
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end
    },
}

CreateThread(function()
    if DrugDealerConfig.DrugDealer then
        local model = lib.requestModel(DrugDealerConfig.DrugDealerModel)
        if not model then return end
        local npc = CreatePed(0, model, DrugDealerConfig.DrugDealerCoords, 343.0224, false, false)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetModelAsNoLongerNeeded(model)
        exports.ox_target:addLocalEntity(npc, options)
    end
end)

-- Drug dealer menu you dumb shit
-- If you touch you black
function DrugDealerMenu()
    lib.registerContext({
        id = 'drugdealer_menu',
        title = LangConfig.title_drugdealer,
        options = {
            {
                title = LangConfig.suggestions_for_drugdealer_menu,
            },
            {
                title = LangConfig.selldrugs_to_drugdealer,
                icon = 'circle',
                onSelect = function()
                    ConfirmDialogForPlayer()
                end,
            },
            {
                title = LangConfig.drugdealer_shop,
                menu = 'drugdealer_shopmenu',
                icon = 'bars'
            },
        }
    })
end

function DrugDealerShopMenu()
    local options = {
        {
            title = LangConfig.title_shop_drugdealer,
        }
    }

    if DrugDealerConfig.DrugDealerItems and type(DrugDealerConfig.DrugDealerItems) == "table" then
        for _, item in ipairs(DrugDealerConfig.DrugDealerItems) do
            if item.name and item.price and item.icon then
                table.insert(options, {
                    title = item.name,
                    description = '$' .. item.price,
                    icon = item.icon,
                    onSelect = function()
                        print("Purchasing item: " .. item.name .. " (" .. item.item .. ") for $" .. item.price)  -- Debug print
                        TriggerServerEvent('drug:purchase', item.item, item.price)
                    end,
                })
            else
                print("Warning: Invalid item found in DrugDealerItems")
            end
        end
    else
        print("Error: DrugDealerItems not found or not properly defined")
    end

    lib.registerContext({
        id = 'drugdealer_shopmenu',
        title = LangConfig.title_drugdealer,
        options = options
    })
end

-- Functions
-- If you touch your a dumb fucker
function HarvestingProgressBar()
    if lib.progressCircle({
        duration = ServerConfig.TimeForHarvest,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    }) then print("Raccolto") else print('Non raccolto') end
end

function ProcessProgressBar()
    if lib.progressCircle({
        duration = ServerConfig.TimeForProcess,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,

        },
    }) then print("Processato") else print('Non processato') end
end

function ConfirmDialogForPlayer()
    local input = lib.inputDialog(LangConfig.title_shop_drugdealer, {
        {type = 'checkbox', label = LangConfig.confirm_action_dialog},
    })

    -- Check if input is nil or false, indicating cancellation or error
    if input == nil or type(input) ~= "table" then
        print("cancel")
    else
        if input[1] then
            TriggerServerEvent("selldrugs:drugdealer")
        else
            print("cancel")  -- This branch handles cases where input is not as expected
        end
    end
end

function CreateDrugDealerBlip()
    if DrugDealerConfig.DrugDealerBlip then
        local blip = AddBlipForCoord(DrugDealerConfig.DrugDealerCoords.x, DrugDealerConfig.DrugDealerCoords.y, DrugDealerConfig.DrugDealerCoords.z)
        SetBlipSprite(blip, DrugDealerConfig.DrugDealerBlipConfig.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, DrugDealerConfig.DrugDealerBlipConfig.scale)
        SetBlipColour(blip, DrugDealerConfig.DrugDealerBlipConfig.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(DrugDealerConfig.DrugDealerBlipConfig.name)
        EndTextCommandSetBlipName(blip)
    end
end

CreateDrugDealerBlip()

function CreateCannabisDispensaryBlip()
    if CannabisDispensaryConfig.CannabisDispensaryShopBlip then
        local blip = AddBlipForCoord(CannabisDispensaryConfig.CannabisDispensaryShopCoords.x, CannabisDispensaryConfig.CannabisDispensaryShopCoords.y, CannabisDispensaryConfig.CannabisDispensaryShopCoords.z)
        SetBlipSprite(blip, CannabisDispensaryConfig.CannabisDispensaryBlipConfig.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, CannabisDispensaryConfig.CannabisDispensaryBlipConfig.scale)
        SetBlipColour(blip, CannabisDispensaryConfig.CannabisDispensaryBlipConfig.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(CannabisDispensaryConfig.CannabisDispensaryBlipConfig.name)
        EndTextCommandSetBlipName(blip)
    end
end

CreateCannabisDispensaryBlip()

-- Commands Functions
-- if you touch then you stupid as fuck
RegisterCommand('_druganimation', function()
    RequestAnimDict('amb@prop_human_bum_bin@base')
    while not HasAnimDictLoaded('amb@prop_human_bum_bin@base') do
        Citizen.Wait(100)
    end
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, 'amb@prop_human_bum_bin@base', 'base', 8.0, -8.0, -1, 49, 0, false, false, false, false)
    Citizen.Wait(ServerConfig.TimeForHarvest) 
    ClearPedTasks(playerPed)
end, false)

RegisterCommand("ferma", function()
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
end)
RegisterCommand('_processanimazione', function()
    local animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
    local animClip = 'machinic_loop_mechandplayer'
    
    -- Request the animation dictionary
    RequestAnimDict(animDict)
    -- Wait for the dictionary to load
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100)
    end
    
    -- Get the player's ped
    local playerPed = PlayerPedId()
    -- Play the animation
    TaskPlayAnim(playerPed, animDict, animClip, 8.0, -8.0, -1, 49, 0, false, false, false, false)
    
    -- Wait for the specified time (replace ServerConfig.TimeForProcess with the actual value or variable)
    Citizen.Wait(ServerConfig.TimeForProcess)
    
    -- Clear the ped's tasks
    ClearPedTasks(playerPed)
    
end, false)

local options = {
    {
        icon = 'fa-solid fa-cannabis',
        label = LangConfig.speak_with_cannabisseller,
        onSelect = function(data)
            CannabisDispensaryShopMenu()
            lib.showContext('cannabisdispensary_shopmenu')
        end,
        canInteract = function(entity, distance, coords, name, bone)
            return not IsEntityDead(entity)
        end
    },
}

CreateThread(function()
    local model = lib.requestModel(CannabisDispensaryConfig.CannabisDispensaryShopModel)
    if not model then return end
    local npc = CreatePed(0, model, CannabisDispensaryConfig.CannabisDispensaryShopCoords, 180.0224, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(model)
    exports.ox_target:addLocalEntity(npc, options)
end)
function CannabisDispensaryShopMenu()
    local options = {
        {
            title = LangConfig.title_cannabisseller,
        }
    }

    -- Check if CannabisDispensaryShopItems is defined and is a table
    if CannabisDispensaryConfig.CannabisDispensaryShopItems and type(CannabisDispensaryConfig.CannabisDispensaryShopItems) == "table" then
        for _, item in ipairs(CannabisDispensaryConfig.CannabisDispensaryShopItems) do
            if item.name and item.price and item.icon then  -- Ensure each item has an icon defined
                table.insert(options, {
                    title = item.name,
                    description = '$' .. item.price,
                    icon = item.icon,  -- Use the icon path specified in CannabisDispensaryConfig
                    onSelect = function()
                        -- Trigger server event for purchase, using item identifier
                        TriggerServerEvent('cannabis:purchase', item.item, item.price)
                    end,
                })
            else
                print("Warning: Invalid item found in CannabisDispensaryShopItems")
            end
        end
    else
        print("Error: CannabisDispensaryShopItems not found or not properly defined")
    end

    -- Register the context
    lib.registerContext({
        id = 'cannabisdispensary_shopmenu',
        title = LangConfig.name_cannabisseller,
        options = options
    })
end



RegisterCommand("leva", function()
 
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent("drugsystem:smokeeffect")
AddEventHandler("drugsystem:smokeeffect", function()
  iniziaEffettoSmoke()
end)

RegisterNetEvent("drugsystem:pilleffect")
AddEventHandler("drugsystem:pilleffect", function()
  iniziaEffettoPill()
end)

RegisterNetEvent("drugsystem:drinkeffect")
AddEventHandler("drugsystem:drinkeffect", function()
  iniziaEffettoLean()
end)


function iniziaEffettoPill()
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mp_suicide',
            clip = 'pill'
        },
        prop = {
            model = `prop_ld_flow_bottle`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    }) then  
    
        ClearPedTasksImmediately(GetPlayerPed(-1))
        SetTimecycleModifier("spectator3")
        SetPedMotionBlur(GetPlayerPed(-1), true)
        SetPedMovementClipset(GetPlayerPed(-1), "move_m@hobo@a", true)
        SetPedIsDrunk(GetPlayerPed(-1), true)
        AnimpostfxPlay("HeistCelebPass", 10000001, true)
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
    Citizen.Wait(ServerConfig.EffectsDuration)
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)

    else  if ServerConfig.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', _source, LangConfig.you_stopped_doing_something)
    elseif ServerConfig.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', _source, {
            title = 'Drug System',
            description = LangConfig.you_stopped_doing_something,
            type = 'error'
        })
    end
end
end

function iniziaEffettoSmoke()
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'switch@michael@smoking',
            clip = 'michael_smoking_loop'
        },
        prop = {
            model = `prop_ld_flow_bottle`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    }) then  
    
        ClearPedTasksImmediately(GetPlayerPed(-1))
        SetTimecycleModifier("spectator3")
        SetPedMotionBlur(GetPlayerPed(-1), true)
        SetPedMovementClipset(GetPlayerPed(-1), "move_m@hobo@a", true)
        SetPedIsDrunk(GetPlayerPed(-1), true)
        AnimpostfxPlay("HeistCelebPass", 10000001, true)
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
    Citizen.Wait(ServerConfig.EffectsDuration)
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)

    else  if ServerConfig.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', _source, LangConfig.you_stopped_doing_something)
    elseif ServerConfig.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', _source, {
            title = 'Drug System',
            description = LangConfig.you_stopped_doing_something,
            type = 'error'
        })
    end
end
end


function iniziaEffettoLean()
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'mp_player_intdrink',
            clip = 'loop_bottle'
        },
        prop = {
            model = `prop_ld_flow_bottle`,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    }) then  
    
        ClearPedTasksImmediately(GetPlayerPed(-1))
        SetTimecycleModifier("spectator3")
        SetPedMotionBlur(GetPlayerPed(-1), true)
        SetPedMovementClipset(GetPlayerPed(-1), "move_m@hobo@a", true)
        SetPedIsDrunk(GetPlayerPed(-1), true)
        AnimpostfxPlay("HeistCelebPass", 10000001, true)
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
    Citizen.Wait(ServerConfig.EffectsDuration)
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(PlayerPedId(), false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)

    else  if ServerConfig.Notify == 'esx' then
        TriggerClientEvent('esx:showNotification', _source, LangConfig.you_stopped_doing_something)
    elseif ServerConfig.Notify == 'ox' then
        TriggerClientEvent('ox_lib:notify', _source, {
            title = 'Drug System',
            description = LangConfig.you_stopped_doing_something,
            type = 'error'
        })
    end
end
end
