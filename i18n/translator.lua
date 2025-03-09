local translator = {}
local locales = require "i18n.locales"

translator.lang = config.lang

function translator.T(key)
    local translations = locales[translator.lang]
    return translations[key] or key
end

return translator
