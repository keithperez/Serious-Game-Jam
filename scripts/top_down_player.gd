extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	elif Input.is_action_pressed("move_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("move_down"):
		velocity.y = SPEED

	move_and_slide()
