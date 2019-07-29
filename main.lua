-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local player = {
  player_behavior = "user_define.behaviors.player_behavior",
}


t = require("components.i18n.locale")("assets.translations")
global_command_queue = require("components.synchronized_non_blocking_methods")()
Runtime:addEventListener("enterFrame", global_command_queue)
global_audio = require("components.audio_player")
global_constants = require("user_define.constants")
system.activate( "multitouch" )

local composer = require('composer')

-- controller panel

local controller = require('components.controller.source_ui')
local controller_panel = display.newGroup()

local listeners = {
  touch = function(event)
    if event.phase == "ended" or event.phase == "cancelled" then
      print("Any Touch!!")
    end
  end,
}

local vc = controller:get_virtual_controller(controller_panel, listeners)
controller:disable_touch_hit_testable(true)
controller:show_controller(false)
Runtime:addEventListener("touch", vc)
player.controller = controller

local splash_screen = display.newGroup()
local bg = display.newRect(splash_screen, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
bg:setFillColor(0, 1, 1)
display.newText(splash_screen, "LOGO", display.contentCenterX, display.contentCenterY, native.systemFont, 32)
-- splash_screen:toBack()
display.getCurrentStage():insert(splash_screen)
display.getCurrentStage():insert(composer.stage)
display.getCurrentStage():insert(controller_panel)

composer.setVariable("player", player)
local options = {
  effect = 'slideLeft',
  time = 200,
}
timer.performWithDelay(1000, function(event)
  composer.gotoScene("user_define.scenes.title", options)
end)

