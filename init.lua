local webserver = require "webserver"
local cfg = require "config"

-- Create the httpd server
local svr = net.createServer (net.TCP, 3);

function wait_for_station_conn ( )
  tmr.alarm (1, 1000, 1, function ()
               if wifi.sta.getip () == nil then
                 print ("Waiting for Wifi connection")
               else
                 tmr.stop (1)
                 print ("ESP8266 mode is: " .. wifi.getmode ( ))
                 print ("The module MAC address is: " .. wifi.ap.getmac ( ))
                 print ("Config done, IP is " .. wifi.sta.getip ( ))
                 mdns.register(cfg.HOSTNAME, {hardware="lua-nodemcu",
                                                         service="http",
                                                         port=80,
                                                         location="racks"})
                 -- Server listening on port 80, call connect function if a request is received
                 svr:listen (80, webserver.connect)
               end
  end)
end

function wait_for_ap_conn()
  tmr.alarm(1, 1000, 1, function()
              if wifi.ap.getip() == nil then
                print("Sleeping while we wait for AP to come up.")
              else
                tmr.stop(1)
                print ("ESP8266 mode is: " .. wifi.getmode ( ))
                print ("The module MAC address is: " .. wifi.ap.getmac ( ))
                print ("Config done, IP is " .. wifi.ap.getip ( ))
                mdns.register(cfg.HOSTNAME, {hardware="lua-nodemcu",
                                             service="http",
                                             port=80,
                                             location="racks"})
                -- Server listening on port 80, call connect function if a request is received
                svr:listen (80, webserver.connect)
              end

  end)
end


-- Configure the ESP as a station (client)
if cfg.MODE=="AP" then
  wifi.setmode(wifi.SOFTAP);
  wifi.ap.config({ssid=cfg.AP_SSID,
                  auth=wifi.WPA2_PSK,
                  save=true,
                  pwd=cfg.AP_PASSWORD});
  wifi.ap.setip({ip=cfg.AP_IP,
                 netmask=cfg.AP_NETMASK,
                 gateway=cfg.AP_GW});
  wifi.ap.dhcp.config({start=cfg.AP_DHCP_START});
  wifi.ap.dhcp.start();
  -- wifi.sta.config {ssid=cfg.SSID, pwd=cfg.SSID_PASSWORD}
  -- wifi.sta.autoconnect (1)
else
  wifi.setmode (wifi.STATION)
  wifi.sta.config {ssid=cfg.SSID, pwd=cfg.SSID_PASSWORD}
  wifi.sta.autoconnect (1)
end

-- Hang out until we get a wifi connection before the httpd server is started.
if cfg.MODE ~="AP" then
  wait_for_station_conn()
else
  -- Server listening on port 80, call connect function if a request is received
  wait_for_ap_conn()

end



