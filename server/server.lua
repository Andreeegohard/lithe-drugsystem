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

-- Check ESX Function Server-side
-- If you touch then you fucking chimpanzee
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

-- Triggers Function For Drugs
-- Dont touch or you a fucking bastard
RegisterNetEvent("lithe-drugs:harvest")
AddEventHandler("lithe-drugs:harvest", function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not xPlayer then
        print("Error: Player data not found for source " .. _source)
        return
    end

    local requiredJob = ServerConfig.PoliceJob 
    local requiredPoliceCount = ServerConfig.PoliceRequired 

    local function countOnlinePlayersWithJob(job)
        local count = 0
        for _, player in ipairs(GetPlayers()) do
            local playerPed = GetPlayerPed(player)
            local playerXPlayer = ESX.GetPlayerFromId(player)

            if playerXPlayer and playerXPlayer.job.name == job then
                count = count + 1
            end
        end
        return count
    end

    local policeOnline = countOnlinePlayersWithJob(requiredJob)

    if policeOnline >= (requiredPoliceCount or 0) then
        -- Allow the player to harvest
        xPlayer.addInventoryItem(item, 1)
        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', _source, LangConfig.harvest)
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'Drug System',
                description = LangConfig.harvest,
                type = 'success'
            })
        end
    else
        -- Notify player that there are not enough police online
        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', _source, LangConfig.notenough_police)
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'Drug System',
                description = LangConfig.notenough_police,
                type = 'error'
            })
        end
    end
end)

-- Functions for Drugs
-- if you touch then you are a fucking monkey that eats shit
RegisterNetEvent("selldrugs:drugdealer")
AddEventHandler("selldrugs:drugdealer", function()
    local playerId = source
    SellDrugsToDrugdealer(playerId)
end)


function SellDrugsToDrugdealer(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer then return end

    local totalItemsRemoved = 0

    for _, config in pairs(DrugsHarvestConfig) do
        local item = config['item']
        local playerItemCount = xPlayer.getInventoryItem(item).count

        if playerItemCount > 0 then
            xPlayer.removeInventoryItem(item, playerItemCount)
            totalItemsRemoved = totalItemsRemoved + playerItemCount
        end
    end

    if totalItemsRemoved > 0 then
        local moneyToGive = totalItemsRemoved * 250
        xPlayer.addMoney(moneyToGive) 

        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', playerId, LangConfig.money_received_drugdealer .. moneyToGive .. '$')
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', playerId, {
                title = 'Drug System',
                description = LangConfig.money_received_drugdealer .. moneyToGive .. '$',
                type = 'success'
            })
        end
    else
        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', playerId, LangConfig.no_drugs_to_sell_drugdealer)
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', playerId, {
                title = 'Drug System',
                description = LangConfig.no_drugs_to_sell_drugdealer,
                type = 'error'
            })
        end
    end
end  
    RegisterServerEvent('drug:purchase')
    AddEventHandler('drug:purchase', function(item, itemPrice)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
    
        print("Received purchase request for item: " .. item .. " with price $" .. itemPrice .. " from player ID " .. _source)  -- Debug print
    
        if xPlayer then
            local playerMoney = xPlayer.getMoney()
            print("Player money: $" .. playerMoney)  -- Debug print
    
            if playerMoney >= itemPrice then
                xPlayer.removeMoney(itemPrice)
                print("Removed $" .. itemPrice .. " from player ID " .. _source)  -- Debug print
                xPlayer.addInventoryItem(item, 1)
                print("Added item: " .. item .. " to player ID " .. _source)  -- Debug print
    
                if ServerConfig.Notify == 'esx' then
                    TriggerClientEvent('esx:showNotification', _source, LangConfig.you_purchased_drugdealer .. ' ' .. item .. ' for $' .. itemPrice)
                elseif ServerConfig.Notify == 'ox' then
                    TriggerClientEvent('ox_lib:notify', _source, {
                        title = 'Drug System',
                        description = LangConfig.you_purchased_drugdealer .. ' ' .. item .. ' for $' .. itemPrice,
                        type = 'success'
                    })
                end
            else
                print("Player does not have enough money")  -- Debug print
                if ServerConfig.Notify == 'esx' then
                    TriggerClientEvent('esx:showNotification', _source, LangConfig.you_have_no_money .. item)
                elseif ServerConfig.Notify == 'ox' then
                    TriggerClientEvent('ox_lib:notify', _source, {
                        title = 'Drug System',
                        description = LangConfig.you_have_no_money .. item,
                        type = 'error'
                    })
                end
            end
        else
            print('Player not found')
        end
    end)
    


