extends Control

@onready var build_gui = get_parent().get_node("build-gui")
@onready var build_cursor = get_tree().get_root().get_node("Node2D/build_cursor")
@onready var interactbtn = get_node("interact")
@onready var npc_control = get_tree().get_root().get_node("Node2D/npc-control")
@onready var navigation_region = get_tree().get_root().get_node("Node2D/map/NavigationRegion2D")
@onready var light_parent = get_tree().get_root().get_node("Node2D/map/lights")
@onready var lightNode = preload("res://assets/light.tscn")
@onready var manage_gui = get_parent().get_node("manage-gui")
@onready var npc_gui = get_parent().get_node("npc-gui")
@onready var pause_gui = get_parent().get_node("pause-gui")

var interact_action = ""
var interact_npc

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and Utils.mode == "main":
		visible = false
		pause_gui.visible = true
		Utils.mode = "pause"

func _on_build_pressed() -> void:
	visible = false
	build_gui.visible = true
	build_cursor.visible = true
	Utils.mode = "build"

func _on_manage_pressed() -> void:
	visible = false
	manage_gui.visible = true
	manage_gui.info_button.button_pressed = true
	manage_gui.info_tab.visible = true
	manage_gui.generate_tent_infos()
	Utils.mode = "manage"

func _on_build_exit_pressed() -> void:
	visible = true
	build_gui.visible = false
	build_cursor.visible = false
	Utils.mode = "main"
	navigation_region.bake_navigation_polygon()

func _on_interact_pressed() -> void:
	if interact_action == "npc":
		Utils.mode = "interact"

		if npc_control.npc_queue.size() > 0:
			visible = false
			npc_gui.visible = true
			npc_gui.load_tent_list()

		#interact_npc = npc_control.npc_queue[0]
		#var test_pos = npc_control.first_unoccupied_tent_pos()
		#npc_control.npc_leave(npc_control.first_unoccupied_tent_index())
		#interact_npc.updateTargetPosition(test_pos)

		if npc_control.npc_queue.size() == 0:
			interactbtn.disabled = true

func _on_interactionarea_area_entered(area: Area2D) -> void:
	if area.is_in_group("npc"):
		interact_action = "npc"
		if npc_control.npc_queue.size() > 0:
			interactbtn.disabled = false

func _on_interactionarea_area_exited(area: Area2D) -> void:
	if area.is_in_group("npc"):
		interact_action = ""
		interact_npc = null
		interactbtn.disabled = true

func new_npc():
	if interact_action == "npc":
		interactbtn.disabled = false

func _on_manage_exit_pressed() -> void:
	visible = true
	manage_gui.visible = false
	Utils.mode = "main"

func _on_back_pressed() -> void:
	visible = true
	pause_gui.visible = false
	Utils.mode = "main"
