local composer = require('composer')

local map_path = 'assets.abcde'
local helper = require("user_define.scenes.scene_helper")
local modal = require("components.windows.modal")
local tilemap_panel = display.newGroup()
local map_path = 'assets.abcde'
local dialog_box1
local dialog_box2
local player


local scene = composer.newScene()

function scene:create(event)
  local sceneGroup = self.view
  player = composer.getVariable("player")
  player.controller:disable_touch_hit_testable(true)

  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
    display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(0, 0, 0)

  local lbl = display.newText(sceneGroup, "", display.contentCenterX, display.contentCenterY - 100, native.systemFont, 24)
  -- dialog_box1 = display.newText(sceneGroup, "question 1", display.contentCenterX, display.contentCenterY, native.systemFont, 24)
  -- dialog_box1:addEventListener("touch", function(event)
  --   if event.phase == "ended" or event.phase == "cancelled" then
  --     modal:show({"りんご", "ばなな", "いちご"}, 0, 0, 26, 5, 20, function(result) lbl.text = tostring(result) end)
  --   end
  --   return true
  -- end)
  dialog_box2 = display.newText(sceneGroup, "question 2", display.contentCenterX, display.contentCenterY, native.systemFont, 24)
  dialog_box2:addEventListener("touch", function(event)
    if event.phase == "ended" or event.phase == "cancelled" then
      modal:show({{"りんご", "めろん", "いちご"}, {"CANCEL"}, {"CANCEL"}, {"りんご", "めろん", "いちご"}, {"CANCEL"}}, 0, 120, 26, 40,  20, function(result) lbl.text = tostring(result) end)
    end
    return true
  end)

  local object_sheets = helper:get_object_sheets(map_path)
  modal:create_modal(sceneGroup, object_sheets, nil)
  lbl.text = tostring(modal.result)
  sceneGroup:insert(tilemap_panel)
  local r = display.newRect(tilemap_panel, 0, 0, 32, 32)
  r:setFillColor(0, 1, 0, 0.5)
end

function scene:show(event)
  local sceneGroup = self.view

  if(event.phase == 'will') then
    
  elseif(event.phase == 'did') then
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