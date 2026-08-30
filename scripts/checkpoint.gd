# res://scripts/checkpoint.gd
# Checkpoint visivo: al passaggio la bandiera diventa verde.
extends Area2D

@onready var flag: ColorRect = $Flag

var _done := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if _done or not body.is_in_group("player"):
		return
	_done = true
	flag.color = Color(0.3, 0.85, 0.4)
	var h = get_tree().get_first_node_in_group("hud")
	if h:
		h.show_message("CHECKPOINT", 1.5)
