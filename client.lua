local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local ESX	 = nil
local open = false

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Checks if the car is in the list
function vehicleType(using)
  local cars = Config.Cars
  for i=1, #cars, 1 do
    if IsVehicleModel(using, GetHashKey(cars[i])) then
      return true
    end
  end
end

-- Key events
Citizen.CreateThread(function()
  SetNuiFocus(false, false)
  while true do
    Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['Y']) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) < 1 then
			if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        if vehicleType(GetVehiclePedIsUsing(GetPlayerPed(-1))) then
          open = true
          SetNuiFocus(true, true)
          SendNUIMessage({
            action = "open"
          })
				end
			end
		end
  end
end)

-- NUI Callback - alarm
RegisterNUICallback('alarm', function(data, cb)
  SetVehicleAlarm(GetPlayersLastVehicle(), true)
  StartVehicleAlarm(GetPlayersLastVehicle())
  SetTimeout(10000, function()
    cb('done')
  end)
end)

-- NUI Callback - save
RegisterNUICallback('save', function(data, cb)
  ESX.TriggerServerCallback('jsfour-mdc:save', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - fetch
RegisterNUICallback('fetch', function(data, cb)
  ESX.TriggerServerCallback('jsfour-mdc:fetch', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - remove
RegisterNUICallback('remove', function(data, cb)
  ESX.TriggerServerCallback('jsfour-mdc:remove', function( d )
    cb(d)
  end, data)
end)

-- NUI Callback - close
RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	open = false
end)
