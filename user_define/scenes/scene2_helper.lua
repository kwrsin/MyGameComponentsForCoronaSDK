
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

function M:start_game(player, bbs, modal, banner, scenerio_player)
  local function goodbye(state)
    global_queue:regist_command(function()
      if state then
        bbs:clear_bbs()
        bbs:say({tag=""}, "あばよ〜っ！！\n", 100, nil, nil, function()
          global_queue:clear_current_command()
          require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
        end)
      else
        banner:show("あばよ〜っ！！", display.actualContentWidth / 2, display.actualContentHeight / 4, 24, nil, function()
          global_queue:clear_current_command()
          require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
        end)
      end
    end)
  end

  local function start_scenario()
    local scenario_list = {
      {
        start = function()
          bbs:clear_bbs()
          bbs:say({tag="S"}, "最近・・！\nうちのハムスターが\nメタボってきた(T T)\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
          bbs:say({tag="D"}, "オー　ドッピオ！！　私の可愛いドッピオよっ！\n", 180, nil, nil, nil, nil)
        end,
        evaluate = function(self)
          if true then
            -- return 0
            return 1
          else
            return -1
          end
        end,
        finalize = function(state)
          bbs:say({tag="D"}, "ありがとうございました！\n", 20, nil, nil, nil, nil)
        end,
      },
     {
        start = function()
          bbs:clear_bbs()
          bbs:say({tag="C"}, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}})
        end,
        evaluate = function()
          if true then
            return 1
          else
            return -1
          end
        end,
        finalize = function(state)
          bbs:say({tag="D"}, "thank you！\n", 20, nil, nil, function()
            goodbye(state)
          end)
        end,
      },
    }
    scenerio_player:set_scenario_list(scenario_list)

  end

  global_queue:regist_command(function()
    bbs:clear_bbs()
    bbs:say({tag="D"}, "はじめまして、僕,ドラえもん！！\n", 100, nil, nil)
    bbs:say({tag=""}, "これからいくつか質問をします！！\n", 100, nil, nil)
    bbs:say({tag=""}, "それでは準備はよろしいでしょうか？\n", 100, nil, nil, function()
      modal:show({{t("YES").value}, {t("NO").value}}, 0, 0, 24, 80, 20, function(result)
        global_queue:clear_current_command()
        if result == 1 then
          start_scenario()
        else
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