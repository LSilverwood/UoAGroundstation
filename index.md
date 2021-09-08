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


## Downloading and preparing real recordings from satNOGS.



For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).

### Jekyll Themes

Your Pages site will use the layout and styles from the Jekyll theme you have selected in your [repository settings](https://github.com/LSilverwood/UoAGroundstation/settings/pages). The name of this theme is saved in the Jekyll `_config.yml` configuration file.

### Support or Contact

Having trouble with Pages? Check out our [documentation](https://docs.github.com/categories/github-pages-basics/) or [contact support](https://support.github.com/contact) and we’ll help you sort it out.
