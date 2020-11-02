require 'csv'

addresses_csv = []
file_ = File.open('addresses-us-1000.csv')
csv_text = file.read(file)
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
    address_csv = []
    address_csv.append(row['address'])
    address_csv.append(row['address2'])
    address_csv.append(row['city'])
    address_csv.append(row['postal_code'])
    address_csv.append(row['country'])
    addresses_csv.append(addresses_csv)
end

file_.close()
