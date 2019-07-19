local composer = require('composer')

local helper = require("user_define.scenes.scene2_helper")
local map_path = 'assets.abcde'
local modal
local bbs
local player
local banner
local scenerio_player


local scene = composer.newScene()

function scene:create(event)
  local sceneGroup = self.view
  player = composer.getVariable("player")

  helper:create_background(sceneGroup)
  bbs = helper:create_bbs(sceneGroup)
  modal = helper:create_modal(sceneGroup, map_path)
  banner = helper:create_banner(sceneGroup, map_path)

end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    helper:initialize(player, bbs)
    scenerio_player = require("components.scenario_player")({})
    helper:start_game(player, bbs, modal, banner, scenerio_player)
  elseif(event.phase == 'did') then
  end
end

function scene:hide(event)
  if(event.phase == 'will') then
    bbs:clean_up()
    scenerio_player:clean_up()
    scenerio_player = nil
  elseif(event.phase == 'did') then
  end
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)

return scene