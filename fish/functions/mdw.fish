function mdw --wraps='mullvad disconnect; mullvad lockdown-mode set off' --description 'alias mdw=mullvad disconnect; mullvad lockdown-mode set off'
    mullvad disconnect; mullvad lockdown-mode set off $argv
end
