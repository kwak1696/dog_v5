#MaxThreadsPerHotkey 2
Coordmode, ToolTip, Screen
#SingleInstance
Toggle=1
TONE=700
TONEUP=100
FLIP=1
WinActivate, 디아
;global STATEBOX_X:= A_ScreenWidth / 2 - 100
global STATEBOX_X:= 50 ;A_ScreenWidth / 2 - 100
;global STATEBOX_Y:= (A_ScreenHeight / 2) + (A_index * 2)
global STATEBOX_Y:= 100 + (A_index * 2)
global wavs:=[ ]
global mainstep=0
global lasttitle:=""
Loop Files, %A_ScriptDir%\*.wav
{
   wavs.push(A_LoopFileName)
}
global step:=1 
return 
\::
loop{
    WinActivate, Diablo II
    send, {f1}
    sleep, 1000
}

return
f2::
    Toggle:=!Toggle
    if Toggle=1
    {
        reload
    }
    ;Gosub, work2
    Gosub, work3
    Toggle:=!Toggle
return

F12::
  reload
return

work3:
    TONEUP=150
    loop{
        LFT_SKILL(5)
        loop,2{   
            mainstep=0
            STATEBOX_Y:= 100 + (A_index * 2)
            Blizzard(2) 
            ORB(2)
            TONE+=TONEUP * FLIP
            FLIP*=-1
            tip("  END  ",0,0)
            sleep,500
        }
    }
return

Blizzard(l)
{
    tip("Blizzard",1,1)
    send, {f3}
    sleep,10
}


BEEPBEEP: 
    WinActivate, Diablo II
    ; WinWaitActive, Diablo II
    TONEUP+=2* FLIP
    TONE+=TONEUP * FLIP
    ; SoundBeep, TONE, 90
    ; SoundPlay, %A_WinDir%\Media\ding.wav
    wav:=wavs[mainstep]
    
    ; 조용 SoundPlay, %A_ScriptDir%/%wav%

    SetTimer, BEEPOFF, 1000
return
BEEPOFF:
  SoundPlay, out
  SetTimer, BEEPOFF, Off
return

LFT_SKILL(l)
{
    loop, %l%{
        tip("LFT_SKILL", l,A_index)
        STATEBOX_Y:= STATEBOX_Y + (A_index * 3)
        Send,z
        sleep,5
    } 
    return
}

RGT_SKILL(l)
{
    loop, %l%{
        tip_nospeak("RGT_SKILL", l,A_index)
        STATEBOX_Y:= STATEBOX_Y + (A_index * 3)
        Send,x
        sleep,50
    } 
    return
}
ORB(l)
{
    loop, %l%{
        tip("ORB", l,A_index)
        STATEBOX_Y:= STATEBOX_Y + (A_index * 3)
        send,{f1}
        ; LFT_SKILL(5)
        RGT_SKILL(5)
        sleep,50
    } 
    
    return
}

TELEPORT:
    tip("TELEPORT", 1,1)
    WinActivate, Diablo II
    MouseGetPos, xpos, ypos  
    sleep,100
    WinActivate, Diablo II
    Mousemove, 930, 540
    sleep,50
    send,{f4}
    sleep,400
    Mousemove, xpos, ypos 
    sleep,100
    send,{f1}
    sleep,200
return
tip_run(title, substepmax, substep, beep)
{
    if beep=1
    {
        If  lasttitle != %title%
        {
            lasttitle:=title
            mainstep:=mainstep+1
            gosub, BEEPBEEP
        }
    }
    ToolTip,******  [%mainstep%] RUN %title% [%substep%/%substepmax%]   ****** %TONE%, %STATEBOX_X%, %STATEBOX_Y%
    SetTimer, TOOLOFF, 1000
    return
}

tip_nospeak(title, substepmax, substep)
{
    tip_run(title, substepmax, substep, 0)
}
tip(title, substepmax, substep)
{
    tip_run(title, substepmax, substep, 1)
}
return

TOOLOFF:
  ToolTip
  SetTimer, TOOLOFF, Off
return


work2:
    loop,7{
        ; 115 or 540
        STATEBOX_Y:= (A_ScreenHeight / 2) + (A_index * 2)
        ToolTip,************* RUN 1/3 - %A_index% / 7 ************* %TONE%,  %STATEBOX_X% , %STATEBOX_Y%
        MouseClick, right
        sleep,100
    } 
    
    loop,1{
        loop,4{
            STATEBOX_Y:= STATEBOX_Y + (A_index * 3)
            ToolTip,********* RUN 2/3 -  %A_index% / 4 ********* %TONE%, %STATEBOX_X%, %STATEBOX_Y%
            send,{f1}
            sleep,600
            loop,4{
                send,{f3}
                sleep,100
            }
            
        } 
    }
    gosub, TELEPORT 
    ;gosub, ORB
    LFT_SKILL(7)
    gosub, TELEPORT
    TONE+=TONEUP * FLIP
    FLIP*=-1
    ToolTip
return