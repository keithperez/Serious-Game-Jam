class_name HealingEvenOddAddition
extends BaseUpgrade

var effect: int = 2
var even_or_odd: bool

func _init() -> void:
	randomize()
	wheel_type = UpgradeDisplayer.wheel_type.HEAL
	rarity = UpgradeDisplayer.rarity_types.COMMON
	even_or_odd = randi() % 2 == 1 # 0 for even, 1 for odd
	if even_or_odd:
		description = "Adds +%d heal to odd numbers." % effect
	else:
		description = "Adds +%d heal to even numbers." % effect
	upgrade_type = "additive"

func apply_upgrade(rolled_number: int, damage: int) -> int:
	if even_or_odd and rolled_number % 2 == 1: # if odd
		return damage + effect
	elif !even_or_odd and rolled_number % 2 == 0:
		return damage + effect
	else:
		return damage
