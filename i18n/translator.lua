local translator = {}
local locales = require "i18n.locales"

function translator.T(key)
    local translations = locales[config.lang]
    return translations[key] or key
end

return translator
