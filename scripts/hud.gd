# res://scripts/hud.gd
extends CanvasLayer

@onready var hp_bar: ProgressBar = $Root/HPBar
@onready var message: Label = $Root/Message


func _ready() -> void:
	message.text = ""
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.hp_changed.connect(_on_hp_changed)
		player.died.connect(_on_died)
		_on_hp_changed(player.hp, player.max_hp)
		show_message("RED EYES - DEMO")


func _on_hp_changed(hp: int, max_hp: int) -> void:
	hp_bar.max_value = max_hp
	hp_bar.value = hp


func _on_died() -> void:
	message.text = "GAME OVER"


func show_message(text: String, duration := 2.0) -> void:
	message.text = text
	await get_tree().create_timer(duration).timeout
	if message.text == text and text != "GAME OVER":
		message.text = ""
