#!/bin/sh

lcm-gen -j ../types/*.lcm

javac -cp ../../lcm-java/lcm.jar exlcm/*.java

jar cf gps_types.jar exlcm/*.class
