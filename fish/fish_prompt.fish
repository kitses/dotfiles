# go set the fucking colours yourself i don't care
function fish_prompt
    set -l last_status $status
    if test $last_status -eq 1 -o $last_status -eq 130
        set_color ed1f67
    else
        set_color $fish_color_cwd
    end
    echo -n (basename $PWD)
    set_color normal
    echo -n ' ❄ '
end
