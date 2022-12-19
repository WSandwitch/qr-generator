require 'uri'
require 'net/http'

class ApplicationController < ActionController::Base
	
	def qr
		image=""
		respond_to do |format|
				format.svg {
					puts ENV['RAILS_QR_URI']
					if (!params[:data] || params[:data].to_s.size==0) then
						send_data( "", :filename => "error" ) if !params[:data]
					elsif params[:extended]
						key="qre/#{params[:data]}/#{params[:level]||"M"}/#{params[:color] || "000000"}/#{params[:bcolor] || "ffffff"}/#{params[:dots] || "dots"}/#{params[:squares] || "dot"}/#{params[:squaredots] || "dot"}"
						req={
							data: params[:data],
							color: params[:color] || "000000",
							bcolor: params[:bcolor] || "ffffff",
							level: params[:level]||"M",
							dots: params[:dots] || "dots",
							squares: params[:squares] || "dot",
							squaredots: params[:squaredots] || "dot"
						}
						send_data(
							Rails.cache.fetch(key, compress: true, expires_in: 5.minutes){
								Base64.decode64(
									#`cd ext;node main.js -d "#{params[:data]}" -c "##{params[:color] || "000000"}" -b "##{params[:bcolor] || "ffffff"}" #{'-i "'+params[:image]+'"' if false} -l #{params[:level]||"M"} -t #{params[:dots] || "dots"} -s #{params[:squares] || "dot"} -q #{params[:squaredots] || "dot"}`
									getQR(req)
								).sub(%/clip-path="url('#clip-path-dot-color')"/,%/clip-path="url('#clip-path-dot-color')" transform="matrix(0,1,1,0,0,0)"/) rescue ""
							},
							:filename => "qr.svg", type: 'image/svg+xml' 
						)
					else
						send_data(
							Rails.cache.fetch("qr/#{params[:data]}/#{params[:level]||"M"}", compress: true, expires_in: 5.minutes){
								RQRCode::QRCode.new(params[:data], level: params[:level]||:m)
									.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6 )
							},
							:filename => "qr.svg", type: 'image/svg+xml' )
					end
					return
				}
				format.html 
		end
	end
		
	def getQR(par)
		uri = URI(ENV['RAILS_QR_URI'])
		uri.query = URI.encode_www_form(par)

		res = Net::HTTP.get_response(uri)
		res.body if res.is_a?(Net::HTTPSuccess)
	end
end
