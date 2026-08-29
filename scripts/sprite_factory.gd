# res://scripts/sprite_factory.gd
# Sprite e animazioni pixel-art generati interamente via codice (niente PNG).
# Uso: preload("res://scripts/sprite_factory.gd").player_frames() ecc.
extends RefCounted

const SCALE := 2

const RUN_POSES := [
	[3, -3, 0, 0], [2, -1, 1, 0], [0, 1, 2, 0],
	[-3, 3, 0, 0], [-1, 2, 0, 1], [1, 0, 0, 2],
]
const WALK_POSES := [
	[2, -2, 0, 0], [1, -1, 1, 0], [-2, 2, 0, 0], [-1, 1, 0, 1],
]

static var _cache: Dictionary = {}


# ------------------------------------------------------------------ pubbliche

static func player_frames() -> SpriteFrames:
	if _cache.has("player"):
		return _cache["player"]
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	_add_anim(sf, "idle", 3.0, true)
	for i in 2:
		sf.add_frame("idle", _tex(_player_img("idle", i)))
	_add_anim(sf, "run", 10.0, true)
	for i in 6:
		sf.add_frame("run", _tex(_player_img("run", i)))
	_add_anim(sf, "jump", 5.0, false)
	sf.add_frame("jump", _tex(_player_img("jump", 0)))
	_add_anim(sf, "fall", 5.0, false)
	sf.add_frame("fall", _tex(_player_img("fall", 0)))
	_cache["player"] = sf
	return sf


static func enemy_frames(style: String) -> SpriteFrames:
	var key := "enemy_" + style
	if _cache.has(key):
		return _cache[key]
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	if style == "mech":
		_add_anim(sf, "idle", 3.0, true)
		for i in 2:
			sf.add_frame("idle", _tex(_barume_img("idle", i)))
		_add_anim(sf, "run", 6.0, true)
		for i in 4:
			sf.add_frame("run", _tex(_barume_img("run", i)))
		_add_anim(sf, "fire", 8.0, true)
		for i in 2:
			sf.add_frame("fire", _tex(_barume_img("fire", i)))
	else:
		_add_anim(sf, "idle", 3.0, true)
		for i in 2:
			sf.add_frame("idle", _tex(_soldier_img("idle", i)))
		_add_anim(sf, "run", 10.0, true)
		for i in 6:
			sf.add_frame("run", _tex(_soldier_img("run", i)))
		_add_anim(sf, "fire", 8.0, true)
		for i in 2:
			sf.add_frame("fire", _tex(_soldier_img("fire", i)))
	_cache[key] = sf
	return sf


static func flash_texture() -> Texture2D:
	if _cache.has("flash"):
		return _cache["flash"]
	var img := Image.create(12, 10, false, Image.FORMAT_RGBA8)
	var outer := Color8(255, 176, 56, 220)
	var mid := Color8(255, 224, 120, 240)
	img.fill_rect(Rect2i(0, 4, 12, 2), outer)
	img.fill_rect(Rect2i(2, 2, 7, 6), outer)
	img.fill_rect(Rect2i(3, 3, 6, 4), mid)
	img.fill_rect(Rect2i(4, 4, 4, 2), Color(1, 1, 1, 0.95))
	img.set_pixel(1, 1, outer)
	img.set_pixel(1, 8, outer)
	var t := _tex(img)
	_cache["flash"] = t
	return t


# ------------------------------------------------------------------- player

