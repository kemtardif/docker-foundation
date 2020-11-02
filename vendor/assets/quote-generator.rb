require 'faker'
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
    numbers_of_columns = numbers_of_columns(floors)
    numbers_of_elevators = (occupants * (floors) / 1000).round()
    elevators_per_column = (numbersOfElevators / numbersOfColumn).round()
    return numbers_of_columns * elevators_per_column
end
std = (1.1 * 7565).round(2)
pre = (1.13 * 12345).round(2)
exc = (1.16 * 15400).round(2)
def game(game)
    if game == "standard"
        return std
    elsif game == "premium"
        return pre
    else
        return exc
end
type_building = ["Residential", "Corporate", "Commercial", "Hybrid"]
models = ["standard", "premium", "excelium"]
def quote_create()
    company_name = Faker::Company.name
    building_type = type_building[rand(0..type_building.length)]
    game = models[rand(0..models.length)]
    apartments = 0
    floors = 0
    basements = 0
    parkings = 0
    elevator_needed = 0
    business_qty = 0
    occupants_floors_qty = 0
    hours_activity = 0
    game = null
    elevator_needed = 0
    total_price = 0
    if building_type == "Residential"
        floors = rand(5..100)
        apartments = floors * rand(5..30)
        basements = rand(2..(floors/6).round())
        elevator_needed = residential(apartments, floors, basements)
        total_price = elevator_needed * game(game)

    elsif building_type == "Commercial"
        floors = rand(5..100)
        apartments = floors * rand(5..30)
        basements = rand(2..(floors/6).round())
        elevator_needed =
    else
        floors = rand(5..100)
        apartments = floors * rand(5..30)

    end
end
    apps_qty
    floors_qty
    basements_qty
    parkings_qty
    elevators_qty
    business_qty
    occupants_floors_qty
    hours_activity
    game
    elevator_needed
    total_price
    t.timestamps