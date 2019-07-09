local utf8 = require('plugin.utf8')


return function()
  local M = {}

  function M.create_bbs(parent, x, y, rows, cols, font_name, size, frame_path, command_queue)
    local offset_group = display.newGroup()
    parent:insert(offset_group)
    local characters = {}
    local tags = {}
    for row = 1, rows do
      local yy = (row - 1) * size
      for col = 1, cols do
        local xx = (col - 1) * size
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
      local tag_x = cols * size + size
      local tag = display.newText(offset_group, "", tag_x, yy, font_name, size)
      tag.init_y = yy
      table.insert(tags, tag)
    end

    if parent then
      parent:insert(offset_group)
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
    M.characters_offset = 0
    M.command_queue = command_queue
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
            transition.to(self.offset_group, {time=100, y=-self.size * (self.characters_offset + 1), transition=easing.linear, onComplete=function()
              local characters_offset = self.characters_offset
              for i = 1 , self.cols do
                local character = self.characters[(characters_offset * self.cols) + i]
                character.text = ""
                character.y = character.y + (self.rows * self.size)
                character:setFillColor(1, 1, 1, 1)
              end

              local tag = self.tags[self.characters_offset + 1]
              tag.text = ""
              tag.y = tag.y + (self.rows * self.size)
              tag:setFillColor(1, 1, 1, 1)

              self.characters_offset = (self.characters_offset + 1) % math.floor(self.rows)
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