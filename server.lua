local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time())

-- SAVE data to the database
ESX.RegisterServerCallback('jsfour-mdc:save', function(source, cb, data)
  MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE lastdigits = @lastdigits', {['@lastdigits'] = data.lastdigits},
  function (result)
    local uploader  = result[1].firstname .. ' ' .. result[1].lastname
    local number    = string.char(math.random(97, 122)) .. math.random(100, 9999)
    if data.type == 'incident' then
      MySQL.Async.execute('INSERT INTO jsfour_incidents (number, text, uploader, date) VALUES (@number, @text, @uploader, @date)',
        {
          ['@number']   = number,
          ['@text']     = data.text,
          ['@uploader'] = uploader,
          ['@date']     = os.date("%Y-%m-%d")
        }
      )
      cb(number)
    elseif data.type == 'car' then
      MySQL.Async.fetchAll('SELECT incident FROM jsfour_cardetails WHERE plate = @plate', {['@plate'] = data.plate},
      function (result)
        if result[1] ~= nil then
          local incidents = {}
          local incident = json.decode(result[1].incident)

          for i=1, #incident, 1 do
            table.insert(incidents, incident[i])
          end

          table.insert(incidents, data.incident .. ' ('..os.date("%Y-%m-%d")..')')

          MySQL.Async.execute('UPDATE jsfour_cardetails SET incident = @incident WHERE plate = @plate', {['@incident'] = json.encode(incidents), ['@plate'] = data.plate})
          cb('updated')
        end
      end)
    elseif data.type == 'efterlysning' then
      MySQL.Async.execute('INSERT INTO jsfour_efterlysningar (wanted, dob, crime, uploader, date, incident) VALUES (@wanted, @dob, @crime, @uploader, @date, @incident)',
        {
          ['@wanted']   = data.wanted,
          ['@dob']      = data.dob,
          ['@crime']    = data.crime,
          ['@uploader'] = uploader,
          ['@date']     = os.date("%Y-%m-%d"),
          ['@incident'] = data.incident
        }
      )
    end
  end)
end)

-- FETCH data from the database
ESX.RegisterServerCallback('jsfour-mdc:fetch', function(source, cb, data)
  if data.type == 'efterlysning' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_efterlysningar', {},
    function (result)
      if result[1] ~= nil then
        cb(result)
      else
        cb('error')
      end
    end)
  elseif data.type == 'logs' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_logs', {},
    function (result)
      if result[1] ~= nil then
        cb(result)
      else
        cb('error')
      end
    end)
  elseif data.type == 'incident' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_incidents WHERE number = @number', {['@number'] = data.number},
    function (result)
      if result[1] ~= nil then
        cb(result)
      else
        cb('error')
      end
    end)
  elseif data.type == 'incidenter' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_incidents', {},
    function (result)
      if result[1] ~= nil then
        cb(result)
      else
        cb('error')
      end
    end)
  elseif data.type == 'car' then
    local found = false
    local result
    local carDetails

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles', {},
    function (result)
      if result[1] ~= nil then
        local vehicles = {}

        for i=1, #result, 1 do
          local vehicleData = json.decode(result[i].vehicle)
          table.insert(vehicleData, result[i].owner)
          table.insert(vehicles, vehicleData)
        end

        for i=1, #vehicles, 1 do
          if vehicles[i]['plate'] == data.plate then
            found = true
            MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, lastdigits FROM users WHERE identifier = @identifier', {['@identifier'] = vehicles[i][1]},
            function (result)
              if result[1] ~= nil then
                result = result
                MySQL.Async.fetchAll('SELECT owner, incident, inspected FROM jsfour_cardetails WHERE identifier = @identifier AND plate = @plate', {['@identifier'] = vehicles[i][1], ['@plate'] = vehicles[i]['plate']},
                function (carDetails)
                  if carDetails[1] ~= nil then
                    local carDetails   = carDetails
                    local carIncidents = {}
                    local carRaw = json.decode(carDetails[1].incident)

                    for i=1, #carRaw, 1 do
                      table.insert(carIncidents, carRaw[i])
                    end

                    local array   = {
                      result = result,
                      carDetails = carDetails,
                      carIncidents = carIncidents
                    }

                    cb(array)
                  else
                    MySQL.Async.execute('INSERT INTO jsfour_cardetails (plate, owner, inspected, identifier) VALUES (@plate, @owner, @inspected, @identifier)',
                      {
                        ['@plate']      = data.plate,
                        ['@owner']      = result[1].firstname .. ' ' .. result[1].lastname,
                        ['@inspected']  = 'Ja',
                        ['@identifier'] = vehicles[i][1]
                      }
                    )

                    cb('rerun')
                  end
                end)
              end
            end)
          elseif not found and i == #vehicles then
            cb('error')
          end
        end
      else
        cb('error')
      end
    end)
  elseif data.type == 'person' then
    local result
    local brottsregister
    local efterlysningar

    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, height, sex, phone_number FROM users WHERE dateofbirth = @dateofbirth AND lastdigits = @lastdigits', {['@dateofbirth'] = data.dob, ['@lastdigits'] = data.lastdigits},
    function (result)
      if result[1] ~= nil then
        result = result
        MySQL.Async.fetchAll('SELECT dateofcrime, crime FROM jsfour_brottsregister WHERE dateofbirth = @dateofbirth AND lastdigits = @lastdigits', {['@dateofbirth'] = data.dob, ['@lastdigits'] = data.lastdigits},
        function (brottsregister)
          if brottsregister[1] ~= nil then
            brottsregister = brottsregister
          else
            brottsregister = nil
          end
          MySQL.Async.fetchAll('SELECT incident, crime FROM jsfour_efterlysningar WHERE dob = @dob', {['@dob'] = data.dob .. '-' .. data.lastdigits},
          function (efterlysningar)
            if efterlysningar[1] ~= nil then
              efterlysningar = efterlysningar
            else
              efterlysningar = nil
            end

            local array   = {
              result = result,
              brottsregister = brottsregister,
              efterlysningar = efterlysningar
            }
            cb(array)
          end)
        end)
      else
        cb('error')
      end
    end)
  end
