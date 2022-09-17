local MetaIntitalise = {}
local BanInfo = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    ReloadBans()
end)

function GetIdentifiersServer(source) 
    local identifiers = {}
    local playerIdentifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(playerIdentifiers) do
        local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
        identifiers[before] = playerIdentifiers[_]
    end
    return identifiers
end

function getTime(tempsrestant)
    local day        = (tempsrestant / 60) / 24
    local hrs        = (day - math.floor(day)) * 24
    local minutes    = (hrs - math.floor(hrs)) * 60
    local txtday     = math.floor(day)
    local txthrs     = math.floor(hrs)
    local txtminutes = math.ceil(minutes)

    return txtday, txthrs, txtminutes
end


local JoinCoolDown = {}
local BannedAlready = false
local isBypassing = false
local DatabaseStuff = {}

AddEventHandler('Initiate:BanSql', function(license, id, reason, name, time, perma)
    local currentTime = os.time()
    time = time * 3600
    local expiration = time + currentTime
    MySQL.Async.execute('UPDATE players_ban SET Reason = @Reason, isBanned = @isBanned, Expire = @Expire, timeat = @timeat, moderatorName = @moderatorName, permanent = @permanent WHERE License = @License', 
    {
        ['@isBanned'] = 1,
        ['@Reason'] = reason,
        ['@License'] = license,
        ['@Expire'] = expiration,
        ["@timeat"] = currentTime,
        ['@moderatorName'] = name,
        ["@permanent"] = perma
    })
    if name ~= nil then
        DropPlayer(id, "Vous avez été banni de SneakyLife\nRaison : "..reason.."\nAuteur : "..name.."\n")
    end
    SetTimeout(1500, function()
	    ReloadBans()
    end)
    MySQL.Async.execute('INSERT INTO players_banhistory (identifier,date,reason,moderator,unbandate) VALUES(@identifier,@date,@reason,@moderator,@unbandate)',
    {
        ['@identifier']   = license,
        ['@unbandate'] = expiration,
        ['@reason'] = reason,
        ['@moderator'] = name,
        ['@date'] = os.time() 
    })
    TriggerClientEvent("esx:showNotification",source, "Le joueur à bien été ~b~ban~s~~n~License : "..license)
end)

