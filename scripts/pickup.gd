# res://scripts/pickup.gd
extends Area2D

@export var heal_amount := 30

@onready var sprite: Sprite2D = $Sprite2D

var _t := 0.0
var _base_y := 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_base_y = sprite.position.y
	# croce medica verde generata via codice
	var img := Image.create(12, 12, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	img.fill_rect(Rect2i(4, 1, 4, 10), Color(0.25, 0.8, 0.35))
	img.fill_rect(Rect2i(1, 4, 10, 4), Color(0.25, 0.8, 0.35))
	img.fill_rect(Rect2i(5, 2, 2, 8), Color(0.55, 0.95, 0.6))
	img.fill_rect(Rect2i(2, 5, 8, 2), Color(0.55, 0.95, 0.6))
	img.resize(24, 24, Image.INTERPOLATE_NEAREST)
	sprite.texture = ImageTexture.create_from_image(img)


func _process(delta: float) -> void:
	_t += delta * 3.0
	sprite.position.y = _base_y + sin(_t) * 3.0


func _on_body_entered(body: Node) -> void:
	if body.has_method("heal"):
		body.heal(heal_amount)
		queue_free()
