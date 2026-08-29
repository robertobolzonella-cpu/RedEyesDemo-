# res://scripts/enemy.gd
extends CharacterBody2D

const BULLET_SCENE := preload("res://scenes/bullet.tscn")
const SF := preload("res://scripts/sprite_factory.gd")

@export_enum("soldier", "mech") var style: String = "soldier"
@export var max_hp: int = 3
@export var speed: float = 60.0
@export var burst: int = 1
@export var damage: int = 10
@export var fire_range: float = 320.0
@export var fire_interval: float = 1.8
@export var burst_gap: float = 0.12
@export var gravity: float = 1500.0

var hp: int
var _facing := -1
var _fire_timer := 1.0
var _burst_left := 0
var _burst_timer := 0.0
var _flash: Sprite2D

@onready var anim: AnimatedSprite2D = $Anim
@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	add_to_group("enemies")
	hp = max_hp
	anim.sprite_frames = SF.enemy_frames(style)
	anim.play("idle")
	_flash = Sprite2D.new()
	_flash.texture = SF.flash_texture()
	_flash.visible = false
	muzzle.add_child(_flash)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = 0.0

	var player = get_tree().get_first_node_in_group("player")
	if player:
		var dx: float = player.global_position.x - global_position.x
		_facing = 1 if dx > 0.0 else -1
		anim.flip_h = _facing < 0
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
	_update_anim()


func _update_anim() -> void:
	if _burst_left > 0:
		anim.play("fire")
	elif absf(velocity.x) > 1.0:
		anim.play("run")
	else:
		anim.play("idle")


func _spawn_bullet() -> void:
	var b := BULLET_SCENE.instantiate()
	b.global_position = muzzle.global_position
	b.direction = Vector2(_facing, 0)
	b.speed = 320.0
	b.damage = damage
	b.tint = Color8(255, 96, 80)
	b.collision_mask = 1 | 2  # mondo + player
	get_parent().add_child(b)
	_flash.visible = true
	_flash.scale = Vector2(1 if _facing > 0 else -1, 1)
	var tw := create_tween()
	tw.tween_interval(0.05)
	tw.tween_callback(func() -> void: _flash.visible = false)


func take_damage(amount: int) -> void:
	hp -= amount
	modulate = Color(1.0, 0.5, 0.5)
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color.WHITE, 0.15)
	if hp <= 0:
		queue_free()
