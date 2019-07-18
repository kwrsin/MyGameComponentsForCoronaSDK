
local M = require("user_define.scenes.scene_helper")

function M:initialize(player, bbs)
  player.controller:disable_touch_hit_testable(true)
  player.controller:show_controller(false)
  player.controller:set_vc_event_listeners({
      touch = function(event)
        if event.phase == "ended" or event.phase == "cancelled" then
          print("Any Touch 2!!")
          bbs:set_speed(15)
        end
      end,
    }
  )
end

function M:execute_opening(bbs, modal, banner)
  local function goodbye()
    global_queue:regist_command(function()
      -- bbs:clear_bbs()
      -- bbs:say({tag=""}, "あばよ〜っ！！\n", 100, nil, nil, function()
      --   global_queue:clear_current_command()
      --   require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
      -- end)
      banner:show("あばよ〜っ！！", display.actualContentWidth / 2, display.actualContentHeight / 4, 24, nil, function()
        global_queue:clear_current_command()
        require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
      end)
    end)

  end
  global_queue:regist_command(function()
    bbs:clear_bbs()
    bbs:say({tag="D"}, "はじめまして、僕,ドラえもん！！\n", 100, nil, nil)
    bbs:say({tag=""}, "これからいくつか質問をします！！\n", 100, nil, nil)
    bbs:say({tag=""}, "それでは準備はよろしいでしょうか？\n", 100, nil, nil, function()
      modal:show({{t("YES").value}, {t("NO").value}}, 0, 0, 24, 80, 20, function(result)
        if result == 1 then
        else
          global_queue:clear_current_command()
          goodbye()
        end
      end)
    end)
  end)
end

function M:create_background(sceneGroup)
  local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY,
    display.actualContentWidth, display.actualContentHeight)
  bg:setFillColor(0, 0, 0)
end

-- function M:create_sample_modal_buttons(sceneGroup, map_path)
--   local modal = require("components.windows.modal")
--   local lbl = display.newText(sceneGroup, "", display.contentCenterX, display.contentCenterY - 100, native.systemFont, 24)
--   dialog_box1 = display.newText(sceneGroup, "question 1", display.contentCenterX, display.contentCenterY-60, native.systemFont, 24)
--   dialog_box1:addEventListener("touch", function(event)
--     if event.phase == "ended" or event.phase == "cancelled" then
--       modal:show({"りんご", "ばなな", "いちご"}, 0, 0, 26, 5, 20, function(result) lbl.text = tostring(result) end)
--     end
--     return true
--   end)
--   dialog_box2 = display.newText(sceneGroup, "question 2", display.contentCenterX, display.contentCenterY, native.systemFont, 24)
--   dialog_box2:addEventListener("touch", function(event)
--     if event.phase == "ended" or event.phase == "cancelled" then
--       modal:show({{"りんご", "めろん", "いちご"}, {"CANCEL"}, {"CANCEL"}, {"りんご", "めろん", "いちご"}, {"CANCEL"}}, 0, 120, 26, 40,  20, function(result) lbl.text = tostring(result) end)
--     end
--     return true
--   end)

--   local object_sheets = M:get_object_sheets(map_path)
--   modal:create_modal(sceneGroup, object_sheets[3], nil)
--   lbl.text = tostring(modal.result)
-- end

return M