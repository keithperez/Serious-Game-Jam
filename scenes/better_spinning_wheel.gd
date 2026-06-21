class_name Wheel
extends Control

signal send_out_what_wheel_landed_on(thing)

@onready var wheelspinnerthing: Node2D = $ATTACHNODECHILDRENHERE
@export var wheel_eighth_sections: PackedScene

@export var wheel_starting_speed: float = 100.0
@export var wheel_starting_friction: float = 0.01

var wheel_velocity: float = 0.0
var wheel_friction: float = wheel_starting_friction
var change_in_rotation: float = 0.0
var bsNum: float = 0.0

var rng = RandomNumberGenerator.new()

var data: Array = []

var sectionStorage: Array = []
var sections: int = 8 # default
var spacing: float

var idling: bool = true

func load_wheel(input_data: Array, starting_friction: float, wheel_sections: int = 8, colors: Array = [], texture_paths: Array = []) -> void:
	data = input_data
	wheel_friction = starting_friction
	spacing = 2 * PI / wheel_sections # get the amount space between wheel sections
	if wheel_sections == 8:
		for i in range(wheel_sections):
			var section = wheel_eighth_sections.instantiate()
			sectionStorage.append(section)
			section.position = wheelspinnerthing.position
			section.rotation = i * spacing
			wheelspinnerthing.add_child(section)
			if colors.is_empty():
				section.set_color(Color(randf(), randf(), randf()))
			else:
				section.set_color(colors[i])
			if !texture_paths.is_empty():
				section.set_texture(texture_paths[i])
			pass
	pass

func _ready() -> void:
	pass

func spin_wheel() -> void:
	# make sure to add the wheel_rotation resetter here we really don't want a big ass number here
	idling = false
	wheelspinnerthing.rotation = 0.0
	wheel_velocity = wheel_starting_speed
	wheel_friction = wheel_starting_friction + rng.randf_range(-wheel_starting_friction*0.5, wheel_starting_friction*0.5)

func _physics_process(delta: float) -> void:
	if idling:
		wheelspinnerthing.rotation += 0.0015
		pass
	elif wheel_velocity > 0.01:
		bsNum = wheel_velocity * delta
		wheelspinnerthing.rotation += bsNum
		change_in_rotation += bsNum
		wheel_velocity *= 1 - wheel_friction
		if change_in_rotation >= spacing:
			change_in_rotation -= spacing
			AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	else:
		emit_signal("send_out_what_wheel_landed_on", get_data_of_current_index())
		idling = true
		
func get_current_slice_index() -> int:
	return floori(fmod(wheelspinnerthing.rotation, 2*PI) / spacing)
	
func get_data_of_current_index():
	return data[get_current_slice_index()]
