host_ = "codeboxx-postgresql.cq6zrczewpu2.us-east-1.rds.amazonaws.com"
dbname_ = "warehouseTB"
user_ = "codeboxx"
password_ = "Codeboxx1!"


# make sure to connect the good user
require 'pg'
namespace :query do
    task postgres: :environment do
        pgsqltest = PG.connect(host: host_, dbname: dbname_, user: user_, password: password_)
        puts pgsqltest
    end

    desc "contact querie to fact_conctact"
    task contact_querie: :environment do
        conn = PG.connect(host: host_, dbname: dbname_, user: user_, password: password_)
            @fact_contact.id.group("DATE_TRUNC('month', created_at)").count
        end
    desc "quote querie to fact_quote"
    task quote_querie: :environment do
        conn = PG.connect(host: host_, dbname: dbname_, user: user_, password: password_)
            @fact_contact.id.group("DATE_TRUNC('month', created_at)").count
        end
    desc "elevator querie to fact_elevator"
    task elevator_querie: :environment do
        conn = PG.connect(host: host_, dbname: dbname_, user: user_, password: password_)
            @fact_contact.id.group("DATE_TRUNC('month', created_at)").count
        end
        
end

