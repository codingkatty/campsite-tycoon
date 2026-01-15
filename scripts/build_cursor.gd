extends Node2D

@onready var tilemap = get_parent().get_node("map/TileMap")
@onready var pointer1 = get_node("1t")
@onready var pointer2_h = get_node("2t_horizontal")
@onready var pointer2_v = get_node("2t_vertical")
@onready var pointer_big = get_node("nt")

var mouse_position
var tilepos

var is_select_item = false

var crnt_pointer
var crnt_item # ItemData
var crnt_tile
var ori_region_rect

var no_overlap: Array[Vector2i] = []
var no_place: Array[Vector2i] = []
var offsets = [
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(1, 0),
	Vector2i(1, -1),
	Vector2i(0, -1),
	Vector2i(-1, -1),
	Vector2i(-1, 0),
	Vector2i(-1, 1)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Utils.item_selected.connect(change_item)
	Utils.reset_crnt.connect(reset)

	var all_land = tilemap.get_used_cells(1)

	for cell in all_land:
		for offset in offsets:
			var check = cell + offset
			if tilemap.get_cell_source_id(1, check) == -1:
				no_overlap.append(cell)

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

	if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		if tilepos != null and is_select_item:
			crnt_pointer.position = tilepos * 16

	if is_select_item:
		if get_viewport().gui_get_hovered_control() != null:
			crnt_pointer.visible = false
		else:
			crnt_pointer.visible = true
			if crnt_item.is_terrain:
				if check_valid_path(tilepos, crnt_item.size):
					if crnt_pointer == pointer_big:
						for i in range(pointer_big.get_child_count()):
							var child = pointer_big.get_child(i)
							child.region_rect = ori_region_rect[i]
					else:
						crnt_pointer.region_rect = ori_region_rect[0]
				else:
					if crnt_pointer == pointer_big:
						for i in range(pointer_big.get_child_count()):
							var child = pointer_big.get_child(i)
							child.region_rect.position.x = ori_region_rect[i].position.x + 32
					else:
						crnt_pointer.region_rect.position.x = ori_region_rect[0].position.x + 32
			else:
				if check_valid_itemplace(tilepos, crnt_item.size):
					if crnt_pointer == pointer_big:
						for i in range(pointer_big.get_child_count()):
							var child = pointer_big.get_child(i)
							child.region_rect = ori_region_rect[i]
					else:
						crnt_pointer.region_rect = ori_region_rect[0]
				else:
					if crnt_pointer == pointer_big:
						for i in range(pointer_big.get_child_count()):
							var child = pointer_big.get_child(i)
							child.region_rect.position.x = ori_region_rect[i].position.x + 32
					else:
						crnt_pointer.region_rect.position.x = ori_region_rect[0].position.x + 32

func reset():
	is_select_item = false
	crnt_item = null
	crnt_tile = null

func change_item(data: ItemData):
	print(data.name)
	is_select_item = true
	crnt_item = data
	crnt_tile = data.item_tile
	reset_big_pointer()

	pointer1.visible = false
	pointer2_h.visible = false
	pointer2_v.visible = false
	pointer_big.visible = false

	if ori_region_rect != null and crnt_pointer != null:
		if crnt_pointer == pointer_big:
			for i in range(pointer_big.get_child_count()):
				var child = pointer_big.get_child(i)
				child.region_rect.position.x = ori_region_rect[i].position.x
		else:
			crnt_pointer.region_rect.position.x = ori_region_rect[0].position.x
	
	if data.size == Vector2i(1, 1):
		crnt_pointer = pointer1
	elif data.size == Vector2i(2, 1):
		crnt_pointer = pointer2_h
	elif data.size == Vector2i(1, 2):
		crnt_pointer = pointer2_v
	else:
		crnt_pointer = pointer_big
		draw_big_pointer(data.size)

	ori_region_rect = []
	if crnt_pointer == pointer_big:
		for i in pointer_big.get_children():
			ori_region_rect.append(i.region_rect)
	else:
		ori_region_rect = [crnt_pointer.region_rect]

func draw_big_pointer(size: Vector2i):
	pointer_big.get_node("nt_br").position.x += size.x * 16 - 16
	pointer_big.get_node("nt_tl").position.y -= size.y * 16 - 16
	pointer_big.get_node("nt_tr").position.x += size.x * 16 - 16
	pointer_big.get_node("nt_tr").position.y -= size.y * 16 - 16

func reset_big_pointer():
	for child in pointer_big.get_children():
		child.position = Vector2(0, 16)

func check_neighbors(cell, layer, off) -> bool:
	for offset in off:
		var check = cell + offset
		if tilemap.get_cell_source_id(layer, check) != -1:
			return true
	return false

func check_air(cell, layer, off) -> bool:
	for offset in off:
		var check = cell + offset
		if tilemap.get_cell_source_id(layer, check) == -1:
			return true
	return false

var offsets2 = [
	Vector2i(0, 1),
	Vector2i(1, 0),
	Vector2i(0, -1),
	Vector2i(-1, 0),
]

func check_valid_itemplace(tpos, size: Vector2i) -> bool:
	var arr = []
	for x in range(size.x):
		for y in range(size.y):
			arr.append(tpos + Vector2i(x, -y))

	for i in arr:
		#if check_neighbors(i, 3, offsets2):
			#print("neighbor", i)
			#return false
		if no_overlap.has(i):
			#print("overlap", i)
			return false
		elif check_air(i, 1, offsets2):
			#print("air", i)
			return false
		elif no_place.has(i):
			#print("no place", i)
			return false
	return true

func check_valid_path(tpos, size: Vector2i) -> bool:
	var arr = []
	for x in range(size.x):
		for y in range(size.y):
			arr.append(tpos + Vector2i(x, -y))

	for i in arr:
		if check_air(i, 1, offsets2):
			return false
		elif no_overlap.has(i):
			return false
	return true

func build():
	if is_select_item:
		if crnt_item.is_terrain and check_valid_path(tilepos, crnt_item.size):
			if crnt_item.is_delete:
				tilemap.set_cells_terrain_connect(2, [tilepos], 0, -1, false)
			else:
				tilemap.set_cells_terrain_connect(2, [tilepos], crnt_item.terrain_set, crnt_item.terrain, false)
		elif not crnt_item.is_terrain and check_valid_itemplace(tilepos, crnt_item.size):
			for x in range(crnt_item.size.x):
				for y in range(crnt_item.size.y):
					no_place.append(tilepos + Vector2i(x, -y))
			tilemap.set_cell(3, tilepos, 0, crnt_tile)
