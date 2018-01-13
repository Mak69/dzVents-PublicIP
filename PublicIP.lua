
return {
    active = true,
    on = {
            timer = {'Every 2 minutes'}
    },
    data = {
            lastIP = { initial = '0.0.0.0' },
            WAN_connected = { initial = false }
    },
    execute = function(domoticz)
            local Host = "https://api.ipify.org"
            local ErrMsg = "WAN connection lost"
            local f = assert(io.popen("curl -s " .. Host , 'r'))
            local s = assert(f:read('*a'))
            if (s == nil) then
                s = "0"
            end

            domoticz.log ('Last   IP: ' .. domoticz.data.lastIP)
            domoticz.log ('Actual IP: ' .. s)
            if (s == '0' and domoticz.data.WAN_connected == true) then
                domoticz.data.WAN_connected = false
                domoticz.log ("Unable to contact " .. Host)
                domoticz.variables('PublicIP').set(ErrMsg)
                domoticz.devices('Public IP').updateText(ErrMsg)
                domoticz.data.lastIP = '0'
            elseif (domoticz.data.lastIP ~= s) then
                domoticz.data.WAN_connected = true
                domoticz.log ('Changing device value -> ' .. s);
                domoticz.variables('PublicIP').set(s)
                domoticz.devices('Public IP').updateText(s)
                domoticz.data.lastIP = s
                domoticz.notify('Public IP Changed','New Public IP ' .. s, domoticz.PRIORITY_LOW)
            end
    end
}
