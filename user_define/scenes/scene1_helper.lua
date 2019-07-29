
local M = require("user_define.scenes.scene_helper")

function M:create_stage(sceneGroup)
  -- background
  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(.25, .25, 0)
end

function M:get_controller_listeners(player, camera)
  return {
    touch = function(event)
      if event.phase == "began" then
        display.currentStage:setFocus(camera.child)
        display.getCurrentStage():setFocus()
        camera.x_origin = event.x - camera.child.x
        camera.y_origin = event.y - camera.child.y
        -- camera.is_playing = true
      elseif event.phase == "moved" then
        camera.child.x = event.x - camera.x_origin
        camera.child.y = event.y - camera.y_origin
        -- camera.is_playing = true
      elseif event.phase == "ended" or event.phase == "cancelled" then
        -- camera.is_playing = false
        display.currentStage:setFocus(nil)
      end
      camera.child.x, camera.child.y = camera:clamp(camera.child.x, camera.child.y)

    end,
    up = function(event)
    end,
    down = function(event)
    end,
    left = function(event)
    end,
    right = function(event)
    end,
    north = function(event)
    end,
    south = function(event)
    end,
    east = function(event)
    end,
    west = function(event)
    end,
    cursor = function(event)
      if player.controller:is_button_repeated("cursor") then
        print(event.target.name .. " ON!!")

      elseif not player.controller:is_button_repeated("cursor") then
        -- camera:move(function(child, done)
        --   local x, y = camera:clamp(-3000, 30)
        --   global_command_queue:to(child, {time=1000, x=x, y=y, transition=easing.inOutQuart, onComplete=function()
        --     global_command_queue:performWithDelay(1000, function(event)
        --       x, y = camera:clamp(0, 0)
        --       global_command_queue:to(child, {time=2000, x=x, y=y, transition=easing.inOutQuart, onComplete=function()
        --         x, y = camera:clamp(camera:get_following_positions())
        --           global_command_queue:to(child, {time=1000, x=x, y=y, transition=easing.inOutQuart, onComplete=function()
        --             done()
        --             global_command_queue:to(player.actor.sprite, {time=6000, x=5730, y=80, transition=easing.inOutQuart, onComplete=function()
        --               global_command_queue:to(player.actor.sprite, {time=4000, x=10, y=500, transition=easing.inOutQuart, onComplete=function()

        --               end}, true)
        --           end}, true)
        --         end}, true)
        --       end}, true)
        --     end, true)
        --   end}, true)
        -- end)
        print(event.target.name .. " OFF!!")
      end
    end,
  }
end

function M:start_game(player, banner, physics)
  player.controller:disable_touch_hit_testable(false)
  local function execute_opening()
    global_command_queue:regist_command(function()
      banner.x = -display.contentCenterX
      banner.isVisible = true
      global_command_queue:to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=200, x=display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=100, x= display.contentWidth + display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      banner.x = -display.contentCenterX
      banner.text = "GO"
      global_command_queue:to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=200, x=display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=100, x= display.contentWidth + display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      banner.x = -display.contentCenterX
      banner.text = "FIGHT"
      global_command_queue:to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=200, x=display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:to(banner, {time=100, x= display.contentWidth + display.contentCenterX})
    end)
    global_command_queue:regist_command(function()
      global_command_queue:performWithDelay(100, function()
        banner.isVisible = false
        player.controller:disable_touch_hit_testable(true)
        player.controller:show_controller(true)
        physics.start()
      end)
    end)
  end

  local function execute_ending()
    require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
  end

  -- start game
  local scenario_list = {
    {
      quest = function(self, done)
        execute_opening()
        player.actor.count = 0
        done()
      end,
      evaluate = function()
        if player.actor.count >= 500 then
          -- return global_constants.CANCEL_ALL
          return global_constants.NEXT
        else
          return global_constants.CONTINUE
        end
      end,
      answer = function(self, state, done)
        done()
        execute_ending()
      end,
    },
  }
  return require("components.scenario_runner")(scenario_list)
end

function M:create_actors_runner(player, actor_list)
  local function observer()
    player.controller:observe("cursor", function()
      player.actor:move(player.controller:get_cursor_positions())
    end)
  end

  return require("components.actors_runner")(player, actor_list, observer)
end

return M