class_name HealingAllNumbers
extends BaseUpgrade

var effect: int = 1

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.HEAL
	rarity = UpgradeDisplayer.rarity_types.COMMON
	description = "Adds +%d base heal to all rolls." % effect
	upgrade_type = "additive"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return damage + effect
