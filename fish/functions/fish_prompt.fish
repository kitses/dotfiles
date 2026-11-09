function fish_prompt
    set -l last_status $status
    if test $last_status -eq 1 -o $last_status -eq 130
        set_color C97A7A
    else
        set_color $fish_color_cwd
    end
    echo -n (basename $PWD)
    set_color normal
    set_color --bold FFFFFF
    echo -n ' λ '
    set_color normal
end
