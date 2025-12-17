; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1A - Collapsing platform from HPZ (and GHZ)
; also supports OOZ, but never made use of
;
; Unlike Object 1F, this supports sloped platforms and subtype-dependant
; mappings. Both are used by GHZ, the latter to allow different shading
; on right-facing ledges.
; ----------------------------------------------------------------------------
; Sprite_108BC:
Obj1A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1A_Index(pc,d0.w),d1
	jmp	Obj1A_Index(pc,d1.w)
; ===========================================================================
; off_108CA:
Obj1A_Index:	offsetTable
		offsetTableEntry.w Obj1A_Init		; 0
		offsetTableEntry.w Obj1A_Main		; 2
		offsetTableEntry.w Obj1A_Fragment	; 4
; ===========================================================================

collapsing_platform_delay_pointer = objoff_34
collapsing_platform_delay_counter = objoff_38
collapsing_platform_stood_on_flag = objoff_3A
collapsing_platform_slope_pointer = objoff_3C

; loc_108D0:
Obj1A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj1A_MapUnc_10C6C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.l	#Obj1A_DelayData,collapsing_platform_delay_pointer(a0)
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1A_MapUnc_1101C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZPlatform,2,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$30,width_pixels(a0)
	move.l	#Obj1A_HPZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.l	#Obj1A_HPZ_DelayData,collapsing_platform_delay_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$40,width_pixels(a0)
	move.l	#Obj1A_OOZ_SlopeData,collapsing_platform_slope_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	move.l	#Obj1A_GHZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.b	#$34,width_pixels(a0)
	move.b	#$38,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_1097C:
Obj1A_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	Obj1A_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_1099E
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1099E:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	movea.l	collapsing_platform_slope_pointer(a0),a2 ; a2=object
	move.w	x_pos(a0),d4
	jsrto	SlopedPlatform, JmpTo_SlopedPlatform
	bra.w	MarkObjGone
; End of function sub_1099E

; ===========================================================================
; loc_109B4:
Obj1A_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	Obj1A_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_1099E
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_109DC
	lea	(Sidekick).w,a1 ; a1=character

sub_109DC:
	btst	#3,status(a1)
	beq.s	+
	bclr	#3,status(a1)
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force player's animation to restart
+
	rts
; End of function sub_109DC

; ===========================================================================
; loc_109F8:
Obj1A_FragmentFall:
	bsr.w	ObjectMoveAndFall
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite



