#!/usr/bin/env ruby
# encoding: utf-8
require "json"
require "open-uri"
require "uri"
require "cgi"

class YOLP
  def initialize(app_id= {appID})
    @app_id = app_id
    # Hubenyの式による距離計算用パラメータ
    #rx:長半径（赤道）,ry:短半径（極）
    # Wikipedia 測地学(WGS84) (m)
    # https://ja.wikipedia.org/wiki/%E6%B8%AC%E5%9C%B0%E5%AD%A6
    # 座標を表す配列は、経度、緯度の順番で値を入れることを想定している。
    @rx = 6378137.000
    @ry = 6356752.314245
    @e = Math.sqrt(1-(@ry/@rx)**2)
    @rdRatio = Math::PI/180
  end
  def coordinate(address)
    coord = nil
    URI.open("https://map.yahooapis.jp/geocode/V1/geoCoder?query=#{CGI.escape(address)}&appid=#{@app_id}&output=json"){|f|
      json = JSON.parse(f.read)
      if json['ResultInfo']['Count'] > 0
        coord = json['Feature'][0]['Geometry']['Coordinates'].split(/,/)
        if coord.length == 2
          coord[0] = coord[0].to_f
          coord[1] = coord[1].to_f
        end
      end
    }
    coord
  end
  def address(coord)
    address = nil
    cArray = coord
    p coord
    if !coord.is_a?(Array)
      cArray = coord.split(/\s*,\s*/)
    end
    URI.open("https://map.yahooapis.jp/geoapi/V1/reverseGeoCoder?lon=#{cArray[0]}&lat=#{cArray[1]}&appid=#{@app_id}&output=json"){|f|
      json = JSON.parse(f.read)
      if json['ResultInfo']['Count'] > 0
        address = json['Feature'][0]['Property']['Address']
      end
    }
    address
  end
  def distance(coord1, coord2)
    rlon1 = @rdRatio  * coord1[0]
    rlon2 = @rdRatio  * coord2[0]
    dx = rlon1 - rlon2
    rlat1 = @rdRatio  * coord1[1]
    rlat2 = @rdRatio  * coord2[1]
    dy = rlat1 - rlat2
    p= (rlat1+rlat2)/2
    w= Math.sqrt(1-(@e*Math.sin(p))**2)
    m = @rx*(1-@e**2)/(w**3)
    n = @rx/w
    return Math.sqrt((dy*m)**2+(dx*n*Math.cos(p))**2)
  end
end
