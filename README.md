![alt text](badge.png "UbuntuAfterConf Project")
# UbuntuAfterConf
A set of bash scripts to automate the configuration of the freshly installed Ubuntu 16.04 LTS.

#### Work in progress for the next version can be foun [here](https://github.com/crtcji/UbuntuAfterConf/projects/1).

## Installation of the Ubuntu 16.04 LTS

> - Install Ubuntu without internet connection  
>- Whenever possible check the mdsums of the manually downloaded apps.

### Installation process  
_This section should be automated._  

- __Welcome__  
  - _English_
- __Installation Type__
  - _Encrypt the new Ubuntu installation for security_
  - _Use LVM with the new Ubuntu installation_
- __Where are you?__
    - _Your Location_
- __Keyboard layout__
  - _English (US) - English (US)_
- __Who are you?__
  - _Require my password to log in_
  - _Encrypt my home folder_

## After installation
### Configuration
###### At this point there will be still no internet connection
Wait for the Ubuntu asking to save the passphrase for the encrypted home directory. When the window will popup just press "Run this action now" and enter you user's password in the automatically opened terminal. Then save somewhere the passphrase. It's needed when restoring access to the home folder.  

##### Disable Telemetry
- System Settings -> Security and Privacy -> Diagnostics

##### Run the main script
Before running the script Enable the internet connection.

##### ESET _(optional)_
Manually install Eset Antivirus for Linux.  
_libc6:i386_ library is needed for the ESET AV to start installation pocess. It is  automatically installed on the previous step.
  * Verify shasum
  * Install manually as root user
  * I am showing only the modified steps.
  * Custom
  * Let "Enable ThreatSense.Net Early Warning System" checked. * Press "Setup" button and disable the "Submission of Suspicious Files" as well as the "Submission of Anonymous Statistical Information".  
  * Enable detection of ptoentially unwanted applications.  
  * Restart the system as the installation software sugests.  


#### Ubuntu Settings Center
_This section should be automated._  

##### Desktop   
  * Appearance  
    * Choose time-changing-wallpapers  
    * Launcher size icon: 40
  * Behavior  
    * Auto-hide the launcher
    * Enable workspaces

##### Brightness & Lock
  * 3 minutes  
  * Lock: ON  
    * 10 minutes
    * Require password

##### Language Support (already automated)
  * Accept the installation of the english language aid packages  

##### Security and privacy
  * Security
    * Waking from suspend  
    * Returning from blank screen  
    * 10 minutes
  * Search  
    * OFF   (default)  
  * Diagnostics  
    * Uncheck both options   

##### Text entry
  * Romanian (standard)  
  * Russian  

##### Bluetooth
  * OFF or ON if the Apple keyboard and mouse are required  
  * Visibility OFF   (default)  

##### Keyboard
  * Shortcuts
    * Custom shortcuts  
      * Volume +  
        `amixer -D pulse sset Master 3%+`  
      * Volume -  
        `amixer -D pulse sset Master 3%-`    
      * Suspend _(Shift+AltS)_  
        `systemctl suspend`  

##### Backups  
  * The backup partition should be formatted as encrypted  
  * Folders to save: crt (the home folder)  
  * Folders to ignore:  
   * Trash (default)  
   * ~/Downloads (default)  
  * Storage location
   * Storage location: the encrypted backup partition  
   * Folder: nothing  
  * Scheduling  
   * Automatic backup: ON  
   * Every: Day  
   * Keep: At least six months  

##### Software & Updates  
  * Updates  
   * Check all boxes (default)  
   * Daily (default)  
   * Download and install automatically (default)  
   * Display immediately  
   * For LTS versions (default)  
  * Additional Drivers  
   * Check all the necessary options in order to install the latest drivers

##### Time and Date  
  * Time&Date  
   * Automatically from the Internet (default)  
  * Clock  
    * Weekday  
    * Date and month  
    * Year  
    * 24-hour time  
    * Seconds   

### Nautilus Preferences (Files)
##### Behavior
  * Single click to open items  
  * Uncheck: Ask before enptying the Trash or deleting files  

