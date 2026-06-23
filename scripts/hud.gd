class_name HUD
extends Control

@onready var wheel: Wheel = $BetterSpinningWheel
@onready var health_bar: ProgressBar = $BarContainer/HealthContainer/HealthBar
@onready var number_of_heals: Label = $BarContainer/HealContainer/PotionsRemaining
@onready var upgradebuttoncontainer: VBoxContainer = $UpgradeOverlay
@onready var upgrade_buttons: HBoxContainer = $UpgradeOverlay/UpgradeButtonContainer

signal upgrade_selected(index: int)

func _ready() -> void:
	GameManager.connect("update_player_health", _update_player_health)


func _update_player_health(PlayerHealth: int, PlayerMaxHealth: int, FlasksRemaining: int) -> void:
	health_bar.max_value = PlayerMaxHealth
	health_bar.value = PlayerHealth
	number_of_heals.text = str(FlasksRemaining)

func change_button(index: int, upgrade: BaseUpgrade) -> void:
	var button: UpgradeDisplayer = upgrade_buttons.get_children()[index]
	button.visible = true
	button.set_which_wheel(upgrade.wheel_type)
	button.set_which_rarity(upgrade.rarity)
	button.set_description(upgrade.description)

func _on_upgrade_displayer_1_pressed() -> void:
	emit_signal("upgrade_selected", 0)
	pass # Replace with function body.


func _on_upgrade_displayer_2_pressed() -> void:
	emit_signal("upgrade_selected", 1)
	pass # Replace with function body.


func _on_upgrade_displayer_3_pressed() -> void:
	emit_signal("upgrade_selected", 2)
	pass # Replace with function body.


func _on_upgrade_displayer_4_pressed() -> void:
	emit_signal("upgrade_selected", 3)
	pass # Replace with function body.
