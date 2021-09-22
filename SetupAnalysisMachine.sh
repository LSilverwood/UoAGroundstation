#!/bin/bash

#Author: Liam Silverwood
#Installing miniconda
echo "Installing Miniconda3"
if ! command -v conda &> /dev/null ; then	
		wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
		bash ~/miniconda.sh -b -p $HOME/miniconda			
		echo "Miniconda3 installed successfully - configuring environments."	
	else
		echo "Conda installation already found, skipping."	
fi

#Initializing conda
source $HOME/miniconda/bin/activate
conda init

##If you wish to use an environment other than base, change this to "false" and enter the name of the environment you wish to use in the line below
USEBASE=true
customEnv=Groundstation
if [ "$USEBASE" = true ] ; then
	conda activate base
	else
	conda deactivate 

	# Creating and then initialising the conda environment
	# Check to see if the environment exists

	if ! conda env list | grep -q $customEnv; then  
		conda create --name $customEnv -y
	fi


	eval "$(conda shell.bash hook)"
	conda activate $customEnv
fi

echo "Installing gnuradio"
if [[ $(conda list gnuradio --json -f) == "[]" ]] ; then
		conda install -c  conda-forge gnuradio -y
		echo "gnuradio successfully installed"
	else
		echo "gnuradio already installed, skipping"
fi

echo "Installing gr-satellites"
if [[ $(conda list gnuradio-satellites --json) == "[]" ]] ; then
		conda install -c  conda-forge gnuradio-satellites -y
		echo "gr-satellites successfully installed"
	else
		echo "gr-satellites already installed, skipping"
fi

echo "Installing git"
if ! command -v git &> /dev/null ; then
		sudo apt install -y git
		sudo apt --fix-broken install -y
		echo "git successfully installed"
	else
		echo "git installation already found, skipping."
fi

echo "Installing gr-frontends into Documents/gr-frontends"
git clone https://github.com/daniestevez/gr-frontends.git ~/Documents/gr-frontends

echo "Cloning sample satellite recordings into Documents/satellite-recordings"
git clone https://github.com/daniestevez/satellite-recordings.git ~/Documents/satellite-recordings


echo "Installing ffmpeg"
if ! command -v ffmpeg &> /dev/null ; then
		sudo apt install -y ffmpeg
		sudo apt --fix-broken install -y
		echo "ffmpeg successfully installed"
	else
		echo "ffmpeg installation already found, skipping."
fi


echo "Software installation complete. Testing operation of gr-satellites..."
gr_satellites "Suomi 100" --wavfile ~/Documents/satellite-recordings/suomi_100.wav


last4lines= "sw_count = 0

            filesystem = 1

            boot_count = 2670

            boot_cause = 1

            clock = 2068-11-18 01:41:59"


echo "If you see several lines of telemetry data, ending with $last4lines , gr-satellites was correctly installed"


