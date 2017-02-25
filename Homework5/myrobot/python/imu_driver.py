#!/usr/bin/env python
# -*- coding: utf-8 -*-
# for IMU

import sys
import lcm
import time
import serial
import pynmea2
import utm

from exlcm import imu_t

class Ct(object):
    def __init__(self, port_name):
        self.port = serial.Serial(port_name, 115200, timeout=1.)  # 4800-N-8-1
        self.lc = lcm.LCM()
        self.packet = imu_t()
	line = self.port.readline()
	print (line)
    
    def readloop(self):
        while True:
        	line = self.port.readline()
		vals = line.split(",")
		print(line)

		self.packet.magX = vals[1];
		self.packet.magY = vals[2];
		self.packet.magZ = vals[3];
		self.packet.accelX = vals[4];
		self.packet.accelY = vals[5];
		self.packet.accelZ = vals[6];
		self.packet.gyroX = vals[7];
		self.packet.gyroY = vals[8];
		self.packet.gyroZ = vals[9];
		self.packet.temp = vals[10];
		self.packet.pressure = vals[11];
  
		self.lc.publish("IMU", self.packet.encode())	



if __name__ == "__main__":	
    if len(sys.argv) != 2:
        print "Usage: %s <serial_port>\n" % sys.argv[0]
        sys.exit(0)
    myct = Ct(sys.argv[1])
    myct.readloop()
