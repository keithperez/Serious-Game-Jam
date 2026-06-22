class_name Player
extends Node2D

enum actionSelected {ATTACK, MAGIC, HEAL}

signal action_emitter(action: actionSelected)

@onready var buttons: Node2D = $Buttons

func _on_attack_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.ATTACK)
	pass # Replace with function body.


func _on_magic_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.MAGIC)
	pass # Replace with function body.


func _on_heal_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.HEAL)
	pass # Replace with function body.
