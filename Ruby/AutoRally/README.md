
### Description
This small ruby script will go to the WeRally website, login with your provided email and password, and check in to all of your missions. It supports both progress-based missions (i.e. run for 30 minutes) and yes-no missions (i.e. did you floss today).

### Usage
$ ruby AutomatedRallyCheckIn.rb rallyAccountEmail rallyAccountPassword

### Requirements
In order to use this script, you must have Ruby installed - see [Ruby Downloads](https://rubyinstaller.org/downloads/ "Ruby Downloads").

##### Ruby Version
Written and tested with Ruby 2.4.4-1 (x86)

##### Ruby Gems
gem 'watir'  
gem 'watir-scroll'  

##### Rally
You must have previously created a [Rally](https://www.werally.com "Rally") account, and joined [missions](https://www.werally.com/missions/ "missions").
