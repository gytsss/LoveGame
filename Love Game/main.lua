--Init game
--
function initGame()
  
  love.window.setTitle("Runimals Game");  

--Colors
  green = {.45, .74, .18}
  red = {255, 0, 0}
  black = {0, 0, 0}

--Sprites
  groundSprite = love.graphics.newImage("res/ground.png")
  backgroundSprite = love.graphics.newImage("res/background.png")
  playerSprite = love.graphics.newImage("res/player.png")

--Sound effects
  jumpSound = love.audio.newSource('res/jump.wav', 'static')
  explosionSound = love.audio.newSource('res/dead.wav', 'static')
  scoreSound = love.audio.newSource('res/score.wav', 'static')
  love.audio.setVolume (0.5)
  
-- Font
  font = love.graphics.newFont('res/04B_30__.TTF', 50)
  fontActive = true
  
--Lose text
  loseTextActive = false 
  oneTime = false
  pause = false
  
--Upload animations
  frames = {}

      for i=1,3 do
          table.insert(frames, love.graphics.newImage("res/run" .. i .. ".png"))
      end
      
  frames2 = {}  
      for i=1,3 do
          table.insert(frames2, love.graphics.newImage("res/runBackward" .. i .. ".png"))
      end
      
  enemyFrames = {}
      
      for i=1,3 do
          table.insert(enemyFrames, love.graphics.newImage("res/fox" .. i .. ".png"))
      end
      
  flyEnemyFrames = {}
      for i=1,3 do
          table.insert(flyEnemyFrames, love.graphics.newImage("res/duck" .. i .. ".png"))
      end
    
  currentFrame = 1

  
--Player
  player = {
    x = 380 ,   
    y = 441,
    speed = 150,
    width = playerSprite:getWidth() - 20,
    height = playerSprite:getHeight(),
    gravity = 0,
    weight = 700,
    isJumping = false,
    isGoingForward = false,
    isGoingBackward=false,
    isStand = true
  }


--Ground
  floor = {
    x = 0,
    y = 500,
    width = 800,
    height = 100
  }


--Obstacles
  Obstacle = {
    x = love.graphics.getWidth(),
    y = 0,
    width = 54,
    height = 30,
    speed = 70,
    isActive = false
  }

  flyObstacle = {
      x = love.graphics.getWidth(),
      y = 0,
      width = 54,
      height = 30,
      speed = 70,
      isActive = false
  }
      listOfObstacles = {}
--Bacground
    background = {
      x = 0,
      y = 0,
      width = 1.3,
      height = 1.2,
      speed = 20,
      move = false  
    }

--Timer 
    obstacleTimer = 0
    flyObstacleTimer = 0

 
--Score
    score = 0
    scoreOnce = 0


  end

  function love.load()
    firstStart = true
    initGame()
  end


--
--Update
--
  function love.update(dt)
    
    if pause == false then
      playerMovement(dt)
  
      if Obstacle.isActive == false and flyObstacle.isActive == false then
        if love.keyboard.isDown("e") or love.keyboard.isDown("r") then
          firstStart = false
          spawObstacle()  
        end
      end

    playerMovement(dt)
  
--Obstacle speed logic
      obstacleTimer = obstacleTimer + dt
        if obstacleTimer >= 3  then
          if Obstacle.speed <=1000 then
            for i, v in ipairs(listOfObstacles) do
            Obstacle.speed = Obstacle.speed + 10
          end
      else 
        for i, v in ipairs(listOfObstacles) do
        Obstacle.speed = Obstacle.speed + 5
      end
      end
  
      obstacleTimer = 0
      end

--FlyObstacle speed logic
      flyObstacleTimer = flyObstacleTimer + dt
      if flyObstacleTimer >= 6  then
        if flyObstacle.speed <=1000 then
          for i, v in ipairs(listOfObstacles) do
          flyObstacle.speed = flyObstacle.speed + 5
        end
        else 
          for i, v in ipairs(listOfObstacles) do
          flyObstacle.speed = flyObstacle.speed + 2
        end
      end
  
      flyObstacleTimer = 0
      end

      for i, v in ipairs(listOfObstacles) do
        Obstacle.x = Obstacle.x - Obstacle.speed * dt
      end

      for i, v in ipairs(listOfObstacles) do
        flyObstacle.x = flyObstacle.x - flyObstacle.speed * dt
      end
  
--Obstacle respawn
      if Obstacle.x + Obstacle.width < 0 then
        Obstacle.x = love.graphics.getWidth()
        scoreOnce = 0
      end
  
      if flyObstacle.x + flyObstacle.width < 0 then
        flyObstacle.x = love.graphics.getWidth()
      end
  
  
--Score logic
      if Obstacle.x < player.x  and scoreOnce == 0  then 
        score = score + 1
        scoreSound:play()
        scoreOnce = 1
      end
  
  
--Player animation frames update
      currentFrame = currentFrame + 10 * dt
  
      if currentFrame >= 4 then
        currentFrame = 1
      end
    
    
--Animations conditions 
--Run forward animation
      if player.isGoingForward == true and player.isJumping == false then
        player.isGoingBackward = false
        player.isStand =false
      end
