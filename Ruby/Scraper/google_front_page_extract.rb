# require 'nokogiri'
# require 'faraday'
# require 'pry'
# require 'fileutils'
require 'watir'
require 'watir-scroll'

# The current goal of this is to extract useful snippets from webpages on the first page of 
# results of a google search

# googleUrl = "https://www.google.com/"

# Fetches the page, saves it to a file, and returns the parsed result
# def getPage(url, sitePagesFolder)
    # response = Faraday.get(url)

    # # open("#{sitePagesFolder}\\#{url.sub!("/", "\\")}.html", "wb") do |file|
       # # file.write(page)
    # # end

    # parsedPage = Nokogiri.HTML(response.body)
# end
joyWords = []

def getSurroundingText(text, wordStartIndex, wordRadius)    
    textWords = text.split(/\ /)
    
    wordIndex = 0
    currentTextLength = 0
    textWords.each do |word|
        currentTextLength = word.length + 1        
        break if currentTextLength > wordStartIndex
        wordIndex += 1
    end 
    
    # Now we have the index of our word, get words on either side of it with
    firstWordIndex = wordIndex - wordRadius
    firstWordIndex = 0 if firstWordIndex < 0
    
    lastWordIndex = wordIndex + wordRadius
    lastWordIndex = textWords.length if lastWordIndex > textWords.length
    
    return textWords[firstWordIndex..lastWordIndex].join(' ')
end

def getTextNearJoyWords(text)
    results = []
    joyWords.each do |word|
        indexes = text.downcase.enum_for(:scan, /?=#{word.downcase}/).map { Regexp.last_match.offset(0).f }
        results[word] = indexes
    end
    
    textNearJoyWords = []
    results.keys.each do |resultKey|        
        results[resultKey].each do |wordStartIndex|
            surroundingText = getSurroundingText(text, wordStartIndex, 5)
            textNearJoyWords[resultKey] = { wordStartIndex => surroundingText}            
        end
    end
    
    return textNearJoyWords
end

# def searchGoogle(browser, query)    
    
    # browser.goto 'https://www.google.com/'
    # browser.text_field(id: 'lst-ib').set(query)    
    # browser.send_keys :enter    
    # until browser.div(id: 'resultStats').exists? do sleep 1 end    
# end


# def extractSummaryFromPage(page)
    # # Using Chrome for this  
    # browser = Watir::Browser.new :chrome
    # browser.goto page
    
    # summary = browser.title
    
    # browser.quit
    
    # return summary
# end


def scanResults(browser)    
    startTime = Time.now
    
    threads = []
    browser.divs(class: 'g').each do |result|
        next unless result.h3.a.exists?
        page = result.h3.a.href
        threads.push(Thread.new { 
            Thread.current["summary"] = extractSummaryFromPage(page) 
        })
    end
    
    summaries = threads.collect { |t| t.join; t["summary"] }
    
    endTime = Time.now
    elapsedTime = endTime - startTime
    puts "elapsed time:", elapsedTime
    
    return summaries
end


def main()
    # We need a place to store the site pages
    # sitePagesFolder = File.dirname('site_pages')
    # FileUtils.mkdir_p(sitePagesFolder)

    # startPage = "https://www.google.com/"
    search = ARGV[0]

    # Using Chrome for this  
    browser = Watir::Browser.new :chrome
        
    # getPage(startPage, sitePagesFolder)
    searchGoogle(browser, search)    
    results = scanResults(browser)
    browser.quit
    puts results
end


main()
# Pry.start(binding)