class_name UpgradeDisplayer
extends Button

enum wheel_type {ATTACK, SPECIAL, HEAL, BOSS}
enum rarity_types {COMMON, UNCOMMON, RARE, LEGENDARY, NONE}

@onready var which_wheel: Label = $WhichWheel
@onready var which_rarity: Label = $WhatRarity
@onready var description: RichTextLabel = $Description
@onready var labelsettings: LabelSettings = LabelSettings.new()

func set_which_wheel(type: wheel_type) -> void:
	match type:
		wheel_type.ATTACK:
			which_wheel.text = "Attack Wheel"
		wheel_type.SPECIAL:
			which_wheel.text = "Special Wheel"
		wheel_type.HEAL:
			which_wheel.text = "Heal Wheel"
		wheel_type.BOSS:
			which_wheel.text = "Boss Upgrade"

func set_which_rarity(type: rarity_types) -> void:
	which_wheel.label_settings = labelsettings
	which_rarity.label_settings = labelsettings
	match type:
		rarity_types.COMMON:
			which_rarity.text = "Common"
			labelsettings.font_color = Color.WHITE
		rarity_types.UNCOMMON:
			which_rarity.text = "Uncommon"
			labelsettings.font_color = Color.GREEN
		rarity_types.RARE:
			which_rarity.text = "Rare"
			labelsettings.font_color = Color.CYAN
		rarity_types.LEGENDARY:
			which_rarity.text = "LEGENDARY"
			labelsettings.font_color = Color.GOLD
		rarity_types.NONE:
			which_rarity.text = ""

func set_description(input_text: String) -> void:
	description.text = "[font_size=14]" + input_text
