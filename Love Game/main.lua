--Init game
--
function initGame()
  
  love.window.setTitle("Little Love Game");  
  
  --Player
  player = {
      x = 380 ,   
      y = 441,
      speed = 300,
      width = 40  ,
      height = 60,
      jumpForce=50,
      gravity = 0,
      weight = 800,
      isJumping = false
      }

--Obstacle
  Obstacle = {
  x = 500,
  y = 450,
  width = 30,
  height = 30,
  speed = 100
  }

  listOfObstacles = {}

--Timer
timer = 5.0

  
  floor = {
      x = 0,
      y = 500,
      width = 800,
      height = 100
    }

end

function love.load()
initGame()
end


--
--Update
--
function love.update(dt)
  playerMovement(dt)
  
  timer = timer - dt
  spawObstacle(timer)
  Obstacle.x = Obstacle.x - Obstacle.speed * dt

  for i, v in ipairs(listOfObstacles) do
    Obstacle.x = Obstacle.x + Obstacle.speed * dt
  end
  
end


function love.draw()
  
  local mode 
  if checkCollision(player, floor) then
    mode = "fill"
    player.isJumping = false
    player.gravity = 0
    
  else
    mode = "line"
    end
  
  love.graphics.rectangle(mode, player.x, player.y, player.width, player.height)
  love.graphics.rectangle(mode, floor.x, floor.y, floor.width, floor.height)
  
  print(timer)
  
  for i, v in ipairs(listOfObstacles) do
    love.graphics.rectangle(mode, Obstacle.x, Obstacle.y, Obstacle.width, Obstacle.height)
  end
  
end




--
--Player movement
--
function playerMovement(dt)
  
  --Right
  if love.keyboard.isDown("d") 
  and player.x + player.width < love.graphics.getWidth()   then
      player.x = player.x + player.speed * dt
  end
  
  --Left
  if love.keyboard.isDown("a") 
   and player.x > 0  then
      player.x = player.x - player.speed * dt
  end
  
  
  if love.keyboard.isDown("space")
  and player.isJumping == false then
    jump(dt)
    end
    
    
    if player.isJumping == true then
  player.gravity = player.gravity + player.weight * dt
  player.y = player.y + player.gravity * dt
  end
  

end

function checkCollision(a,b)
  
  

    local a_left = a.x
    local a_right = a.x + a.width
    local a_top = a.y
    local a_bottom = a.y + a.height

    local b_left = b.x
    local b_right = b.x + b.width
    local b_top = b.y
    local b_bottom = b.y + b.height
    
    if  a_right > b_left
    and a_left < b_right
    and a_bottom > b_top
    and a_top < b_bottom then
        return true
    else
        return false
  end
end



function jump(dt)
  player.gravity = -300
  player.y = player.y + player.gravity * dt   
  if player.y < 440 then
  player.isJumping = true
  end
end

function love.keypressed(key)
  
  if key == "escape" then
    love.event.quit()
  end 
end


    function createObstacle()

  Obstacle.x = 500
  Obstacle.y = 450
  Obstacle.width = 30
  Obstacle.height = 30
  Obstacle.speed = 100

  table.insert(listOfObstacles, Obstacle)

end

function spawObstacle(timer)
    if timer <= 0 then
    timer = 5.0
    createObstacle()
    end
end

