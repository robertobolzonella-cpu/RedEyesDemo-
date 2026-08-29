# res://scripts/bullet.gd
extends Area2D

var direction := Vector2.RIGHT
var speed := 520.0
var damage := 1
var lifetime := 1.5

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	var img := Image.create(8, 4, false, Image.FORMAT_RGBA8)
	img.fill(Color(1.0, 0.9, 0.35))
	sprite.texture = ImageTexture.create_from_image(img)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