AddEventHandler('TargetPlayerIsOffline', function(license, reason, name, time, perma)
    local currentTime = os.time()
    time = time * 3600
    local expiration = time + currentTime
    MySQL.Async.fetchAll('SELECT License FROM players_ban WHERE License = @License',
    {
        ['@License'] = license

    }, function(data)
        if data[1] then
            MySQL.Async.execute('UPDATE players_ban SET Reason = @Reason, isBanned = @isBanned, Expire = @Expire, timeat = @timeat, moderatorName = @moderatorName, permanent = @permanent WHERE License = @License', 
            {
                ['@isBanned'] = 1,
                ['@Reason'] = reason,
                ['@License'] = license,
                ['@Expire'] = expiration,
                ["@timeat"] = currentTime,
                ['@moderatorName'] = name,
                ["@permanent"] = perma
            })
            MySQL.Async.execute('INSERT INTO players_banhistory (identifier,date,reason,moderator,unbandate) VALUES(@identifier,@date,@reason,@moderator,@unbandate)',
            {
                ['@identifier']   = license,
                ['@unbandate'] = expiration,
                ['@reason'] = reason,
                ['@moderator'] = name,
                ['@date'] = os.time() 
            })
            SetTimeout(1500, function()
                ReloadBans()
            end)
            if source ~= 0 then
                TriggerClientEvent("esx:showNotification",source, "Le joueur à bien été ~b~ban~s~~n~License : "..license)
            else
                print("Le joueur à bien été ~b~ban~s~~n~License : "..license)
            end
        else
            TriggerClientEvent("esx:showNotification",source, "~r~License incorrect.")
        end
    end)
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local Lice = "NONE"
    local Live = "NONE"
    local Xbox = "NONE"
    local Discord = "NONE"
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("license:")) == "license:" then
            Lice = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            Live = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            Discord = v
        end
    end
    deferrals.defer()
    local card = {
        ["type"] = "AdaptiveCard",
        ["minHeight"] = "100px",
        ["body"] = {
            {
                ["type"] = "ColumnSet",
                ["columns"] = {
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "Image",
                                ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                ["size"] = "Small"
                            }
                        },
                        ["width"] = "auto"
                    },
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "TextBlock",
                                ["weight"] = "Bolder",
                                ["text"] = "SneakyLife",
                                ["wrap"] = true
                            },
                            {
                                ["type"] = "TextBlock",
                                ["spacing"] = "None",
                                ["text"] = "https://sneakylife-store.tebex.io",
                                ["isSubtle"] = true,
                                ["wrap"] = true
                            }
                        },
                        ["width"] = "stretch"
                    }
                }
            },
            {
                ["type"] = "Container",
                ["items"] = {
                    {
                        ["type"] = "TextBlock",
                        ["horizontalAlignment"] = "Left",
                        ["text"] = "Initialisation de la connexion au serveur...",
                    },
                }
            }
        },
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.2"
    }
    deferrals.presentCard(card)
    Citizen.Wait(1000)
    if Lice == nil or Lice == "" then
        local card = {
            ["type"] = "AdaptiveCard",
            ["minHeight"] = "100px",
            ["body"] = {
                {
                    ["type"] = "ColumnSet",
                    ["columns"] = {
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "Image",
                                    ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                    ["size"] = "Small"
                                }
                            },
                            ["width"] = "auto"
                        },
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["weight"] = "Bolder",
                                    ["text"] = "SneakyLife",
                                    ["wrap"] = true
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["spacing"] = "None",
                                    ["text"] = "https://sneakylife-store.tebex.io",
                                    ["isSubtle"] = true,
                                    ["wrap"] = true
                                }
                            },
                            ["width"] = "stretch"
                        }
                    }
                },
                {
                    ["type"] = "Container",
                    ["items"] = {
                        {
                            ["type"] = "TextBlock",
                            ["horizontalAlignment"] = "Left",
                            ["text"] = "Votre license rencontre un problème, merci de relancer FiveM.",
                        },
                    }
                }
            },
            ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ["version"] = "1.2"
        }
        deferrals.presentCard(card)
        CancelEvent()
        return
    end
    local card = {
        ["type"] = "AdaptiveCard",
        ["minHeight"] = "100px",
        ["body"] = {
            {
                ["type"] = "ColumnSet",
                ["columns"] = {
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "Image",
                                ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                ["size"] = "Small"
                            }
                        },
                        ["width"] = "auto"
                    },
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "TextBlock",
                                ["weight"] = "Bolder",
                                ["text"] = "SneakyLife",
                                ["wrap"] = true
                            },
                            {
                                ["type"] = "TextBlock",
                                ["spacing"] = "None",
                                ["text"] = "https://sneakylife-store.tebex.io",
                                ["isSubtle"] = true,
                                ["wrap"] = true
                            }
                        },
                        ["width"] = "stretch"
                    }
                }
            },
            {
                ["type"] = "Container",
                ["items"] = {
                    {
                        ["type"] = "TextBlock",
                        ["horizontalAlignment"] = "Left",
                        ["text"] = "Bienvenue "..name.." sur SneakyLife...",
                    },
                }
            }
        },
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.2"
    }
    deferrals.presentCard(card)
    Citizen.Wait(1000)
    local card = {
        ["type"] = "AdaptiveCard",
        ["minHeight"] = "100px",
        ["body"] = {
            {
                ["type"] = "ColumnSet",
                ["columns"] = {
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "Image",
                                ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                ["size"] = "Small"
                            }
                        },
                        ["width"] = "auto"
                    },
                    {
                        ["type"] = "Column",
                        ["items"] = {
                            {
                                ["type"] = "TextBlock",
                                ["weight"] = "Bolder",
                                ["text"] = "SneakyLife",
                                ["wrap"] = true
                            },
                            {
                                ["type"] = "TextBlock",
                                ["spacing"] = "None",
                                ["text"] = "https://sneakylife-store.tebex.io",
                                ["isSubtle"] = true,
                                ["wrap"] = true
                            }
                        },
                        ["width"] = "stretch"
                    }
                }
            },
            {
                ["type"] = "Container",
                ["items"] = {
                    {
                        ["type"] = "TextBlock",
                        ["horizontalAlignment"] = "Left",
                        ["text"] = "Vérification de votre IP...",
                    },
                }
            }
        },
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.2"
    }
    deferrals.presentCard(card)
    if GetNumPlayerTokens(source) == 0 or GetNumPlayerTokens(source) == nil or GetNumPlayerTokens(source) < 0 or GetNumPlayerTokens(source) == "null" or GetNumPlayerTokens(source) == "**Invalid**" or not GetNumPlayerTokens(source) then
        local card = {
            ["type"] = "AdaptiveCard",
            ["minHeight"] = "100px",
            ["body"] = {
                {
                    ["type"] = "ColumnSet",
                    ["columns"] = {
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "Image",
                                    ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                    ["size"] = "Small"
                                }
                            },
                            ["width"] = "auto"
                        },
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["weight"] = "Bolder",
                                    ["text"] = "SneakyLife",
                                    ["wrap"] = true
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["spacing"] = "None",
                                    ["text"] = "https://sneakylife-store.tebex.io",
                                    ["isSubtle"] = true,
                                    ["wrap"] = true
                                }
                            },
                            ["width"] = "stretch"
                        }
                    }
                },
                {
                    ["type"] = "Container",
                    ["items"] = {
                        {
                            ["type"] = "TextBlock",
                            ["horizontalAlignment"] = "Left",
                            ["text"] = "Vos tokens rencontre actuellement des problèmes, merci de relancer FiveM afin de régler ce problème.",
                        },
                    }
                }
            },
            ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ["version"] = "1.2"
        }
        deferrals.presentCard(card)
        CancelEvent()
        return
    end
    if JoinCoolDown[Lice] == nil then
        JoinCoolDown[Lice] = os.time()
    elseif os.time() - JoinCoolDown[Lice] < 15 then
        local card = {
            ["type"] = "AdaptiveCard",
            ["minHeight"] = "100px",
            ["body"] = {
                {
                    ["type"] = "ColumnSet",
                    ["columns"] = {
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "Image",
                                    ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                    ["size"] = "Small"
                                }
                            },
                            ["width"] = "auto"
                        },
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["weight"] = "Bolder",
                                    ["text"] = "SneakyLife",
                                    ["wrap"] = true
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["spacing"] = "None",
                                    ["text"] = "https://sneakylife-store.tebex.io",
                                    ["isSubtle"] = true,
                                    ["wrap"] = true
                                }
                            },
                            ["width"] = "stretch"
                        }
                    }
                },
                {
                    ["type"] = "Container",
                    ["items"] = {
                        {
                            ["type"] = "TextBlock",
                            ["horizontalAlignment"] = "Left",
                            ["text"] = "Veuillez patienter avant de vous reconnecter.",
                        },
                    }
                }
            },
            ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ["version"] = "1.2"
        }
        deferrals.presentCard(card) 
        CancelEvent()
        return
    else
        JoinCoolDown[Lice] = nil
    end
    
    local Detected = {}
    local TokenFind = {}
    TokenFind[Lice] = {}

    if MetaIntitalise[tostring(Lice)] then
        Detected[Lice] = MetaIntitalise[tostring(Lice)]
    elseif MetaIntitalise[tostring(Live)] then
        Detected[Lice] = MetaIntitalise[tostring(Live)]
    elseif MetaIntitalise[tostring(Xbox)] then
        Detected[Lice] = MetaIntitalise[tostring(Xbox)]
    elseif MetaIntitalise[tostring(Discord)] then
        Detected[Lice] = MetaIntitalise[tostring(Discord)]
    end
    
    for g = 0, GetNumPlayerTokens(source) - 1 do
        if MetaIntitalise[GetPlayerToken(source, g)] then
            Detected[Lice] = MetaIntitalise[GetPlayerToken(source, g)]
        end
        
        table.insert(TokenFind[Lice], GetPlayerToken(source, g))
    end    

    d = BanInfo[Detected[Lice]]

    if Detected[Lice] then
        BannedAlready = true
        
        local txtday, txthrs, txtminutes = getTime(d.Expire)
        if (tonumber(d.permanent)) == 1 then
            local card = {
                ["type"] = "AdaptiveCard",
                ["minHeight"] = "100px",
                ["body"] = {
                    {
                        ["type"] = "ColumnSet",
                        ["columns"] = {
                            {
                                ["type"] = "Column",
                                ["items"] = {
                                    {
                                        ["type"] = "Image",
                                        ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                        ["size"] = "Small"
                                    }
                                },
                                ["width"] = "auto"
                            },
                            {
                                ["type"] = "Column",
                                ["items"] = {
                                    {
                                        ["type"] = "TextBlock",
                                        ["weight"] = "Bolder",
                                        ["text"] = "SneakyLife",
                                        ["wrap"] = true
                                    },
                                    {
                                        ["type"] = "TextBlock",
                                        ["spacing"] = "None",
                                        ["text"] = "https://sneakylife-store.tebex.io",
                                        ["isSubtle"] = true,
                                        ["wrap"] = true
                                    }
                                },
                                ["width"] = "stretch"
                            }
                        }
                    },
                    {
                        ["type"] = "Container",
                        ["items"] = {
                            {
                                ["type"] = "TextBlock",
                                ["horizontalAlignment"] = "Left",
                                ["text"] = "Vous êtes banni de ce serveur",
                            },
                            {
                                ["type"] = "TextBlock",
                                ["horizontalAlignment"] = "Left",
                                ["text"] = "Ban ID : "..d.ID,
                            },
                            {
                                ["type"] = "TextBlock",
                                ["horizontalAlignment"] = "Left",
                                ["text"] = "Modérateur : "..d.moderatorName,
                            },
                            {
                                ["type"] = "TextBlock",
                                ["horizontalAlignment"] = "Left",
                                ["text"] = "Raison :  "..d.Reason,
                            },
                            {
                                ["type"] = "TextBlock",
                                ["horizontalAlignment"] = "Left",
                                ["text"] = "Temps restant : permanent",
                            },
                        }
                    }
                },
                ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                ["version"] = "1.2"
            }
            deferrals.presentCard(card)
            CancelEvent()
        elseif (tonumber(d.Expire)) > os.time() then
            local tempsrestant     = (((tonumber(d.Expire)) - os.time())/60)
            if tempsrestant >= 1440 then
                local day        = (tempsrestant / 60) / 24
                local hrs        = (day - math.floor(day)) * 24
                local minutes    = (hrs - math.floor(hrs)) * 60
                local txtday     = math.floor(day)
                local txthrs     = math.floor(hrs)
                local txtminutes = math.ceil(minutes)
                local card = {
                    ["type"] = "AdaptiveCard",
                    ["minHeight"] = "100px",
                    ["body"] = {
                        {
                            ["type"] = "ColumnSet",
                            ["columns"] = {
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "Image",
                                            ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                            ["size"] = "Small"
                                        }
                                    },
                                    ["width"] = "auto"
                                },
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "TextBlock",
                                            ["weight"] = "Bolder",
                                            ["text"] = "SneakyLife",
                                            ["wrap"] = true
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["spacing"] = "None",
                                            ["text"] = "https://sneakylife-store.tebex.io",
                                            ["isSubtle"] = true,
                                            ["wrap"] = true
                                        }
                                    },
                                    ["width"] = "stretch"
                                }
                            }
                        },
                        {
                            ["type"] = "Container",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Vous êtes banni de ce serveur",
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Ban ID : "..d.ID,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Modérateur : "..d.moderatorName,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Raison :  "..d.Reason,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Temps restant : "..txtday.." jours "..txthrs.." heures "..txtminutes.." minutes",
                                },
                            }
                        }
                    },
                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                    ["version"] = "1.2"
                }
                deferrals.presentCard(card)
                CancelEvent()
            elseif tempsrestant >= 60 and tempsrestant < 1440 then
                local day        = (tempsrestant / 60) / 24
                local hrs        = tempsrestant / 60
                local minutes    = (hrs - math.floor(hrs)) * 60
                local txtday     = math.floor(day)
                local txthrs     = math.floor(hrs)
                local txtminutes = math.ceil(minutes)
                local card = {
                    ["type"] = "AdaptiveCard",
                    ["minHeight"] = "100px",
                    ["body"] = {
                        {
                            ["type"] = "ColumnSet",
                            ["columns"] = {
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "Image",
                                            ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                            ["size"] = "Small"
                                        }
                                    },
                                    ["width"] = "auto"
                                },
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "TextBlock",
                                            ["weight"] = "Bolder",
                                            ["text"] = "SneakyLife",
                                            ["wrap"] = true
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["spacing"] = "None",
                                            ["text"] = "https://sneakylife-store.tebex.io",
                                            ["isSubtle"] = true,
                                            ["wrap"] = true
                                        }
                                    },
                                    ["width"] = "stretch"
                                }
                            }
                        },
                        {
                            ["type"] = "Container",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Vous êtes banni de ce serveur",
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Ban ID : "..d.ID,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Modérateur : "..d.moderatorName,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Raison :  "..d.Reason,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Temps restant : "..txtday.." jours "..txthrs.." heures "..txtminutes.." minutes",
                                },
                            }
                        }
                    },
                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                    ["version"] = "1.2"
                }
                deferrals.presentCard(card)
                CancelEvent()
            elseif tempsrestant < 60 then
                local txtday     = 0
                local txthrs     = 0
                local txtminutes = math.ceil(tempsrestant)
                local card = {
                    ["type"] = "AdaptiveCard",
                    ["minHeight"] = "100px",
                    ["body"] = {
                        {
                            ["type"] = "ColumnSet",
                            ["columns"] = {
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "Image",
                                            ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                            ["size"] = "Small"
                                        }
                                    },
                                    ["width"] = "auto"
                                },
                                {
                                    ["type"] = "Column",
                                    ["items"] = {
                                        {
                                            ["type"] = "TextBlock",
                                            ["weight"] = "Bolder",
                                            ["text"] = "SneakyLife",
                                            ["wrap"] = true
                                        },
                                        {
                                            ["type"] = "TextBlock",
                                            ["spacing"] = "None",
                                            ["text"] = "https://sneakylife-store.tebex.io",
                                            ["isSubtle"] = true,
                                            ["wrap"] = true
                                        }
                                    },
                                    ["width"] = "stretch"
                                }
                            }
                        },
                        {
                            ["type"] = "Container",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Vous êtes banni de ce serveur",
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Ban ID : "..d.ID,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Modérateur : "..d.moderatorName,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Raison :  "..d.Reason,
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["horizontalAlignment"] = "Left",
                                    ["text"] = "Temps restant : "..txtday.." jours "..txthrs.." heures "..txtminutes.." minutes",
                                },
                            }
                        }
                    },
                    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                    ["version"] = "1.2"
                }
                deferrals.presentCard(card)
                CancelEvent()
            end
        elseif (tonumber(d.permanent)) == 0 and (tonumber(d.Expire)) < os.time() then
            CreateUnbanThread(tostring(d.License))
            deferrals.done()
            SendLogs(3066993,"Serveur - Connexion","**"..name.."** vient de se connecter\n **License** : "..Lice,"https://discord.com/api/webhooks/841179533965393920/hQxVi3C7A23F5SrcSdHwAvDuUZ89xq688lnfHUIbkHzQMNBozy4W64NXEkusL8nzM8Sl")
            RconPrint("^2["..GetCurrentResourceName().."] ^0 : ^2Connexion^0 du joueur : ^5"..name.."^0 "..Lice.."\n") 
        end
    end

    if not BannedAlready then
        InitiateDatabase(tonumber(source))
        Citizen.Wait(1000)
        local card = {
            ["type"] = "AdaptiveCard",
            ["minHeight"] = "100px",
            ["body"] = {
                {
                    ["type"] = "ColumnSet",
                    ["columns"] = {
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "Image",
                                    ["url"] = "https://media.discordapp.net/attachments/874054406776168448/897950119465463838/logo_png.png",
                                    ["size"] = "Small"
                                }
                            },
                            ["width"] = "auto"
                        },
                        {
                            ["type"] = "Column",
                            ["items"] = {
                                {
                                    ["type"] = "TextBlock",
                                    ["weight"] = "Bolder",
                                    ["text"] = "SneakyLife",
                                    ["wrap"] = true
                                },
                                {
                                    ["type"] = "TextBlock",
                                    ["spacing"] = "None",
                                    ["text"] = "https://sneakylife-store.tebex.io",
                                    ["isSubtle"] = true,
                                    ["wrap"] = true
                                }
                            },
                            ["width"] = "stretch"
                        }
                    }
                },
                {
                    ["type"] = "Container",
                    ["items"] = {
                        {
                            ["type"] = "TextBlock",
                            ["horizontalAlignment"] = "Left",
                            ["text"] = "Connexion réussie bon jeu à vous.",
                        },
                    }
                }
            },
            ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
            ["version"] = "1.2"
        }
        deferrals.presentCard(card)
        Citizen.Wait(1000)
        deferrals.done() 
        SendLogs(3066993,"Serveur - Connexion","**"..name.."** vient de se connecter\n **License** : "..Lice,"https://discord.com/api/webhooks/841179533965393920/hQxVi3C7A23F5SrcSdHwAvDuUZ89xq688lnfHUIbkHzQMNBozy4W64NXEkusL8nzM8Sl")
        RconPrint("^2["..GetCurrentResourceName().."] ^0 : ^2Connexion^0 du joueur : ^5"..name.."^0 "..Lice.."\n") 
    end
    if BannedAlready then
        BannedAlready = false
    end