end)

-- REMOVE data from the database
ESX.RegisterServerCallback('jsfour-mdc:remove', function(source, cb, data)
  if data.type == 'efterlysning' then
    MySQL.Async.execute('DELETE FROM jsfour_efterlysningar WHERE dob = @dob',{ ['@dob'] = data.dob})
  elseif data.type == 'incident' then
    MySQL.Async.execute('DELETE FROM jsfour_incidents WHERE number = @number',{ ['@number'] = data.incident})
  elseif data.type == 'brottsregister' then
    MySQL.Async.execute('DELETE FROM jsfour_brottsregister WHERE lastdigits = @lastdigits AND crime = @crime AND dateofcrime = @date',{['@lastdigits'] = data.lastdigits, ['@crime'] = data.crime, ['@date'] = data.date})
  elseif data.type == 'car' then
    MySQL.Async.fetchAll('SELECT incident FROM jsfour_cardetails WHERE plate = @plate', {['@plate'] = data.plate},
    function (result)
      if result[1] ~= nil then
        local incidents = {}
        local incident = json.decode(result[1].incident)

        for i=1, #incident, 1 do
          table.insert(incidents, incident[i])
        end

        for i=1, #incidents, 1 do
          if incidents[i] == data.incident then
            table.remove(incidents, i)
          end
        end

        MySQL.Async.execute('UPDATE jsfour_cardetails SET incident = @incident WHERE plate = @plate', {['@incident'] = json.encode(incidents), ['@plate'] = data.plate})
        cb('updated')
      end
    end)
  end

  MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE lastdigits = @lastdigits', {['@lastdigits'] = data.signedin},
  function (result)
    local remover = result[1].firstname .. ' ' .. result[1].lastname
    local wanted  = nil

    if data.type == 'efterlysning' then
      wanted = data.dob
    elseif data.type == 'incident' then
      wanted = data.incident
    elseif data.type == 'brottsregister' then
      wanted = data.lastdigits
    elseif data.type == 'car' then
      wanted = data.plate
    end

    MySQL.Async.execute('INSERT INTO jsfour_logs (type, remover, wanted) VALUES (@type, @remover, @wanted)',
      {
        ['@type']    = data.type,
        ['@wanted']  = wanted,
        ['@remover'] = remover
      }
    )
  end)

  cb('removed')
end)
