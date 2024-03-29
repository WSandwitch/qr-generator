class ApplicationController < ActionController::Base
	
	def qr
		$MUTEX ||= Mutex.new
		image=""
		respond_to do |format|
				format.svg {
				
					if (!params[:data] || params[:data].to_s.size==0) then
						send_data( "", :filename => "error" ) if !params[:data]
					elsif params[:extended]
						key="qre/#{params[:data]}/#{params[:level]||"M"}/#{params[:color] || "000000"}/#{params[:bcolor] || "ffffff"}/#{params[:dots] || "dots"}/#{params[:squares] || "dot"}/#{params[:squaredots] || "dot"}"
						req="-d \"#{params[:data]}\" -c \"##{params[:color] || "000000"}\" -b \"##{params[:bcolor] || "ffffff"}\" #{'-i "'+params[:image]+'"' if false} -l #{params[:level]||"M"} -t #{params[:dots] || "dots"} -s #{params[:squares] || "dot"} -q #{params[:squaredots] || "dot"}"
						begin
							$MUTEX.synchronize{
								$QR.puts(req)
							}
						rescue
							$MUTEX.synchronize{
								$QR = IO.popen("cd ext;node main_popen.js", "r+")
								sleep(0.5)
								$QR.puts(req)
							}
						end
						$MUTEX.synchronize{
							image=$QR.readline
						}
						send_data(
							Rails.cache.fetch(key, compress: true, expires_in: 5.minutes){
								Base64.decode64(
									#`cd ext;node main.js -d "#{params[:data]}" -c "##{params[:color] || "000000"}" -b "##{params[:bcolor] || "ffffff"}" #{'-i "'+params[:image]+'"' if false} -l #{params[:level]||"M"} -t #{params[:dots] || "dots"} -s #{params[:squares] || "dot"} -q #{params[:squaredots] || "dot"}`
									image
								).sub(%/clip-path="url('#clip-path-dot-color')"/,%/clip-path="url('#clip-path-dot-color')" transform="matrix(0,1,1,0,0,0)"/)
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
end
