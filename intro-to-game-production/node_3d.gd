extends Node3D

var player: Node3D

@export var cube_scene: PackedScene
@export var existing_cube: Node3D

var spawned_cubes: Array = []  # list so we can track all spawned cubes

func _ready():
	player = get_node("player")  

func _process(_delta):
	# shows existing cube
	if Input.is_action_just_pressed("show_cube"):
		if existing_cube:
			existing_cube.show()

	# hides existing cube
	if Input.is_action_just_pressed("hide_cube"):
		if existing_cube:
			existing_cube.hide()

	# spawns a new cube
	if Input.is_action_just_pressed("spawn_cube"):
		if cube_scene and player:
			var new_cube = cube_scene.instantiate()  
			add_child(new_cube)
			new_cube.global_transform.origin = player.global_transform.origin + Vector3(0, 0, 3)
			spawned_cubes.append(new_cube)  # adds new cube to list

	# deletes the last spawned cube
	if Input.is_action_just_pressed("destroy_cube"):
		if spawned_cubes.size() > 0:
			var cube_to_delete = spawned_cubes.pop_back()  # gets last cube from list
			cube_to_delete.queue_free()  # remove cube