end)

function CreateUnbanThread(License)
    MySQL.Async.fetchAll('SELECT License FROM players_ban WHERE License = @License',
    {
        ['@License'] = License

    }, function(data)
        if data[1] then
            MySQL.Async.execute('UPDATE players_ban SET Reason = @Reason, isBanned = @isBanned, Expire = @Expire, timeat = @timeat, permanent = @permanent, moderatorName = @moderatorName WHERE License = @License', 
            {
                ['@isBanned'] = 0,
                ['@Reason'] = "",
                ['@License'] = License,
                ['@Expire'] = 0,
                ['@timeat'] = 0,
                ['@permanent'] = 0,
                ['@moderatorName'] = "Aucun"
            })
            SetTimeout(1000, function()
                ReloadBans()
            end)
        end
    end)
end

function InitiateDatabase(source)
    local source = source
    local LC = "None"
    local LV = "None"
    local XB = "None"
    local DS = "None"
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("license:")) == "license:" then
            LC  = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            LV  = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            DS = v
        end
    end
    DatabaseStuff[LC] = {}
    for i = 0, GetNumPlayerTokens(source) - 1 do 
        table.insert(DatabaseStuff[LC], GetPlayerToken(source, i))
    end
    MySQL.Async.fetchAll('SELECT * FROM players_ban WHERE License = @License',
    {
        ['@License'] = LC

    }, function(data) 
        if data[1] == nil then
            MySQL.Async.execute('INSERT INTO players_ban (License, Tokens, Discord, Xbox, Live, Reason, Expire, isBanned) VALUES (@License, @Tokens, @Discord, @Xbox, @Live, @Reason, @Expire, @isBanned)',
            {
                ['@License'] = LC,
                ['@Discord'] = DS,
                ['@Xbox'] = XB,
                ['@Live'] = LV,
                ['@Reason'] = "",
                ['@Tokens'] = json.encode(DatabaseStuff[LC]),
                ['@Expire'] = 0,
                ['@isBanned'] = 0
            })
            DatabaseStuff[LC] = nil
        end 
    end)
