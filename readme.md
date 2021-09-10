# dbatools Lab environment

This repo contains scripts to help you build a lab suitable for following along with the dbatools MOL labs and exercises.

## Config
This folder holds our configuration information that will be used throughout the other scripts. Here you can configure where we'll store backups, where the installation media is, and many more values.

## Scripts
This folder holds all the scripts we need to get our lab built:
- 00_Install_Prereqs.ps1 
    - This script presumes you are connected to the internet, and helps to download all the software you'll need.
    - If you are not connected to the internet you will need to manually download a few things and copy them to your lab.
- 01_Install_Lab.ps1 
    - This will install two instances of SQL Server, if you only have resources for one that is also an option
- 02_Configure_Lab.ps1
    - this will create objects for us to explore and can be run against the SQL Server installation we created in step 1 or a test instance you already have kicking around.
- 99_Cleanup_Lab.ps1
    - this will clean up all the objects created in the configuration step
    - It won't uninstall instances

## Tests - Coming Soon!
We love using pester to make sure everything looks like we expect it to. The tests folder contains pester tests that you can run to ensure our dbatools lab is set up perfectly and ready for us to use.

## Advanced - Coming Soon!
This folder will contain some more advanced scripts, for example terraform that will setup an Azure VM for the lab.