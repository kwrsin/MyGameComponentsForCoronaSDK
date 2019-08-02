return function()
  local M = {
    sequence_names = {},
    sprite = nil,
    count = 0,
    length = 3,
    audio_path_step = "assets/audio/step.wav",
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
    return "base_behavior startTimer"
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
    M:set_sound_effects()

  end

  function M:set_sound_effects()
    if not global_audio then return end
    global_audio:add_se(M.audio_path_step)
  end

  function M:play_se(key)
    if not global_audio then return end
    global_audio:play_se(key)
  end

  function M:set_sequence(sequence_name)
    if self.selected_seq_name ~= sequence_name then
      self.sprite:pause()
      self.sprite:setSequence(sequence_name)
      self.sprite:play()
      self.selected_seq_name = sequence_name
    end
  end

  function M:up()
    M:set_sequence("up")
  end

  function M:down()
    M:set_sequence("down")
  end

  function M:left()
    M:set_sequence("left")
  end

  function M:right()
    M:set_sequence("right")
  end

  function M:move(x, y)
    if not (x ~= x) then
      self.sprite.x = self.sprite.x + (x * M.length)
    end
    if not (y ~= y) then
      self.sprite.y = self.sprite.y + (y * M.length)
    end
    if x * x -  y * y > 0 then
      if x > 0 then
        self:right()
        self:play_se(M.audio_path_step)
      elseif x < 0 then
        self:left()
        self:play_se(M.audio_path_step)
      end
    elseif y * y - x * x > 0 then
      if y > 0 then
        self:down()
        self:play_se(M.audio_path_step)
      elseif y < 0 then
        self:up()
        self:play_se(M.audio_path_step)
      end
    end

  end

  function M:enterFrame(event)

    M.count = M.count + 1
  end

  function M:moveAround()
    global_command_queue:run(function(clear_current_command)
      M:up()
      transition.to(self.sprite, {time = 1000, x = 0, y = 0, onComplete=function() clear_current_command() end})
    end)
    global_command_queue:run(function(clear_current_command)
      M:right()
      transition.to(self.sprite, {time = 1000, x = display.contentWidth, y = 0, onComplete=function() clear_current_command() end})
    end)
    global_command_queue:run(function(clear_current_command)
      M:down()
      transition.to(self.sprite, {time = 1000, x = display.contentWidth, y = display.contentHeight, onComplete=function() clear_current_command() end})
    end)
    global_command_queue:run(function(clear_current_command)
      M:left()
      transition.to(self.sprite, {time = 1000, x = 0, y = display.contentHeight, onComplete=function() clear_current_command() end})
    end)
    global_command_queue:run(function(clear_current_command)
      M:up()
      transition.to(self.sprite, {time = 1000, x = display.contentCenterX, y = display.contentCenterY, onComplete=function() clear_current_command() end})
    end)
    global_command_queue:run(function(clear_current_command)
      M.sprite:applyLinearImpulse(0, -0.1, M.sprite.x, M.sprite.y)
      clear_current_command()
    end)
  end


  return M
end