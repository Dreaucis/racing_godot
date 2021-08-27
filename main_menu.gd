extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
    pass

func start_button_pressed():
    print("start button pressed")
    get_tree().change_scene("World.tscn")
