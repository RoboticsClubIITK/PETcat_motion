# PETcat_motion
Motion and Trajectory Planning for PETCat, the long term project.

## Cloning and Setting Up Files

### 1. Fork the repo on GitHub

Use the button at the top right.

### 2. Clone the project to your own machine

``` 
git clone https://github.com/${your_username_here}/PETcat_motion
``` 

### 3. Setup and Build files
* Place the contents of the `python/` directory in your catkin workspace. Navigate to the top-level repo directory and:

```
cp -r ./python/* ~/catkin_ws/src
```

* Add the executable for python script
```
cd ~/catkin_ws/src/motion/src
sudo chmod +x billi.py  ## or name any other python file
```

* Build files

```
cd ../..
catkin build
source ~/catkin_ws/devel/setup.bash
```


## Running Stick Model Quadruped

Go to the folder containing `billi.py` file
```
cd ~/catkin_ws/src/motion/src
python3 billi.py
```

## Running Champ Simulation
### Running Champ simulator with native controller
```
roslaunch champ_config gazebo.launch
```

### Running Champ Simulator with _custom_ controller
```
roslaunch champ_config gazebo.launch custom:=true
```

## Contribution Guidelines

### 1. Commit changes to your own branch on your fork: 

Create a new branch by

```
git checkout -b ${your_branch_name}
```

### 2. Push your work back up to your fork: 

Navigate to the top-level repo directory and:
``` 
git add .
git commit -m "Explanative commit message"
git push origin ${your_branch_name} 
```
    
### 3. Submit a Pull request so that we can review your changes:

Create a new pull request from the `Pull Requests` tab on this repo, not the fork.

Request reviews from at least two people. 
  
