require 'bundler'
require_relative 'models/model.rb'
Bundler.require


class ApplicationController < Sinatra::Base

  get '/' do
    @title = "Homepage"
    erb :index, :layout => :base
  end

  post '/page2' do
    @title = "page2"
	  @lat_lng = format_request_and_send_api_call(params[:user_input])
	  @places = format_request_and_send_api_call_to_places(@lat_lng[0],@lat_lng[1])
	  @articles = generate_wiki_info(@places)
    erb :page2, :layout => :base
  end

end
