local composer = require('composer')

local helper = require("user_define.scenes.scene2_helper")
local modal
local bbs
local player
local banner
local scenario_runner


local scene = composer.newScene()

function scene:create(event)
  local sceneGroup = self.view
  player = composer.getVariable("player")
  helper:prepare_extra_audio()
  helper:create_background(sceneGroup)
  bbs = helper:create_bbs(sceneGroup)
  modal = helper:create_modal(sceneGroup)
  banner = helper:create_banner(sceneGroup)

end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    helper:initialize(player, bbs)
    scenario_runner = require("components.scenario_runner")({})
    helper:start_game(player, bbs, modal, banner, scenario_runner)
  elseif(event.phase == 'did') then
  end
end

function scene:hide(event)
  if(event.phase == 'will') then
    bbs:clean_up()
    scenario_runner:clean_up()
    scenario_runner = nil
    -- helper:clear_audio()
  elseif(event.phase == 'did') then
  end
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)

return scene