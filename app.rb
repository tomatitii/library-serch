#!/usr/bin/env ruby
# coding: utf-8
require 'sinatra'
require './yolp'
require 'open-uri'
require 'json'
enable :sessions

yolp = YOLP.new
def fetch_json(uri)
  URI.open(uri) { |f| JSON.parse(f.read) }
rescue OpenURI::HTTPError => e
  halt erb(:error, locals: { error_message: "HTTP エラー: #{e.message}" })
rescue URI::InvalidURIError => e
  halt erb(:error, locals: { error_message: "無効な URI: #{e.message}" })
rescue StandardError => e
  halt erb(:error, locals: { error_message: "エラーが発生しました: #{e.message}" })
end

get '/search' do
  erb :search
end

get '/keyword' do
  keyword = params[:keyword]
  target = "https://ci.nii.ac.jp/books/opensearch/search?title=#{URI.encode(keyword)}&format=json&appid={appID}"
  @titles = []
  @hit_books = []
  URI.open(target) do |f|
    json = JSON.parse(f.read)
    items = json["@graph"]&.first&.dig("items") || []

    @titles = items.map { |item| item["title"] }
    @IDs = items.map { |item| item["@id"] }
    session[:titles] = @titles
    session[:IDs] = @IDs
    #@hit_books = titles.zip(IDs)
  end
  erb :select
end

get '/result' do
  ids = []
  id = params[:id]
  id += ".json"
  uri = id
  begin
    URI.open(uri) do |f|
      json = JSON.parse(f.read)
      belong_info = json["@graph"]&.first&.dig("bibo:owner")
      ids = belong_info&.map{ |lib| lib["@id"] } || []
    end
  rescue OpenURI::HTTPError => e
    @error_message = "HTTP エラー: #{e.message}"
    return erb :error
  rescue URI::InvalidURIError => e
    @error_message = "無効な URI: #{e.message}"
    return erb :error
  rescue StandardError => e
    @error_message = "エラーが発生しました: #{e.message}"
    return erb :error
  end
  @names = []
  @addresses = []
  @coordinates = []
  @ids = ids
  ids.each do |id|
      id += ".json"
      begin
        URI.open(id) do |f|
            json = JSON.parse(f.read)
            library_info = json["@graph"]&.first

            name = library_info&.dig("v:fn")
            address = library_info&.dig("v:adr", "v:label")
            if name && address
              coord = yolp.coordinate(address)
              if coord 
                @names.push(name)
                @addresses.push(address)
                @coordinates.push(coord)
              end
            end
        end
      rescue OpenURI::HTTPError => e
        @error_message = "HTTP エラー: #{e.message}"
        return erb :error
      rescue URI::InvalidURIError => e
        @error_message = "無効な URI: #{e.message}"
        return erb :error
      rescue StandardError => e
        @error_message = "エラーが発生しました: #{e.message}"
        return erb :error
      end
  end

  #puts yolp.address(coord)
  session[:names] = @names
  session[:addresses] = @addresses
  erb :result
end

get '/map' do
  index = params[:index].to_i
  @name = session[:names][index]
  @address = session[:addresses][index]
  @lat = params[:lat].to_f
  @lon = params[:lon].to_f
  @bbox = "#{@lon-0.005}%2C#{@lat-0.003}%2C#{@lon+0.005}%2C#{@lat+0.003}"
  
  erb :map
end
