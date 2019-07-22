
local M = require("user_define.scenes.scene_helper")

function M:create_stage(sceneGroup)
  -- background
  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(.25, .25, 0)
end


return M