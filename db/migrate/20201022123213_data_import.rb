class DataImport < ActiveRecord::Migration[5.2]
  def change
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
    
    def customer
        1.upto(20) do |cu|
            puts "Customer #{cu} creates\t"
            customer_ = Customer.new
            user_ = User.new
            # user_.add_role :customer
            customer_.company_name = Faker::Company.name
            user_.email = Faker::Internet.email(name: "info", domain: customer_.company_name)
            user_.password = "123456"
            customer_.date_create = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
            customer_.cpy_contact_name = Faker::Name.unique.name
            customer_.cpy_contact_phone = Faker::PhoneNumber.phone_number
            customer_.cpy_contact_email = Faker::Internet.email(name: customer_.cpy_contact_name)
            customer_.cpy_description = "test"
            customer_.sta_name = Faker::Name.unique.name
            customer_.sta_phone = Faker::PhoneNumber.phone_number
            customer_.sta_mail = Faker::Internet.email(name: customer_.sta_name)
            user_.customer = customer_
            user_.save!
            
            1.upto(rand(1..5)) do |bu|
                puts "    |- Building Cu#{cu}/Bu#{bu} creates"
                building_ = Building.new
                building_.adm_contact_name = Faker::Name.unique.name
                building_.adm_contact_phone = Faker::PhoneNumber.phone_number
                building_.adm_contact_mail = Faker::Internet.email(name: building_.adm_contact_name)
                building_.tect_contact_name = Faker::Name.unique.name
                building_.tect_contact_phone = Faker::PhoneNumber.phone_number
                building_.tect_contact_email = Faker::Internet.email(name: building_.tect_contact_name)
                customer_.buildings << building_ 
                patato()           
            end
            user_.save!
            # pp customer_.buildings.first.errors
            puts "\n"     
        end
    end
    
    def patato
        type_building = ["Residential", "Corporate", "Commercial", "Hybrid"]
        status = ["Offline", "Online", "to_fix"]
        models = ["standard", "premium", "excelium"]
    
        1.upto(rand(1..3)) do |ba|
            batterie_ = Patato.new
            # pp batterie_.errors
            batterie_.type = type_building[rand(0..3)]
            puts "    |     |- Batterie #{ba} #{batterie_.type} creates\t"
            batterie_.status = status[rand(0..2)]
            batterie_.date_commissioning = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
            batterie_.date_last_inspection = Faker::Date.between(from: '2017-09-30', to: '2020-09-30')
            batterie_.cert_ope = Faker::Alphanumeric.alphanumeric(number: 12, min_alpha: 5, min_numeric: 3)
            batterie_.information = "Informations"
            batterie_.notes = "notes"
            
            1.upto(rand(1..4)) do |co|
                puts "    |     |     |- Column #{co} creates"
                column_ = Column.new
                column_.type = batterie_.type
                column_.amount_floors_served = rand(5..100)
                column_.status = status[rand(0..2)]
                column_.information = "Informations"
                column_.notes = "Notes"
                batterie_.columns << column_  
                1.upto(rand(1..5)) do |el|
                    puts "    |     |     |     |- Elevator #{el} creates"
                    elevator_ = Elevator.new
                    elevator_.serial_number = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)
                    elevator_.model = models[rand(0..2)]
                    elevator_.type =  batterie_.type
                    elevator_.status = status[rand(0..2)]
                    elevator_.date_commissioning = batterie_.date_commissioning
                    elevator_.date_last_inspection = Faker::Date.between(from: batterie_.date_commissioning, to: '2020-09-30')
                    elevator_.cert_ope = Faker::Alphanumeric.alphanumeric(number: 12, min_alpha: 5, min_numeric: 3)
                    elevator_.information = "Informations"
                    elevator_.notes = "Notes"
                    column_.elevators << elevator_
                end  
                puts "    |     |     |\n"     
            end        
            batterie_.save!
            puts "    |     |\n"     
        end
        puts "    |\n"     
    end
    # employee()
    # customer()
  end
end
