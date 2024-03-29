local M = {}
M.CONTINUE = -1
M.CANCEL_ALL = 0
M.NEXT = 1

-- DEFAULT AUDIO
M.BBS_AUDIO_PATH = "assets/audio/on.wav"
M.MODAL_AUDIO_PATH = "assets/audio/selected.wav"

-- SCENE 1
  -- TILEMAP
  M.MAP_PATH = 'assets.fghi'

-- SCENE 2
  -- FRAME
  M.FRAME_PATH = 'assets.abcde'

  -- EXTRA AUDIO
  M.BBS_AUDIO_PATH_ETC = "assets/audio/tap.wav"
  M.OK_AUDIO_PATH = "assets/audio/ok.wav"
  M.NG_AUDIO_PATH = "assets/audio/ng.wav"

return M