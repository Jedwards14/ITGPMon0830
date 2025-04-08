extends CharacterBody3D
# How fast the player moves in meters per second.
@export var speed = 2
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 50
@export var sensitivity = 0.1
@export var jump_impulse = 15
var target_velocity = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _input(event):
	
	if event is InputEventMouseMotion:
		$Camera.rotation_degrees.x -= event.relative.y * sensitivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * sensitivity
	

func _physics_process(delta):
	var look_direction = Vector3.ZERO
	look_direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	rotate_y(look_direction.x * -sensitivity) 
	$Camera.rotate_x(look_direction.y * -sensitivity) 
	$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
	
	if Input.is_action_pressed("respawn"):
		position = Vector3(0.5,-3.5,10)

	if Input.is_action_just_pressed("run"):
		speed += 2
	if Input.is_action_just_released("run"):
		speed -= 2
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	var move_input_direction = Vector3.ZERO
	move_input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(move_input_direction.x, 0, move_input_direction.y)).normalized()
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	if direction: # Ground Velocity
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		target_velocity.x = move_toward(direction.x, 0, speed)
		target_velocity.z = move_toward(direction.z, 0, speed)
		
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
