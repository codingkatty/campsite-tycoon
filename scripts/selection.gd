extends Button

var btn_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_toggled(toggled_on:bool) -> void:
	if toggled_on:
		Utils.emit_signal("tent_selected", btn_index)