--Run backward animation
      if player.isGoingBackward == true and player.isJumping == false then
        player.isGoingForward = false
        player.isStand = false
      end
--Stay stand animation
      if player.isStand == true then
        player.isGoingBackward = false
        player.isGoingForward = false
      end
    end
    
    collisions()

  end


  function love.draw()
    
--Draw background

  love.graphics.draw(backgroundSprite, background.x, background.y, 0, background.width, background.height)  
  love.graphics.draw(backgroundSprite, 0, 0, 0, 1.3, 1.2)  


  
--Draw ground
    love.graphics.setColor(green)
    love.graphics.rectangle("fill", floor.x, floor.y, floor.width, floor.height)
   
--Draw Obstacle
--fox
    for i, v in ipairs(listOfObstacles) do
      love.graphics.setColor(1,1,1)
      love.graphics.draw(enemyFrames[math.floor(currentFrame)], Obstacle.x , Obstacle.y - 30, 0, 1.2,1.2)
    end
  
--Draw FlyObstacle
--Duck
    for i, v in ipairs(listOfObstacles) do
      love.graphics.setColor(1,1,1)
      love.graphics.draw(flyEnemyFrames[math.floor(currentFrame)], flyObstacle.x , flyObstacle.y - 10, 0, 0.5, 0.5)
    end

  
--Draw ground texture
    love.graphics.setColor(1,1,1)
    love.graphics.draw(groundSprite, floor.x, floor.y)
  
--Draw front player
    if player.isJumping == true or player.isStand == true then
      love.graphics.draw(playerSprite, player.x -10, player.y)
    end

--Draw animations
    if player.isGoingForward == true then
      love.graphics.draw(frames[math.floor(currentFrame)], player.x, player.y)
    end

    if player.isGoingBackward == true then
      love.graphics.draw(frames2[math.floor(currentFrame)], player.x, player.y)
    end

--Draw score
    love.graphics.setColor(black)
    love.graphics.setFont(font)
    love.graphics.print(score,love.graphics.getWidth() / 2 - 20 , 50)
    love.graphics.setColor(1, 1, 1)
  
--Draw StarText
    if fontActive == true and firstStart == true then
      love.graphics.setColor(black)
      love.graphics.setFont(font)
      love.graphics.print("Press E to start",love.graphics.getWidth() / 10 , love.graphics.getHeight() /1.7)
      love.graphics.setColor(1, 1, 1)
    end

    if loseTextActive == true then
      love.graphics.setColor(black)
      love.graphics.setFont(font)
      love.graphics.print("You Lose",love.graphics.getWidth() / 3.5 , love.graphics.getHeight() /1.7)  
      love.graphics.print("Press R to restart",love.graphics.getWidth() / 20 , love.graphics.getHeight() /1.5)
      love.graphics.setColor(1, 1, 1)
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
      player.isGoingForward = true
      player.isGoingBackward = false
    else 
      player.isStand=true
      player.isGoingForward = false
      player.isGoingBackward = false
    end
  
--Left
    if love.keyboard.isDown("a") 
    and player.x > 0  then
      player.x = player.x - player.speed * dt
      player.isGoingBackward = true
      player.isGoingForward = false
    end
  
--Jump
    if love.keyboard.isDown("space")
    and player.isJumping == false then
      jump(dt)
      player.isStand = true
      player.isGoingBackward = false
      player.isGoingForward = false
    end
  
--Down
    if love.keyboard.isDown("s") 
    and player.isJumping == true  then
      player.gravity = player.gravity + player.weight * dt
      player.y = player.y + player.gravity * dt
      player.isStand = true
      player.isGoingBackward = false
      player.isGoingForward = false
    end
    
--Jump gravity
    if player.isJumping == true and player.y < floor.y  then
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

  function collisions()
  
    if checkCollision(player, floor) then
      mode = "fill"
      player.isJumping = false
      player.gravity = 0
    end
  
    if checkCollision(player, Obstacle) then
      if oneTime == false then
        explosionSound:play()
        oneTime = true
      end
      restartGame()
    end
  
    if checkCollision(player, flyObstacle) then
      if oneTime == false then
        explosionSound:play()
        oneTime = true
      end
      restartGame()
    end
end

  function jump(dt)
    jumpSound:play()
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

    Obstacle = {}
    Obstacle.x = love.graphics.getWidth() - 54
    Obstacle.y = love.graphics.getHeight() - 30 - 100
    Obstacle.width = 54
    Obstacle.height = 30
    Obstacle.speed = 140
    table.insert(listOfObstacles, Obstacle)

  end

  function createFlyObstacle()

    flyObstacle = {}
    flyObstacle.x = love.graphics.getWidth() - 54
    flyObstacle.y = love.graphics.getHeight() - 200
    flyObstacle.width = 70
    flyObstacle.height = 20
    flyObstacle.speed = 70
    table.insert(listOfObstacles, flyObstacle)

  end

  function spawObstacle()
    createObstacle()
    createFlyObstacle()
    fontActive = false  
    Obstacle.isActive = true
    flyObstacle.isActive = true
  end

    
  function restartGame()
    loseTextActive = true
    pause = true
    if pause == true and love.keyboard.isDown("r") then
      initGame()
    end
  end