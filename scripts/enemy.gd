# res://scripts/enemy.gd
extends CharacterBody2D

const BULLET_SCENE := preload("res://scenes/bullet.tscn")

@export var max_hp: int = 3
@export var speed: float = 60.0
@export var burst: int = 1
@export var damage: int = 10
@export var fire_range: float = 320.0
@export var fire_interval: float = 1.8
@export var burst_gap: float = 0.12
@export var gravity: float = 1500.0
@export var sprite_size: Vector2i = Vector2i(40, 72)
@export var sprite_color: Color = Color(0.35, 0.45, 0.3)

var hp: int
var _facing := -1
var _fire_timer := 1.0
var _burst_left := 0
var _burst_timer := 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	add_to_group("enemies")
	hp = max_hp
	var img := Image.create(sprite_size.x, sprite_size.y, false, Image.FORMAT_RGBA8)
	img.fill(sprite_color)
	img.fill_rect(Rect2i(4, 8, sprite_size.x - 8, 6), Color(0.9, 0.15, 0.15))
	sprite.texture = ImageTexture.create_from_image(img)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = 0.0

	var player = get_tree().get_first_node_in_group("player")
	if player:
		var dx: float = player.global_position.x - global_position.x
		_facing = 1 if dx > 0.0 else -1
		sprite.flip_h = _facing < 0
		muzzle.position.x = absf(muzzle.position.x) * _facing

		if absf(dx) > fire_range * 0.6 and absf(dx) < fire_range * 2.0:
			velocity.x = _facing * speed

		_fire_timer -= delta
		if absf(dx) <= fire_range and _fire_timer <= 0.0 and _burst_left == 0:
			_fire_timer = fire_interval
			_burst_left = burst
			_burst_timer = 0.0

	if _burst_left > 0:
		_burst_timer -= delta
		if _burst_timer <= 0.0:
			_spawn_bullet()
			_burst_left -= 1
			_burst_timer = burst_gap

	move_and_slide()


func _spawn_bullet() -> void:
	var b := BULLET_SCENE.instantiate()
	b.global_position = muzzle.global_position
	b.direction = Vector2(_facing, 0)
	b.speed = 320.0
	b.damage = damage
	b.collision_mask = 1 | 2  # mondo + player
	get_parent().add_child(b)


func take_damage(amount: int) -> void:
	hp -= amount
	modulate = Color(1.0, 0.5, 0.5)
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color.WHITE, 0.15)
	if hp <= 0:
		queue_free()
