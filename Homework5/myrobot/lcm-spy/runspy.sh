#!/bin/sh

export CLASSPATH=gps_types.jar
lcm-logger-s./data/lcm-log-%F-%T &
lcm-spy &
