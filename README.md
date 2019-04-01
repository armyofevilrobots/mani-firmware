# Mani-Firmware

Ever go truck-camping? It's late, it's dark, you have a dinky little flashlight, and you know 
there is another beer in... one of these bins? So you try and search, using that silver-dollar
sized circle of light, and grow progressively more frustrated by your fruitless search, and
encroaching sobriety. If only you had better lighting under there...

```TODO: A picture of this stuff```

## Mani-Firmware

Mani is a lighting controller that lives in a little box, and runs LED strips. It uses a low-power
ESP8266 based controller running the nodemcu lua stack, and quietly waits for a POST on it's webserver
to turn the lights on, and/or off, or some state in between if you like that kind of thing.
Security is provided on the NETWORK layer, using WPA2. We don't have SSL on this thing, but I might
add it if enough people complain. I will definitely be adding credentials and MQTT based control,
as well as state querying.

## The Box

STL files are available here:
[Mani-Controller on Thingiverse](https://www.thingiverse.com/thing:3532224).

![Let there be light](https://thingiverse-production-new.s3.amazonaws.com/assets/ba/b1/95/a7/1c/mani-let-there-be-light.jpg)

![The Control Box](https://thingiverse-production-new.s3.amazonaws.com/assets/41/8f/a3/9f/f2/mani-control-box.jpg)


# Building

Edit the config.lua.example and rename it to config.lua; it should be pretty self explanatory.
Once you're done, you can hook up your stuff to the controller, and your led to a mosfet
switched by output #2 (index 4), which is where the blue LED on those nodemcu dev boards lives too.

Next, join the AP with your device (I use a raspberry pi as a central vehicle control module).

Then you can visit http://$CONFIGURED_IP/ and turn it on and off via the webapp. Whee! I found the beer!


# TODO:

 * Upload those gPCB/gSCHEM files so you know what the board is supposed to look like.
 * Diagram of hooking it up to a vehicle. It's straightforward, but a beginner might... burn something?
