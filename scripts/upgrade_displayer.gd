class_name UpgradeDisplayer
extends Button

enum wheel_type {ATTACK, SPECIAL, HEAL}
enum rarity_types {COMMON, UNCOMMON, RARE, LEGENDARY}

@onready var which_wheel: Label = $WhichWheel
@onready var which_rarity: Label = $WhatRarity
@onready var description: RichTextLabel = $Description

func set_which_wheel(type: wheel_type) -> void:
	match type:
		wheel_type.ATTACK:
			which_wheel.text = "Attack Wheel"
		wheel_type.SPECIAL:
			which_wheel.text = "Special Wheel"
		wheel_type.HEAL:
			which_wheel.text = "Heal Wheel"

func set_which_rarity(type: rarity_types) -> void:
	match type:
		rarity_types.COMMON:
			which_rarity.text = "Common"
		rarity_types.UNCOMMON:
			which_rarity.text = "Uncommon"
		rarity_types.RARE:
			which_rarity.text = "Rare"
		rarity_types.LEGENDARY:
			which_rarity.text = "LEGENDARY"

func set_description(input_text: String) -> void:
	description.text = input_text