RegisterNetEvent('drugProcessing:process')
AddEventHandler('drugProcessing:process', function(drug)
    local xPlayer = ESX.GetPlayerFromId(source)
    local config = DrugsProcessConfig[drug]

    if not config then
        return
    end

    local harvestedItem = config.item_harvested
    local processedItem = config.item_processed
    local requiredCount = config.count_harvested_needed
    local givenCount = config.count_processed_given

    local harvestedItemCount = xPlayer.getInventoryItem(harvestedItem).count

    if harvestedItemCount >= requiredCount then
        xPlayer.removeInventoryItem(harvestedItem, requiredCount)
        Citizen.Wait(ServerConfig.TimeForProcess)

        xPlayer.addInventoryItem(processedItem, givenCount)

        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', source, LangConfig.you_have_processed .. requiredCount .. ' ' .. harvestedItem .. ' into ' .. givenCount .. ' ' .. processedItem)
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Drug System',
                description = LangConfig.you_have_processed .. requiredCount .. ' ' .. harvestedItem .. ' into ' .. givenCount .. ' ' .. processedItem,
                type = 'success'
            })
        end
    else
        if ServerConfig.Notify == 'esx' then
            TriggerClientEvent('esx:showNotification', source, LangConfig.not_enough_to_process .. harvestedItem)
        elseif ServerConfig.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Drug System',
                description = LangConfig.not_enough_to_process .. harvestedItem,
                type = 'error'
            })
        end
        -- Triggering the client-side event to clear ped tasks
        TriggerClientEvent('drugProcessing:clearPedTasks', source)
    end
end)


RegisterCommand('clearTasks', function(source, args, rawCommand)
    TriggerClientEvent('clearPedTasks', source)
end, false)

RegisterServerEvent('cannabis:purchase')
AddEventHandler('cannabis:purchase', function(itemName, itemPrice)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local playerMoney = xPlayer.getMoney()

        if playerMoney >= itemPrice then
            -- Deduct money from player
            xPlayer.removeMoney(itemPrice)

            -- Give the item to the player
            xPlayer.addInventoryItem(itemName, 1)

            -- Inform the player
            if ServerConfig.Notify == 'esx' then
                TriggerClientEvent('esx:showNotification', _source, LangConfig.you_purchased_cannabisseller .. ' ' .. itemName .. ' for $' .. itemPrice)
            elseif ServerConfig.Notify == 'ox' then
                TriggerClientEvent('ox_lib:notify', _source, {
                    title = 'Drug System',
                    description = LangConfig.you_purchased_cannabisseller .. ' ' .. itemName .. ' for $' .. itemPrice,
                    type = 'success'
                })
            end

        else
            -- Inform the player they don't have enough money
            if ServerConfig.Notify == 'esx' then
                TriggerClientEvent('esx:showNotification', _source, LangConfig.you_have_no_money)
            elseif ServerConfig.Notify == 'ox' then
                TriggerClientEvent('ox_lib:notify', _source, {
                    title = 'Drug System',
                    description = LangConfig.you_have_no_money,
                    type = 'error'
                })
            end
        end
    else
        print('Player not found')
    end
end)


