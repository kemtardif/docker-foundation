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

def quote_create()
    company_name = Faker::Company.name
    building_type = $type_building[rand(0..$type_building.length)]
    game = $models[rand(0..$models.length)]
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
        basements = rand(2..(floors/6).round())
        elevator_needed = residential(apartments, floors, basements)
        total_price = elevator_needed * game(game)
    elsif building_type == "Commercial"
        elevator_needed = rand(10..100)
        business_qty = elevator_needed * rand(2..4)
        floors = business_qty * (1..3)
        basements = rand(2..(floors/6).round())
        parkings = rand(2..(floors/8).round())
        total_price = elevator_needed * game(game)
    elsif building_type == "Corporate"
        occupants = rand(500..2000)
        floors = rand(5..50)
        basements = rand(2..(floors/6).round())
        elevator_needed = corporate(occupants, floors, basements)
        business_qty = elevator_needed * rand(2..4)
        parkings = rand(2..(floors/8).round())
        elevator_qty = elevator_needed
        total_price = elevator_needed * game(game)
    else
        occupants = rand(500..2000)
        floors = rand(5..50)
        basements = rand(2..(floors/6).round())
        elevator_needed = corporate(occupants, floors, basements)
        business_qty = elevator_needed * rand(2..4)
        parkings = rand(2..(floors/8).round())
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

puts quote_create()
