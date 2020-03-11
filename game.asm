; #########################################################################
;
;   game.asm - Assembly file for CompEng205 Assignment 4/5
;
;
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include Include/stars.inc
include Include/lines.inc
include Include/trig.inc
include Include/blit.inc
include Include/game.inc

include \masm32\include\windows.inc
include \masm32\include\winmm.inc
includelib \masm32\lib\winmm.lib

include \masm32\include\masm32.inc
includelib \masm32\lib\masm32.lib

include \masm32\include\user32.inc
includelib \masm32\lib\user32.lib

;; Has keycodes
include Include/keys.inc

	
.DATA
;Game Object + Display
LEVEL DWORD 1;; Level data (Level * 3 = #projectile sprites in game)
COIN_CNT DWORD 0;
SCORE DWORD 0
GAME_STATE DWORD 0; ENUM: 0 - Play, 1 - Pause, 2 - Game Over, 3 - Game Start Screen
DELAY DWORD 0


;DISPLAY STRINGS
INST1 BYTE "Welcome!", 0
INST2 BYTE "Avoid Bullet Bills and collect Coins to progress", 0
INST3 BYTE "Use W/S Up/Dwn to move and your mouse buttons to steer", 0
INST4 BYTE "Collect coins to gain points, powerups, and progress through levels", 0
LEVEL_STR BYTE "Level: %d", 0
SCORE_STR BYTE "Score: %d", 0
COIN_STR BYTE, "Coins %d/3", 0
PAUSE_STR BYTE "Game Paused", 0
OVER_STR BYTE "Game Over", 0
PLAY_STR BYTE "PLAY", 0
START_OVER_STR BYTE "START OVER", 0
OUT_STR BYTE 256 DUP(0)

;SOUND PATHS
CrabWav BYTE "Music/Crab1.wav", 0
Silence BYTE "Music/Silence.wav", 0
GAME_SND BYTE "Music/game.wav", 0
MENU_SND BYTE "Music/menu.wav", 0

;PLAYER
player Object <?, ?, ?> ;;start player sprite at center, facing up
playerSpeed DWORD 5
PlayerBounds EECS205BITMAP <200, 200,,,>;;bounds around the player so that no objects spawn too close to them
Animate DWORD 0
AnimateCnt DWORD 0

;Bullets
bullets Object <240, 240, 0> ;;initial values for a random sprite
randSpriteAngle FXPT 0;

numBullets DWORD 0
bulletArray Object 15 DUP(<?, ?, ?>)

;Coin(s)
Coin Object <?, ?, ?>
PowerCoin Object <?, ?, ?>
PowerCoinOn DWORD 0


.CODE
	

;; Note: You will need to implement CheckIntersect!!!
CheckIntersect PROC uses ebx esi oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP
      LOCAL oneL:DWORD, oneR:DWORD, oneT:DWORD, oneB:DWORD, twoL:DWORD, twoR:DWORD, twoT:DWORD, twoB:DWORD

            ;;init bounds for one
            mov ebx, oneBitmap

            mov eax, (EECS205BITMAP PTR [ebx]).dwWidth
            mov esi, oneX

            sar eax, 1 ;; halve the width
            mov oneL, esi;; start both bounds at the centerX
            mov oneR, esi
            sub oneL, eax;; add/sub each of them by half the width
            add oneR, eax

            mov eax, (EECS205BITMAP PTR [ebx]).dwHeight
            mov esi, oneY

            sar eax, 1 ;; halve the height
            mov oneT, esi;; start both bounds at the centerY
            mov oneB, esi
            sub oneT, eax;; add/sub each of them by half the height
            add oneB, eax

            ;;init bounds for two
            mov ebx, twoBitmap

            mov eax, (EECS205BITMAP PTR [ebx]).dwWidth
            mov esi, twoX

            sar eax, 1 ;; halve the width
            mov twoL, esi;; start both bounds at the centerX
            mov twoR, esi
            sub twoL, eax;; add/sub each of them by half the width
            add twoR, eax

            mov eax, (EECS205BITMAP PTR [ebx]).dwHeight
            mov esi, twoY

            sar eax, 1 ;; halve the height
            mov twoT, esi;; start both bounds at the centerY
            mov twoB, esi
            sub twoT, eax;; add/sub each of them by half the height
            add twoB, eax
            

            ;;Now we can check if bounds overlap
            ;;for consistency, "one" values will sit in eax, and compare to "two" values

            ;;compare 1Left with 2Right
            mov eax, oneL;
            cmp eax, twoR;
            jg ZERO ;;if left is greater than right, return no collision

            mov eax, oneR;
            cmp eax, twoL;
            jl ZERO ;;if right is less than left, return no collision

            mov eax, oneT;
            cmp eax, twoB;
            jg ZERO ;;if top is greater than bottom, return no collision

            mov eax, oneB;
            cmp eax, twoT;
            jl ZERO ;;if bottom is less than top, return no collision

            ;;if none of these conditions passed, it means that the bounds are overlapping
            mov eax, 1
            ret

      ZERO:
            mov eax, 0
            ret

      
      ret
CheckIntersect ENDP

CheckMouseOver PROC left:DWORD, top:DWORD, right:DWORD, bottom:DWORD, x:DWORD, y:DWORD
            mov eax, x
            cmp eax, left
            jl Yes

            cmp eax, right
            jg Yes

            mov eax, y
            cmp eax, top
            jl Yes
            
            cmp eax, bottom
            jg Yes

            mov eax, 1
            ret

      Yes:
            mov eax, 0
            ret
CheckMouseOver ENDP

;;can be used to reset every level maybe
InitializeNewBullets PROC uses ecx ebx edx esi edi
            ;initialize our ebx pointer to the start of the uninitialized section of the bullet array
            ;this way, adding new bullets wont impact old ones
            mov eax, numBullets
            mov edx, TYPE bulletArray
            imul edx
            mov ebx, eax
            add ebx, OFFSET bulletArray
            
            mov ecx, numBullets
            add numBullets, 2; <=== This is the only place we increment the number of bullets per level
            jmp COND

      L0:
		push ecx
            invoke nrandom, 560
            add eax, 40
            shl eax, 16
            mov (Object PTR [ebx]).x, eax
            invoke nrandom, 400
            add eax, 40
            shl eax, 16
            mov (Object PTR [ebx]).y, eax
            invoke nrandom, 411774 ;;2*PI
            mov (Object PTR [ebx]).angle, eax
		pop ecx

            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16
            mov eax, (Object PTR [ebx]).x
            shr eax, 16
            mov edx, (Object PTR [ebx]).y
            shr edx, 16
            invoke CheckIntersect, esi, edi, OFFSET PlayerBounds, eax, edx, OFFSET bulletLeft

            cmp eax, 1
            je L0; Re-initialize the bullet so that it isnt near the player

            inc ecx
            add ebx, TYPE bulletArray
      COND:
            cmp ecx, numBullets;; how many bullets to add at the start of each level
            jl L0

            ret
InitializeNewBullets ENDP

DrawBullets PROC uses ecx ebx esi edi
            mov ecx, 0
            mov ebx, OFFSET bulletArray
            jmp COND
      L0:
            mov esi, (Object PTR [ebx]).x
            shr esi, 16
            mov edi, (Object PTR [ebx]).y
            shr edi, 16
            invoke RotateBlit, OFFSET bulletLeft, esi, edi, (Object PTR [ebx]).angle
            inc ecx
            add ebx, TYPE bulletArray
      COND:
            cmp ecx, numBullets
            jl L0

            ret
DrawBullets ENDP

DrawNumWord PROC STR_PTR:DWORD, value:DWORD, x:DWORD, y:DWORD
            push value
            push STR_PTR
            push OFFSET OUT_STR
            call wsprintf
            add esp, 12
            invoke DrawStr, offset OUT_STR, x, y, 118
            ret
DrawNumWord ENDP

CheckBounce PROC uses ecx ebx edx
            mov ecx, 0
            mov ebx, OFFSET bulletArray
            jmp LoopCond

      Loop1:
      ;;==================LEFT/RIGHT BOUNCE CHECK================
            mov eax, bulletLeft.dwWidth
            shl eax, 15; convert to fixed point but divide by 2
            cmp (Object PTR [ebx]).x, eax
            jg CheckRight

            ;;if center of bitmap is smaller than the 
            ;;width of the bitmap, it has hit the left
            ;;side, so we will reflect the angle across the y axis
            mov eax, (Object PTR [ebx]).angle
            sub eax, 205887
            neg eax
            mov (Object PTR [ebx]).angle, eax

            ;;re-adjust x center so that the bullet
            ;;doesnt get stuck on the side
            mov eax, bulletLeft.dwWidth
            shl eax, 15
            add eax, 10000h
            mov (Object PTR [ebx]).x, eax;;adjust x to the edge
            jmp CheckVertical

      CheckRight:
            mov eax, bulletLeft.dwWidth
            shl eax, 15
            add eax, (Object PTR [ebx]).x
            shr eax, 16
            cmp eax, 625
            jl CheckVertical

            ;;if center of bitmap + width/2 is greater than
            ;;640, it has hit the right side
            mov eax, (Object PTR [ebx]).angle
            sub eax, 205887
            neg eax
            mov (Object PTR [ebx]).angle, eax

            ;;adjust the bullet to the left margin
            mov eax, bulletLeft.dwWidth
            sar eax, 1
            sub eax, 625
            shl eax, 16
            neg eax
            mov (Object PTR [ebx]).x, eax;;adjust x to the edge
      ;;===============LEFT/RIGHT BOUNCE COMPLETE==============
      CheckVertical:
      ;;===============TOP/BOT BOUNCE CHECK==============
            mov eax, bulletLeft.dwHeight
            shl eax, 15
            cmp (Object PTR [ebx]).y, eax
            jg CheckBot

            ;;if center of bitmap is smaller than the 
            ;;height/2 of the bitmap, it has hit the top
            ;;side, so we will reflect the angle across the x axis
            neg (Object PTR [ebx]).angle


            ;;re-adjust y center so that the bullet
            ;;doesnt get stuck on the side
            mov eax, bulletLeft.dwHeight
            sar eax, 1
            add eax, 1
            shl eax, 16
            mov (Object PTR [ebx]).y, eax;;adjust y to the top
            jmp EndCheck

      CheckBot:
            mov eax, bulletLeft.dwHeight
            shl eax, 15
            add eax, (Object PTR [ebx]).y
            sar eax, 16
            cmp eax, 455
            jl EndCheck

            ;;if center of bitmap + height/2 is greater than
            ;;480, it has hit the right side
            neg (Object PTR [ebx]).angle

            ;;adjust the bullet to the bottom margin
            mov eax, bulletLeft.dwHeight
            sar eax, 1
            sub eax, 454
            neg eax
            shl eax, 16
            mov (Object PTR [ebx]).y, eax;;adjust y to the bottom   




      EndCheck:
            inc ecx
            add ebx, TYPE bulletArray
      LoopCond:
            cmp ecx, numBullets
            jl Loop1
            ret
CheckBounce ENDP

InitializeCoin PROC
            invoke nrandom, 560
            add eax, 40
            shl eax, 16
            mov Coin.x, eax
            invoke nrandom, 400
            add eax, 40
            shl eax, 16
            mov Coin.y, eax
            ret
InitializeCoin ENDP

InitializePowerCoin PROC uses esi edi edx
      L1:
            invoke nrandom, 560
            add eax, 40
            shl eax, 16
            mov PowerCoin.x, eax
            invoke nrandom, 400
            add eax, 40
            shl eax, 16
            mov PowerCoin.y, eax
            invoke nrandom, 411774 ;;2*PI
            mov PowerCoin.angle, eax

            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16
            mov eax, PowerCoin.x
            shr eax, 16
            mov edx, PowerCoin.y
            shr edx, 16
            invoke CheckIntersect, esi, edi, OFFSET PlayerBounds, eax, edx, OFFSET bulletLeft

            cmp eax, 1
            je L1; Re-initialize the coin so that it isnt near the player

            ret
InitializePowerCoin ENDP

MovePowerCoin PROC uses esi edi edx
            cmp PowerCoinOn, 0; only execute if the coin is on
            jne MoveCoin
            ret
      MoveCoin:
      ;;Check Intersections
            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16
            mov eax, PowerCoin.x
            shr eax, 16
            mov edx, PowerCoin.y
            shr edx, 16
            invoke CheckIntersect, esi, edi, OFFSET PlayerCar, eax, edx, OFFSET Coin2
            cmp eax, 0
            je NoPowerUp
            mov playerSpeed, 7
            mov PowerCoinOn, 0
            mov Animate, 1

            invoke PlaySound, offset CrabWav, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC

            mov eax, 2000
            mov edx, LEVEL
            imul edx
            add SCORE, eax

      NoPowerUp:
            mov eax, Coin2.dwWidth
            shl eax, 15; convert to fixed point but divide by 2
            cmp PowerCoin.x, eax
            jg CheckRight

            ;;if center of bitmap is smaller than the 
            ;;width of the bitmap, it has hit the left
            ;;side, so we will reflect the angle across the y axis
            mov eax, PowerCoin.angle
            sub eax, 205887
            neg eax
            mov PowerCoin.angle, eax

            ;;re-adjust x center so that the coin
            ;;doesnt get stuck on the side
            mov eax, Coin2.dwWidth
            add eax, 1
            shl eax, 15
            mov PowerCoin.x, eax;;adjust x to the edge
            jmp CheckVertical

      CheckRight:
            mov eax, bulletLeft.dwWidth
            shl eax, 15
            add eax, PowerCoin.x
            shr eax, 16
            cmp eax, 640
            jl CheckVertical

            ;;if center of bitmap + width/2 is greater than
            ;;640, it has hit the right side
            mov eax, PowerCoin.angle
            sub eax, 205887
            neg eax
            mov PowerCoin.angle, eax

            ;;adjust the coin to the left margin
            mov eax, Coin2.dwWidth
            sar eax, 1
            sub eax, 617
            shl eax, 16
            neg eax
            mov PowerCoin.x, eax;;adjust x to the edge
      ;;===============LEFT/RIGHT BOUNCE COMPLETE==============
      CheckVertical:
      ;;===============TOP/BOT BOUNCE CHECK==============
            mov eax, Coin2.dwHeight
            shl eax, 15
            cmp PowerCoin.y, eax
            jg CheckBot

            ;;if center of bitmap is smaller than the 
            ;;height/2 of the bitmap, it has hit the top
            ;;side, so we will reflect the angle across the x axis
            neg PowerCoin.angle


            ;;re-adjust y center so that the coin
            ;;doesnt get stuck on the side
            mov eax, Coin2.dwHeight
            sar eax, 1
            add eax, 1
            shl eax, 16
            mov PowerCoin.y, eax;;adjust y to the top
            jmp EndCheck

      CheckBot:
            mov eax, Coin2.dwHeight
            shl eax, 15
            add eax, PowerCoin.y
            sar eax, 16
            cmp eax, 455
            jl EndCheck

            ;;if center of bitmap + height/2 is greater than
            ;;480, it has hit the right side
            neg PowerCoin.angle

            ;;adjust the coin to the bottom margin
            mov eax, Coin2.dwHeight
            sar eax, 1
            sub eax, 454
            neg eax
            shl eax, 16
            mov PowerCoin.y, eax;;adjust y to the bottom
      EndCheck:
            ;======MOVE=======
            invoke FixedCos, PowerCoin.angle
            mov edx, 7
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub PowerCoin.x, eax

            invoke FixedSin, PowerCoin.angle
            mov edx, 7
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub PowerCoin.y, eax

            ret
MovePowerCoin ENDP

MovePlayer PROC uses edx esi edi
            ;;MOUSE (Steering Input) START =========
            mov eax, MouseStatus.buttons
            cmp eax, MK_LBUTTON
            je LeftSpin
            cmp eax, MK_RBUTTON
            je RightSpin
            jmp NoMouse
            
      LeftSpin:
            sub player.angle, 2000h
            jmp NoSteering
            
      RightSpin:
            add player.angle, 2000h
            jmp NoSteering

      NoSteering:
      
      
      NoMouse:
            ;;MOUSE INPUT END=======================

		;;KEYBOARD INPUT START==================
            mov eax, KeyPress
            cmp eax, 0
            je NoKey

            cmp eax, VK_UP
            je Up
            cmp eax, VK_DOWN
            je Down
            cmp eax, VK_W
            je Up
            cmp eax, VK_S
            je Down
            jmp NoKey

      Up:
            invoke FixedCos, player.angle
            mov edx, playerSpeed
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub player.y, eax

            invoke FixedSin, player.angle
            mov edx, playerSpeed
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            add player.x, eax
            jmp L1

      Down:
            invoke FixedCos, player.angle
            mov edx, playerSpeed
            sub edx, 1;; slower to go backwards
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            add player.y, eax

            invoke FixedSin, player.angle
            mov edx, playerSpeed
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub player.x, eax
            jmp L1


      L1:
            ;;Adjust if border was hit
            mov eax, PlayerCar.dwWidth
            shl eax, 15
            cmp player.x, eax
            jg RightBorder
            mov player.x, eax

      RightBorder:
            mov eax, PlayerCar.dwWidth
            shl eax, 15
            add eax, player.x
            shr eax, 16
            cmp eax, 629
            jl TopBot
            mov eax, PlayerCar.dwWidth
            sar eax, 1
            mov player.x, 629
            sub player.x, eax
            shl player.x, 16
            

      TopBot:            
            mov eax, PlayerCar.dwHeight
            shl eax, 15
            cmp player.y, eax
            jg BotBorder
            mov player.y, eax
            jmp L2

      BotBorder:
            mov eax, PlayerCar.dwHeight
            shl eax, 15
            add eax, player.y
            shr eax, 16
            cmp eax, 446
            jl L2
            mov eax, PlayerCar.dwHeight
            sar eax, 1
            mov player.y, 446
            sub player.y, eax
            shl player.y, 16
      L2:


      NoKey:
            ;;KEYBOARD INPUT END=====================
            ;;erase old car
            ;; invoke EraseBlit, OFFSET PlayerCar, player.x, player.y 
            ret
MovePlayer ENDP

MoveBullets PROC uses ecx ebx
            invoke CheckBounce
            mov ecx, 0
            mov ebx, OFFSET bulletArray
            jmp COND
      L0:
            ;; invoke EraseBlit, OFFSET bulletLeft, (Object PTR [ebx]).x, (Object PTR [ebx]).y
            invoke FixedCos, (Object PTR [ebx]).angle
            mov edx, 5
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub (Object PTR [ebx]).x, eax

            invoke FixedSin, (Object PTR [ebx]).angle
            mov edx, 5
            shl edx, 16
            imul edx
            shl edx, 16
            shr eax, 16
            or eax, edx
            sub (Object PTR [ebx]).y, eax

            inc ecx
            add ebx, TYPE bulletArray
      COND:
            cmp ecx, numBullets
            jl L0

            ret
MoveBullets ENDP

DrawPlayer PROC uses edx ebx esi edi
            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16

            ;;now we know that the powerup is active
            cmp Animate, 0
            je NoAnimate

            inc AnimateCnt
            mov eax, AnimateCnt
            xor edx, edx
            mov ebx, 10
            idiv ebx
            cmp edx, 5
            jge NoAnimate
            invoke RotateBlit, OFFSET CarAnimation, esi, edi, player.angle
            ret
      NoAnimate:
            invoke RotateBlit, OFFSET PlayerCar, esi, edi, player.angle
            ret
DrawPlayer ENDP

CheckBulletCollisions PROC uses ecx ebx edx esi edi
            mov ecx, 0
            mov ebx, OFFSET bulletArray
            jmp LoopCond

      L1:
            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16
            mov eax, (Object PTR [ebx]).x
            shr eax, 16
            mov edx, (Object PTR [ebx]).y
            shr edx, 16
            invoke CheckIntersect, esi, edi, OFFSET PlayerCar, eax, edx, OFFSET bulletLeft
            cmp eax, 0
            jne CollisionDetected

            inc ecx
            add ebx, TYPE bulletArray
      LoopCond:
            cmp ecx, numBullets
            jl L1

            mov eax, 0
            ret
      CollisionDetected:
            mov eax, 1
            mov GAME_STATE, 2
            invoke PlaySound, offset MENU_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
            ret
CheckBulletCollisions ENDP

CheckCoinCollision PROC uses edx ebx esi edi ecx
            mov esi, player.x
            shr esi, 16
            mov edi, player.y
            shr edi, 16
            mov eax, Coin.x
            shr eax, 16
            mov edx, Coin.y
            shr edx, 16
            invoke CheckIntersect, esi, edi, OFFSET PlayerCar, eax, edx, OFFSET Coin1
            cmp eax, 0
            jne NewCoin
            ret
      NewCoin:
            cmp Animate, 1
            jne ContinueSound
            invoke PlaySound, offset GAME_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC

      ContinueSound:
            ;Remove Player PowerUp Buff
            mov playerSpeed, 5
            mov Animate, 0
            mov AnimateCnt, 0

            ;Create a new coin on the field
            invoke InitializeCoin

            ;;Increment Score by 1000 * LEVEL
            mov eax, 1000
            mov edx, LEVEL
            imul edx
            add SCORE, eax

            ;;Increment the Coin Count and determine if to increase the level
            inc COIN_CNT
            mov eax, COIN_CNT
		xor edx, edx
            mov ebx, 3
            idiv ebx
            cmp edx, 0 ;check if 3 coins have been picked up (3 per level)
            jne DONE
            inc LEVEL
            mov PowerCoinOn, 1
            invoke InitializePowerCoin
            cmp LEVEL, 5 ;MAX LEVEL
            jg DONE;Dont add bullets if the level is above 5
            invoke InitializeNewBullets
            mov COIN_CNT, 0

      DONE:
            ret
CheckCoinCollision ENDP

PauseButtons PROC
            ;Left Button (Play)
            invoke DrawLine, 200, 150, 300, 150, 0ffh
            invoke DrawLine, 200, 200, 300, 200, 0ffh
            invoke DrawLine, 200, 150, 200, 200, 0ffh
            invoke DrawLine, 300, 150, 300, 200, 0ffh


            ;Right Button (Start Over)
            invoke DrawLine, 340, 150, 440, 150, 0ffh
            invoke DrawLine, 340, 200, 440, 200, 0ffh
            invoke DrawLine, 340, 150, 340, 200, 0ffh
            invoke DrawLine, 440, 150, 440, 200, 0ffh


            ;Highlight Boxes if player mouse is over them
            invoke CheckMouseOver, 200, 150, 300, 200, MouseStatus.horiz, MouseStatus.vert
            cmp eax, 1
            jne L1
            invoke DrawBox, 200, 150, 300, 200, 0ffh

            ;OnClick Play Button
            mov eax, MouseStatus.buttons
            cmp eax, MK_LBUTTON
            jne L1
            mov GAME_STATE, 0
            invoke PlaySound, offset GAME_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
      L1:


            invoke CheckMouseOver, 340, 150, 440, 200, MouseStatus.horiz, MouseStatus.vert
            cmp eax, 1
            jne L2
            invoke DrawBox, 340, 150, 440, 200, 0ffh

            ;OnClick Start Over Button
            mov eax, MouseStatus.buttons
            cmp eax, MK_LBUTTON
            jne L2
            invoke GameInit
            mov GAME_STATE, 3
            ;invoke PlaySound, offset MENU_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC

      L2:
            ;Draw Strings over buttons
            invoke DrawStr, OFFSET PLAY_STR, 235, 173, 118
            invoke DrawStr, OFFSET START_OVER_STR, 350, 173, 118
            ret
PauseButtons ENDP

GameOverButton PROC
            ;Button (Start Over)
            invoke DrawLine, 270, 150, 370, 150, 0ffh
            invoke DrawLine, 270, 200, 370, 200, 0ffh
            invoke DrawLine, 270, 150, 270, 200, 0ffh
            invoke DrawLine, 370, 150, 370, 200, 0ffh


            ;Highlight Boxes if player mouse is over them
            invoke CheckMouseOver, 270, 150, 370, 200, MouseStatus.horiz, MouseStatus.vert
            cmp eax, 1
            jne L1
            invoke DrawBox, 270, 150, 370, 200, 0ffh

            ;OnClick Start Over Button
            mov eax, MouseStatus.buttons
            cmp eax, MK_LBUTTON
            jne L1
            invoke GameInit
            mov GAME_STATE, 0
            invoke PlaySound, offset GAME_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
            
      L1:
            ;Draw Strings over buttons
            invoke DrawStr, OFFSET START_OVER_STR, 280, 173, 118
            ret
GameOverButton ENDP

PauseDisplay PROC uses ebx
            ;First draw the game Object
            invoke BlackStarField
            invoke DrawStarField
            invoke DrawBullets

            cmp PowerCoinOn, 0
            je NoPower
            mov eax, PowerCoin.x
            shr eax, 16
            mov ebx, PowerCoin.y
            shr ebx, 16
            invoke BasicBlit, OFFSET Coin2, eax, ebx
      NoPower:
            mov eax, Coin.x
            shr eax, 16
            mov ebx, Coin.y
            shr ebx, 16
            invoke BasicBlit, OFFSET Coin1, eax, ebx

            mov eax, player.x
            shr eax, 16
            mov ebx, player.y
            shr ebx, 16
            invoke RotateBlit, OFFSET PlayerCar, eax, ebx, player.angle

            ;Next draw player info and buttons
            invoke DrawStr, OFFSET PAUSE_STR, 275, 20, 118
            invoke DrawNumWord, OFFSET LEVEL_STR, LEVEL, 289, 80
            invoke DrawNumWord, OFFSET SCORE_STR, SCORE, 280, 100
            invoke PauseButtons

            inc DELAY
            cmp DELAY, 3
            jl ContPause
            mov eax, KeyPress
            cmp eax, VK_P
            je UnPause
            cmp eax, VK_SPACE
            jne ContPause
      UnPause:
            mov GAME_STATE, 0
            mov DELAY, 0
            invoke PlaySound, offset MENU_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
      ContPause:
            ret
PauseDisplay ENDP

GameOverDisplay PROC
            invoke BlackStarField
            invoke DrawStarField
            invoke DrawStr, OFFSET OVER_STR, 285, 20, 118
            invoke DrawNumWord, OFFSET LEVEL_STR, LEVEL, 289, 80
            invoke DrawNumWord, OFFSET SCORE_STR, SCORE, 280, 100
            invoke GameOverButton
            
            ret
GameOverDisplay ENDP

PlayGame PROC uses ebx
            inc DELAY
            cmp DELAY, 3
            jl ContPlay
            mov eax, KeyPress
            cmp eax, VK_P
            je Pause
            cmp eax, VK_SPACE
            jne ContPlay
      Pause:
            mov GAME_STATE, 1
            mov DELAY, 0
            invoke PlaySound, offset MENU_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
            ret

      ContPlay:
            invoke BlackStarField; clear screen
            invoke MovePlayer;move objects on screen
		invoke MoveBullets
            invoke MovePowerCoin
            invoke CheckBulletCollisions;check for bullet collision
            invoke CheckCoinCollision;check coin collision
            invoke DrawStarField
            invoke DrawBullets
            
            cmp PowerCoinOn, 0
            je NoPower
            mov eax, PowerCoin.x
            shr eax, 16
            mov ebx, PowerCoin.y
            shr ebx, 16
            invoke BasicBlit, OFFSET Coin2, eax, ebx
      NoPower:
            mov eax, Coin.x
            shr eax, 16
            mov ebx, Coin.y
            shr ebx, 16
            invoke BasicBlit, OFFSET Coin1, eax, ebx

            invoke DrawPlayer

            invoke DrawNumWord, OFFSET LEVEL_STR, LEVEL, 20, 20
            invoke DrawNumWord, OFFSET COIN_STR, COIN_CNT, 280, 20
            invoke DrawNumWord, OFFSET SCORE_STR, SCORE, 520, 20
            ret  
PlayGame ENDP

StartButton PROC
            ;Button (Play)
            invoke DrawLine, 240, 250, 410, 250, 0ffh
            invoke DrawLine, 240, 300, 410, 300, 0ffh
            invoke DrawLine, 240, 250, 240, 300, 0ffh
            invoke DrawLine, 410, 250, 410, 300, 0ffh


            ;Highlight Boxes if player mouse is over them
            invoke CheckMouseOver, 240, 250, 410, 300, MouseStatus.horiz, MouseStatus.vert
            cmp eax, 1
            jne L1
            invoke DrawBox, 240, 250, 410, 300, 0ffh

            ;OnClick Start Over Button
            mov eax, MouseStatus.buttons
            cmp eax, MK_LBUTTON
            jne L1
            invoke GameInit
            mov GAME_STATE, 0
            invoke PlaySound, offset GAME_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC

      L1:
            ;Draw Strings over buttons
            invoke DrawStr, OFFSET PLAY_STR, 310, 273, 118
            ret
StartButton ENDP

StartDisplay PROC
      invoke BlackStarField
      invoke DrawStarField
      invoke StartButton
      invoke DrawStr, OFFSET INST1, 295, 50, 118
      invoke DrawStr, OFFSET INST2, 140, 100, 118
      invoke DrawStr, OFFSET INST3, 115, 150, 118
      invoke DrawStr, OFFSET INST4, 70, 200, 118
      ret
StartDisplay ENDP

GameInit PROC uses edx ecx
      ;;initialize all variables for game reset
      mov player.x, 320
      shl player.x, 16
      mov player.y, 240
      shl player.y, 16
      mov player.angle, 0
      mov LEVEL, 1
      mov COIN_CNT, 0
      mov SCORE, 0
      mov Animate, 0
      mov playerSpeed, 5
      mov GAME_STATE, 3
      mov numBullets, 2
      mov PowerCoinOn, 1
      ;;seed randmoness with clock cycle
      rdtsc
      invoke nseed, eax
      invoke InitializeNewBullets
      invoke InitializeCoin
      invoke InitializePowerCoin
	invoke DrawStarField
      invoke DrawBullets
      
      mov ecx, player.x
      shr ecx, 16
      mov edx, player.y
      shr edx, 16
      invoke RotateBlit, OFFSET PlayerCar, ecx, edx, player.angle
      
      invoke PlaySound, offset MENU_SND, 0, SND_FILENAME OR SND_LOOP OR SND_ASYNC
	ret         ;; Do not delete this line!!!
GameInit ENDP

GamePlay PROC
            ;;Object Control
            cmp GAME_STATE, 0
            je Play
            cmp GAME_STATE, 1
            je Pause1
            cmp GAME_STATE, 2
            je GameOver
            cmp GAME_STATE, 3
            je GameStart

      Play:
            invoke PlayGame
            ret
      Pause1:
            invoke PauseDisplay
            ret
      GameOver:
            invoke GameOverDisplay
            ret
      GameStart:
            invoke StartDisplay
            ret         ;; Do not delete this line!!!
GamePlay ENDP

END