end

function BanNewAccount(source, Reason, Time)
    local source = source
    local LC = "None"
    local LV = "None"
    local XB = "None"
    local DS = "None"
    local currentTime = os.time()
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("license:")) == "license:" then
            LC  = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            LV  = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            DS = v
        end
    end
    DatabaseStuff[LC] = {}
    for i = 0, GetNumPlayerTokens(source) - 1 do 
        table.insert(DatabaseStuff[LC], GetPlayerToken(source, i))
    end
    MySQL.Async.fetchAll('SELECT * FROM players_ban WHERE License = @License',
    {
        ['@License'] = LC

    }, function(data) 
        if data[1] == nil then
            MySQL.Async.execute('INSERT INTO players_ban (License, Tokens, Discord, Xbox, Live, Reason, Expire, isBanned, timeat, permanent) VALUES (@License, @Tokens, @Discord, @Xbox, @Live, @Reason, @Expire, @isBanned, @timeat, @permanent)',
            {
                ['@License'] = LC,
                ['@Discord'] = DS,
                ['@Xbox'] = XB,
                ['@Live'] = LV,
                ['@Reason'] = Reason,
                ['@Tokens'] = json.encode(DatabaseStuff[LC]),
                ['@Expire'] = Time,
                ['@isBanned'] = 1,
                ['@timeat'] = currentTime,
                ['@permanent'] = 0
            })
            DatabaseStuff[LC] = nil
        end 
    end)
