local composer = require('composer')

local scene = composer.newScene()

local player
local actor_list = {}
local tilemap_panel
local banner
local _actors_enterFrame
local map_path = 'assets.fghi'
local physics = require("physics")
local helper = require("user_define.scenes.scene1_helper")
local scenerio_player
local camera

local back_to_title

function scene:create(event)
  local sceneGroup = self.view
  -- physics.setDrawMode("hybrid")
  physics.start()
  physics.pause()

  player = composer.getVariable("player")
  helper:create_stage(sceneGroup)
  tilemap_panel = display.newGroup()
  -- sceneGroup:insert(tilemap_panel)
  camera = require("components.camera")(sceneGroup, 300, 300, tilemap_panel, nil, 900, 300)

  -- banner
  local scenario_panel = display.newGroup()
  sceneGroup:insert(scenario_panel)
  banner = display.newText(scenario_panel, "READY", -display.contentCenterX, display.contentCenterY, "Arial", 32 )
  banner.isVisible = false

  back_to_title = display.newText(sceneGroup, "back to title", display.contentCenterX, display.contentCenterY, native.systemFont, 24)
  back_to_title:addEventListener('touch', function(event)

    composer.gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
  end)

  print("scene1 created")
end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    print("scene1 show will")
    physics.pause()
    
    -- player controller
    camera.x_origin = 0
    camera.y_origin = 0
    player.controller:set_vc_event_listeners(
      {
        touch = function(event)
          if event.phase == "began" then
            display.currentStage:setFocus(camera.child)
            display.getCurrentStage():setFocus()
            camera.x_origin = event.x - camera.child.x
            camera.y_origin = event.y - camera.child.y
          elseif event.phase == "moved" then
            camera.child.x = event.x - camera.x_origin
            camera.child.y = event.y - camera.y_origin
          elseif event.phase == "ended" or event.phase == "cancelled" then
            display.currentStage:setFocus(nil)
          end

        end,
        up = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        down = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        left = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        right = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        north = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        south = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        east = function(event)
          if event.phase == "ended" or event.phase == "cancelled" then
            print("EAST!!")
          end
        end,
        west = function(event)
          if event.is_button_repeated then
            print(event.target.name .. " ON!!")
          else
            print(event.target.name .. " OFF!!")
          end
        end,
        cursor = function(event)
          if not event.is_cursor_repeated then return end
          if event.is_cursor_repeated > 0 then
            print(event.target.name .. " ON!!")
            -- player.actor:up()
            -- player.actor:move_up(true)
          elseif event.is_cursor_repeated < 0 then
            -- player.actor:down()
            -- player.actor:move_up(false)
            -- transition.to(player.actor.sprite, {time=1000, x=3600, y=80, transition=easing.inOutQuart, onComplete=function()
            -- end})
            camera:move(function(child, done)
              transition.to(child, {time=1000, x=-3000, y=30, transition=easing.inOutQuart, onComplete=function()
                timer.performWithDelay(1000, function(event)
                  transition.to(child, {time=2000, x=000, y=00, transition=easing.inOutQuart, onComplete=function()
                      done()
                    transition.to(player.actor.sprite, {time=1000, x=300, y=80, transition=easing.inOutQuart, onComplete=function()
                    end})
                  end})
                end)
              end})
            end)
            print(event.target.name .. " OFF!!")
          end
        end,
      }
    )

    actor_list = helper:create_tilemap(tilemap_panel, player, map_path, physics)
    camera:set_focus(player.actor.sprite)
    camera:start_focus()

    local function clear_current_command()
      global_queue:clear_current_command()
    end

    player.controller:disable_touch_hit_testable(false)
    local function execute_opening()
      global_queue:regist_command(function()
        banner.x = -display.contentCenterX
        banner.isVisible = true
        transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        banner.x = -display.contentCenterX
        banner.text = "GO"
        transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        banner.x = -display.contentCenterX
        banner.text = "FIGHT"
        transition.to(banner, {time=600, x=display.contentCenterX, transition=easing.inOutElastic, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=200, x=display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        transition.to(banner, {time=100, x= display.contentWidth + display.contentCenterX, onComplete=clear_current_command})
      end)
      global_queue:regist_command(function()
        timer.performWithDelay(100, function()
          banner.isVisible = false
          player.controller:disable_touch_hit_testable(true)
          player.controller:show_controller(true)
          physics.start()
          clear_current_command()
        end)
      end)
    end

    local function execute_ending()
    end

    -- start game
    _actors_enterFrame = function(event)
      for i = 1, #actor_list do
        actor_list[i].enterFrame(event)
      end
    end
    Runtime:addEventListener("enterFrame", _actors_enterFrame)

    execute_opening()
    local scenario_list = {
      {
        quest = function(self, done)
          done()
        end,
        evaluate = function()
          -- if player.actor.count >= 500 then
          --   -- return 0
          --   return 1
          -- else
          --   return -1
          -- end
          return 1
        end,
        answer = function(self, state, done)
          done()
        end,
      },

    }
    scenerio_player = require("components.scenario_player")(scenario_list)


  elseif(event.phase == 'did') then

    print("scene1 show did")
  end
end

function scene:hide(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    camera:stop_focus()
    global_queue:clean_up()
    Runtime:removeEventListener("enterFrame", _actors_enterFrame)
    for i = 1 , #actor_list do
      if actor_list[i].timerId then
        timer.cancel(actor_list[i].timerId)
        actor_list[i] = nil
      end
    end
    if tilemap_panel then
      for i = tilemap_panel.numChildren , 1, -1 do
        display.remove(tilemap_panel[i])
        tilemap_panel[i] = nil
      end
    end
    scenerio_player:clean_up()
    scenerio_player = nil

    print("scene1 hide will")
  elseif(event.phase == 'did') then
    print("scene1 hide did")
  end
end

function scene:destroy(event)
  local sceneGroup = self.view
  print("scene1 destroyed")
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene