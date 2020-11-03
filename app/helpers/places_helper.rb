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
			data[:address] = [building.address.address, building.address.city, building.address.postal_code, building.address.country].compact.join(', ')
			
			$amount_columns = 0
			$amount_elevators = 0

			comment = ""		
			comment.concat(data[:address]) 
			comment += "\n#{building.customer.company_name}"	
			comment += "\nNumber of Batteries: #{building.batteries.count}"
			
			building.batteries.each do |battery|
				$amount_columns += battery.columns.count      
				battery.columns.each do |column|
					$amount_elevators += column.elevators.count      
				end
			end
			comment += "\nNumber of Columns: #{$amount_columns}"   
			comment += "\nNumber of Elevators: #{$amount_elevators}"   
			comment += "\nTechnical contact: #{building.tect_contact_name}"
			
			data[:comment] = comment
			$datas.append(data)
		end
		# return $datas
		# pp $datas
		puts "#####################"
		puts "#####################"
		puts "#####################"
		puts "#####################"
		results = Geocoder.search("560 Penstock Drive, Grass Valley, 95945, United State")
		pp results
		puts "#####################"
		puts "#####################"
		puts "#####################"
		puts "#####################"
	end
end




