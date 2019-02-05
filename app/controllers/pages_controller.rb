require 'net/http'
require 'json'
require 'uri'


class PagesController < ApplicationController
  def home
  end

  def show
    uri = URI("https://api.tronalddump.io/search/quote?query=obama")
    req = Net::HTTP::Get.new(uri)
    req["Accept"] = "application/hal+json"

     req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) {|http|
      http.request(req)
    }

    # this converts the data as a string into a JSON format
    response = JSON.parse(response.body)
    @cleansed_response = response["_embedded"]["quotes"][2]["value"]
  end
end

