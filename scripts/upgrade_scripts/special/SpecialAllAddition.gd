class_name SpecialAllAddition
extends BaseUpgrade

var effect: int = 4

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.SPECIAL
	rarity = UpgradeDisplayer.rarity_types.COMMON
	description = "Adds +%d damage to all rolls." % effect
	upgrade_type = "additive"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return damage + effect
