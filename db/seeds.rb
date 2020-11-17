require 'faker'


###Intervention generator



def create_intervention

  random = rand(1..2)
  startDate = Faker::Date.between(from: '2018-09-30', to: '2020-09-30')

  int_ = Intervention.new 
  int_.startDateIntervention = startDate
  int_.report = Faker::ChuckNorris.fact

  if random == 1
    int_.endDateIntervention = Faker::Date.between(from: startDate, to: '2020-10-30')
  end

  return int_
end
    


# Real Addresses
  class AddressCsv
    
    attr_accessor :address, :address2, :city, :postal_code, :country
    
    def initialize()
      @address = ""
      @address2 = ""
      @city = ""
      @postal_code = ""
      @country = ""
    end
  end

  $addresses_csv = []
  csv_text = File.read(Rails.root.join('lib', 'seeds', 'addresses-us-1000.csv'))
  csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
  csv.each do |row|
      address_csv = AddressCsv.new
      address_csv.address = row['address']
      address_csv.address2 = row['address2']
      address_csv.city = row['city']
      address_csv.postal_code = row['postal_code']
      address_csv.country = row['country']
      $addresses_csv.append(address_csv)
  end
  # pp addresses_csv[0].address
  $iterator_addresses = 0
# /Real Addresses

# quote_generator
  def numbers_of_columns (floors)
    return (floors / 20).round()
  end

  def residential(apartments, floors, basements)
  return ((apartments / (floors - basements)) / 6) * numbers_of_columns((floors - basements)).round()
  end

  def commercial(cages)
    return cages
  end

  def corporate(occupants, floors, basements)
    numbers_of_columns = numbers_of_columns(floors) + 1
    numbers_of_elevators = (occupants * (floors) / 1000).round()
    elevators_per_column = (numbers_of_elevators / numbers_of_columns).round()
    return numbers_of_columns * elevators_per_column
  end

  $std = (1.1 * 7565).round(2)
  $pre = (1.13 * 12345).round(2)
  $exc = (1.16 * 15400).round(2)

  def game(game)
    if game == "standard"
        return $std
    elsif game == "premium"
        return $pre
    else
        return $exc
    end
  end

  $type_building = ["Residential", "Corporate", "Commercial", "Hybrid"]
  $models = ["standard", "premium", "excelium"]

  def quote_generator()
    company_name = Faker::Company.name
    building_type = $type_building[rand(0..3)]
    game = $models[rand(0..2)]
    apartments = 0
    floors = 0
    basements = 0
    parkings = 0
    elevator_needed = 0
    business_qty = 0
    occupants = 0
    hours_activity = 0
    total_price = 0
    
    if building_type == "Residential"
      floors = rand(5..100)
      apartments = floors * rand(5..30)
      basements = rand(2..((floors/6).round()+1))
      elevator_needed = residential(apartments, floors, basements)
      total_price = elevator_needed * game(game)
    elsif building_type == "Commercial"
      elevator_needed = rand(10..100)
      business_qty = elevator_needed * rand(2..4)
      floors = business_qty * rand(1..3)
      basements = rand(2..(floors/6).round()+1)
      parkings = rand(2..(floors/8).round()+1)
      total_price = elevator_needed * game(game)
    elsif building_type == "Corporate"
      occupants = rand(500..2000)
      floors = rand(5..50)
      basements = rand(2..(floors/6).round()+1)
      elevator_needed = corporate(occupants, floors, basements)
      business_qty = elevator_needed * rand(2..4)
      parkings = rand(2..(floors/8).round()+1)
      elevator_qty = elevator_needed
      total_price = elevator_needed * game(game)
    else
        occupants = rand(500..2000)
        floors = rand(5..50)
        basements = rand(2..(floors/6).round()+1)
        elevator_needed = corporate(occupants, floors, basements)
        business_qty = elevator_needed * rand(2..4)
        parkings = rand(2..(floors/8).round()+1)
        hours_activity = rand(8..24)
        total_price = elevator_needed * game(game)
    end

    return [    company_name,
                building_type,
                apartments,
                floors,
                basements,
                parkings,
                elevator_qty,
                business_qty,
                occupants,
                hours_activity,
                game,
                elevator_needed,
                total_price
            ]
  end
# /quote_generator

