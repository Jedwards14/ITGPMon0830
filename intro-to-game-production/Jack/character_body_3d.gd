extends CharacterBody3D
# How fast the player moves in meters per second.
@export var speed = 2
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 50
@export var sensivity = 0.1
@export var jump_impulse = 15
var target_velocity = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		$Camera.rotation_degrees.x -= event.relative.y * sensivity
		$Camera.rotation_degrees.x = clamp($Camera.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * sensivity
		
func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
		
	if Input.is_action_pressed("respawn"):
		position = Vector3(0.5,-3.5,10)

	if Input.is_action_just_pressed("run"):
		speed += 2
	if Input.is_action_just_released("run"):
		speed -= 2
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
