#! /usr/bin/env python3

import sys

import numpy as np
from numpy import cos, sin, arccos, arctan, arctan2

from rotations import *

import rospy
from trajectory_msgs.msg import JointTrajectory, JointTrajectoryPoint

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import animation
fig = plt.figure()
ax = fig.add_axes([0, 0, 1, 1], projection='3d')

PI = np.pi
class Billi:
    def __init__(self, length, width, thigh, calf, ros_flag):
        self.length = length
        self.width = width
        self.thigh = thigh
        self.calf = calf

        self.ros_flag = ros_flag
        if ros_flag:
            rospy.init_node("custom_motion", anonymous=False)
            self.pub = rospy.Publisher("/joint_group_position_controller/command", JointTrajectory, queue_size=10)
            self.rate = rospy.Rate(30)
    
    def kinematics(self, leg, x, y, z, roll, pitch, yaw):
        v_length = np.sqrt(x**2 + y**2 + z**2)
        if v_length > self.thigh + self.calf:
            # print("Impossible Configuration")
            return -1
        
        x0 = x
        y0 = y
        z0 = z
        # print("leg = %d: x0 = %6.3f, y0 = %6.3f, z0 = %6.3f, length = %6.3f" %(leg, x0, y0, z0, np.sqrt(x0**2 + y0**2 + z0**2)))
        #-------------------------YAW-------------------------#
        yaw = yaw*PI/180

        if leg == 1:
            x_b = x + self.length
            y_b = y - self.width
        elif leg == 2:
            x_b = x + self.length
            y_b = y + self.width
        elif leg == 3:
            x_b = x - self.length
            y_b = y + self.width
        elif leg == 4:
            x_b = x - self.length
            y_b = y - self.width

        r = np.sqrt(x_b**2 + y_b**2)
        angle = arctan2(y_b,x_b)

        x_b = r*cos(angle - yaw)
        y_b = r*sin(angle - yaw)

        if leg == 1:
            x3 = x_b - self.length
            y3 = y_b + self.width
        elif leg == 2:
            x3 = x_b - self.length
            y3 = y_b - self.width
        elif leg == 3:
            x3 = x_b + self.length
            y3 = y_b - self.width
        elif leg == 4:
            x3 = x_b + self.length
            y3 = y_b + self.width
        z3 = z

        x0 = x3
        y0 = y3
        z0 = z3
        #------------------------PITCH------------------------#
        pitch = pitch*PI/180

        if leg == 1 or leg == 2:
            x_b = -x3 + self.length*(1 - cos(pitch))
            z_b = z3 + self.length*sin(pitch)
        elif leg == 3 or leg == 4:
            x_b = -x3 - self.length*(1 - cos(pitch))
            z_b = z3 - self.length*sin(pitch)
        
        r = np.sqrt(x_b**2 + z_b**2)
        angle = arctan2(x_b, z_b)
        z2 = r*cos(pitch - angle)
        x2 = r*sin(pitch - angle)
        y2 = y3

        x0 = x2
        y0 = y2
        z0 = z2
        #-------------------------ROLL------------------------#
        roll = roll*PI/180

        if leg == 1 or leg == 4:
            y_b = -y2 + self.width*(1 - cos(roll))
            z_b = z2 + self.width*sin(roll)
        elif leg == 3 or leg == 2:
            y_b = -y2 - self.width*(1 - cos(roll))
            z_b = z2 - self.width*sin(roll)
        
        r = np.sqrt(y_b**2 + z_b**2)
        angle = arctan2(y_b, z_b)
        z1 = r*cos(roll - angle)
        y1 = r*sin(roll - angle)
        x1 = x2
        
        x0 = x1
        y0 = y1
        z0 = z1

        
        v_length = np.sqrt(x0**2 + y0**2 + z0**2)
        if v_length > self.thigh + self.calf:
            # print("Impossible Configuration")
            return -1
        #---------------------TRANSLATION---------------------#
        # print("leg = %d: x0 = %6.3f, y0 = %6.3f, z0 = %6.3f, length = %6.3f" %(leg, x0, y0, z0, np.sqrt(x0**2 + y0**2 + z0**2)))
        hipAngle = np.arctan2(y0,z0)

        v_length = np.sqrt(y0**2 + z0**2)
        shoulderAngle1 = -np.arctan2(x0,v_length)

        v_length = np.sqrt(x0**2 + y0**2 + z0**2)
        if v_length > self.thigh + self.calf:
            # print("Impossible Configuration")
            return -1
        shoulderAngle2 = np.arccos((v_length**2 + self.thigh**2 - self.calf**2)/(2*v_length*self.thigh))

        kneeAngle = -(shoulderAngle2 + np.arccos((v_length**2 - self.thigh**2 + self.calf**2)/(2*v_length*self.calf)))

        # if leg == 3 or leg == 4:
        #     # shoulderAngle1 = -shoulderAngle1
        #     shoulderAngle2 = -shoulderAngle2
        #     kneeAngle = -kneeAngle

        return [hipAngle, shoulderAngle1, shoulderAngle2, kneeAngle]


    def plotBot(self):
        ax.clear()

        ax.scatter(self.body[0,5].T, self.body[1,5].T, self.body[2,5].T)
        ax.scatter(self.leg1[0,:].T, self.leg1[1,:].T, self.leg1[2,:].T)
        ax.scatter(self.leg2[0,:].T, self.leg2[1,:].T, self.leg2[2,:].T)
        ax.scatter(self.leg3[0,:].T, self.leg3[1,:].T, self.leg3[2,:].T)
        ax.scatter(self.leg4[0,:].T, self.leg4[1,:].T, self.leg4[2,:].T)
        
        ax.plot_wireframe(self.body[0,:].T, self.body[1,:].T, self.body[2,:].T)
        ax.plot_wireframe(self.leg1[0,:].T, self.leg1[1,:].T, self.leg1[2,:].T)
        ax.plot_wireframe(self.leg2[0,:].T, self.leg2[1,:].T, self.leg2[2,:].T)
        ax.plot_wireframe(self.leg3[0,:].T, self.leg3[1,:].T, self.leg3[2,:].T)
        ax.plot_wireframe(self.leg4[0,:].T, self.leg4[1,:].T, self.leg4[2,:].T)

        ax.set_xlim(self.leg4[0,2] - 0.05, self.leg1[0,2] + 0.05)
        ax.set_ylim(self.leg4[1,2] - 0.15, self.leg2[1,2] + 0.15)
        ax.set_zlim(self.leg4[2,2], 0.6)
        ax.set_xlabel('X axis')
        ax.set_ylabel('Y axis')
        ax.set_zlabel('Z axis')

        plt.pause(0.01)
        return

    def test(self):
        dur = 120/6

        # For Z testing
        for i in np.linspace(self.calf + self.thigh - 0.1, 0.05, int(dur/4)):
            self.get_joints(0, 0, i, 0, 0, 0)
            # print(i)
        for i in np.linspace(0.05, self.calf + self.thigh - 0.02, int(dur/2)):
            self.get_joints(0.0, 0.0, i, 0, 0, 0)
            # print(i)      
        for i in np.linspace(self.calf + self.thigh - 0.02, self.calf + self.thigh - 0.1, int(dur/4)):
            self.get_joints(0, 0, i, 0, 0, 0)
            # print(i)

        # For X testing
        for i in np.linspace(0.0, -10, int(dur/4)):
            self.get_joints(i/150, 0, 0.2, 0, 0, 0)
            # print(i/150)
        for i in np.linspace(-10.0, 10.0, int(dur/2)):
            self.get_joints(i/150, 0, 0.2, 0, 0, 0)
            # print(i/150)      
        for i in np.linspace(10.0, 0.0, int(dur/4)):
            self.get_joints(i/150, 0, 0.2, 0, 0, 0)
            # print(i/150)


        # For Y testing
        for i in np.linspace(0.0, -10, int(dur/4)):
            self.get_joints(0, i/150, 0.2, 0, 0, 0)
            # print(i/150)
        for i in np.linspace(-10.0, 10.0, int(dur/2)):
            self.get_joints(0, i/150, 0.2, 0, 0, 0)
            # print(i/150)      
        for i in np.linspace(10.0, 0.0, int(dur/4)):
            self.get_joints(0, i/150, 0.2, 0, 0, 0)
            # print(i/150)


        # For ROLL testing
        for i in np.linspace(0.0, -10, int(dur/4)):
            self.get_joints(0, 0, 0.2, i, 0, 0)
            # print(i)
        for i in np.linspace(-10.0, 10.0, int(dur/2)):
            self.get_joints(0, 0, 0.2, i, 0, 0)
            # print(i)      
        for i in np.linspace(10.0, 0.0, int(dur/4)):
            self.get_joints(0, 0, 0.2, i, 0, 0)
            # print(i)


        # For PITCH testing
        for i in np.linspace(0.0, -10, int(dur/4)):
            self.get_joints(0, 0, 0.2, 0, i, 0)
            # print(i)
        for i in np.linspace(-10.0, 10.0, int(dur/2)):
            self.get_joints(0, 0, 0.2, 0, i, 0)
            # print(i)      
        for i in np.linspace(10.0, 0.0, int(dur/4)):
            self.get_joints(0, 0, 0.2, 0, i, 0)
            # print(i)


        # For YAW testing
        for i in np.linspace(0.0, -10, int(dur/4)):
            self.get_joints(0, 0, 0.2, 0, 0, i)
            # print(i)
        for i in np.linspace(-10.0, 10.0, int(dur/2)):
            self.get_joints(0, 0, 0.2, 0, 0, i)
            # print(i)      
        for i in np.linspace(10.0, 0.0, int(dur/4)):
            self.get_joints(0, 0, 0.2, 0, 0, i)
            # print(i)

    def get_joints(self, x, y, z, r, p, yaw):
        self.leg1_angles = self.kinematics(1, -x, -y, z, r, p, yaw)
        self.leg2_angles = self.kinematics(2, -x, -y, z, r, p, yaw)
        self.leg3_angles = self.kinematics(3, -x, -y, z, r, p, yaw)
        self.leg4_angles = self.kinematics(4, -x, -y, z, r, p, yaw)
        
        if self.leg1_angles == -1 or self.leg2_angles == -1 or self.leg3_angles == -1 or self.leg4_angles == -1:
            print("Aborting Calculation")
            return -1
        
        # print('leg1', self.leg1_angles, '\nleg2', self.leg2_angles, '\nleg3', self.leg3_angles, '\nleg4', self.leg4_angles)
        # print(((Rz(y) @ Ry(p) @ Rx(r) @ np.mat([-self.length, -(self.width), 215, 1]).T).T)[0])
        self.body = np.hstack(((T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([ self.length, -self.width, 0, 1]).T),
                               (T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([ self.length,  self.width, 0, 1]).T),
                               (T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([-self.length,  self.width, 0, 1]).T),
                               (T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([-self.length, -self.width, 0, 1]).T),
                               (T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([ self.length, -self.width, 0, 1]).T),
                               (T([x,y,z]) @ Rz(-yaw*PI/180) @ Ry(-p*PI/180) @ Rx(-r*PI/180) @ np.mat([ self.length,           0, 0, 1]).T)))
        thigh = np.mat([0, 0, -self.thigh, 1], dtype=np.float).T
        calf = np.mat([0, 0, -self.calf, 1], dtype=np.float).T

        self.leg1 = np.mat(np.zeros((4, 3)))
        self.leg1[:, 0] = self.body[:, 0]
        self.leg1[:, 1] = T(self.leg1[:, 0]) @ Rx(self.leg1_angles[0]) @ Ry((self.leg1_angles[1] + self.leg1_angles[2])) @ thigh
        self.leg1[:, 2] = T(self.leg1[:, 0]) @ Rx(self.leg1_angles[0]) @ Ry((self.leg1_angles[1] + self.leg1_angles[2])) @ T(thigh) @ Ry(self.leg1_angles[3]) @ calf
        # print("%6.3f %6.3f %6.3f" %(ln.norm(self.leg1[0:3, 0] - self.leg1[0:3, 2]), ln.norm(self.leg1[0:3, 0] - self.leg1[0:3, 1]), ln.norm(self.leg1[0:3, 1] - self.leg1[0:3, 2])))

        self.leg2 = np.mat(np.zeros((4, 3)))
        self.leg2[:, 0] = self.body[:, 1]
        self.leg2[:, 1] = T(self.leg2[:, 0]) @ Rx(self.leg2_angles[0]) @ Ry((self.leg2_angles[1] + self.leg2_angles[2])) @ thigh
        self.leg2[:, 2] = T(self.leg2[:, 0]) @ Rx(self.leg2_angles[0]) @ Ry((self.leg2_angles[1] + self.leg2_angles[2])) @ T(thigh) @ Ry(self.leg2_angles[3]) @ calf

        self.leg3 = np.mat(np.zeros((4, 3)))
        self.leg3[:, 0] = self.body[:, 2]
        self.leg3[:, 1] = T(self.leg3[:, 0]) @ Rx(self.leg3_angles[0]) @ Ry((self.leg3_angles[1] + self.leg3_angles[2])) @ thigh
        self.leg3[:, 2] = T(self.leg3[:, 0]) @ Rx(self.leg3_angles[0]) @ Ry((self.leg3_angles[1] + self.leg3_angles[2])) @ T(thigh) @ Ry(self.leg3_angles[3]) @ calf

        self.leg4 = np.mat(np.zeros((4, 3)))
        self.leg4[:, 0] = self.body[:, 3]
        self.leg4[:, 1] = T(self.leg4[:, 0]) @ Rx(self.leg4_angles[0]) @ Ry((self.leg4_angles[1] + self.leg4_angles[2])) @ thigh
        self.leg4[:, 2] = T(self.leg4[:, 0]) @ Rx(self.leg4_angles[0]) @ Ry((self.leg4_angles[1] + self.leg4_angles[2])) @ T(thigh) @ Ry(self.leg4_angles[3]) @ calf

        if not self.ros_flag:
            self.plotBot()
        else:
            self.publishAngles()

    def publishAngles(self):
        traj = JointTrajectory()

        point=JointTrajectoryPoint()
        
        traj.header.frame_id = "/"


        # leg1
        traj.joint_names.append("lf_hip_joint")
        traj.joint_names.append("lf_upper_leg_joint")
        traj.joint_names.append("lf_lower_leg_joint")

        # point.positions.append(self.leg1_angles[0])
        # point.positions.append(self.leg1_angles[1] - self.leg1_angles[2])
        # point.positions.append(self.leg1_angles[3])
        point.positions.append(self.leg1_angles[0])
        point.positions.append((self.leg1_angles[1] + self.leg1_angles[2]))
        point.positions.append(self.leg1_angles[3])


        # leg2
        traj.joint_names.append("rf_hip_joint")
        traj.joint_names.append("rf_upper_leg_joint")
        traj.joint_names.append("rf_lower_leg_joint")

        # point.positions.append(self.leg2_angles[0])
        # point.positions.append(self.leg2_angles[1] - self.leg2_angles[2])
        # point.positions.append(self.leg2_angles[3])
        point.positions.append(self.leg2_angles[0])
        point.positions.append((self.leg2_angles[1] + self.leg2_angles[2]))
        point.positions.append(self.leg2_angles[3])


        # leg3
        traj.joint_names.append("rh_hip_joint")
        traj.joint_names.append("rh_upper_leg_joint")
        traj.joint_names.append("rh_lower_leg_joint")

        # point.positions.append(self.leg3_angles[0])
        # point.positions.append(self.leg3_angles[1] - self.leg3_angles[2])
        # point.positions.append(self.leg3_angles[3])
        point.positions.append(self.leg3_angles[0])
        point.positions.append((self.leg3_angles[1] + self.leg3_angles[2]))
        point.positions.append(self.leg3_angles[3])


        # leg4
        traj.joint_names.append("lh_hip_joint")
        traj.joint_names.append("lh_upper_leg_joint")
        traj.joint_names.append("lh_lower_leg_joint")

        # point.positions.append(self.leg4_angles[0])
        # point.positions.append(self.leg4_angles[1] - self.leg4_angles[2])
        # point.positions.append(self.leg4_angles[3])
        point.positions.append(self.leg4_angles[0])
        point.positions.append((self.leg4_angles[1] + self.leg4_angles[2]))
        point.positions.append(self.leg4_angles[3])

        for i in range(12):
            point.velocities.append(0)
            point.accelerations.append(0)
            # point.positions.append(0)

        point.time_from_start = rospy.Duration(0, 2e8)

        traj.points.append(point)

        traj.header.stamp=rospy.Time.now()

        # print(traj)
        self.pub.publish(traj)
        self.rate.sleep()

if __name__ == "__main__":
    ros_f = False
    if len(sys.argv) > 1:
        ros_f = True
    test = Billi(0.250, 0.145, 0.175, 0.175, ros_f)
    if ros_f:
        try:
            while not rospy.is_shutdown():
                print(ros_f)
                test.test()
        except rospy.ROSInterruptException():
            pass
    else:
        test.test()

# print(test.legs)