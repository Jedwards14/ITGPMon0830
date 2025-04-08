extends Button

@export var button_path: NodePath  

# key for button press
var key_to_press = KEY_R

var button: Button

func _ready():
	# assigns the button node when loading the scene
	button = get_node(button_path)  # uses node_path to get button

func _process(_delta):
	# checks if the R key is pressed
	if Input.is_key_pressed(key_to_press):  
		if button:  
			button.emit_signal("pressed")
		
func _on_Button_pressed():
	print("Button Pressed with Keyboard!")
