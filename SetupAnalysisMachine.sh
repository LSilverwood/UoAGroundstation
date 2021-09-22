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



expected_output="gr::log :DEBUG: correlate_access_code_tag_bb0 - Access code: 930b51de
gr::log :DEBUG: correlate_access_code_tag_bb0 - Mask: ffffffff
gr::log :DEBUG: correlate_access_code_tag_bb0 - writing tag at sample 3783
gr::log :DEBUG: correlate_access_code_tag_bb0 - writing tag at sample 4863
***** VERBOSE PDU DEBUG PRINT ******
((transmitter . 9k6 FSK downlink))
pdu length = 96 bytes
pdu vector contents = 
0000: 01 80 a7 82 00 b9 fd f5 e8 01 23 01 23 01 37 1f 
0010: c9 00 1c 00 01 00 50 00 03 00 3e 00 6f 00 b2 00 
0020: b2 00 23 00 09 00 36 00 99 00 00 00 02 00 03 00 
0030: 04 00 00 00 00 03 b9 fd f5 e8 00 48 00 46 ff 9b 
0040: f2 55 ff 9c b9 fd f5 e8 00 01 00 00 00 01 00 02 
0050: 00 00 03 4d 00 4c 00 50 17 6b 1a f5 8b db ce af 
************************************
***** VERBOSE PDU DEBUG PRINT ******
((transmitter . 9k6 FSK downlink))
pdu length = 136 bytes
pdu vector contents = 
0000: 01 80 a7 82 01 b9 fd f5 e8 00 00 1b e2 00 01 16 
0010: b6 00 00 00 06 00 00 00 00 00 00 00 00 00 00 00 
0020: 00 00 00 00 00 00 00 07 00 00 00 00 00 00 00 00 
0030: 00 00 00 00 01 01 01 01 01 01 00 00 01 b9 fd f5 
0040: e8 00 00 02 58 a5 00 01 62 92 01 66 63 90 00 a3 
0050: 09 c8 07 64 00 00 00 01 00 06 63 12 00 00 00 15 
0060: 02 00 00 0a 9b 00 00 00 15 b9 fd f5 e8 01 01 01 
0070: 01 00 00 00 00 01 0a 6e 00 00 00 01 b9 fd f5 e7 
0080: c9 f4 1f b0 5a ed 03 ef 
************************************" 


satname='"Suomi 100"'

ActualOutput="$(gr_satellites "$satname" --wavfile ~/Documents/satellite-recordings/suomi_100.wav --hexdump)"

if [[ $ActualOutput == $expected_output ]] ; then
		echo "Test passed - gr-satellites is installed and working!"
	else
		echo "Test failed - output hex dumps do not match."
fi


