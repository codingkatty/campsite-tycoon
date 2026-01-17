extends Control

@onready var build_gui = get_parent().get_node("build-gui")
@onready var build_cursor = get_tree().get_root().get_node("Node2D/build_cursor")
@onready var interactbtn = get_node("interact")
@onready var npc_control = get_tree().get_root().get_node("Node2D/npc-control")
@onready var navigation_region = get_tree().get_root().get_node("Node2D/map/NavigationRegion2D")

var interact_action = ""
var interact_npc

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
	Utils.mode = "build"

func _on_manage_pressed() -> void:
	pass # Replace with function body.

func _on_build_exit_pressed() -> void:
	visible = true
	build_gui.visible = false
	build_cursor.visible = false
	Utils.mode = "main"
	navigation_region.bake_navigation_polygon()

func _on_interactionarea_body_entered(body:Node2D) -> void:
	if body.is_in_group("npc"):
		interact_action = "npc"
		if body.place_in_queue == 1:
			interact_npc = body
		interactbtn.disabled = false

func _on_interactionarea_body_exited(body:Node2D) -> void:
	if body.is_in_group("npc"):
		interact_action = ""
		interact_npc = null
		interactbtn.disabled = true

func _on_interact_pressed() -> void:
	if interact_action == "npc":
		Utils.mode = "interact"

		var test_pos = npc_control.first_unoccupied_tent_pos()
		npc_control.npc_leave(npc_control.first_unoccupied_tent_index())
		interact_npc.updateTargetPosition(test_pos)
