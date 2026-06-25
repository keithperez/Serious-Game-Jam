class_name Player
extends Node2D

enum actionSelected {ATTACK, SPECIAL, HEAL}

signal action_emitter(action: actionSelected)

@onready var buttons: Node2D = $Buttons
@onready var atk_button: Button = $Buttons/AttackButton
@onready var mgk_button: Button = $Buttons/MagicButton
@onready var heal_button: Button = $Buttons/HealButton
@onready var describe: RichTextLabel = $Buttons/DescribingOptions

func _physics_process(_delta: float) -> void:
	if atk_button.is_hovered():
		describe.text = "Attack\nSpin the wheel and do that much in damage!"
	elif mgk_button.is_hovered():
		describe.text = "Special\nTake damage to spin this enhanced wheel!"
	elif heal_button.is_hovered():
		describe.text = "Heal\nSpin the wheel and heal!"
	else:
		describe.text = "Pick an action!"
	pass

func _on_attack_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.ATTACK)
	AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	pass # Replace with function body.

func _on_magic_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.SPECIAL)
	AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	pass # Replace with function body.

func _on_heal_button_pressed() -> void:
	emit_signal("action_emitter", actionSelected.HEAL)
	AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	pass # Replace with function body.
