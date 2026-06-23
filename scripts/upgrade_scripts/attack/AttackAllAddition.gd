class_name AttackAllAddition
extends BaseUpgrade

var effect: int = 2

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.ATTACK
	rarity = UpgradeDisplayer.rarity_types.COMMON
	description = "Adds +%d damage to all numbers." % effect
	upgrade_type = "additive"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return damage + effect
