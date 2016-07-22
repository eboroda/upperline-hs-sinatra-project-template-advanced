require 'uri'
require 'net/http'
require 'json'
require 'pry'

def format_request_and_send_api_call(address)
    key= "AIzaSyAVx1eef9WQBL--tbcxh-f1JrtSh8jfOMI"
    geo_request = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address.gsub(" ","+")}&key=#{key}"
    make_api_call(geo_request)
end

def make_api_call(request_string)
    uri = URI(request_string)
    response = Net::HTTP.get(uri)
    formatted_data = JSON.parse(response)
    data = formatted_data["results"][0]["geometry"]["location"]
    @lat = data["lat"] 
    @lng = data["lng"]
    @answer_array = [@lat,@lng]
end 


def format_request_and_send_api_call_to_places(lat,lng)
    key= "AIzaSyCPSiFsUKqRCzNQFr502QvmHnvG67fYkDo"
    places_request = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=500&key=#{key}"
    make_api_call_to_places(places_request)
end

def make_api_call_to_places(request_string)
    uri = URI(request_string)
    response = Net::HTTP.get(uri)
    formatted_data = JSON.parse(response)
    @answer_array = []
    formatted_data["results"].each do |thing| 
         @answer_array << thing["name"]
    end 
    @answer_array
end 

def calL_wiki_api(formatted_name)
    wiki_request = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=#{formatted_name.gsub(" ","_")}"
    make_api_call(wiki_request)
end 
    

def generate_wiki_link(name)
    formatted_name = name.gsub(" ", "_")
    request_string = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=#{formatted_name}"
    
    uri = URI(request_string)
    response = Net::HTTP.get(uri)
    formatted_data = JSON.parse(response)
    
    formatted_name.each do |place|
        "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=#{place}"
    end
    
    if names[:"query"][:"pages"].keys.include?(:"-1")
    	"Don't display"
    else
    	response[:"query"][:"pages"].values.first[:"title"]
		response[:"query"][:"pages"].values.first[:"extract"]
    end
    
    if names[:"query"][:"pages"].values.first:[:"title"] == "New York"
        "Don't display"
    else 
        response[:"query"][:"pages"].values.first[:"title"]
		response[:"query"][:"pages"].values.first[:"extract"]
	end 
	
	if names[:"query"][:"pages"].values.first:[:"title"].include?(:"Hotel")
	    "Don't Display"
	else 
	    response[:"query"][:"pages"].values.first[:"title"]
	    response[:"query"][:"pages"].values.first[:"extract"]
	end 
	
	if names[:"query"][:"pages"].values.first:[:"title"] == "Inn"
	    "Don't Display"
	else 
	    response[:"query"][:"pages"].values.first[:"title"]
	    response[:"query"][:"pages"].values.first[:"extract"]
	end 
	
      
end 





# https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=Empire_State_Building
# for each name that comes back from Google, send request to Wiki API
# if results, then display
# if not, don't display