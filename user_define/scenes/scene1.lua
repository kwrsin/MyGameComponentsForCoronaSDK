local composer = require('composer')

local scene = composer.newScene()

local player
local actor_list = {}
local tilemap_panel
local fast_speak
local bbs
local banner
local _actors_enterFrame
local map_path = 'assets.abcde'
local physics = require("physics")
local helper = require("user_define.scenes.scene1_helper")
local scenerio_player

local back_to_title

function scene:create(event)
  local sceneGroup = self.view
  -- physics.setDrawMode("hybrid")
  physics.start()
  physics.pause()

  player = composer.getVariable("player")
  helper:create_stage(sceneGroup)
  tilemap_panel = display.newGroup()
  sceneGroup:insert(tilemap_panel)

  -- banner
  local scenario_panel = display.newGroup()
  sceneGroup:insert(scenario_panel)
  banner = display.newText(scenario_panel, "READY", -display.contentCenterX, display.contentCenterY, "Arial", 32 )
  banner.isVisible = false

  -- bbs
  bbs = require('components.windows.bbs')()
  local bbs_group = display.newGroup()
  sceneGroup:insert(bbs_group)
  local local_queue = require("components.synchronized_non_blocking_methods")()
  bbs:create_bbs(bbs_group, 0, 0, 6, 20, native.systemFont, 12, "frame_path", local_queue)
  Runtime:addEventListener("enterFrame", local_queue)
  fast_speak = function()
    bbs:set_speed(10)
  end

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
    player.controller:set_vc_event_listeners(
      {
        touch = function(event)
          if event.phase == "ended" or event.phase == "cancelled" then
            print("Any Touch 2!!")
            if fast_speak then
              fast_speak()
            end
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
            player.actor:up()
            player.actor:move_up(true)
          elseif event.is_cursor_repeated < 0 then
            player.actor:down()
            player.actor:move_up(false)
            print(event.target.name .. " OFF!!")
          end
        end,
      }
    )

    actor_list = helper:create_tilemap(tilemap_panel, player, map_path, physics)

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
    -- bbs:say({tag="S"}, t("HELLO").value .. "\nあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇおあういぇお\nはげ\n", 50, nil, {{begin=3, stop=4, color_table={0.7, 1, 0}}})
    -- bbs:clear_bbs()
    -- bbs:say({tag="D"}, "リゾット\nねいろ\n暗殺者\n", 100, nil, nil)
    -- bbs:say({tag="D"}, "なんだと？　ドッピオ！！　さすがに足をやられるダメージはまずいっ！\nドッピオでは\nもう倒せない\n", 80, nil)
    -- bbs:say({tag="D"}, "リゾット　俺はドッピオに言ったんだ！\nもうお前では\n勝てないって・・・\n", 80, nil, {{begin=10, stop=14, color_table={0.5, 0, 0}}})
    -- bbs:say({tag="C"}, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}})

    local scenario_list = {
      {
        start = function()
          bbs:clear_bbs()
          bbs:say({tag="S"}, "最近・・！\nうちのハムスターが\nメタボってきた(T T)\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
          bbs:say({tag="D"}, "オー　ドッピオ！！　私の可愛いドッピオよっ！\n", 180, nil, nil, nil, nil)
        end,
        evaluate = function(self)
          if player.actor.count >= 500 then
            -- return 0
            return 1
          else
            return -1
          end
        end,
        finalize = function()
          bbs:say({tag="D"}, "ありがとうございました！\n", 20, nil, nil, nil, nil)
        end,
      },
     {
        start = function()
          bbs:clear_bbs()
          bbs:say({tag="C"}, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}})
        end,
        evaluate = function()
          if player.actor.sprite.x <= 0 then
            return 1
          else
            return -1
          end
        end,
        finalize = function()
          bbs:say({tag="D"}, "thank you！\n", 20, nil, nil, nil, nil)
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
    bbs:refresh()
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