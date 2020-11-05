class Customer < ApplicationRecord
    has_many :buildings
    belongs_to :user
    belongs_to :address

    after_create :migrate_attachments_to_dropbox
    after_update :migrate_attachments_to_dropbox  # This line calls the function below after create or update a customer


  # Logic to connect to the dropbox account, create a diretory for the client, export the binary files to dropbox client's directory, delete the binary file from MySQL database 
    def migrate_attachments_to_dropbox
      puts self.id
      dropbox_client = DropboxApi::Client.new
      
      puts self.cpy_contact_email    
      Lead.where(email: self.cpy_contact_email).each do |lead|  # for each lead that has this email       
        unless lead.attached_file.nil?  # check if the attached_file is NOT null
          puts "This model has blob"          
          begin           
              dropbox_client.create_folder "/customer_id_" + self.id.to_s   # create a folder named (use the customer_id) if there is no folder for this customer yet
          rescue DropboxApi::Errors::FolderConflictError => err
            puts "Folder already exists in path, ignoring folder creation. Continue to upload files."
          end  
          begin
            dropbox_client.upload("/customer_id_" + self.id.to_s + "/attachment_" + lead.id.to_s, lead.attached_file)    # send file to user's folder at dropbox
          rescue DropboxApi::Errors::FileConflictError => err
            puts "File already exists in folder, ignoring file upload. Continue to delete file from database."
          end  

          lead.attached_file = nil;
          lead.save!
        end
    end 
  end

end
