require 'net/http'
require 'json'
require 'uri'

class PagesController < ApplicationController
  def home
  end

  def show
    # raise
    @query = params[:query]
    # this converts the data as a string from the parse method into a JSON format
    response = JSON.parse(parse)

    @cleansed_response = if response["status"] == 412
      "must have minimum length of 3 characters"
    elsif [400, 403, 404, 405, 406, 410, 418, 429, 500, 503].include?(response["status"])
      "Please try again"
    elsif response["_embedded"] == []
        "Donald doesn't care about #{@query}!"
    else
      response["_embedded"]["quotes"].first["value"]
    end
  end

  private

  def parse
    uri = URI("https://api.tronalddump.io/search/quote?query=#{@query}")
    req = Net::HTTP::Get.new(uri)
    req["Accept"] = "application/hal+json"

     req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) {|http|
      http.request(req)
    }
    response.body
  end
end

