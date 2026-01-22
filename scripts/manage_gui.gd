extends Control

@onready var info_tab = get_node("info-container")
@onready var data_container = get_node("info-container/ScrollContainer/VBoxContainer")
@onready var manage_tent = preload("res://assets/manager.tscn")
@onready var message = get_node("message")
@onready var info_button = get_node("info")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func generate_tent_infos() -> void:
	for child in data_container.get_children():
		child.queue_free()

	for i in range(Utils.tent_data.size()):
		var tent_info = manage_tent.instantiate()
		tent_info.tent_data = Utils.tent_data[i]
		print(i)
		data_container.add_child(tent_info)

	if Utils.tent_data.size() == 0:
		message.visible = true
		message.text = "nothing here yet :(\nplace a tent to get started!"
	else:
		message.visible = false

func _on_info_toggled(toggled_on:bool) -> void:
	if toggled_on:
		info_tab.visible = true
		generate_tent_infos()
	else:
		info_tab.visible = false
		message.visible = false

func _on_reviews_toggled(toggled_on:bool) -> void:
	if toggled_on:
		#review tab visible
		message.visible = true
		message.text = "reviews is in construction!"
	else:
		# make tab not visible
		message.visible = false

func _on_helpers_toggled(toggled_on:bool) -> void:
	if toggled_on:
		#helpers tab visible
		message.visible = true
		message.text = "helper function is in construction!"
	else:
		# make tab not visible
		message.visible = false
