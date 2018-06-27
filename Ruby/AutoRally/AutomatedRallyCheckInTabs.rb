require 'watir'
require 'watir-scroll'

# Intent: Stops the program if input is invalid
# Returns: email, password
def validateInputParameters(args)   
    if ARGV.length < 2
        puts "Expected at least username and password."
        puts "User: #{ARGV[0]}"
        puts "Password: #{ARGV[1]}"
        exit
    elsif ARGV.length > 4 
        puts "Too many arguments. Just enter username and password or optionall specify console logging and headless operation."
        exit
    end
        
    # we expect a username and pass here
    email = ARGV[0]
    password = ARGV[1]
    consoleLogging = ARGV[2] ? (true if ARGV[2] == "true") : false
    runHeadless = ARGV[3] ? (true if ARGV[3] == "true") : false
    return email, password, consoleLogging, runHeadless
end

def login(browser, email, password, consoleLogging = false)
    # Login
    
    puts "Logging in" if consoleLogging
    browser.goto 'https://accounts.werally.com/'
    browser.text_field(id: 'loginEmail').set(email)
    browser.text_field(id: 'loginPassword').set(password)
    browser.button(type: 'submit').click
    puts "Log in attempted" if consoleLogging
end

def goToMissionsPage(browser, consoleLogging = false)
    puts "Going to missions page" if consoleLogging
    # Goto Missions
    browser.elements(id: 'navMissionsBtn')[0].click
    # Wait for the page to finish loading what we need
    # We need the following element (the parent of the podContainer) to exist 
    # for the script we execute to get the totalMissions
    until browser.element(css: "div[ng-show='galleryMissions.loaded']").exists? do sleep 1 end
    puts "Missions page loaded" if consoleLogging
    lazyLoadHandler(browser, consoleLogging)
end

def lazyLoadHandler(browser, consoleLogging = false)   
    puts "Handling lazy loading" if consoleLogging	
    hardLimit = 1000
    #hardLimit = browser.execute_script("return angular.element(document.getElementsByClassName('podContainer')[0]).scope().$parent.limitTotal;")
    totalMissions = browser.execute_script("return angular.element(document.getElementsByClassName('podContainer')[0]).scope().$parent.galleryMissions.myMissions.length;")
    
    # Keep scrolling down through lazy loading - be wary of the hard limit
    puts "Expecting #{totalMissions} elements" if consoleLogging
    loop do
        currentCount = browser.divs(class: 'missionsPod').size
	puts "Currently loaded #{currentCount} elements" if consoleLogging
        break if currentCount == totalMissions || currentCount >= hardLimit
        browser.scroll.to :bottom
    end
    puts "Fully loaded lazy page" if consoleLogging
end

def checkInMissions(browser, consoleLogging = false)
    puts "Checking in missions" if consoleLogging
    # Check In to all missions
    browser.divs(class: 'missionsPod').each do |pod|
    
        # Skip missions that can only be checked in on a mobile device
        mobileOnly = pod.div(class: 'mobileCheckIn').exists?
	puts "Skipping mobile-only mission check in" if mobileOnly and consoleLogging
        next if mobileOnly
            
        progressTotal = pod.div(class: 'progressTotal').text   
        
        # Make sure the button is in view before we do anything with it
        pod.button.scroll.to:center
	missionTitle = pod.h3(class: 'podHeader').text
	missionId = pod.id
	puts "Checking in mission (#{missionId}): #{missionTitle}" if consoleLogging
        
        # This Check In doesn't involve any progress numbers
        if progressTotal == ""
            booleanCheckIn(browser, pod)
        else 
            # Extract the remaining progress required (i.e. 30 (minutes))
            remainingProgress = progressTotal.scan(/((\d+\.)?\d+)/)[0][0].to_f
            # If no progress is required, don't do anything
            if remainingProgress > 0.0
                # Set the progress input - this has to be done before checking in, otherwise
                # the button is disabled and the check in fails
                pod.text_field(class: 'checkInInput').set(remainingProgress)
                # Check In - this doesn't navigate to a new page, but it opens a popup congratulating you            
                pod.button.click            
                # Wait for the (congratulations popup) completion container to appear
                # and close it, then wait for it to go away          
                until browser.div(class: 'completionContainer').exists? do sleep 1 end
                browser.div(class: 'completionContainer').button.click
                until !browser.div(class: 'completionContainer').exists? do sleep 1 end
                # The page refreshes after the container closes so we have to go through
                # the missions page again
                goToMissionsPage(browser, consoleLogging)
            end
        end
    end
end

def booleanCheckIn(browser, pod)
    missionId = pod.button.attribute_value('event-label').split('_')[2]
    missionUrl = "https://www.werally.com/missions/details/#{missionId}/"
    browser.execute_script("window.open('#{missionUrl}');")
    browser.windows.last.use do
        # Wait until we have the progress section loaded
        until browser.div(class: 'dailyProgress').exists? do sleep 1 end
        # Check In if not already
        yesBtn = browser.button(class: 'yesBtn')
        if (yesBtn.exists?) then yesBtn.click end
        browser.windows.last.close
    end
end

def main() 
    email, password, consoleLogging, runHeadless = validateInputParameters(ARGV)
    
    # Using Chrome for this  
    browser = Watir::Browser.new :chrome, headless: runHeadless
    
    login(browser, email, password, consoleLogging)    
    goToMissionsPage(browser, consoleLogging)
    checkInMissions(browser, consoleLogging)
    puts "Finished" if consoleLogging
    browser.quit
end

startTime = Time.now
main()
endTime = Time.now
totalTime = endTime - startTime
timeMessage = Time.at(totalTime).utc.strftime("%H:%M:%S")

puts "Time elapsed: #{timeMessage}"
