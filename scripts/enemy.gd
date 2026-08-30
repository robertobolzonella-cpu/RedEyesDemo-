# res://scripts/enemy.gd
extends CharacterBody2D

const BULLET_SCENE := preload("res://scenes/bullet.tscn")
const SF := preload("res://scripts/sprite_factory.gd")

@export var art_faces_left := false  # true se il disegno guarda a sinistra
@export var max_hp: int = 3
@export var speed: float = 60.0
@export var burst: int = 1
@export var damage: int = 10
@export var fire_range: float = 320.0
@export var fire_interval: float = 1.8
@export var burst_gap: float = 0.12
@export var gravity: float = 1500.0
@export var melee := false  # charger: sotto melee_range smette di sparare e carica
@export var melee_range := 200.0
@export var melee_reach := 52.0
@export var melee_damage := 15
@export var melee_cooldown := 0.8

var hp: int
var _facing := -1
var _fire_timer := 1.0
var _burst_left := 0
var _burst_timer := 0.0
var _melee_timer := 0.0
var _flash: Sprite2D
var _anim_t := 0.0
var _recoil := 0.0
var _base_y := 0.0

@onready var anim: Sprite2D = $Anim
@onready var muzzle: Marker2D = $Muzzle


func _ready() -> void:
	add_to_group("enemies")
	hp = max_hp
	_base_y = anim.position.y
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
		anim.flip_h = (_facing > 0) if art_faces_left else (_facing < 0)
		muzzle.position.x = absf(muzzle.position.x) * _facing

		if melee and absf(dx) < melee_range:
			# carica: niente spari, corsa a velocità doppia verso il player
			_burst_left = 0
			velocity.x = _facing * speed * 2.0
			_melee_timer -= delta
			var dy: float = absf(player.global_position.y - global_position.y)
			if absf(dx) < melee_reach and dy < 70.0 and _melee_timer <= 0.0:
				_melee_timer = melee_cooldown
				_recoil = 0.15  # affondo visivo
				if player.has_method("take_damage"):
					player.take_damage(melee_damage)
		else:
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
	_update_anim(delta)


func _update_anim(delta: float) -> void:
	_recoil = move_toward(_recoil, 0.0, delta * 0.9)
	var rot := -_recoil * _facing
	if absf(velocity.x) > 1.0:
		_anim_t += delta * 9.0
		anim.position.y = _base_y - absf(sin(_anim_t)) * 2.5
		rot += sin(_anim_t) * 0.04 * _facing
	else:
		_anim_t += delta * 2.0
		anim.position.y = _base_y + sin(_anim_t) * 1.0
	anim.rotation = rot


func _spawn_bullet() -> void:
	var b := BULLET_SCENE.instantiate()
	b.global_position = muzzle.global_position
	b.direction = Vector2(_facing, 0)
	b.speed = 320.0
	b.damage = damage
	b.tint = Color8(255, 96, 80)
	b.collision_mask = 1 | 2  # mondo + player
	get_parent().add_child(b)
	_recoil = 0.1
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