# functions
  def elevator_create(models, status_, type_building, battery_date_comissioning, el)
    puts "    |     |     |     |- Elevator #{el} creates"
    elevator_ = Elevator.new
    elevator_.serial_number = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)
    elevator_.model = models[rand(0..2)]
    elevator_.type_building = type_building
    elevator_.status = status_[rand(0...status_.length)]
    elevator_.date_commissioning = battery_date_comissioning
    elevator_.date_last_inspection = Faker::Date.between(from: elevator_.date_commissioning, to: '2020-09-30')
    elevator_.cert_ope = Faker::Alphanumeric.alphanumeric(number: 12, min_alpha: 5, min_numeric: 3)
    elevator_.information = Faker::Ancient.god
    elevator_.notes = Faker::ChuckNorris.fact
    return elevator_
  end

  def column_create(status_, type_building, co)
      puts "    |     |     |- Column #{co} creates"
      column_ = Column.new
      column_.type_building = type_building
      column_.amount_floors_served = rand(5..100)
      column_.status = status_[rand(0...status_.length)]
      column_.information = Faker::GreekPhilosophers.quote
      column_.notes = Faker::Lorem.paragraph
      return column_
  end

  def battery_create(cust_date_create, type_building, ba, status_)
      battery_ = Battery.new
      # pp battery_.errors
      battery_.type_building = type_building[rand(0..3)]
      puts "    |     |- Batterie #{ba} #{battery_.type_building} creates\t"
      battery_.status = status_[rand(0...status_.length)]
      battery_.date_commissioning = Faker::Date.between(from: cust_date_create, to: '2020-09-30')
      battery_.date_last_inspection = Faker::Date.between(from: battery_.date_commissioning, to: '2020-09-30')
      battery_.cert_ope = Faker::Alphanumeric.alphanumeric(number: 12, min_alpha: 5, min_numeric: 3)
      battery_.information = Faker::Ancient.hero
      battery_.notes = Faker::Lorem.paragraph
      battery_.employee_id = rand(1..7)
      return battery_
  end

  def building_details_create
    buildings_details_ = BuildingsDetail.new
    buildings_details_.info_key = Faker::Beer.brand
    buildings_details_.value = Faker::Beer.alcohol
    return buildings_details_
  end

  def building_create(bu)
    puts "    |- Building #{bu} creates"
    building_ = Building.new
    building_.adm_contact_name = Faker::Name.unique.name
    building_.adm_contact_phone = Faker::PhoneNumber.phone_number
    building_.adm_contact_mail = Faker::Internet.email(name: building_.adm_contact_name)
    building_.tect_contact_name = Faker::Name.unique.name
    building_.tect_contact_phone = Faker::PhoneNumber.phone_number
    building_.tect_contact_email = Faker::Internet.email(name: building_.tect_contact_name)
    address_ = address_create("Building", "Building")
    address_.building = building_
    return building_
  end

  def address_create(entite, type_address)
    address_ = Address.new
    address_.type_address = type_address
    address_.status = Faker::Types.random_type ##########
    address_.entite = entite
    address_.address = $addresses_csv[$iterator_addresses].address
    address_.address2 = $addresses_csv[$iterator_addresses].address2
    address_.city = $addresses_csv[$iterator_addresses].city
    address_.postal_code = $addresses_csv[$iterator_addresses].postal_code
    address_.country = $addresses_csv[$iterator_addresses].country
    address_.notes = Faker::Lorem.paragraph
    address_.full_street_address = [address_.address, address_.city, address_.postal_code, address_.country].compact.join(', ')
    $iterator_addresses += 1
    # puts $iterator_addresses
    return address_
  end

  def customer_create()
    user_ = User.new
    customer_ = Customer.new
    # user_.add_role :customer
    customer_.company_name = Faker::Company.name
    user_.email = Faker::Internet.email(name: "info", domain: customer_.company_name)
    user_.password = Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true)
    customer_.date_create = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
    customer_.cpy_contact_name = Faker::Name.unique.name
    customer_.cpy_contact_phone = Faker::PhoneNumber.phone_number
    customer_.cpy_contact_email = Faker::Internet.email(name: customer_.cpy_contact_name)
    customer_.cpy_description = Faker::Company.industry
    customer_.sta_name = Faker::Name.unique.name
    customer_.sta_phone = Faker::PhoneNumber.phone_number
    customer_.sta_mail = Faker::Internet.email(name: customer_.sta_name)
    user_.customer = customer_
    address_ = address_create("Customer", "Head Office")
    address_.customer = customer_
    user_.save!
    return customer_
  end

  def employee
      nicolas = ['nicolas.genest@codeboxx.biz','nicolas','Genest','Nicolas','CEO']
      nadya = ['nadya.fortier@codeboxx.biz','nadya1','Fortier','Nadya','Director']
      martin = ['martin.chantal@codeboxx.biz','martin','Chantal','Martin','Director Assistant']
      mathieuH = ['mathieu.houde@codeboxx.biz','mathieu','Houde','Mathieu','Captain']
      david = ['david.boutin@codeboxx.biz','david1','Boutin','David','Engineer']
      mathieuL = ['mathieu.lortie@codeboxx.biz','mathieu','Lortie','Mathieu','Engineer']
      thomas = ['thomas.carrier@codeboxx.biz','thomas','Carrier','Thomas','Engineer']
      
      list_ = [nicolas, nadya, martin, mathieuH, david, mathieuL, thomas]
      
      for user in list_ do
          user_ = User.new
          user_.email = user[0]
          user_.password = user[1]
          user_.add_role :employee
          employee = Employee.new
          employee.last_name = user[2]
          employee.first_name = user[3]
          employee.title = user[4]
          user_.employee = employee   
          user_.save!
      end
  end

  def lead_create(department)
    lead_ = Lead.new
    lead_.full_name = Faker::Name.unique.name
    lead_.company_name = Faker::Company.name
    lead_.email = Faker::Internet.email(name: lead_.full_name)
    lead_.phone_number = Faker::PhoneNumber.phone_number
    lead_.project_name = Faker::Commerce.product_name
    lead_.project_description = Faker::Lorem.paragraph
    lead_.department = department[rand(department.length)]
    lead_.message = Faker::Lorem.paragraph
    lead_.attached_file = Faker::LoremPixel.image(size: "50x60")
    lead_.create_at = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
    lead_.save!
    
    return lead_
  end

  def quote_create
    quote_g = quote_generator()
    quote_ = Quote.new
    quote_.company_name = quote_g[0]
    quote_.building_type = quote_g[1]
    quote_.apps_qty = quote_g[2]
    quote_.floors_qty = quote_g[3]
    quote_.basements_qty = quote_g[4]
    quote_.parkings_qty = quote_g[5]
    quote_.elevators_qty = quote_g[6]
    quote_.business_qty = quote_g[7]
    quote_.occupants_floors_qty = quote_g[8]
    quote_.hours_activity = quote_g[9]
    quote_.game = quote_g[10]
    quote_.elevator_needed = quote_g[11]
    quote_.total_price = quote_g[12]
    quote_.total_price = quote_g[12]
    quote_.create_at = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
    quote_.email = Faker::Internet.email
    quote_.save!
  end

