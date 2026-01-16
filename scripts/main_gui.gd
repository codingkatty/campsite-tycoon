extends Control

@onready var build_gui = get_parent().get_node("build-gui")
@onready var build_cursor = get_tree().get_root().get_node("Node2D/build_cursor")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_build_pressed() -> void:
	visible = false
	build_gui.visible = true
	build_cursor.visible = true

func _on_manage_pressed() -> void:
	pass # Replace with function body.

func _on_build_exit_pressed() -> void:
	visible = true
	build_gui.visible = false
	build_cursor.visible = false
