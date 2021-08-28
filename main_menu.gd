extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func start_button_pressed():
    print("start button pressed")
    get_tree().change_scene("World.tscn")

func quit_button_pressed():
    get_tree().quit()
