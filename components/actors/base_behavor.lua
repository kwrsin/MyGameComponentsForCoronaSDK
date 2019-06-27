return function()
  local M = {}

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

  return M
end