end

RegisterCommand('banreload', function(source, args)
    if source ~= 0 then
        return
    end
    ReloadBans()
end)

RegisterCommand('ban', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then return end
    local target = tonumber(args[1])
    local reason = table.concat(args, ' ', 3)
    if args[1] then
        if tonumber(args[2]) then
            if tostring(reason) then
                if tonumber(args[1]) then
                    if GetPlayerName(target) then
                        for k, v in ipairs(GetPlayerIdentifiers(target)) do
                            if string.sub(v, 1, string.len("license:")) == "license:" then
                                license = v
                            end
                        end
                        if tonumber(args[2]) > 0 then
                            TriggerEvent('Initiate:BanSql', license, tonumber(target), reason, GetPlayerName(source), tonumber(args[2]), 0)
                        else
                            TriggerEvent('Initiate:BanSql', license, tonumber(target), reason, GetPlayerName(source), tonumber(args[2]), 1)
                        end
                    else
                        TriggerClientEvent("esx:showNotification",source, "~r~Player non connecté(e).")
                    end
                else
                    if string.find(args[1], "license:") ~= nil then
                        if tonumber(args[2]) > 0 then
                            TriggerEvent('TargetPlayerIsOffline', args[1], reason, GetPlayerName(source), tonumber(args[2]),0)
                        else
                            TriggerEvent('TargetPlayerIsOffline', args[1], reason, GetPlayerName(source), tonumber(args[2]),1)
                        end
                    else
                        TriggerClientEvent("esx:showNotification",source, "~r~License non correct.")
                    end
                end
            else
                TriggerClientEvent("esx:showNotification",source, "~r~Raison non correct.")
            end
        else
            TriggerClientEvent("esx:showNotification",source, "~r~Temps non correct.")
        end
    else
        TriggerClientEvent("esx:showNotification",source, "~r~ID non correct.")
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.getGroup() == "user" then return end
        if tonumber(args[1]) then
            MySQL.Async.fetchAll('SELECT License FROM players_ban WHERE ID = @ID',
            {
                ['@ID'] = args[1]

            }, function(data)
                if data[1] then
                    MySQL.Async.execute('UPDATE players_ban SET Reason = @Reason, isBanned = @isBanned, Expire = @Expire, timeat = @timeat, permanent = @permanent, moderatorName = @moderatorName WHERE License = @License', 
                    {
                        ['@isBanned'] = 0,
                        ['@Reason'] = "",
                        ['@License'] = data[1].License,
                        ['@Expire'] = 0,
                        ['@timeat'] = 0,
                        ['@permanent'] = 0,
                        ['@moderatorName'] = "Aucun"
                    })
                    ReloadBans()
                    TriggerClientEvent('esx:showNotification', source, "La license à bien été ~b~unban~s~.") 
                else
                    TriggerClientEvent('esx:showNotification', source, "~r~La license est incorrect.") 
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', source, "~r~La license est incorrect.") 
        end
    else
        if tonumber(args[1]) then
            MySQL.Async.fetchAll('SELECT License FROM players_ban WHERE ID = @ID',
            {
                ['@ID'] = args[1]

            }, function(data)
                if data[1] then
                    MySQL.Async.execute('UPDATE players_ban SET isBanned = @isBanned, Reason = @Reason, Expire = @Expire, timeat = @timeat, permanent = @permanent, moderatorName = @moderatorName WHERE License = @License', 
                    {
                        ['@isBanned'] = 0,
                        ['@Reason'] = "",
                        ['@License'] = data[1].License,
                        ['@Expire'] = 0,
                        ['@timeat'] = 0,
                        ['@permanent'] = 0,
                        ['@moderatorName'] = "Aucun"
                    })
                    ReloadBans()
                    print("^5 La license à bien été unban.^7")
                else
                    print("^4 La license n'est pas correct.^7")
                end
            end)
        else
            print("^4 La license n'est pas correct.^7")
        end
    end
end)

function ReloadBans()
    MetaIntitalise = {}
    BanInfo = {}
    MySQL.Async.fetchAll('SELECT * FROM players_ban WHERE isBanned = 1', {}, function(info)
        for k,v in pairs(info) do
            MetaIntitalise[v.License] = v.ID
            MetaIntitalise[v.Discord] = v.ID
            MetaIntitalise[v.Xbox] = v.ID
            MetaIntitalise[v.Live] = v.ID
            for _,z in pairs(json.decode(v.Tokens)) do
                MetaIntitalise[z] = v.ID
            end
            BanInfo[v.ID] = {
                ID = v.ID,
                License = v.License,
                Discord = v.Discord,
                Xbox = v.Xbox,
                Live = v.Live,
                Tokens = v.Tokens,
                Reason = v.Reason,
                IsBanned = v.IsBanned,
                Expire = v.Expire,
                timeat = v.timeat,
                permanent = v.permanent,
                moderatorName = v.moderatorName,
            }
        end
    end)
end

AddEventHandler("onMySQLReady",function()
	ReloadBans()
    WhileTrue()
end)

function WhileTrue()
    SetTimeout(120000, function()
        WhileTrue()
        ReloadBans()
    end)
end

function kickPlayer(source, target, reason)
    local playerLicense = GetIdentifiersServer(target)["license"]
    local targetName = GetPlayerName(target)
    local moderatorName = GetPlayerName(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        banPlayerAC(xPlayer.source, {
            name = "changestateuser",
            title = "Anticheat : kick",
            description = "Anticheat : kick"
        })
        return
    end
    if targetName == nil then 
        return TriggerClientEvent('esx:showNotification', source, "~r~Joueur non existant.") 
    end
    sendLogs("https://canary.discord.com/api/webhooks/828722803989020682/CkX1DKB_UHaL9ty9ZYlxlPoR8IDTEr0sx9sq7o7wvIEZhwf5_EIh_ZIuylC054KOKDE6", "Kick d'un joueur", " Le joueur : "..targetName..", "..playerLicense.." à été kick avec comme raison : "..reason.." par le modérateur :  "..moderatorName)
    DropPlayer(target, "\nRaison : "..reason.."\nAuteur : "..moderatorName)
    TriggerClientEvent("esx:showNotification", source, "Vous avez ~r~kick~s~ le joueur ~b~"..targetName.."~s~ !")
end

RegisterCommand("kick",function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "user" then
        TriggerClientEvent("esx:showNotification", source, "~r~Vous n'avez pas accès à cette commande.")
        return
    end
    local target = tonumber(args[1])
	local reason = table.concat(args, ' ', 2)
	if target and target > 0 then
        kickPlayer(source, target, reason)
    end
end)