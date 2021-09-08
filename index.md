# Installation and Operation of gr-satellites

## Requirements
This guide has been tested and confirmed to work on Ubuntu 18.04 LTS and Ubuntu 20.04 LTS.You must be connected to the internet to install the necessary software. You will require superuser permissions to install the software.


## Software Installation

### Recommended Method: Installation Shell Script.

The shell script [SetupAnalysisMachine.sh](https://github.com/LSilverwood/UoAGroundstation/blob/main/SetupAnalysisMachine.sh) will automatically install Miniconda3, gnuradio, gr-satellites, gr-frontends, and all of their dependencies. The script also verifies that gr-satellites is functioning by decoding a recorded .wav file.

If the script fails to complete, you should take not of the stage at which it failed - the script will print "Installing X" and "X Successfuly Installed" as it works through installing the programs one by one. Then, skip down to the 2nd installation method (Manual Installation) and attempt to manually install whichever piece of software responsible for the error.

To use the script, download it from the [main github branch.](https://raw.githubusercontent.com/LSilverwood/UoAGroundstation/main/SetupAnalysisMachine.sh). Locate the the directory where the file is stored(Typically in the downloads folder), right click, and select "Open in terminal".
Then, enter the following command in the terminal window:
```bash
sudo bash ./SetupAnalysisMachine.sh
```
and enter your password when prompted. When the script finishes executing, you should see the output "Test passed - gr-satellites is installed and working!". Additionally, you will see an example of a decoded packet in the terminal window. 

### Manual Method: 

The manual method of installing the software is covered in great detail in [gr_satellites_guide_Project_93.pdf](https://github.com/LSilverwood/UoAGroundstation/blob/main/gr_satellites_guide_Project_93.pdf). TODO: Transcribe this.

# Testing and Using Gr-Satellites

## Downloading and preparing real recordings from SatNOGS.

1. Go to the (SatNOGS observations homepage)[https://network.satnogs.org/observations/], and filter to only include 'Good' (i.e the green tick) observations, and select 'With Data' and 'With Audio' in the results section. You may also choose a specific satellite at this stage. 
2. Click through to one of the listed observations. Click on the 'download audio' icon on the left hand side of the webpage. You can download as many observations as you want.
3. (Optional) If you wish to test gr-satellites using either a recorded wav file directly, or to do a simulated over the air test (I.e stream the audio over UDP from one computer to another), you must convert the .ogg files to 48kHz wav files. This is best done using ffmpeg. The [SatNOGStoWAv.sh](https://github.com/LSilverwood/UoAGroundstation/blob/main/SatNOGStoWav.sh) shell command can assist with this - when run, it will look for any .ogg files in the same directory as the script. The script then uses the observation number (recorded in the name of the file) to pull the satellite's NORAD ID from the SatNOGS database. Finally, the script creates a new folder called "Wavs" and converts each .ogg to a .wav file, named with the satellite's NORAD ID. When using gr-satellites, you must specify the broadcasting satellite - either by NORAD ID or by name, so having access to the NORAD IDs proves to be very useful.

## Decoding a recorded wav file.
To use gr-satellites to decode a wav file, the following command must be entered in the terminal
```shell
gr_satellites SATELLITE_NAME --wavfile PATHTOWAVFILE --samp_rate 48e3
```
SATELLITE_NAME can be either the NORAD ID, or the satellite's commonly used name. If the name contains a whitespace character, it must be input in double quote marks e.g "Suomi 100". 
Note that while gr-satellites is stylised with a hyphen between the two words, the command uses an underscore.

If you have correctly entered the command, you should see telemetry data being sent to the terminal output. As with all terminal commands, you can pipe this output into another terminal command using the | character, or send it to a file with a > character followed by the name of the output file.

## Simulated over the air test with gr-frontends.

gr-frontends is a small utility designed to essentially simulate the output of an SDR being controlled by GQRX - i.e 1 channel 48kHz audio being streamed over UDP port 7355. This testing can be performed with either 1 computer, or 2 computers that are connected to the same network. These instructions are given to 2 computers, in which the computer that streams the audio is the "Source Computer" and the the computer that runs gr-satellites is the "Analysis Computer". If you wish to test this with only 1 computer, you can safely ignore these labels.

1. In a terminal window on the source computer, enter the command `gnuradio-companion`. In the GUI that opens, select file->open. Navigate to the 'gr-frontends' folder, located inside the Documents folder. Select and open 'wav_48kHz.grc'.
2. Double click on the parameter block with the ID value "input_file". In the value field, enter the path to the recording you will be using. If you are using 2 computers, you will also need to change the "destination" parameter block to be the local IP address of the analysis computer. You can find this out by entering the terminal command `ifconfig`, and looking for 'inet' value. This is typically of the form 192.168.X.XXX. If you are only using 1 computer, this should be left as 'localhost'.
3. On the analysis machine, enter the following command to start gr-satellites.
```shell
gr_satellites SATELLITE_NAME --udp --samp_rate 48e3
```
As for before, the satellite name can be the NORAD ID or the commonly used name. 
4. Back on the source machine, click the green play icon on the toolbar to execute the flowgraph. A dialogue box concering a missing xterm executable will appear if this is your first time running the programm - this can be dismissed.
5. Watch the output of the terminal on the analysis PC. Real SatNOGs recordings tend to have significant amounts of dead air either side of the packets, so it is not unusual to have to wait several minutes before seeing any meaningful output.

## Over the air test

To perform an over the air test, you must have RF equipment capable of broadcasting, as well as the legal right to operate it. The equipment in question does not have to be strong, assuming you will keep the broadcasting antenna close to the receiving antenna. For this test, you will require typically a minimum of 2 devices - 1 to broadcast the signal, and 1 to receive and decode it. You can also split this further into 1 recieving computer, and 1 decoding computer, by broadcasting the output of GQRX over UDP.
#TODO: Need to update shell, instructions etc to include installation of GQRX.
1. Locate the audio in line on your broadcasting eqipment, and connect this via a cable to a computer/laptop/phone that is playing the recording on loop. 
2. On the receiving computer, press the green icon to start GQRX recieving signals. You should then take a look around the FM frequencies to find a frequency that is within your antenna's broadcasting range, and isn't already busy. Tune both the recieving antenna and broadcasting antenna to this frequency. If you have your volume on, you may now be able to hear the recording - typically, the recording sounds predominantly like static, with occasional quiet, high pitched beeps or clicks.
3. Click the small network icon on the bottom right hand corner of GQRX to begin broadcasting the audio over UDP.
4. On the decoding machine, start gr-satellites with the following command
```shell
gr_satellites SATELLITE_NAME --udp --samp_rate 48e3
```
After a few moments, you should start to see decoded frames appearing in the terminal window.

## Debugging
TODO: hexdump output


For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/LSilverwood/UoAGroundstation/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
