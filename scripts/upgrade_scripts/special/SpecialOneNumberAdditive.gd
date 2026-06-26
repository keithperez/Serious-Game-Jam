class_name SpecialOneNumberAdditive
extends BaseUpgrade

var effect: int = 20
var number: int

func _init() -> void:
	randomize()
	wheel_type = UpgradeDisplayer.wheel_type.SPECIAL
	rarity = UpgradeDisplayer.rarity_types.COMMON
	number = randi_range(1, 20)
	description = "Adds +%d damage to the %d number." % [effect, number]
	upgrade_type = "additive"

func apply_upgrade(rolled_number: int, damage: int):
	if rolled_number == number:
		return damage + effect
	else:
		return damage
