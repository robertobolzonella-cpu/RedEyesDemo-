# res://scripts/player.gd
extends CharacterBody2D

signal hp_changed(hp: int, max_hp: int)
signal died

const BULLET_SCENE := preload("res://scenes/bullet.tscn")
const SF := preload("res://scripts/sprite_factory.gd")

@export var speed: float = 240.0
@export var jump_velocity: float = -560.0
@export var gravity: float = 1500.0
@export var max_hp: int = 100
@export var fire_cooldown: float = 0.15

var hp: int
var _cooldown := 0.0
var _facing := 1
var _flash: Sprite2D
var _anim_t := 0.0
var _recoil := 0.0
var _base_y := 0.0

@onready var anim: Sprite2D = $Anim
@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	add_to_group("player")
	hp = max_hp
	_base_y = anim.position.y
	_make_camera()
	_flash = Sprite2D.new()
	_flash.texture = SF.flash_texture()
	_flash.visible = false
	muzzle.add_child(_flash)
	hp_changed.emit(hp, max_hp)


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
		anim.flip_h = _facing < 0
		muzzle.position.x = absf(muzzle.position.x) * _facing
	move_and_slide()
	_update_anim(delta)

	_cooldown = maxf(0.0, _cooldown - delta)
	if Input.is_action_pressed("fire") and _cooldown == 0.0:
		_fire()


func _update_anim(delta: float) -> void:
	# animazione procedurale: bob in corsa, tilt in salto, rinculo allo sparo
	_recoil = move_toward(_recoil, 0.0, delta * 0.9)
	var rot := -_recoil * _facing
	if not is_on_floor():
		rot += (-0.10 if velocity.y < 0.0 else 0.07) * _facing
		anim.position.y = _base_y
	elif absf(velocity.x) > 1.0:
		_anim_t += delta * 13.0
		anim.position.y = _base_y - absf(sin(_anim_t)) * 3.0
		rot += sin(_anim_t) * 0.045 * _facing
	else:
		_anim_t += delta * 2.5
		anim.position.y = _base_y + sin(_anim_t) * 1.2
	anim.rotation = rot


func _fire() -> void:
	_cooldown = fire_cooldown
	var b := BULLET_SCENE.instantiate()
	b.global_position = muzzle.global_position
	b.direction = Vector2(_facing, 0)
	b.damage = 1
	b.collision_mask = 1 | 4  # mondo + nemici
	get_parent().add_child(b)
	_recoil = 0.12
	_show_flash()


func _show_flash() -> void:
	_flash.visible = true
	_flash.scale = Vector2(1 if _facing > 0 else -1, 1)
	var tw := create_tween()
	tw.tween_interval(0.05)
	tw.tween_callback(func() -> void: _flash.visible = false)


func take_damage(amount: int) -> void:
	if hp <= 0:
		return
	hp = maxi(0, hp - amount)
	hp_changed.emit(hp, max_hp)
	if hp == 0:
		remove_from_group("player")
		set_physics_process(false)
		anim.modulate = Color(1.0, 0.3, 0.3, 0.6)
		died.emit()