static func _player_img(pose: String, f: int) -> Image:
	var img := Image.create(24, 44, false, Image.FORMAT_RGBA8)
	var base := Color8(236, 222, 186)
	var shade := Color8(198, 180, 142)
	var hi := Color8(250, 244, 222)
	var dark := Color8(66, 58, 46)
	var metal := Color8(118, 114, 106)
	var visor := Color8(226, 46, 42)
	var boot := Color8(88, 76, 58)

	var bob := 0
	match pose:
		"idle":
			bob = f
		"run":
			bob = 1 if f % 3 == 1 else 0
		"fall":
			bob = 1

	# gambe (prima, così il torso copre l'anca)
	match pose:
		"run":
			var p: Array = RUN_POSES[f]
			_leg(img, 8, 24 + bob, p[0], p[2], shade, boot)
			_leg(img, 13, 24 + bob, p[1], p[3], base, boot)
		"jump":
			_leg(img, 8, 24, 2, 5, shade, boot)
			_leg(img, 13, 24, -2, 4, base, boot)
		"fall":
			_leg(img, 8, 24 + bob, 1, 2, shade, boot)
			_leg(img, 13, 24 + bob, -1, 1, base, boot)
		_:
			_leg(img, 8, 24 + bob, 0, 0, shade, boot)
			_leg(img, 13, 24 + bob, 0, 0, base, boot)

	# torso + zaino esoscheletro
	var ty := 11 + bob
	img.fill_rect(Rect2i(3, ty + 2, 3, 11), metal)
	img.fill_rect(Rect2i(6, ty, 12, 13), base)
	img.fill_rect(Rect2i(15, ty, 3, 13), shade)
	img.fill_rect(Rect2i(6, ty, 12, 1), hi)
	img.fill_rect(Rect2i(4, ty, 4, 5), shade)
	img.fill_rect(Rect2i(16, ty, 4, 5), base)
	img.fill_rect(Rect2i(16, ty, 4, 1), hi)
	img.fill_rect(Rect2i(9, ty + 5, 3, 3), Color8(196, 52, 46))

	# testa con visiera rossa
	var hy := 2 + bob
	img.fill_rect(Rect2i(7, hy, 10, 9), base)
	img.fill_rect(Rect2i(7, hy, 10, 1), hi)
	img.fill_rect(Rect2i(14, hy + 1, 3, 8), shade)
	img.fill_rect(Rect2i(12, hy + 3, 5, 3), visor)
	img.set_pixel(16, hy + 3, Color8(255, 140, 120))
	img.fill_rect(Rect2i(7, hy + 8, 10, 1), Color8(150, 134, 102))

	# braccio avanti + fucile
	var ay := ty + 4
	img.fill_rect(Rect2i(13, ay, 6, 3), base)
	img.fill_rect(Rect2i(19, ay, 2, 3), shade)
	img.fill_rect(Rect2i(17, ay - 1, 7, 2), dark)
	img.fill_rect(Rect2i(21, ay + 1, 3, 1), metal)
	return img


# ------------------------------------------------------------------- fante

static func _soldier_img(pose: String, f: int) -> Image:
	var img := Image.create(20, 36, false, Image.FORMAT_RGBA8)
	var base := Color8(104, 124, 82)
	var shade := Color8(78, 96, 62)
	var helm := Color8(74, 92, 60)
	var dark := Color8(48, 52, 40)
	var skin := Color8(212, 176, 138)
	var red := Color8(232, 52, 48)
	var rifle := Color8(40, 38, 34)
	var metal := Color8(130, 126, 118)
	var boot := Color8(54, 48, 40)

	var bob := 0
	match pose:
		"idle":
			bob = f
		"run":
			bob = 1 if f % 3 == 1 else 0
		"fire":
			bob = 0

	match pose:
		"run":
			var p: Array = RUN_POSES[f]
			_leg(img, 6, 22 + bob, clampi(p[0], -2, 2), p[2], shade, boot, 4, 6, 5)
			_leg(img, 11, 22 + bob, clampi(p[1], -2, 2), p[3], base, boot, 4, 6, 5)
		_:
			_leg(img, 6, 22 + bob, 0, 0, shade, boot, 4, 6, 5)
			_leg(img, 11, 22 + bob, 0, 0, base, boot, 4, 6, 5)

	# torso
	var ty := 10 + bob
	img.fill_rect(Rect2i(5, ty, 11, 12), base)
	img.fill_rect(Rect2i(13, ty, 3, 12), shade)
	img.fill_rect(Rect2i(5, ty, 2, 12), dark)
	img.fill_rect(Rect2i(5, ty + 10, 11, 2), dark)

	# elmetto + faccia con occhi rossi luminosi
	var hy := 1 + bob
	img.fill_rect(Rect2i(6, hy, 9, 6), helm)
	img.fill_rect(Rect2i(5, hy + 5, 11, 1), dark)
	img.fill_rect(Rect2i(8, hy + 6, 6, 3), skin)
	img.fill_rect(Rect2i(10, hy + 6, 4, 2), red)
	img.set_pixel(13, hy + 6, Color8(255, 130, 110))

	# braccio + fucile (rinculo di 1px nei frame "fire")
	var rx := 0
	if pose == "fire":
		rx = -1
	var ay := ty + 3
	img.fill_rect(Rect2i(11, ay, 5, 3), base)
	img.fill_rect(Rect2i(10 + rx, ay + 1, 10, 2), rifle)
	img.fill_rect(Rect2i(17 + rx, ay, 3, 1), rifle)
	img.set_pixel(19, ay + 1, metal)
	if pose == "fire" and f == 0:
		img.fill_rect(Rect2i(18, ay - 1, 2, 4), Color8(255, 220, 120))
	return img


