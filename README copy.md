# Rocket_Elevators_Information_System
Application for website of the Company of Rocket Elevators
## URL
<https://tonted.xyz/>
## Gems used
* gem 'devise'
* gem 'rails_admin'
* gem 'rails_admin_rollincode'
* gem 'multiverse'
* gem 'cancancan'
* gem 'rolify'
* gem 'faker'
### pour la creation des tables dans mysql avec migration
rails g migration CreateTableName
pour leads, address, customers, buildings, buildingdetails, batteries, columns et elvator
### pour la creation des tables dans postgres avec migration
DB=warehouse rails g migration CreateTableName
pour factquotes, factelevators, dimcustomers
### pour les seeds
faker a ete utiliser pour la creation de donnees fictive
https://github.com/faker-ruby/faker#default
## Infos development:
### After pull:
```
bundle install
rails db:drop
rails db:create
rails db:migrate
```
~~rails db:seed~~
### pour operer dans la Database postgres
DB=warhouse rails db:drop
DB=warhouse rails db:create
DB=warhouse rails db:migrate
### pour populler la warehouse
### nous avons utiliser des rake task
### a linterieur de du dossier lib/task importdata.rake
rake dwh:mysql
    - pour etablir la connection avec le serveur local mysql
rake dwh:postgres
    - connecter avec postgres specifiquement
    -pgsqltest = PG.connect( host: "localhost", dbname: 'warehouse_development', user: connect[0], password: connect[1] )
rake dwh:fact_contact
    - incorpore les donnees de la table leads(mysql) a la table fact_contact(postgres)
rake dwh:fact_elevator
    - incorpore les donnees de la table elevator(qui consiste dune boucle imbriquer customer=>building=>batteries=>columns=>elevators(mysql)) a la table fact_elevator(postgres)
rake dwh:fact_quote
    - incorpore les donnees de la table quote(mysql) a la table fact_quote(postgres)
rake dwh:dimcustomer
    - ici on cest baser du meme principe que la fact_elevator task (boucle imbriqer) avec quelque modification pour aller chercher le montant d elevator
### pour faire les relations entre les DB nous avons utilisers
has_many    :(dependant de quoi ex: customer)
belongs_to  :(dependant de quoi ex: customer)
has_one     :(dependant de quoi ex: customer)
### notes pour le admin
le diagram des relations entre les tables elle est disponible dans longlet diagram en dessous de datavisualization ( charts en extra )
### Config alias:
### Access to Dashboard:
***email:*** admin@tonted.xyz
***password:*** password
## Developpers
* **Jean-François Taillefer**
* **Alexandre Leblanc**
* **Jorge Marcoux**
* **Teddy Blanco**