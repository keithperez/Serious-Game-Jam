extends Control

@onready var wheelspinnerthing: Node2D = $ATTACHNODECHILDRENHERE
@export var wheel_eighth_sections: PackedScene

@export var wheel_starting_speed: float = 100.0
@export var wheel_starting_friction: float = 0.01

var wheel_velocity: float = 0.0
var wheel_friction: float = wheel_starting_friction
var change_in_rotation: float = 0.0
var bsNum: float = 0.0

var rng = RandomNumberGenerator.new()

var sectionStorage: Array = []
var sections: int = 8 # default
var spacing: float

var idling: bool = true

func load_wheel(wheel_sections: int = 8) -> void:
	spacing = 2 * PI / wheel_sections # get the amount space between wheel sections
	if wheel_sections == 8:
		for i in range(wheel_sections):
			var section = wheel_eighth_sections.instantiate()
			sectionStorage.append(section)
			section.position = wheelspinnerthing.position
			section.rotation = i * spacing
			wheelspinnerthing.add_child(section)
			section.set_color(Color(randf(), randf(), randf()))
			if i == 0:
				section.set_texture("")
			pass
	pass

func _ready() -> void:
	load_wheel()

func spin_wheel() -> void:
	# make sure to add the wheel_rotation resetter here we really don't want a big ass number here
	wheel_velocity = wheel_starting_speed
	wheel_friction = wheel_starting_friction + rng.randf_range(-0.005, 0.005)

func _physics_process(delta: float) -> void:
	if idling:
		wheelspinnerthing.rotation += 0.0015
		pass
	elif wheel_velocity > 0.05:
		bsNum = wheel_velocity * delta
		wheelspinnerthing.rotation += bsNum
		change_in_rotation += bsNum
		wheel_velocity *= 1 - wheel_friction
		if change_in_rotation >= spacing:
			change_in_rotation -= spacing
			AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
		
func get_current_slice_index() -> int:
	return floori(fmod(wheelspinnerthing.rotation, 2*PI) / spacing)
