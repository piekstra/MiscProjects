require 'nokogiri'
require 'faraday'
require 'pry'
require 'fileutils'

# The current goal of this is to extract useful snippets from webpages on the first page of 
# results of a google search

# Fetches the page, saves it to a file, and returns the parsed result
def getPage(url, sitePagesFolder)
    response = Faraday.get(url)

    # open("#{sitePagesFolder}\\#{url.sub!("/", "\\")}.html", "wb") do |file|
       # file.write(page)
    # end

    parsedPage = Nokogiri.HTML(response.body)
end

# We need a place to store the site pages
sitePagesFolder = File.dirname('site_pages')
FileUtils.mkdir_p(sitePagesFolder)

startPage = ARGV[0]
getPage(startPage, sitePagesFolder)

Pry.start(binding)