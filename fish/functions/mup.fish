function mup --wraps='mullvad lockdown-mode set on; mullvad connect' --description 'alias mup=mullvad lockdown-mode set on; mullvad connect'
    mullvad lockdown-mode set on; mullvad connect $argv
end
