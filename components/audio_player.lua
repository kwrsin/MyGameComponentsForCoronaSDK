local M = {
  is_mute = false,
  sound_assets = {},
  music_assets = {},
  sound_channels = {},
  music_handles = {},
  playing_se_list = {},
  volume = 0,
}

function M:reserve_channels(channels)
  audio.reserveChannels(channels)
end

function M:add_se(file)
  if not file then return end
  self.sound_assets[file] = audio.loadSound(file)
end

function M:add_music(file)
  if not file then return end
  self.music_assets[file] = file
  self.music_handles[file] = audio.loadStream(file)
end

function M:play_se(key, opts, allow_overlap)
  if self.is_mute then return end
  local options = {}
  if opts then
    for key, value in ipairs(opts) do
      options[key] = value
    end
  end

  if not allow_overlap then
    local playing_se = table.indexOf(self.playing_se_list, key) 
    if playing_se then
      return
    end
    table.insert(self.playing_se_list, key)
    options.onComplete = function()
      table.remove(self.playing_se_list, table.indexOf(self.playing_se_list, key))
    end
  end
  self.sound_channels[key] = audio.play(self.sound_assets[key], options)
end

function M:play_bgm_loop(key, restart_time, opts)
  if self.is_mute then return end
  local handle = self.music_handles[key]
  local options = {}
  options.loops = 0
  options.onComplete = function(event)
    if event.completed then
      audio.seek(restart_time, handle)
      self.sound_channels[key] = audio.play(handle, options)
    end
  end
  if opts then
    for key, value in ipairs(opts) do
      options[key] = value
    end
  end
  audio.rewind(handle)
  self.sound_channels[key] = audio.play(handle, options)
end

function M:stop(key)
  if key then
    audio.stop(self.sound_channels[key])
  else
    audio.stop()
  end
end

function M:play_bgm(key, opts)
  if self.is_mute then return end
  local options = {loops = -1}
  if opts then
    for key, value in ipairs(opts) do
      options[key] = value
    end
  end

  local handle = self.music_handles[key]
  if handle then
    self.sound_channels[key] = auido.play(handle, options)
  end
end

function M:stop_sounds()
  audio.pause()
end

function M:restart_sounds()
  audio.resume()
end

function M:set_volume(volume, options)
  if volume then
    self.volume = volume
  end
  return audio.setVolume(self.volume, options)
end

function M:get_volume(options)
  return audio.getVolume(options)
end

function M:rewind(key, options)
  if key then
    return audio.rewind(self.music_handles[key])
  else
    if options then
      return audio.rewind(options)
    else
      return audio.rewind()
    end
  end
end

function M:seek(sec, key, options)
  if key then
    return audio.seek(sec, self.music_handles[key])
  else
    if options then
      return audio.seek(sec, options)
    else
      return audio.seek(sec)
    end
  end
end

function M:destory_sound_assets()
  audio.stop()
  if self.sound_assets then
    for i, r in pairs(self.sound_assets) do
      audio.dispose( r )
      r = nil
    end
    print("disposing se")
  end

end

function M:destory_music_assets()
  audio.stop()

  if self.music_assets then
    for i, r in pairs(self.music_assets) do
      audio.dispose( r )
      r = nil
    end
    print("disposing bg")
  end
end

function M:fade_out(options, key)
  if key then
    options.channel = self.sound_channels[key]
    self.volume = self:get_volume({channel=self.sound_channels[key]})
  end
  audio.fadeOut( options )
end

function M:fade(options, key)
  if key then
    options.channel = self.sound_channels[key]
    self:set_volume(self.volume, options)
  end
  audio.fade( options )
end

function M:sound_stop_with_delay(delaytime)
  -- audio.fadeOut( {time=delaytime / 2 } )
  audio.stopWithDelay(delaytime)

end

return M