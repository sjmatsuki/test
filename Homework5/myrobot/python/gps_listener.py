import lcm
from exlcm import gps_t

def my_handler(channel, data):
	msg = gps_t.decode(data)
	print("Received message on channel \"%s\"" % channel)
	print("   timestamp     = %s" % str(msg.timestamp))
	print("   latitude      = %s" % str(msg.latitude)) 
	print("   direction     = %s%s" % ((msg.latitude_s),(msg.longitude_s)))
	print("   northing      = %s" % str(msg.northing))
	print("   longitude     = %s" % str(msg.longitude))
	print("   easting       = %s" % str(msg.easting))
	print("   northing      = %s" % str(msg.northing))
	print("   zone          = %s" % str(msg.zone))
	print("   zone letter   = %s" % str(msg.zoneLetter))
	print("")

lc = lcm.LCM()
subscription = lc.subscribe("GPS", my_handler)

try:
    while True:
        lc.handle()
except KeyboardInterrupt:
    pass

lc.unsubscribe(subscription)


