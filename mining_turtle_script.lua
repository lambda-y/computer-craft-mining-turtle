local function turnAround()
    turtle.turnRight()
    turtle.turnRight()
end

local function isFullInventory()
    -- Check all slots except the first (reserved for tools)

    if turtle.getItemCount(16) == 0 then
        return false
    end
    return true
end

local function depositLoot()
    -- Spawn chest behind the turtle
    turnAround()

    turtle.select(2)
    turtle.place()

    -- Loop through inventory and deposit items
    for i = 3, 16 do
        -- while turtle.getItemCount(i) > 0 do
        -- turtle.suckUp()
        turtle.select(i)
        turtle.drop(turtle.getItemCount(i))

        -- end
    end

    turnAround()

    -- Destroy chest, wtf
    -- turtle.dig("chest")
end

local function refuel()
    turtle.select(1)
    if turtle.getFuelLevel() < 10 and turtle.getItemCount(1) > 0 then
        -- Check for fuel in inventory (assuming slot 1)
        if turtle.getItemCount(1) > 0 then
            turtle.refuel(5)
        end
    end
end


local function fallingBlockCheck()
    while turtle.detect() do
        turtle.dig()
    end
end

local function dig()
    -- gonna be honest, I didn't want to call a check on it
    turtle.dig()
    fallingBlockCheck()
end

local function healthCheck()
    -- Check for full inventory before mining
    if isFullInventory() then
        depositLoot()
    end

    -- Refuel check
    refuel()
end


local function mineSides()
    turtle.turnLeft()
    dig()
    turnAround()
    dig()
    turtle.turnLeft()
end

local function tunnelForward(height)

    healthCheck()

    dig()
    turtle.forward()
    mineSides()   
    -- Mine 1 block and move forward
    for _ = 1, height do
         
        turtle.digUp()
        turtle.up()
        mineSides()
    end
    -- Mine up
    

    -- Mine 1 block and move forward
    dig()
    turtle.forward()
    mineSides()

    for _ = 1, height do
        turtle.digDown()
        turtle.down()
        mineSides()
    end

    -- Reset to first step
    
    
end

local function burrow(wall_length, wall_height)
    -- Lol, thanks Ida
    local orientation = 1

    for _ = 1,wall_height do
        
        healthCheck()
    
        turtle.digDown()
        turtle.down()
        for d = 1, wall_length do
        
            for _ = 2, wall_length do
                dig()
                turtle.forward()
            end
        
            if (orientation == 1) and (d < wall_length) then
                turtle.turnRight()
                dig()
                turtle.forward()
                turtle.turnRight()
                orientation = 2
            elseif (orientation == 2) and (d < wall_length) then
                turtle.turnLeft()
                dig()
                turtle.forward()
                turtle.turnLeft()
                orientation = 1
            end
        end
    
        if orientation == 1 then
            turtle.turnLeft()
            turtle.turnLeft()
        elseif orientation == 2 then
            turtle.turnRight()
            orientation = 1
        end
    end
end

local function main()
    io.write('Be sure to add a fuel source in the first (top left) slot followed right after with chests\n')
    io.write('Make your Choice\n')
    io.write('1. Tunnel\n')
    io.write('2. Burrow\n')
    io.write('3. Give up\n')
    io.write('Make your Choice\n')
    local choice = read() + 0-- read a number

    if choice == 1 then
        io.write("\nHow far? -1 for infinite\n")
        local distance = read() + 0

        io.write("\nHow tall?\n")
        local height = read() + 0
        if distance < 0 then
            while true do
                tunnelForward(height)
            end
        end
        for _ = 0, choice do
            tunnelForward(height)
        end
    end
    if choice  == 2 then
        io.write("\nIts important to keep the turtle at the\
         ceiling or the highest part that you want your room\
          to be at")
        io.write("How long do you want the walls to be?\n")
        local wall_length = read() + 0
        io.write("How tall do you want the walls to be?\n")
        local wall_height = read() + 0
        
        if wall_length > 0 and wall_height > 0 then
            
            burrow(wall_length, wall_height)

        end
    end
end



main()
