local pwm_setter = require "pwm_setter"
local decoder = sjson.decoder();

page_body = [[
<html>
  <head>
    <script>
      function set_pwm(value){
        document.getElementById("led_brightness").value=value;
        var xhr=new XMLHttpRequest();
        xhr.open("POST", "/", true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("PWM", value);
        xhr.send("");
        return false;
      };
    </script>
    <style>
      button{
        width:40%; height:25%;
      }
      input[type=range]{
        width:100%;
        height:25%;
      }
    </style>
  </head>
  <body>
  <input type="range" min="0" max="1023" value="1023" style="direction:rtl" class="slider" id="led_brightness" onchange="set_pwm(this.value)" />
  <br/>
  <button onclick="set_pwm(1023)">Off</button>
  <button onclick="set_pwm(0)">On</button>
  </body>
</html>
  ]]

local function connect (conn, data)
  local query_data

  conn:on ("receive",
           function (cn, req_data)
             query_data = get_http_req (req_data)
             print("PWM", query_data["PWM"])
             if query_data["PWM"] ~= nil then
               print("Resetting PWM to", query_data["PWM"])
               pwm_setter.set_led_pwm(tonumber(query_data["PWM"]))
             end
             print (query_data["METHOD"] .. " " .. " " .. query_data["User-Agent"])
             cn:send (
               "HTTP/1.1 200 OK\r\n" ..
                 "Server: esp8266-aoer\r\n" ..
                 "Content-Type: text/html charset=utf-8\r\n" ..
                 "Access-Control-Allow-Origin: *\r\n" ..
                 "Access-Control-Allow-Methods: GET,POST\r\n" ..
                 string.format("Content-Length: %d\r\n", string.len(page_body)) ..
                 "Connection: close" .. "\r\n\r\n" ..
                 page_body)
           end, nil)

  conn:on ("sent",
           function (cn)
             -- Close the connection for the request
             cn:close()
  end)
end


-- Build and return a table of the http request data
function get_http_req (instr)
  local t = {}
  local first = nil
  local last = nil
  local key, v, strt_ndx, end_ndx

  for str in string.gmatch (instr, "([^\n]+)") do
    -- First line in the method and path
    if (first == nil) then
      first = 1
      strt_ndx, end_ndx = string.find (str, "([^ ]+)")
      v = trim (string.sub (str, end_ndx + 2))
      key = trim (string.sub (str, strt_ndx, end_ndx))
      t["METHOD"] = key
      t["REQUEST"] = v
    else -- Process and reamaining ":" fields
      strt_ndx, end_ndx = string.find (str, "([^:]+)")
      if (end_ndx ~= nil) then
        v = trim (string.sub (str, end_ndx + 2))
        key = trim (string.sub (str, strt_ndx, end_ndx))
        t[key] = v
      end
    end
  end


  return t
end

-- String trim left and right
function trim (s)
  return (s:gsub ("^%s*(.-)%s*$", "%1"))
end

function get_led_pwm()
  return led_pwm
end

return {
  get_led_pwm=get_led_pwm,
  connect=connect
}
