#! /usr/bin/env python

import rospy

fighter1 = rospy.get_param('/ros_params_read/fighter1')
fighter2 = rospy.get_param('/ros_params_read/fighter2')

print (fighter1 + " beat " + fighter2 + " in a one on one today!")