##### Display
  * Check: Navigate folders in a tree  

##### Preview
  * Thumbnails size: 4 GB  
  * Count number of items: Always  

### gEdit Preferences

##### View
  * Check the following:  
   * Display line numbers  
   * Display overview map  
   * Highlight current line  
   * Highlight matcjing brackets  

##### View
  * Check the following:  
   * Tab width: 2  
   * Insert spaces instead of tabs  
   * Enable automatic indentation  
  * Autosave every 1 minutes  

##### Fonts&Colors
  * Uncheck: Use the system fixed width font  
  * Color Scheme: Oblivion  

##### Plugins
  * Enable the following:  
   * Bookmarks  
   * Bracket completion  
   * Character map  
   * Code comment  
   * Color Picker  
   * Color scheme editor  
   * Commander  
   * Dashboard  
   * Devhelp support  
   * Draw spaces  
   * Embedded Terminal  
   * External Tools  
   * Find in Files  
   * Git  
   * Join/Split Lines  
   * Multi Edit  
   * Quick open  
   * Smart Spaces  
   * Snippets  
   * Sort  
   * Text size  
   * Word completion  

### Rhythmbox Preferences

##### General
  * Uncheck: Track number  
  * Check: Last played, Rating  

##### Playback
  * Check: Crossfade  
  * Crossfade duration: 1.0  

##### Music
  * Preferred format: FLAC  

##### View Menu
  * Check: View Queue as Sied Panel  

##### Control Menu
  * Check: Shuffle  

##### Tools Menu (Plugins)
  * Check the following plugins:  
   * Alternative Toolbar  
   * Song Lyrics:  
    * set the folder to /home/$usr/Lyrics  
    * Enable lyrics providers  
   * Soundlcoud  
  * Uncheck: Cover art search  

### Firefox Preferences

##### Advanced
  * Data choices: uncheck everything  

##### Addons
  * HttpsEverywhere  
  * uBlock Origin
  * Container by Mozilla https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/

##### General
  * Show tabs from the last time  

##### Search
  * Make StarPage the main search engine  
  * Add the following search engines to the address bar submenu:  
   * YouTube  
   * Gandi.net  
   * Namecheap.com  
   * Yandex.com  

##### Content
  * Check: DRM  
  * Preferences languages: Delete everything except English [en]  

##### Privacy
  * Tracking-Change Block Lists: Choose Disconnect.me strict protection  
  * Do Not Track: Always  

##### Security
  * Set a maser password  

##### Advanced
  * Check:  
   * General: Search for text when typing  
   * Network: Limit cache to 350 MB  

##### Customize the interface

##### Add Bookmark bar

### Atom Editor
##### Settings
  * Telemetry consent - No  
  * Welcome Guide - No  
  * Check:
    * Editor:
      * Show Indent Guide
      * Show Invisibles
      * Soft Wrap
    * Markdown Package: GitHub Like Preview Style

### VirtualBox
##### Settings
  * Set Default Machine Folder to a separate partition  
  * Set the commander Key
  * Install Oracle VM VirtualBox Extension Pack

### Unity Settings
* Unlock from Launcher the following shortcuts: LibreOffice Writer, LibreOffice Calc, LibreOffice Impress, Ubuntu Software, System Settings

### Unity-tweak-tool
##### Unity
* Launcher
  * Minimize single windows applications on click
* Webapps
  * Integartion prompts: OFF  
  * Uncheck the following options fomr the Preauthorised domains scetion: amazon, ubuntuone  
* Switcher
  * Switch between windows on all workspaces

#### Windows manager
  * Workspace switcher
    * horizontal 4
    * vertical 1
  * Window snapping: for each halfs and corners
  * Hot corners
   * Bottom: Show workspaces
  * Additional
   * Auto-raise: OFF
   * Focus mode: Click
   * Titlebar actions:
    * Double click: Maximize
    * Middle click: Minimize
    * Right click: Menu

  * System
   * Scrolling
    * Scrollbars: Legacy
