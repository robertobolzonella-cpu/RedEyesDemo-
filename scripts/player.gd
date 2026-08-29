# res://scripts/player.gd
extends CharacterBody2D

signal hp_changed(hp: int, max_hp: int)
signal died

const BULLET_SCENE := preload("res://scenes/bullet.tscn")

@export var speed: float = 240.0
@export var jump_velocity: float = -560.0
@export var gravity: float = 1500.0
@export var max_hp: int = 100
@export var fire_cooldown: float = 0.15

var hp: int
var _cooldown := 0.0
var _facing := 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	add_to_group("player")
	hp = max_hp
	_make_placeholder()
	_make_camera()
	hp_changed.emit(hp, max_hp)


func _make_placeholder() -> void:
	# Esoscheletro SAA: placeholder crema 48x88 generato via codice.
	var img := Image.create(48, 88, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.93, 0.87, 0.72))
	img.fill_rect(Rect2i(26, 10, 16, 8), Color(0.75, 0.12, 0.12))
	img.fill_rect(Rect2i(6, 40, 36, 6), Color(0.55, 0.48, 0.36))
	sprite.texture = ImageTexture.create_from_image(img)


func _make_camera() -> void:
	var cam := Camera2D.new()
	cam.limit_left = 0
	cam.limit_right = 3200
	cam.limit_top = -640
	cam.limit_bottom = 376
	cam.position_smoothing_enabled = true
	add_child(cam)
	cam.make_current()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * speed
	if dir != 0.0:
		_facing = 1 if dir > 0.0 else -1
		sprite.flip_h = _facing < 0
		muzzle.position.x = absf(muzzle.position.x) * _facing
	move_and_slide()

	_cooldown = maxf(0.0, _cooldown - delta)
	if Input.is_action_pressed("fire") and _cooldown == 0.0:
		_fire()


func _fire() -> void:
	_cooldown = fire_cooldown
	var b := BULLET_SCENE.instantiate()
	b.global_position = muzzle.global_position
	b.direction = Vector2(_facing, 0)
	b.damage = 1
	b.collision_mask = 1 | 4  # mondo + nemici
	get_parent().add_child(b)


func take_damage(amount: int) -> void:
	if hp <= 0:
		return
	hp = maxi(0, hp - amount)
	hp_changed.emit(hp, max_hp)
	if hp == 0:
		remove_from_group("player")
		set_physics_process(false)
		sprite.modulate = Color(1.0, 0.3, 0.3, 0.6)
		died.emit()
