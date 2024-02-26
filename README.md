# basic_ml_env

0) you need a Ubuntu machine with an Nvidia GPU that you can ssh into.

For an AWS Option, I have tested with a `g5.xlarge' ec2 instance. Increase the root volume 100gb, the 8gb default won't be enough. This makes for a fairly powerful AI workstation that is still affordable. The on-demand price is around $1/hr. It's a good price for compute hardware that costs maybe $15k to buy physically. This makes it good value for R&D-- as long as you don't forget to shut it down when you're not using it !

Make sure you use the Ubunutu base image, and use 'ubuntu' as the username when you ssh in.

1) Clone this repo via ssh onto that machine `git clone git@github.com:Tuee22/basic_ml_env.git ~/basic_ml_env`. (NB: you will first need to generate an ssh key with `ssh-keygen` and add the public key to your github.)
2) type `~/basic_ml_env/scripts/install_docker_cuda.sh`, and reboot the machine when it's done with `sudo reboot now`
3) type `cd ~/basic_ml_env/docker` then `docker compose up -d` (this only needs to be done once, the container will start automatically on reboots)
4) once the container builds, the jupyter notebook should be listening on port 8888
5) forward the port to your localhost (vscode makes this easy, I also use termius on ipad), then go to `http://localhost:8888` in your browser
6) Open `notebooks/SDE_Simulation_with_CuPy.ipyb` and run all cells
7) If you don't see any errors everything worked ! Congrats, you now have a state-of-the-art AI environment 
