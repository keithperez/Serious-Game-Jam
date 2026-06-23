class_name Wheel
extends Control

signal send_out_what_wheel_landed_on(thing)

@onready var wheelspinnerthing: Node2D = $ATTACHNODECHILDRENHERE
@export var wheel_eighth_sections: PackedScene

@export var wheel_starting_speed: float = 25.0
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

var roulette_number_sequence: Array[int] = [2,13,4,17,8,14,6,18,3,19,1,12,11,9,16, 5, 20, 7, 15, 10]
func load_roulette_wheel(starting_friction: float) -> void:
	data = roulette_number_sequence
	wheel_starting_friction = starting_friction
	spacing = 2 * PI / 20
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = load("res://assets/placeholder/wheel_not_final_with_numbers.png")
	wheelspinnerthing.add_child(sprite)

func _ready() -> void:
	pass

func spin_wheel() -> void:
	# make sure to add the wheel_rotation resetter here we really don't want a big ass number here
	idling = false
	wheelspinnerthing.rotation = randf_range(0.0, 2*PI)
	change_in_rotation = fmod(wheelspinnerthing.rotation, spacing)
	wheel_velocity = wheel_starting_speed
	wheel_friction = wheel_starting_friction

func _physics_process(delta: float) -> void:
	if idling:
		wheelspinnerthing.rotation += 0.0015
		pass
	elif wheel_velocity > 0.01:
		bsNum = wheel_velocity * delta
		wheelspinnerthing.rotation += bsNum
		change_in_rotation += bsNum
		wheel_velocity *= (1 - wheel_friction)
		#if wheel_velocity > 10:
			#if change_in_rotation >= 2 * spacing:
				#change_in_rotation -= 2 * spacing
				#AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
		#else:
		if change_in_rotation >= spacing:
			change_in_rotation -= spacing
			AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	else:
		idling = true
		emit_signal("send_out_what_wheel_landed_on", get_data_of_current_index())
		
func get_current_slice_index() -> int:
	return floori(fmod(wheelspinnerthing.rotation, 2*PI) / spacing)
	
func get_data_of_current_index():
	return data[get_current_slice_index()]
