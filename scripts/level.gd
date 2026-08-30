# res://scripts/level.gd
# Regia del livello: arena del boss (muro + spawn bloccato), traguardo,
# kill zone dei burroni.
extends Node2D

var _boss: Node = null

@onready var boss_spawn: Area2D = $BossSpawn
@onready var arena_wall: StaticBody2D = $ArenaWall
@onready var wall_shape: CollisionShape2D = $ArenaWall/CollisionShape2D
@onready var goal: Area2D = $Goal
@onready var kill_zone: Area2D = $KillZone


func _ready() -> void:
	boss_spawn.spawned.connect(_on_boss_spawned)
	goal.body_entered.connect(_on_goal_entered)
	kill_zone.body_entered.connect(_on_kill_zone)


func _hud() -> Node:
	return get_tree().get_first_node_in_group("hud")


func _on_boss_spawned(enemy: Node) -> void:
	_boss = enemy
	arena_wall.visible = true
	wall_shape.set_deferred("disabled", false)
	enemy.tree_exited.connect(_on_boss_dead)
	var h := _hud()
	if h:
		h.show_message("COBRA!", 1.5)


func _on_boss_dead() -> void:
	arena_wall.visible = false
	wall_shape.set_deferred("disabled", true)
	goal.visible = true
	goal.set_deferred("monitoring", true)
	var h := _hud()
	if h:
		h.show_message("VIA LIBERA!", 2.0)


func _on_goal_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var h := _hud()
	if h:
		h.show_permanent("MISSION COMPLETE")
	body.set_physics_process(false)


func _on_kill_zone(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(999)
