require 'net/http'
require 'json'
require 'uri'


class PagesController < ApplicationController
  def home
  end

  def show
    @query = params[:question]

    uri = URI("https://api.tronalddump.io/search/quote?query=#{@query}")
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
    case response["status"]
    when 412 then @cleansed_response = "must have minimum length of 3 characters"
    else
      @cleansed_response = if response["_embedded"] == []
        "Donald doesn't care about #{@query}!"
      else
        response["_embedded"]["quotes"].first["value"]
      end
    end
  end
end

