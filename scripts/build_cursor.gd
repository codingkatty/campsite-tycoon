extends Node2D

@onready var tilemap = get_parent().get_node("map/TileMap")
@onready var pointer1 = get_node("1t")
@onready var pointer2_h = get_node("2t_horizontal")
@onready var pointer2_v = get_node("2t_vertical")
var mouse_position
var tilepos

var is_select_item = false

var crnt_pointer
var crnt_item # ItemData
var crnt_tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Utils.item_selected.connect(change_item)
	Utils.reset_crnt.connect(reset)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		build()

	if event is InputEventMouseMotion:
		if tilepos != null and is_select_item:
			crnt_pointer.position = tilepos * 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_position = get_global_mouse_position()
	tilepos = tilemap.local_to_map(mouse_position)

	if is_select_item:
		if get_viewport().gui_get_hovered_control() != null:
			crnt_pointer.visible = false
		else:
			crnt_pointer.visible = true

func reset():
	is_select_item = false
	crnt_item = null
	crnt_tile = null
	crnt_pointer = null

func change_item(data: ItemData):
	is_select_item = true
	crnt_item = data
	crnt_tile = data.item_tile

	pointer1.visible = false
	pointer2_h.visible = false
	pointer2_v.visible = false

	if data.size == "1t":
		crnt_pointer = pointer1
	elif data.size == "2t_h":
		crnt_pointer = pointer2_h
	elif data.size == "2t_v":
		crnt_pointer = pointer2_v

func build():
	if is_select_item:
		if crnt_item.is_terrain:
			tilemap.set_cells_terrain_connect(2, [tilepos], crnt_item.terrain_set, crnt_item.terrain, false)
		else:
			tilemap.set_cell(3, tilepos, 0, crnt_tile)
