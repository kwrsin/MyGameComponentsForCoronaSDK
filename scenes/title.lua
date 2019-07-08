local composer = require('composer')

local scene = composer.newScene()

function scene:create(event)
  local sceneGroup = self.view
  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(0, .5, .5)
  local start_button = display.newText(
    sceneGroup,
    "Start",
    display.contentCenterX,
    display.contentCenterY,
    native.systemFont,
    30)
  local ui = composer.getVariable("ui")
  ui:enable_touch(true)
  ui:set_vc_event_listeners({
    touch = function(event)
      if event.phase == "ended" or event.phase == "cancelled" then
        local options = {
          effect = 'slideLeft',
          time = 200,
        }
        composer.gotoScene("scenes.scene1", options)
      end
    end,
  })

end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
  elseif(event.phase == 'did') then
    composer.removeScene( "scenes.scene1")
  end
end

function scene:hide(event)
  if(event.phase == 'will') then
  elseif(event.phase == 'did') then
  end
end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)

return scene