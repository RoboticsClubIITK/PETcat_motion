import numpy as np

def Rx(angle):
    return np.mat([[1,             0,              0, 0],
                   [0, np.cos(angle), -np.sin(angle), 0],
                   [0, np.sin(angle),  np.cos(angle), 0],
                   [0,             0,              0, 1]],
                   dtype=np.float)

def Ry(angle):
    return np.mat([[ np.cos(angle), 0, np.sin(angle), 0],
                   [             0, 1,             0, 0],
                   [-np.sin(angle), 0, np.cos(angle), 0],
                   [             0, 0,             0, 1]],
                   dtype=np.float)

def Rz(angle):
    return np.mat([[ np.cos(angle), np.sin(angle), 0, 0],
                   [-np.sin(angle), np.cos(angle), 0, 0],
                   [             0,             0, 1, 0],
                   [             0,             0, 0, 1]],
                   dtype=np.float)

def T(point):
    return np.mat([[1, 0, 0, point[0]],
                   [0, 1, 0, point[1]],
                   [0, 0, 1, point[2]],
                   [0, 0, 0,        1]],
                   dtype=np.float)