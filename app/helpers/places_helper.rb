require 'geocoder'

module PlacesHelper
	def get_data 
		# Location of the Building
		# Number of floors in the building (If the information is available)
		# Client name
		# Number of Batteries
		# Number of Columns
		# Number of Elevators
		# Full name of technical contact

		$datas = []

		Building.all.each do |building|
			data = {}
			address = [building.address.address, building.address.city, building.address.postal_code, building.address.country].compact.join(', ')
			
			if Geocoder.search(address).length > 0
				get_coordinates = Geocoder.search(address)
				pp get_coordinates

				data[:lat] = get_coordinates.first.coordinates[0]
				data[:lng] = get_coordinates.first.coordinates[1]
			end
			
			$amount_columns = 0
			$amount_elevators = 0

			comment = "<h4><FONT color='#920001'>#{building.customer.company_name}</FONT></h4>"	
			comment += "<h6><FONT color='#0B64A0'>#{address}</FONT></h6>"		
			comment += "<b>Number of Batteries:</b> #{building.batteries.count}"
			
			building.batteries.each do |battery|
				$amount_columns += battery.columns.count      
				battery.columns.each do |column|
					$amount_elevators += column.elevators.count      
				end
			end
			comment += "<br><b>Number of Columns:</b> #{$amount_columns}"   
			comment += "<br><b>Number of Elevators:</b> #{$amount_elevators}"   
			comment += "<br><b>Technical contact:</b> #{building.tect_contact_name}"
			
			data[:infowindow] = comment
			$datas.append(data)
		end
		pp $datas
		return $datas
	end
end




