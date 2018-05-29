require 'watir'
require 'watir-scroll'

# Intent: Stops the program if input is invalid
# Returns: email, password
def validateInputParameters(args)   
    if ARGV.length < 2
        puts "Expected username and password."
        puts "User: #{ARGV[0]}"
        puts "Password: #{ARGV[1]}"
        exit
    elsif ARGV.length > 2
        puts "Too many arguments. Just enter username and password."
        exit
    end
        
    # we expect a username and pass here
    email = ARGV[0]
    password = ARGV[1]
    return email, password
end

def login(browser, email, password)
    # Login
    browser.goto 'https://accounts.werally.com/'
    browser.text_field(id: 'loginEmail').set(email)
    browser.text_field(id: 'loginPassword').set(password)
    browser.button(type: 'submit').click
end

def goToMissionsPage(browser)
    # Goto Missions
    browser.goto browser.a(id: 'navMissionsBtn').href
    # Wait for the page to finish loading what we need
    # We need the following element (the parent of the podContainer) to exist 
    # for the script we execute to get the totalMissions
    until browser.element(css: "div[ng-show='galleryMissions.loaded']").exists? do sleep 1 end
    lazyLoadHandler(browser)
end

def lazyLoadHandler(browser)    
    hardLimit = 1000
    #hardLimit = browser.execute_script("return angular.element(document.getElementsByClassName('podContainer')[0]).scope().$parent.limitTotal;")
    totalMissions = browser.execute_script("return angular.element(document.getElementsByClassName('podContainer')[0]).scope().$parent.galleryMissions.myMissions.length;")
    
    # Keep scrolling down through lazy loading - be wary of the hard limit
    loop do
        currentCount = browser.divs(class: 'missionsPod').size
        break if currentCount == totalMissions || currentCount >= hardLimit
        browser.scroll.to :bottom
    end
end

def checkInMissions(browser)
    # Check In to all missions
    browser.divs(class: 'missionsPod').each do |pod|
    
        # Skip missions that can only be checked in on a mobile device
        mobileOnly = pod.div(class: 'mobileCheckIn').exists?
        next if mobileOnly
            
        progressTotal = pod.div(class: 'progressTotal').text   
        
        # Make sure the button is in view before we do anything with it
        pod.button.scroll.to:center
        
        # This Check In doesn't involve any progress numbers
        if progressTotal == ""
            booleanCheckIn(browser, pod)
        else 
            # Extract the remaining progress required (i.e. 30 (minutes))
            remainingProgress = progressTotal.scan(/\d+/)[0].to_i
            # If no progress is required, don't do anything
            if remainingProgress > 0
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
    email, password = validateInputParameters(ARGV)
    
    # Using Chrome for this  
    browser = Watir::Browser.new :chrome
    
    login(browser, email, password)    
    goToMissionsPage(browser)
    checkInMissions(browser)

    browser.quit
end

main()
