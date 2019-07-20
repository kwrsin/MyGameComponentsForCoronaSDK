local utf8 = require('plugin.utf8')


return function()
  local M = require("components.windows.frame")()

  function M:create_bbs(parent, x, y, rows, cols, font_name, size, object_sheet, command_queue)
    self.x_start_pos = display.actualContentWidth / 2 - size * cols / 2
    local bbs_group = display.newGroup()
    local offset_group = display.newGroup()
    local frame_group = display.newGroup()
    bbs_group:insert(offset_group)
    bbs_group:insert(frame_group)
    parent:insert(bbs_group)
    bbs_group.x = x
    bbs_group.y = y
    local characters = {}
    local tags = {}
    for row = 1, rows do
      local yy = display.contentCenterY - size * rows / 2 + (row - 1) * size
      for col = 1, cols do
        local xx = self.x_start_pos + (col - 1) * size
        local character = display.newText(offset_group, "", xx, yy, font_name, size)
        if col == 1 then
          character.is_line_head = true
        else
          character.is_line_head = false
        end
        if col == cols then
          character.is_line_end = true
        else
          character.is_line_end = false
        end
        character.init_x = xx
        character.init_y = yy
        table.insert(characters, character)
      end
      local tag_x = M:get_tag_start_position() + cols * size + size
      local tag = display.newText(offset_group, "", tag_x, yy, font_name, size)
      tag.init_y = yy
      table.insert(tags, tag)
    end

    M.rows = rows
    M.cols = cols
    M.font_name = font_name
    M.size = size
    M.characters = characters
    M.tags = tags
    M.output_count = 0
    M.characters_index = -1
    M.prompt_icon_path = nil
    M.timer_id_list = {}
    M.offset_group = offset_group
    M.bbs_group = bbs_group
    M.characters_offset = 0
    M.command_queue = command_queue
    M:set_frame(frame_group, object_sheet)
    local width, height = cols * size, rows * size
    M:adjust_frame(frame_group, width, height, size)
  end

  function M:set_frame(frame_group, object_sheet)
    if object_sheet then
      if frame_group.numChildren > 0 then
        for i = 1, frame_group.numChildren do
          frame_group[i]:removeSelf()
          frame_group[i] = nil
        end
      end
      for i = 1, 9 do
        local frame_image = display.newImage(frame_group, object_sheet, i)
      end
    end
  end

  -- function M:adjust_frame(frame_group, width, height, size)
  --   frame_group[1].x = display.contentCenterX - size / 2
  --   frame_group[1].y = display.contentCenterY - size / 2  
  --   frame_group[1].width = width + 16
  --   frame_group[1].height = height + 16
  --   frame_group[1].strokeWidth = 3
  --   frame_group[1]:setFillColor( 0.1, 0, 0, 0.3 )
  --   frame_group[1]:setStrokeColor( 1, 0, 0 )
  -- end
function M:adjust_frame(frame_group, width, height, size)
  frame_group[1].x = display.contentCenterX - width / 2 - frame_group[1].width / 2 - size / 2
  frame_group[1].y = display.contentCenterY - height / 2 - frame_group[1].height / 2 - frame_group[1].height + size / 2
  frame_group[2].x = display.contentCenterX - size / 2
  frame_group[2].y = display.contentCenterY - height / 2 - frame_group[1].height / 2 - frame_group[1].height + size / 2
  frame_group[2].width = width
  frame_group[3].x = display.contentCenterX + width / 2 + frame_group[1].width / 2 - size / 2
  frame_group[3].y = display.contentCenterY - height / 2 - frame_group[1].height / 2 - frame_group[1].height + size / 2
  frame_group[4].x = display.contentCenterX - width / 2 - frame_group[1].width / 2 - size / 2
  frame_group[4].y = display.contentCenterY - frame_group[1].height + size / 2
  frame_group[4].height = height + frame_group[1].height / 2
  -- frame_group[5].x = 0
  -- frame_group[5].y = 0
  frame_group[5].isVisible = false
  frame_group[6].x = display.contentCenterX + width / 2 + frame_group[1].width / 2 - size / 2
  frame_group[6].y = display.contentCenterY - frame_group[1].height + size / 2
  frame_group[6].height = height + frame_group[1].height / 2
  frame_group[7].x = display.contentCenterX -width / 2 - frame_group[1].width / 2 - size / 2
  frame_group[7].y = display.contentCenterY + height / 2 + frame_group[1].height / 2 - frame_group[1].height + size / 2
  frame_group[8].x = display.contentCenterX - size / 2
  frame_group[8].y = display.contentCenterY + height / 2 + frame_group[1].height / 2 - frame_group[1].height + size / 2
  frame_group[8].width = width
  frame_group[9].x = display.contentCenterX + width / 2 + frame_group[1].width / 2 - size / 2
  frame_group[9].y = display.contentCenterY + height / 2 + frame_group[1].height / 2 - frame_group[1].height + size / 2 
