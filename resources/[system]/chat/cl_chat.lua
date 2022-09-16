local chatInputActive = false
local chatInputActivating = false
local shouldBeHidden = true

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  if shouldBeHidden then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = { 0, 0, 0 },
      multiline = true,
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
  if shouldBeHidden then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
  end
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');

  cb('ok')
end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)

  while true do
    Wait(50)
    if not chatInputActive then
      if IsControlPressed(0, 245) then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        chatInputActivating = false
      end
    end
  end
end)

local delay = 30 * 60000

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        TriggerEvent('chat:addMessage', {args = { "^5[Annonce] ^7 Pensez à rejoindre notre discord: discord.gg/^5sneaky^7life." }})
        TriggerEvent('chat:addMessage', {args = { "^5[Annonce] ^7 Pour ^5soutenir^7 le serveur  : ^5https://sneakylife-store.tebex.io^7" }})
        TriggerEvent('chat:addMessage', {args = { "^5[Annonce] ^7 Si vous rencontrez un problème vous pouvez faire un /report." }})
        Citizen.Wait(delay)
    end
end)

RegisterCommand('chat', function()
  chatEnabled = not chatEnabled
  if not chatEnabled then
    shouldBeHidden = true
  else
    shouldBeHidden = false
    SendNUIMessage({
      type = 'ON_CLOSE'
    })
  end
end, false)