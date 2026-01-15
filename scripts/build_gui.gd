extends Control

@export var item_data: Array[ItemData]
@onready var item_container = get_node("ScrollContainer/HBoxContainer")
@onready var item_t = preload("res://assets/item.tscn")
@onready var item_catag = get_node("build-catalog-container")
@onready var scroll = get_node("ScrollContainer")
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
	
	var empty = Control.new()
	item_container.add_child(empty)

func delete_items():
	for item in item_container.get_children():
		item.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_scrollbar(r_rect: Rect2, c_grabber, c_highlight, c_pressed) -> void:
	var h_scrollbar = scroll.get_h_scroll_bar()

	var scroll_bg = h_scrollbar.get_theme_stylebox("scroll", "HScrollBar").duplicate()
	scroll_bg.region_rect = r_rect
	h_scrollbar.add_theme_stylebox_override("scroll", scroll_bg)

	var scroll_grabber = h_scrollbar.get_theme_stylebox("grabber", "HScrollBar").duplicate()
	scroll_grabber.bg_color = c_grabber
	h_scrollbar.add_theme_stylebox_override("grabber", scroll_grabber)

	var grabber_highlight = h_scrollbar.get_theme_stylebox("grabber_highlight", "HScrollBar").duplicate()
	grabber_highlight.bg_color = c_highlight
	h_scrollbar.add_theme_stylebox_override("grabber_highlight", grabber_highlight)

	var grabber_pressed = h_scrollbar.get_theme_stylebox("grabber_pressed", "HScrollBar").duplicate()
	grabber_pressed.bg_color = c_pressed
	h_scrollbar.add_theme_stylebox_override("grabber_pressed", grabber_pressed)

func _on_tent_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "tent")
		item_catag.region_rect = Rect2(0, 0, 16, 16)
		set_scrollbar(Rect2(0, 0, 16, 4), Color.html("4d9be6"), Color.html("88bef6"), Color.html("c3e7ff"))

func _on_terrain_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "terrain")
		item_catag.region_rect = Rect2(0, 16, 16, 16)
		set_scrollbar(Rect2(0, 4, 16, 4), Color.html("0b8a8f"), Color.html("6ae4ac"), Color.html("bbf8dc"))

func _on_others_toggled(toggled_on:bool) -> void:
	if toggled_on:
		load_items(item_data, "amenities")
		item_catag.region_rect = Rect2(0, 32, 16, 16)
		set_scrollbar(Rect2(0, 8, 16, 4), Color.html("905ea9"), Color.html("c5aff2"), Color.html("dbcdf8"))