# /functions

department = ["Residential", "Commercial", "Corporate", "Hybrid"]

def faker_data
  type_building = ["Residential", "Corporate", "Commercial", "Hybrid"]
  status_ = ["Offline", "Online", "To_fix", "Intervention"]
  models = ["standard", "premium", "excelium"]
  type_addresses = ["Billing", "Shipping", "Business", "Home"]
  department = ["Residential", "Commercial", "Corporate", "Hybrid"]
  
    employee()

    1.upto(10) do |cu|
        puts "Customer #{cu} creates\t"
        customer_ = customer_create()
        random = rand(1..5)
        random2 = rand(1..5)

        inter_ = create_intervention()
        customer_.interventions << inter_
        inter_.author = Employee.find(random)
        inter_.employee = Employee.find(random2)



        lead_ = lead_create(department)
        customer_.lead = lead_
        
        1.upto(rand(1..3)) do |bu|
            building_ = building_create(bu)
            customer_.buildings << building_


            building_.interventions << inter_
            customer_.interventions << inter_

           

            1.upto(rand(1..3)) do |ba|
              buildings_detail_ = building_details_create()
              building_.buildings_details << buildings_detail_
            end

            1.upto(rand(1..3)) do |ba|
              battery_ = battery_create(customer_.date_create, type_building, ba, status_)
              building_.batteries << battery_

              battery_.interventions << inter_

             

              
              1.upto(rand(1..3)) do |co|
                  column_ = column_create(status_, battery_.type_building, co)
                  battery_.columns << column_  

                  column_.interventions << inter_

                

                  1.upto(rand(1..3)) do |el|
                      elevator_ = elevator_create(models, status_, battery_.type_building, battery_.date_commissioning, el)
                      column_.elevators << elevator_


                      elevator_.interventions << inter_
                      inter_.save!
                  end  
                  # column_.save!
                  puts "    |     |     |\n"     
              end        
              # battery_.save!
              puts "    |     |\n"     
          end
          # building_.save!
          puts "    |\n"                
        end
        customer_.save!
        # pp customer_.buildings.first.errors
        puts "\n"     
    end
    1.upto(rand(2..8)) do
      lead_create(department)
      quote_create()
    end 
end

faker_data()
