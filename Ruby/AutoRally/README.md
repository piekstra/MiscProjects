
### Description
This small ruby script will go to the WeRally website, login with your provided email and password, and check in to all of your missions. It supports both progress-based missions (i.e. run for 30 minutes) and yes-no missions (i.e. did you floss today).

### Usage
In Command Prompt:

```sh
ruby AutomatedRallyCheckInTabs.rb "rallyAccountEmail" "rallyAccountPassword"
```

### Requirements
In order to use this script, you must have Ruby installed - see [Ruby Downloads](https://rubyinstaller.org/downloads/ "Ruby Downloads").
You will also need to have `chromedriver.exe` in a folder that is added to your `PATH`.

#### Chrome WebDriver
You can download the webdriver [here](http://chromedriver.chromium.org/downloads "here"). Simply download the latest release, which should be called something like `chromedriver_win32.zip`. Extract the contents of the .zip file to a folder on your computer. Next, go to your `system environment variables` and add that folder path to your `Path` variable. This will allow the script to use the Chrome browser environment in an automated fashion.

##### Chrome WebDriver Version
Written and tested with ChromeDriver 2.38 (Chrome v65-67)

##### Ruby Version
Written and tested with Ruby 2.4.4-1 (x86)

##### Ruby Gems
In Command Prompt:

```sh
gem install 'watir'  
gem install 'watir-scroll'  
```

##### Rally
You must have previously created a [Rally](https://www.werally.com "Rally") account, and joined [missions](https://www.werally.com/missions/ "missions").
