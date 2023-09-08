## Short Description

An image classifier using Tensorflow and Docker for deployment and file-sharing for communcatio.


This was a mini-project for MPCS Distributed Systems course; classifier code provided by Professor Kyle Chard.

## Instructions to run application
1) Start the Docker engine
	- In the host machine, start the Docker engine using Docker desktop or by running `sudo service docker start` in the terminal

2) Clone/download the git repository in [link](https://github.com/mpcs-52040/homework-2-mshalimay)

3) In the command line,  navigate to `homework-2-mshalimay/part1`

- Note: you can substitute steps (4) and (5) below by running `sudo chmod +x build_run.sh | ./build_run.sh` in the command line. This runs the scripts `build.sh` and `run.sh`  building the image and deploying the container. For a step-by-step process and the descripition of what the scripts are doing, go through each step separately 

4) Build the `train-model` image
	- In the command line, run `chmod +x build.sh | ./build.sh`
	- **Description**: this will execute a bash script that creates a Dockerfile and build the Docker image with following specs:
		- python 3
		- a copy of `train.py`, `classif.py` to the `HW2_part1` folder of the container filesystem
		- instalation of python libraries `tensorflow` and `imageio` 
	- To check the image was created run `docker image ls` in the command line

5) Run the `image-classifier` container
	- In the command line, run `chmod +x run.sh | ./run.sh`
	- **Description**: this will execute a bash script that:
		- stop and remove any existing `image-classifier` container
		- unzip the `images.tar.gz` creating the `images` folder (if it was not unzipped yet) in the host machine
		- run the container `image-classifier` binding the host machine folder `images` to the container folder `/HW2_part1/images`
		- The container will remain active until it is manually killed from the command line 
	- To check the container was created run `docker ps` in the command line
	- To check if `image` folders were correctly binded, run `docker exec image-classifier ls /HW2_part1/images` in the command line

6)  Classify images using the `image-classifier` container
	- in the command line, run: `chmod +x infer.sh | ./infer.sh`
	- **Description:** this will execute a bash script that:
		- randomly selects an image from the `images` folder
			- *Notice*: the script will loop while an image is found, so make sure there are files in the folder with same format as provided in the homework. This should be the case if the correct `images.tar.gz` was downloaded in step (2)
		- execute the `classify.py` in the `image-classifier` container, using the ramdomly selected image as input
		- print the predicted and expected category to the command line

*Notice*:
- The steps and code were tested for the Linux Ubuntu distribution from the WSL2 (windows subsystem for linux) and using the Linux computers from the University of Chicago. 
- I did not test the functionality on a MAC


## Note on data sharing
-  Dynamic sharing of contents in the host machine and the container is done via the `images` folder.

- I provided an alternative solution using a *shared volume* between the host computer and the container to share data. 
	- To use the volumes soution:
	  1)  in `build.sh` , uncomment the lines in 13 and 14
	  2) in `run.sh` comment the lines below "Solution 1"  and uncomment the lines below solution 2

    - Notes:
     	- This do not use the specific `images` folder but instead create an isolated directory in the host where the data between the host and the container is syncronized
     	- Notice a directory would still be created in the host machine in this case, but would be isolated from the other files in the host machine, bringing more security (potentially with a performance penalty) 
     	- Info about the volumes created, including where they are created in the host machine, can be accessed through `docker volume inspect <volume-name>`