-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local player = {
  player_behavior = "user_define.behaviors.player_behavior",
}


t = require("components.i18n.locale")("assets.translations")
global_queue = require("components.synchronized_non_blocking_methods")()
Runtime:addEventListener("enterFrame", global_queue)
system.activate( "multitouch" )

local composer = require('composer')

-- controller panel

local user_interface = require('components.controller.source_ui')
local controller_panel = display.newGroup()

local listeners = {
  touch = function(event)
    if event.phase == "ended" or event.phase == "cancelled" then
      print("Any Touch!!")
    end
  end,
}

local vc = user_interface:get_virtual_controller(controller_panel, listeners)
user_interface:enable_touch(true)
user_interface:show_controller(false)
Runtime:addEventListener("touch", vc)
player.user_interface = user_interface

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

