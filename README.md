# basic_ml_env

0) you need a Ubuntu machine with an Nvidia GPU that you can ssh into.
1) Clone this repo onto that machine `git clone git@github.com:Tuee22/basic_ml_env.git ~/basic_ml_env`. (NB: you will first need to generate an ssh key with `ssh-keygen` and add the public key to your github. Don't reuse an existing key!)
2) type `~/basic_ml_env/scripts/install_docker_cuda.sh` and reboot the machine when it's done
3) type `cd ~/basic_ml_env/docker` then `docker-compose up -d`
4) once the container builds, the jupyter notebook should be listening on port 8888
5) forward the port to your localhost (vscode makes this easy, I also use termius on ipad), then go to `http://localhost:8888`
6) Open `SDE_Simulation_with_CuPy.ipyb` and run all cells
7) If you don't see any errors everything worked !