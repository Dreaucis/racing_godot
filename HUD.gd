extends CanvasLayer


onready var lifebar = $GUI/HBoxContainer/VBoxContainer/EnergyBar

func _on_Car_health_changed(new_health):
    lifebar.value = new_health
