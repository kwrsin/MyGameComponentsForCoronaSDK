
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
        local message = "あばよ〜っ！！"
        if state == scenerio_player.CANCEL_ALL then
          message = "この負け犬が〜っ"
        end
        bbs:clear_bbs()
        bbs:say({tag=""}, message, 100, nil, nil, function()
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
        start = function(self)
          bbs:clear_bbs()
          bbs:say({tag="S"}, "問題1\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
          bbs:say({tag="D"}, "5 + 6 = ?\n", 180, nil, nil, function()
            modal:show({{"10"}, {"11"}}, 0, 0, 24, 80, 20)
            self.running = true
          end)
        end,
        evaluate = function()
          if modal.result == -1 then
            return scenerio_player.CONTINUE
          elseif modal.result == 2 then
            return scenerio_player.NEXT
          elseif modal.result ~= 2 then
            return scenerio_player.CANCEL_ALL
          end
        end,
        finalize = function(state)
          if state == scenerio_player.NEXT then
            bbs:say({tag="D"}, "正解です\n", 20, nil, nil, nil, nil)
          else
            goodbye(state)
          end
        end,
      },
     {
        start = function(self)
          bbs:clear_bbs()
          bbs:say({tag="C"}, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}})
          self.running = true
        end,
        evaluate = function()
          if true then
            return scenerio_player.NEXT
          else
            return scenerio_player.CONTINUE
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