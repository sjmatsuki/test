#!/usr/bin/env python
# -*- coding: utf-8 -*-
# for NBOSI-CT sensor (seabed 125)

import sys
import lcm
import time
import serial
import pynmea2
import utm

from exlcm import gps_t

class Ct(object):
    def __init__(self, port_name):
        self.port = serial.Serial(port_name, 4800, timeout=1.)  # 4800-N-8-1
        self.lc = lcm.LCM()
        self.packet = gps_t()


    def readloop(self):
        while True:
        	line = self.port.readline()
		vals = line.split(",")           	
		if '$GPGGA' == vals[0]:
	
				#self.packet.format = vals[0]
				#self.packet.timestamp = vals[1]              
			self.packet.timestamp = int(time.time() * 1e6) 
			
			self.packet.latitude_s = vals[3]
			self.packet.longitude_s = vals[5]
				#self.packet.q_in = vals[6]
				#self.packet.satelites = vals[7]
				#self.packet.hdop = vals[8]
				#self.packet.ant_alt = vals[9]
				#self.packet.ant_alt_u = vals[10]
				#self.packet.geo_sep = vals[11]
				#self.packet.geo_sep_u = vals[12]
				#self.packet.age = vals[13] 
				#self.packet.dif_ref = vals[14]

			if (str(vals[3]) == "N"):
				latitude = float(int(vals[2][0:2]) + float(vals[2][2:9])/60)
			elif (str(vals[3]) == "S"):
				latitude = (-1)*float(int(vals[2][0:2]) + float(vals[2][2:9])/60)

			if (str(vals[5]) == "E"):
				longitude = float(int(vals[4][0:3]) + float(vals[4][3:10])/60)
			elif (str(vals[5]) == "W"):
				longitude = (-1)*float(int(vals[4][0:3]) + float(vals[4][3:9])/60)
			
			self.packet.latitude = (latitude)
			self.packet.longitude = (longitude)

			utms = utm.from_latlon(latitude,longitude)
			self.packet.easting = utms[0]
			self.packet.northing = utms[1]
			self.packet.zone = utms[2]
			self.packet.zoneLetter = utms[3]

			self.lc.publish("GPS", self.packet.encode())


if __name__ == "__main__":	
    if len(sys.argv) != 2:
        print "Usage: %s <serial_port>\n" % sys.argv[0]
        sys.exit(0)
    myct = Ct(sys.argv[1])
    myct.readloop()
