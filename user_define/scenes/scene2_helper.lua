
local M = require("user_define.scenes.scene_helper")

M.bbs_audio_path = "assets/audio/on.wav"
M.bbs_audio_path_etc = "assets/audio/tap.wav"
M.ok_audio_path = "assets/audio/ok.wav"
M.ng_audio_path = "assets/audio/ng.wav"
M.selected_audio_path = "assets/audio/selected.wav"

function M:prepare_extra_audio()
  global_audio:add_se(M.bbs_audio_path_etc)
  global_audio:add_se(M.ok_audio_path)
  global_audio:add_se(M.ng_audio_path)
end

function M:initialize(player, bbs)
  player.controller:disable_touch_hit_testable(true)
  player.controller:show_controller(false)
  player.controller:set_listeners({
      touch = function(event)
        if event.phase == "ended" or event.phase == "cancelled" then
          print("Any Touch 2!!")
          bbs:set_speed(15)
        end
      end,
    }
  )
end

function M:start_game(player, bbs, modal, banner, scenario_runner)
  local function goodbye(state, done)
    global_command_queue:regist_command(function()
      if state then
        local message = "あばよ〜っ！！"
        if state == scenario_runner.CANCEL_ALL then
          message = "この負け犬が〜っ"
        end
        bbs:clear_bbs()
        bbs:say({tag=""}, message, 100, nil, nil, function()
          if done then done() end
          global_command_queue:clear_current_command()
          require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
        end)
      else
        banner:show("あばよ〜っ！！", display.actualContentWidth / 2, display.actualContentHeight / 4, 24, nil, function()
          if done then done() end
          global_command_queue:clear_current_command()
          require("composer").gotoScene("user_define.scenes.title", {time=200, effect="slideLeft"})
        end)
      end
    end)
  end

  local function start_scenario()
    local scenario_list = {
      {
        quest = function(self, done)
          bbs:clear_bbs()
          bbs:say({tag="S"}, "問題1\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
          bbs:say({tag="D"}, "5 + 6 = ?\n", 180, nil, nil, function()
            modal:show({{"10"}, {"11"}}, 0, 0, 24, 80, 20)
            done()
          end)
        end,
        evaluate = function()
          if modal.result == -1 then
            return scenario_runner.CONTINUE
          elseif modal.result == 2 then
            return scenario_runner.NEXT
          elseif modal.result ~= 2 then
            return scenario_runner.CANCEL_ALL
          end
        end,
        answer = function(self, state, done)
          global_command_queue:performWithDelay(500, function()
            if state == scenario_runner.NEXT then
              global_audio:play_se(M.ok_audio_path)
              bbs:say({tag="D"}, "正解です\n", 20, nil, nil, function() done() end, nil)
            else
              global_audio:play_se(M.ng_audio_path)
              goodbye(state, done)
            end
          end)
        end,
      },
     {
        quest = function(self, done)
          bbs:clear_bbs()
          bbs:say({tag="C"}, "transition.*\nThe transition library provides functions and methods to transition tween display objects or display groups over a specific period of time. Library features include\nAbility to pause, resume, or cancel a transition (or all transitions)\n", 80, M.bbs_audio_path_etc, {{begin=32, stop=38, color_table={1, 1, 0}}}, function()
            done()
          end)
        end,
        evaluate = function()
          if true then
            return scenario_runner.NEXT
          else
            return scenario_runner.CONTINUE
          end
        end,
        answer = function(self, state, done)
          bbs:say({tag="D"}, "thank you！\n", 20, nil, nil, function()
            -- goodbye(state, done)
            done()
          end)
        end,

        scenario_list = {
          {
            quest = function(self, done)
              bbs:clear_bbs()
              bbs:say({tag="S"}, "問題2\n", 80, nil, {{begin=9, stop=13, color_table={1, 0, 1}}})
              bbs:say({tag="D"}, "8 + 9 = ?\n", 180, nil, nil, function()
                modal:show({{"17"}, {"19"}}, 0, 0, 24, 80, 20)
                done()
              end)
            end,
            evaluate = function()
              if modal.result == -1 then
                return scenario_runner.CONTINUE
              elseif modal.result == 1 then
                return scenario_runner.NEXT
              elseif modal.result ~= 1 then
                return scenario_runner.CANCEL_ALL
              end
            end,
            answer = function(self, state, done)
              global_command_queue:performWithDelay(500, function()
                if state == scenario_runner.NEXT then
                  global_audio:play_se(M.ok_audio_path)
                  bbs:say({tag="D"}, "正解です\n", 20, nil, nil, function() done() end, nil)
                else
                  global_audio:play_se(M.ng_audio_path)
                  goodbye(state, done)
                end
              end)
            end,
          },
          {
            quest = function(self, done)
              bbs:clear_bbs()
              bbs:say({tag="C"}, "いろはにほへと\n", 80, nil, {{begin=32, stop=38, color_table={1, 1, 0}}}, function()
                done()
              end)
            end,
            evaluate = function()
              if true then
                return scenario_runner.NEXT
              else
                return scenario_runner.CONTINUE
              end
            end,
            answer = function(self, state, done)
              bbs:say({tag="D"}, "thank you！\n", 20, nil, nil, function()
                goodbye(state, done)
              end)
            end,
          },
        }




      },
    }
    scenario_runner:set_scenario_list(scenario_list)

  end

  global_command_queue:regist_command(function()
    bbs:clear_bbs()
    bbs:say({tag="D"}, "はじめまして、僕,ドラえもん！！\n", 100, nil, nil)
    bbs:say({tag=""}, "これからいくつか質問をします！！\n", 100, nil, nil)
    bbs:say({tag=""}, "それでは準備はよろしいでしょうか？\n", 100, nil, nil, function()
      modal:show({{t("YES").value}, {t("NO").value}}, 0, 0, 24, 80, 20, function(result)
        global_command_queue:clear_current_command()
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