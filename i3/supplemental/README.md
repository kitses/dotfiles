At this current moment, the only thing contained in this directory is
`seldom`, a shitty, vibe-coded x86 assembly application ran at line
252 of the configuration, meant to manage mpd(scribble) while using
the least amount of resources possible.

If you plan to use this i3 configuration (why?) and are indeed reading
this, you should remove it from your file and use another music player
system, since you most likely aren't as complacent as we are to do
this.

Otherwise:
```
$ nasm -f elf64 seldom.asm -o seldom.o
$ ld -s seldom.o -o seldom
$ ./seldom
```
