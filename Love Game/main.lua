--Init game
--
function initGame()
  
  love.window.setTitle("Little Love Game");  
  
  --Player
  playerX = 380    
  playerY = 500
  playerSpeed = 300
  playerWidth = 40  
  playerHeight = 60

end

function love.load()
initGame()
end


--
--Update
--
function love.update(dt)
  playerMovement(dt)
end


function love.draw()
  love.graphics.rectangle("line", playerX, playerY, playerWidth, playerHeight)
end




--
--Player movement
--
function playerMovement(dt)
  
  --Right
  if love.keyboard.isDown("d") then
      playerX = playerX + playerSpeed * dt
  end
  
  --Left
  if love.keyboard.isDown("a") then
      playerX = playerX - playerSpeed * dt
  end
  
  --Up
  if love.keyboard.isDown("w") then
      playerY = playerY - playerSpeed * dt
  end
  
  --Down
  if love.keyboard.isDown("s") then
      playerY = playerY + playerSpeed * dt
  end
  
end

