extends Control

@export var item_data: Array[ItemData]
@onready var item_container = get_node("ScrollContainer/HBoxContainer")
@onready var item_t = preload("res://assets/item.tscn")
@onready var item_catag = get_node("build-catalog-container")
var button_group: ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_group = ButtonGroup.new()
	load_items(item_data, "tent")

func load_items(itemd, type):
	Utils.emit_signal("reset_crnt")
	delete_items()
	var at_y = 0
	if type == "tent":
		at_y = 0
	elif type == "terrain":
		at_y = 28
	elif type == "amenities":
		at_y = 56

	for data in itemd:
		if data.item_type == type:
			var item_instance = item_t.instantiate()
			item_instance.data = data
			item_instance.atlas_x = data.atlas_x
			item_instance.atlas_y = at_y
			item_instance.get_node("TextureButton").button_group = button_group

			item_container.add_child(item_instance)

func delete_items():
	for item in item_container.get_children():
		item.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tent_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "tent")
		item_catag.region_rect = Rect2(0, 0, 16, 16)

func _on_terrain_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "terrain")
		item_catag.region_rect = Rect2(0, 16, 16, 16)

func _on_others_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "amenities")
		item_catag.region_rect = Rect2(0, 32, 16, 16)
