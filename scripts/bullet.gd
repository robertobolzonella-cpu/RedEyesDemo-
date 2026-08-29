# res://scripts/bullet.gd
extends Area2D

var direction := Vector2.RIGHT
var speed := 520.0
var damage := 1
var lifetime := 1.5
var tint := Color(1.0, 0.9, 0.35)

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# tracciante: scia che sfuma verso la coda, testa bianca
	var img := Image.create(12, 4, false, Image.FORMAT_RGBA8)
	for x in 12:
		var a := 0.15 + 0.85 * (x / 11.0)
		var c := Color(tint.r, tint.g, tint.b, a)
		img.set_pixel(x, 1, c)
		img.set_pixel(x, 2, c)
	img.fill_rect(Rect2i(9, 1, 3, 2), Color(1, 1, 1, 0.95))
	img.resize(24, 8, Image.INTERPOLATE_NEAREST)
	sprite.texture = ImageTexture.create_from_image(img)
	sprite.flip_h = direction.x < 0.0


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
