extends Control

@onready var npc_control = get_tree().get_root().get_node("Node2D/npc-control")
@onready var tents_container = get_node("bg-container/container/ScrollContainer/VBoxContainer")
@onready var selector_button = preload("res://assets/selection.tscn")
@onready var main_gui = get_parent().get_node("main-gui")
var crnt_selected_tent_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Utils.tent_selected.connect(set_crnt_selected)

func load_tent_list() -> void:
	for item in tents_container.get_children():
		item.queue_free()

	crnt_selected_tent_index = 0
	
	var u_tents = npc_control.get_unoccupied_tent_list()
	var buttongroup = ButtonGroup.new()
	var first_tent = false

	for tent in u_tents:
		var sbutton = selector_button.instantiate()
		sbutton.text = " " + tent.name
		sbutton.button_group = buttongroup
		sbutton.btn_index = tent.index

		if not first_tent:
			sbutton.button_pressed = true
			first_tent = true

		tents_container.add_child(sbutton)

func set_crnt_selected(tent_index):
	#print("set tenti: ", tent_index)
	crnt_selected_tent_index = tent_index

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_yes_pressed() -> void:
	var interact_npc = npc_control.npc_queue[0]
	var tent_position = npc_control.get_tent_position(crnt_selected_tent_index)
	npc_control.npc_leave(crnt_selected_tent_index)
	interact_npc.updateTargetPosition(tent_position)

	main_gui.visible = true
	visible = false
	Utils.mode = "main"

func _on_no_pressed() -> void:
	npc_control.npc_denied()

	main_gui.visible = true
	visible = false
	Utils.mode = "main"
