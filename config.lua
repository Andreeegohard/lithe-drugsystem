


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

ServerConfig = {
    ESX = 'old', -- Select 'old' or 'new' depending on your ESX version (1.8.5 or higher)
    Notify = 'ox', -- Choose 'ox' or 'esx' based on your preferred notify system
    PoliceJob = 'police', -- Specify the preferred job name for police
    PoliceRequired = 0, -- Number of police required for certain actions
    TimeForHarvest = 5000, -- Time in milliseconds for harvesting actions
    TimeForProcess = 10000,
    EffectsDuration = 20000, -- Time in milliseconds for effects of drugs
}

DrugDealerConfig = {
    DrugDealer = true, -- Enable/disable drug dealer NPC
    DrugDealerCoords = vector3(-1308.563, -1318.094, 3.904876), -- Coordinates of the drug dealer NPC
    DrugDealerModel = 's_m_y_dealer_01', -- Model of the drug dealer NPC
    DrugDealerBlip = true, -- Enable/disable blip for drug dealer

    DrugDealerBlipConfig = {
        sprite = 140,  -- Blip sprite (1 = standard GTA blip type)
        color = 1,  -- Blip color (29 = yellow)
        scale = 0.8, -- Blip scale
        name = "Drug Dealer", -- Blip name
    },

    DrugDealerItems = {
        { name = 'LSD Blotters', item = 'lsd_paper', icon = 'fa-solid fa-tablets', price = 750 },       
        { name = 'Cocaine', item = 'cocaine_strip', icon = 'fa-solid fa-cannabis', price = 600 },          
        { name = 'Heroin', item = 'heroin', icon = 'fa-solid fa-syringe', price = 600 },           
        { name = 'Methamphetamine', item = 'meth', icon = 'fa-solid fa-pills', price = 450 },  
        { name = 'Codeine', item = 'lean', icon = 'fa-solid fa-prescription-bottle-medical', price = 500 },  
    }
}

CannabisDispensaryConfig = {
    CannabisDispensaryShop = true, -- Enable/disable cannabis dispensary NPC
    CannabisDispensaryShopCoords = vector3(377.61, -826.7293, 28.30224), -- Coordinates of the cannabis dispensary NPC
    CannabisDispensaryShopModel = 'a_m_y_beach_02', -- Model of the cannabis dispensary NPC
    CannabisDispensaryShopBlip = true, -- Enable/disable blip for cannabis dispensary

    CannabisDispensaryBlipConfig = {
        sprite = 140,  -- Blip sprite (1 = standard GTA blip type)
        color = 2,  -- Blip color (29 = yellow)
        scale = 0.8, -- Blip scale
        name = "Cannabis Dispensary", -- Blip name
    },

    CannabisDispensaryShopItems = {
        { name = 'Banana Kush', item = 'banana_kush', icon = 'fa-solid fa-cannabis', price = 500 },       
        { name = 'Joint', item = 'joint', icon = 'fa-solid fa-cannabis', price = 500 },          
    }
}

DrugsHarvestConfig = {
    ['Marijuana'] = { 
        coords = vector3(2222.062, 5576.698, 53.81032), -- Coordinates for harvesting marijuana
        item = 'marijuana', -- Placeholder for item (seems incorrect for context)
        icon = 'fa-solid fa-cannabis', -- Icon for the harvested item
        count = 1, -- Amount of items harvested
        animation = 'amb@prop_human_bum_bin@base', -- Animation played during harvesting
    },
    ['example'] = { 
        coords = vector3(200, 500, 20), -- Coordinates for harvesting marijuana
        item = 'item_name', -- Placeholder for item (seems incorrect for context)
        icon = 'fa-solid fa-cannabis', -- Icon for the harvested item
        count = 1, -- Amount of items harvested
        animation = 'amb@prop_human_bum_bin@base', -- Animation played during harvesting
    },
}


DrugsProcessConfig = {
    ['Cannabis'] = {
        coords = vector3(382.4219, -816.6145, 29.30419), -- Coordinates for harvesting marijuana
        item_harvested = 'marijuana', -- Item required for processing
        item_processed = 'illegal_joint', -- Item given after processing
        icon = 'fa-solid fa-cannabis', -- Icon for the process point
        count_harvested_needed = 2, -- Amount of items required to process
        count_processed_given = 1, -- Amount of items given after processing
        animation = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', -- Animation played during processing
    },
    ['Example'] = {
        coords = vector3(382.4219, -816.6145, 29.30419), -- Coordinates for harvesting marijuana
        item_harvested = 'item_name_example', -- Item required for processing
        item_processed = 'item_name_example', -- Item given after processing
        icon = 'fa-solid fa-cannabis', -- Icon for the process point
        count_harvested_needed = 2, -- Amount of items required to process
        count_processed_given = 1, -- Amount of items given after processing
        animation = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', -- Animation played during processing
    },
}

LangConfig = {
    harvest = 'Harvest Suspicious Plants', -- Displayed when a player needs to harvest a drug
    speak_with_drugdealer = 'Speak with Billy',
    title_drugdealer = 'Drug Dealer',
    suggestions_for_drugdealer_menu = 'Pssst... What do you need?',
    selldrugs_to_drugdealer = 'Sell your drugs to Billy',
    drugdealer_shop = 'Billy\'s Secret Shop',
    money_received_drugdealer = 'You received: ',
    no_drugs_to_sell_drugdealer = 'You don\'t have enough drugs with you',
    title_shop_drugdealer = 'Billy\'s Shop Menu',
    you_purchased_drugdealer = 'You purchased: ',
    you_have_no_money = 'You don\'t have enough money for: ',
    speak_with_cannabisseller = 'Speak with Timmy',
    title_cannabisseller = 'Cannabis Dispenser',
    name_cannabisseller = 'Timmy',
    you_purchased_cannabisseller = 'You purchased: ',
    confirm_action_dialog = 'By pressing confirm, you can\'t go back. Do you still want to proceed?',
    invalid_item = 'Invalid item selected',
    notenough_police = 'Insufficient police presence',
    you_stopped_doing_something = 'You stopped.',
    process_drug = 'Process the drugs',
    you_have_processed = 'You have processed',
    not_enough_to_process = 'You dont have enough',
}




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