end

  function M:get_tag_start_position()
    return self.x_start_pos
  end

  function M:clear_bbs()
    self.command_queue:regist_command(function()
      -- timer.performWithDelay(100, function()
        for i = 1, #self.characters do
          self.characters[i].text = ""
          self.characters[i].x = self.characters[i].init_x
          self.characters[i].y = self.characters[i].init_y
          self.characters[i]:setFillColor(1, 1, 1, 1)
        end
        for i = 1, #self.tags do
          self.tags[i].text = ""
          self.tags[i].y = self.tags[i].init_y
          self.tags[i]:setFillColor(1, 1, 1, 1)
        end

        self.output_count = 0
        self.characters_index = -1
        for i in pairs (self.timer_id_list) do
          self.timer_id_list[i] = nil
        end
        self.offset_group.y = 0
        self.characters_offset = 0
        self.command_queue:clear_current_command()
      end)

    -- end)
  end

  function M:get_next_characters_index()
    local next_index = self.characters_index + 1
    self.characters_index = next_index % math.floor((self.rows * self.cols))
    return self.characters_index + 1
  end

  function M:delete()
    for i = 1, #self.timer_id_list do
      timer.cancel(self.timer_id_list[i])
      self.timer_id_list[i] = nil
    end
    Runtime:removeEventListener("enterFrame", self.command_queue)
  end

  function M:clean_up()
    for i = 1, #self.timer_id_list do
      timer.cancel(self.timer_id_list[i])
      self.timer_id_list[i] = nil
    end
    self.command_queue:clean_up()
    for i = 1, #self.characters do
      self.characters[i].text = ""
      self.characters[i].x = self.characters[i].init_x
      self.characters[i].y = self.characters[i].init_y
      self.characters[i]:setFillColor(1, 1, 1, 1)
    end
    for i = 1, #self.tags do
      self.tags[i].text = ""
      self.tags[i].y = self.tags[i].init_y
      self.tags[i]:setFillColor(1, 1, 1, 1)
    end

    self.output_count = 0
    self.characters_index = -1
    self.offset_group.y = 0
    self.characters_offset = 0

  end

  function M:say(actor, serif, speed, sound, colorOptions, onAsk, onActorAction)
    local function to_serif_array(serif)
      local serif_array = {}
      for i = 1, utf8.len(serif) do
        table.insert(serif_array, utf8.sub(serif, i, i))
      end
      return serif_array
    end
    local function set_color(character, start_output_position, skip_space_count, colorOptions)
      if not colorOptions  then return end
      for i, op in ipairs(colorOptions) do
        local start = op.begin + start_output_position - 1 + skip_space_count
        local stop = op.stop + start_output_position - 1 + skip_space_count
        if start <= self.output_count and self.output_count <= stop then
          character:setFillColor(unpack(op.color_table))
        end
      end
    end

    self.command_queue:regist_command(function()
      local serif_array = to_serif_array(serif)
      local is_anim_duration = false
      local is_done_clear_command = false
      local start_output_position = self.output_count
      local skip_space_count = 0
      local timer_id
      local _speed = speed
      local label = nil
      function _set_speed(value)
        _speed = value
      end
      self.set_speed = function(self, value)
        _set_speed(value)
      end
      local function run(count)
        if count <= 0 then
          if onAsk then
            onAsk()
          end
          return
        end
        timer_id = timer.performWithDelay(_speed, function(event)
          local v = table.remove(serif_array, 1)
          local next_characters_index = self:get_next_characters_index()
          local character = self.characters[next_characters_index]
          if v == "\n" then
            while character.is_line_end == false do
              next_characters_index = self:get_next_characters_index()
              character = self.characters[next_characters_index]
              self.output_count = self.output_count + 1
              skip_space_count = skip_space_count + 1
              if character.is_line_end then
                break
              end
            end
            -- character.text = v
          else
            character.text = v
            set_color(character, start_output_position, skip_space_count, colorOptions)
            self.output_count = self.output_count + 1
          end
          if label == nil and actor then
            if actor.tag then
              label = actor.tag
              self.tags[math.floor(next_characters_index / self.cols) + 1].text = label
            end
          end
          -- scroll line by line
          if self.output_count > (self.rows - 1) * (self.cols - 1) and character.is_line_end then
            is_anim_duration = true
            transition.to(self.offset_group, {time=50, y=-self.size * (self.characters_offset + 1), transition=easing.linear, onComplete=function()
              local characters_offset = self.characters_offset
              for i = 1 , self.cols do
                local character = self.characters[((characters_offset % math.floor(self.rows)) * self.cols) + i]
                character.text = ""
                character.y = character.y + (self.rows * self.size)
                character:setFillColor(1, 1, 1, 1)
              end

              local tag = self.tags[(self.characters_offset % math.floor(self.rows)) + 1]
              tag.text = ""
              tag.y = tag.y + (self.rows * self.size)
              tag:setFillColor(1, 1, 1, 1)

              self.characters_offset = (self.characters_offset + 1)
              is_anim_duration = false
              if #serif_array <= 0 and is_done_clear_command == false then
                self.command_queue:clear_current_command()
              end
            end})
          end
          if #serif_array <= 0 and is_anim_duration == false then
            self.command_queue:clear_current_command()
            is_done_clear_command = true
          end
          run(count - 1)
        end, 1)
        table.insert(self.timer_id_list, timer_id)
      end
      run(#serif_array)
    end)
  end
  return M
end