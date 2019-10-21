Steps to use sim:

1. Set ROBOT_IP to the desired target in robot.env
2. Change noah to the target username everywhere in robot.sh
3. ./robot.sh deploy

Periodically run 
  docker system prune
to delete old images if imageprune.py doesn't do it's job
#racecar 

Repository for Pitt RAS' Autonomous Raceacar Platform

The main purpose behind this repository is to create a umbrella code base that can be applied to a wide range of autonomous vehicle competitions. This code is based off of the Magellan code stack (https://github.com/Pitt-RAS/magellan-2018)

## Deployment Scripts

Code is deployed to the robot as a Docker image. Most actions are automated with the `robot.sh` script.

### Example Uses

#### Deploying
```bash
./robot.sh deploy
```

This will copy and build your current workspace on the NUC. After building it will start execuiting on the NUC after stopping any previous code. A custom launch command can be given through command line arguments after `deploy`. After starting, your shell will show stdout/stderr from the NUC. Ctrl+Cing in your shell will not stop the process on the NUC.

#### Starting/Stopping
```bash
./robot.sh start
./robot.sh stop
```

These start/stop commands will start and stop the last image that has been deployed to the NUC. A custom launch command can be given through command line arguments after `start`. After starting, your shell will show stdout/stderr from the NUC. Ctrl+Cing in your shell will not stop the process on the NUC.

#### Viewing the console
```bash
./robot.sh watch
```

"Watching" the console will watch the output of stdout/stderr, while also showing output from before you connected. Ctrl+Cing in your shell will not stop the process on the NUC.

### Configuration
Deployment script configuration is set in `robot.env`. `ROBOT_IP` and `DEFAULT_LAUNCH` set the target system and default command to execute when starting an image. Other parameters like image/container name can be tweaked, but please don't change them on the competition robot without good reason.

### Help, I can't connect

Make sure you

- Connected to the PittRAS WiFi network.
- Have Docker installed on your machine (a local daemon does not need to be running)
- Have your SSH key trusted by the NUC (see instructions in the computer-configuration folder)

