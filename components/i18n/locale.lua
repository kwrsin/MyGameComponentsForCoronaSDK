return function(translations_path)
  local translations = require(translations_path)
  local language = system.getPreference("ui", "language")
  local device = require("components.i18n.device")
  if(device.isGoogle) then
      if(language == "English" or language == "en") then
          language = "en"
      else
          language = "ja"
      end
  end
  language = string.gsub(language, "(..)-..", "%1")

  return function(key)
    return translations[key][language]
  end
end