# ------------------------------------------------------------------- Barume

static func _barume_img(pose: String, f: int) -> Image:
	var img := Image.create(32, 48, false, Image.FORMAT_RGBA8)
	var base := Color8(148, 44, 48)
	var shade := Color8(104, 28, 32)
	var hi := Color8(196, 84, 86)
	var dark := Color8(52, 26, 28)
	var metal := Color8(110, 106, 112)
	var boot := Color8(58, 50, 52)
	var glow := Color8(255, 70, 56)
	var glow_dim := Color8(190, 50, 44)

	var bob := 0
	match pose:
		"idle":
			bob = f
		"run":
			bob = 1 if f % 2 == 1 else 0
		"fire":
			bob = 0

	var eye := glow
	if pose == "idle" and f == 1:
		eye = glow_dim

	match pose:
		"run":
			var p: Array = WALK_POSES[f]
			_leg(img, 9, 28 + bob, p[0], p[2], shade, boot, 7, 8, 7, 9, 4)
			_leg(img, 17, 28 + bob, p[1], p[3], base, boot, 7, 8, 7, 9, 4)
		_:
			_leg(img, 9, 28 + bob, 0, 0, shade, boot, 7, 8, 7, 9, 4)
			_leg(img, 17, 28 + bob, 0, 0, base, boot, 7, 8, 7, 9, 4)

	# torso con core energetico
	var ty := 12 + bob
	img.fill_rect(Rect2i(7, ty, 18, 16), base)
	img.fill_rect(Rect2i(21, ty, 4, 16), shade)
	img.fill_rect(Rect2i(7, ty, 18, 1), hi)
	img.fill_rect(Rect2i(13, ty + 5, 6, 5), dark)
	var core := eye
	if pose == "fire":
		core = Color8(255, 160, 90)
	img.fill_rect(Rect2i(14, ty + 6, 4, 3), core)

	# spalloni
	img.fill_rect(Rect2i(3, ty - 1, 6, 8), shade)
	img.fill_rect(Rect2i(3, ty - 1, 6, 1), hi)
	img.fill_rect(Rect2i(23, ty - 1, 6, 8), base)
	img.fill_rect(Rect2i(23, ty - 1, 6, 1), hi)

	# testa a cupola con striscia occhi rossi
	var hy := 4 + bob
	img.fill_rect(Rect2i(12, hy, 9, 8), base)
	img.fill_rect(Rect2i(12, hy, 9, 1), hi)
	img.fill_rect(Rect2i(15, hy + 3, 6, 2), eye)
	img.set_pixel(20, hy + 3, Color8(255, 150, 130))

	# braccio-cannone (rinculo nei frame "fire")
	var rx := 0
	if pose == "fire":
		rx = -2 if f == 0 else -1
	var ay := ty + 5
	img.fill_rect(Rect2i(22, ay, 6, 5), metal)
	img.fill_rect(Rect2i(27 + rx, ay - 1, 5, 4), dark)
	img.fill_rect(Rect2i(29 + rx, ay, 3, 2), metal)
	return img


# -------------------------------------------------------------------- utils

static func _leg(
	img: Image, x: int, y: int, dx: int, lift: int, col: Color, bcol: Color,
	w := 4, th := 8, sh := 7, bw := 6, bh := 3
) -> void:
	img.fill_rect(Rect2i(x, y, w, th), col)
	var sx := x + dx
	var shh := maxi(2, sh - lift)
	img.fill_rect(Rect2i(sx, y + th, w, shh), col)
	img.fill_rect(Rect2i(sx - 1, y + th + shh, bw, bh), bcol)


static func _add_anim(sf: SpriteFrames, anim_name: String, fps: float, loop: bool) -> void:
	sf.add_animation(anim_name)
	sf.set_animation_speed(anim_name, fps)
	sf.set_animation_loop(anim_name, loop)


static func _tex(img: Image) -> ImageTexture:
	img.resize(img.get_width() * SCALE, img.get_height() * SCALE, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)
