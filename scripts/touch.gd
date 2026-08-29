# res://scripts/touch.gd
extends CanvasLayer


func _ready() -> void:
	var normal := _make_circle(Color(1.0, 1.0, 1.0, 0.22))
	var pressed := _make_circle(Color(1.0, 1.0, 1.0, 0.45))
	for child in get_children():
		if child is TouchScreenButton:
			child.texture_normal = normal
			child.texture_pressed = pressed


func _make_circle(color: Color) -> ImageTexture:
	var size := 72
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var center := Vector2(size / 2.0, size / 2.0)
	for y in size:
		for x in size:
			if Vector2(x, y).distance_to(center) <= 34.0:
				img.set_pixel(x, y, color)
	return ImageTexture.create_from_image(img)
