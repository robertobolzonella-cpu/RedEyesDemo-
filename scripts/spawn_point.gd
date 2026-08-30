# res://scripts/spawn_point.gd
# Trigger di ondata: Area2D che, al passaggio del player, istanzia i nemici
# ai marker relativi. one-shot.
extends Area2D

signal spawned(enemy: Node)

@export var enemy_scene: PackedScene
@export var count := 1
@export var spacing := 80.0
@export var spawn_offset := Vector2(300, -10)
@export var boss := false
@export var overrides := {}

var _done := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _done or not body.is_in_group("player"):
		return
	_done = true
	for i in count:
		var e := enemy_scene.instantiate()
		e.global_position = global_position + spawn_offset + Vector2(spacing * i, 0)
		for k in overrides:
			e.set(k, overrides[k])
		if boss:
			e.scale = Vector2(1.15, 1.15)
		get_parent().call_deferred("add_child", e)
		spawned.emit(e)
