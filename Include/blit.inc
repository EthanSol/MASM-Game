; #########################################################################
;
;   blit.inc - Includes for CompEng205 Assignment 3
;
;
; #########################################################################


_EECS205BITMAP STRUCT
 dwWidth      DWORD  ?
 dwHeight     DWORD  ?
 bTransparent BYTE   ?
              BYTE   3 DUP(?)
 lpBytes      DWORD  ?
_EECS205BITMAP ENDS

EECS205BITMAP TYPEDEF _EECS205BITMAP

EXTERNDEF ScreenBitsPtr:DWORD

DrawBox PROTO STDCALL x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
BasicBlit PROTO STDCALL ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD
RotateBlit PROTO STDCALL ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
EraseBlit PROTO STDCALL ptrBitmap:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD
INT_FXPT_MULT PROTO STDCALL dwInt:DWORD, fxd:FXPT





