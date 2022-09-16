fx_version 'adamant'
game 'gta5'

ui_page "API/html/index.html"

files {
    "API/html/index.html",
    "API/html/*.css",
    "API/html/scripts/listener.js",
    "API/html/scripts/SoundPlayer.js",
    "API/html/scripts/functions.js",
    "API/html/diplayLogo.js",
    "API/html/dysplay-screen.js",
    "API/html/toastr.min.js",
    "API/html/img/*.png",
    "API/html/music.mp3",
}

client_scripts {
    "API/client/*.lua",
}

shared_scripts {
    "modules/Illegal/Braquage/shared/*.lua",
    "modules/Property/shared/*.lua",
    "modules/Vehicle/Essence/shared/*.lua",
    "modules/Vehicle/Persistence/shared/*.lua",
    "modules/Job/**/shared/*.lua",
    "Anticheat/shared/*.lua",
}

client_scripts {
    -- RageUI
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    -- Config Banque
    "config.lua",
    -- Anticheat
    "Anticheat/client/*.lua",
    -- System server
    "modules/System/**/*_cl.lua",
    -- Protection events system
    "modules/ProtectEvent/**/*_cl.lua",
    -- Admin system
    "modules/Admin/client/*.lua",
    -- Boutique system
    "modules/Boutique/client/*.lua",
    -- Bank system
    "modules/Bank/client/*.lua",
    -- Call system
    "modules/Call/client/*.lua",
    -- Job system
        "modules/Job/refreshJob.lua",
        "modules/Job/**/client/*.lua",
    -- Shops system
        -- Accessories system
        "modules/Shops/Accessories/client/*.lua",
        -- Barbier
        "modules/Shops/Barber/client/*.lua",
        -- Clothes
        "modules/Shops/Clothes/client/*.lua",
        -- Ammunation 
        "modules/Shops/Ammunation/client/*.lua",
        -- Location 
        "modules/Shops/Location/client/*.lua",
        -- Store
        "modules/Shops/Store/client/*.lua",
        -- Tattoo
        "modules/Shops/Tattoo/client/*.lua",
    -- Activity legal system
        -- Chasse
        "modules/Activity/Chasse/Client/*.lua",
        -- Boxe 
        --"modules/Activity/Boxe/Client/*.lua",
        -- Karting 
        "modules/Activity/Karting/client/*.lua",
        -- Casino
        --"modules/Activity/Casino/client/*.lua",
        -- Pêche
        "modules/Activity/Peche/client/*.lua",
        -- Orpaillage
        "modules/Activity/Orpaillage/client/*.lua",
        -- Golf
        "modules/Activity/Golf/client/*.lua",
        -- Reseller
        "modules/Reseller/**/client.lua",
    -- Illegal system
        -- Braquage 
        "modules/Illegal/Braquage/client/*.lua",
        -- Drugs Sell 
        "modules/Illegal/Drugs/sellnpc_cl.lua",
        -- Blanchiment
        "modules/Illegal/Blanchiment/*_cl.lua",
        -- Laboratoire 
        "modules/Illegal/Laboratoire/client/*.lua",
        -- -- AutoEvent 
        "modules/Illegal/AutoEvent/client/*.lua",
        -- Menu F7
        "modules/Illegal/MenuGang/client/*.lua",
    -- Garage system
        -- Garage
        "modules/Garage/client/*.lua",
    -- Property system
        -- Property
        "modules/Property/client/*.lua",
    -- Emote system
        -- Emote
        "modules/Emotes/client/*.lua",
    -- Personnal system
        -- Identite 
        "modules/Personnal/Identite/client/*.lua",
        -- Menu 
        "modules/Personnal/Menu/client/*.lua",
        -- Billing system
        "modules/Billing/client/*.lua",
        -- Item 
        "modules/Personnal/Item/client/*.lua",
        -- Society 
        "modules/Personnal/Society/client/*.lua",
    -- Vehicle system
        -- Coffre 
        "modules/Vehicle/Coffre/client/*.lua",
        -- Essence
        "modules/Vehicle/Essence/client/*.lua",
        -- Lavage
        "modules/Vehicle/Lavage/client/*.lua",
        -- Persistence
        "modules/Vehicle/Persistence/client/*.lua",
        -- Damage
        "modules/Vehicle/Damage/client/*.lua",
    -- World system
        -- Ped
        "modules/World/Ped/client/*.lua",
        "modules/World/Ped/World/*.lua",
        -- Sneaky
        "modules/World/Sneaky/client/*.lua",
        -- Creator
        "modules/World/Creator/client/*.lua",
        -- Meteo
        "modules/World/Meteo/client/*.lua",
        -- Blip 
        "modules/World/Blip/client/*.lua",

        "modules/World/Xp/client/*.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    -- Config Banque 
    "config.lua",
    -- Anticheat
    "Anticheat/server/*.lua",
    -- System server
    "modules/System/**/*_sv.lua",
    -- Protection events system
    "modules/ProtectEvent/**/*_sv.lua",
    -- Admin system
    "modules/Admin/server/*.lua",
    -- Boutique system
    "modules/Boutique/server/*.lua",
    -- Bank system
    "modules/Bank/server/*.lua",   
    -- Call system
    "modules/Call/server/*.lua",    
    -- Job system
    "modules/Job/**/server/*.lua",
    -- Garage system
        -- Garage
        "modules/Garage/server/*.lua",
        -- Emote
        "modules/Emotes/server/*.lua",
    -- Property system
        -- Property
        "modules/Property/server/*.lua",
        "modules/Property/server/objects/*.lua",
    -- Shops system
        -- Accessories system
        "modules/Shops/Accessories/server/*.lua",
        -- Barbier
        "modules/Shops/Barber/server/*.lua",
        -- Clothes
        "modules/Shops/Clothes/server/*.lua",
        -- Ammunation 
        "modules/Shops/Ammunation/server/*.lua",
        -- Location 
        "modules/Shops/Location/server/*.lua",
        -- Store 
        "modules/Shops/Store/server/*.lua",
        -- Tattoo 
        "modules/Shops/Tattoo/server/*.lua",
    -- Personnal system
        -- Identite 
        "modules/Personnal/Identite/server/*.lua",
        -- Billing system
        "modules/Billing/server/*.lua",
        -- Item 
        "modules/Personnal/Item/server/*.lua",
        -- Society 
        "modules/Personnal/Society/server/*.lua",
    -- Activity legal system
        -- Chasse
        "modules/Activity/Chasse/Server/*.lua",
        -- Boxe
        --"modules/Activity/Boxe/Server/*.lua",
        -- Karting
        "modules/Activity/Karting/server/*.lua",
        -- Casino
        --"modules/Activity/Casino/server/*.lua",
        -- Peche
        "modules/Activity/Peche/server/*.lua",
        -- Orpaillage
        "modules/Activity/Orpaillage/server/*.lua",
        -- Golf
        "modules/Activity/Golf/server/*.lua",
        -- Reseller
        "modules/Reseller/**/server.lua",
    -- Illegal system
        -- Braquage 
        "modules/Illegal/Braquage/server/*.lua",
        -- Drugs Sell 
        "modules/Illegal/Drugs/sellnpc_sv.lua",
        -- Blanchiment
        "modules/Illegal/Blanchiment/*_sv.lua",
        -- Laboratoire 
        "modules/Illegal/Laboratoire/server/*.lua",
        -- AutoEvent 
        --"modules/Illegal/AutoEvent/server/*.lua",   
        -- Menu F7
        "modules/Illegal/MenuGang/server/*.lua",
    -- Vehicle system
        -- Coffre 
        "modules/Vehicle/Coffre/server/*.lua",
        -- Essence 
        "modules/Vehicle/Essence/server/*.lua",
        -- Lavage 
        "modules/Vehicle/Lavage/server/*.lua",
        -- Persistence 
        "modules/Vehicle/Persistence/server/*.lua",
    -- World system
        -- Sneaky
        "modules/World/Sneaky/server/*.lua",
        -- Creator
        "modules/World/Creator/server/*.lua",
        -- Meteo
        "modules/World/Meteo/server/*.lua",

        "modules/World/Xp/server/*.lua",
}

exports {
    "GetIdentity",
    "GetStreetLabel",
    "GetVIP",
    "ProgressBar",
    "ProgressBarExists",
    "CheckService",
    "CheckServiceMecano",
    "DrawText3DMe",
    "TriggerPlayerEvent",
    "CheckServiceHarmony",
    "GetStateFishing",
    "getRessource",
    "GetSpecateBoolStaff",
    "GetNearbyPlayer",
    "OpenCloseVehicle",
    "GetStatutComa"
}

server_exports {
    "GetIdentityServer",
    "GetVIP",
    "banPlayerAC",
    "SendLogs"
}