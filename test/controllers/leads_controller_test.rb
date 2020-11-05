require 'test_helper' 
class LeadsControllerTest < ActiveSupport::TestCase

    test "hello_world" do
        leadsController = LeadsController.new

        cst = create_customer 'cindy.okino@gmail.com'

        # Customer.all.each do |customer|
        #     puts customer.inspect
        # end 

    end

    def create_customer (email)
        user_ = User.new
        customer_ = Customer.new

        puts "USER ID:"
        puts user_.id

        puts "Customer ID:"
        puts customer_.id
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
        customer_.sta_mail = email
        user_.customer = customer_
        user_.save!
        # address_ = Address.new
        customer_.address = Address.new
        # address_.customer = customer_
        customer_.save!
        
        return customer_
    end

end