return function()
  local M = {
    sequence_names = {},
    sprite = nil
  }

  function M.CoroPerformWithDelay( delay, func, n )
      local wrapped = coroutine.wrap( function( event )
          func( event )  -- Do the action...

          return "cancel"  -- ...then tell the timer to die when we're done.
      end )

      local event2  -- Our "shadow" event.

      return timer.performWithDelay( delay, function( event )
          event2 = event2 or { source = event.source }  -- On first run, save source...

          event2.count = event.count  -- ...update these every time.
          event2.time = event.time

          local result = wrapped( event2 )  -- Update the coroutine. It will pick up the event on the first run.

          if result == "cancel" then
              timer.cancel( event2.source )  -- After func completes, or on a cancel request, kill the timer.
          end
      end, n or 0 )
  end

  function M:Defensive()
      print("hoge")
      coroutine.yield()

      return M:Offensive()
  end

  function M:Offensive()
      print("fuga")
      coroutine.yield()

      return M:Defensive()
  end

  function M:start_timer()
    self.timerId = self.CoroPerformWithDelay( 2000, self.Defensive )
    return "base_behavor startTimer"
  end

  function M:create_sprite(parent_object, x, y, object_sheets)
    local sequences = self.sequences
    for i, sec in ipairs(sequences) do
      sec.sheet = object_sheets[sec.sheet_number]
      table.insert(self.sequence_names, sec.name)
    end
    local sprite = display.newSprite(parent_object, object_sheets[self.object_sheets_index], sequences)
    sprite.x = x
    sprite.y = y

    sprite:setSequence(self.sequence_names[1])
    sprite:play()

    self.sprite = sprite

    -- Runtime:addEventListener('enterFrame', function(event)
    --   if M.is_move_up then
    --     print("move")
    --     M.sprite:applyLinearImpulse(0, -0.1, M.sprite.x, M.sprite.y)
    --     -- M.sprite:applyForce(0, -0.3, M.sprite.x, M.sprite.y)
    --     -- M.sprite.y = M.sprite.y - 5
    --   end
    -- end)

  end

  function M:up()
    self.sprite:setSequence("up")
    self.sprite:play()
  end

  function M:down()
    self.sprite:setSequence("down")
    self.sprite:play()
  end

  function M:left()
    self.sprite:setSequence("left")
    self.sprite:play()
  end

  function M:right()
    self.sprite:setSequence("right")
    self.sprite:play()
  end

  M.is_move_up = false
  function M:move_up(flag)
    M.is_move_up = flag
  end

  function M:enterFrame(event)
    if M.is_move_up then
      M:moveAround()
      -- M.sprite:applyLinearImpulse(0, -0.1, M.sprite.x, M.sprite.y)
      -- M.sprite:applyForce(0, -0.3, M.sprite.x, M.sprite.y)
      -- M.sprite.y = M.sprite.y - 5
      M.is_move_up = not M.is_move_up
    end
  end

  function M:moveAround()
    global_queue:regist_command(function()
      M:up()
      transition.to(self.sprite, {time = 1000, x = 0, y = 0, onComplete=function() global_queue:clear_current_command() end})
    end)
    global_queue:regist_command(function()
      M:right()
      transition.to(self.sprite, {time = 1000, x = display.contentWidth, y = 0, onComplete=function() global_queue:clear_current_command() end})
    end)
    global_queue:regist_command(function()
      M:down()
      transition.to(self.sprite, {time = 1000, x = display.contentWidth, y = display.contentHeight, onComplete=function() global_queue:clear_current_command() end})
    end)
    global_queue:regist_command(function()
      M:left()
      transition.to(self.sprite, {time = 1000, x = 0, y = display.contentHeight, onComplete=function() global_queue:clear_current_command() end})
    end)
    global_queue:regist_command(function()
      M:up()
      transition.to(self.sprite, {time = 1000, x = display.contentCenterX, y = display.contentCenterY, onComplete=function() global_queue:clear_current_command() end})
    end)
    global_queue:regist_command(function()
      M.sprite:applyLinearImpulse(0, -0.1, M.sprite.x, M.sprite.y)
      global_queue:clear_current_command()
    end)
  end


  return M
end