require 'rqrcode'
require 'base64'
require 'net/http'


class QRGenerator
  def call(env)
    req = Rack::Request.new(env)
    params=req.params
    case req.path_info
    when /.*\.svg/
      if (!params['data'] || params['data'].to_s.size==0) then
	[500,{},[""]]
      elsif params['extended'] then
        [200, {"Content-Type" => "image/svg+xml"}, [
          Base64.decode64(
            getQR({
              data: params['data'],
              color: '#'+(params['color'] || "000000").sub('##','#'),
              bcolor: '#'+(params['bcolor'] || "ffffff").sub("##","#"),
              level: params['level']||"M",
              dots: params['dots'] || "dots",
              squares: params['squares'] || "dot",
              squaredots: params['squaredots'] || "dot"
            })
	  ).sub(%/clip-path="url('#clip-path-dot-color')"/,%/clip-path="url('#clip-path-dot-color')" transform="matrix(0,1,1,0,0,0)"/)
	]]
      else 
        [200, {"Content-Type" => "image/svg+xml"}, [
	  RQRCode::QRCode.new(params['data'], level: params['level']||:m)
		.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6 )
	]]
      end
    else
      [404, {"Content-Type" => "text/html"}, ["I'm Lost!"]]
    end
  end


  def getQR(par)
    uri = URI(ENV['RAILS_QR_URI'])
    uri.query = URI.encode_www_form(par)
	
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end
end

run QRGenerator.new
