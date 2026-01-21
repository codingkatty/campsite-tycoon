extends Node2D

@onready var npc_node = preload("res://assets/npc.tscn")
@onready var main_gui = get_parent().get_node("map/player/main-gui")

var npc_queue = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_npcspawn_timer_timeout() -> void:
	if not npc_queue.size() < 2:
		return
	
	var tent_data = Utils.tent_data
	for tent in tent_data:
		if not tent.occupied and npc_queue.size() < find_max_occupied():
			var npc = npc_node.instantiate()
			if npc_queue.size() == 0:
				npc.position = Vector2(59, -2)
				npc.place_in_queue = 1
			elif npc_queue.size() == 1:
				npc.position = Vector2(79, -2)
				npc.place_in_queue = 2
			get_parent().get_node("map").add_child(npc)
			main_gui.new_npc()
			npc_queue.append(npc)
			break

func find_max_occupied():
	var tent_data = Utils.tent_data
	var max_o = 0
	for tent in tent_data:
		if not tent.occupied:
			# or tent.max
			max_o += 1

	return max_o

func npc_leave(tent_index):
	print("npc leave que")
	npc_queue[0].place_in_queue = 0
	npc_queue.pop_front()
	print(npc_queue)
	for tent in Utils.tent_data:
		if tent.index == tent_index:
			tent.occupied = true
			# do something about occupants
			break

	if npc_queue.size() > 0:
		npc_queue[0].place_in_queue = 1
		npc_queue[0].moving_to_first = true

func npc_denied():
	print("npc denied que")
	npc_queue[0].queue_free()
	npc_queue.pop_front()

	if npc_queue.size() > 0:
		npc_queue[0].place_in_queue = 1
		npc_queue[0].moving_to_first = true

func get_unoccupied_tent_list():
	var unoccupied_tents = []
	#print("tent data" + str(Utils.tent_data))
	for tent in Utils.tent_data:
		if not tent.occupied:
			unoccupied_tents.append(tent)
	#print(unoccupied_tents)
	return unoccupied_tents

func get_tent_position(tent_index) -> Vector2:
	for tent in Utils.tent_data:
		if tent.index == tent_index:
			return tent.position
	return Vector2.ZERO

#test only
func first_unoccupied_tent_pos():
	var tent_data = Utils.tent_data
	for tent in tent_data:
		if not tent.occupied:
			return tent.position
	return Vector2.ZERO

func first_unoccupied_tent_index():
	var tent_data = Utils.tent_data
	for tent in tent_data:
		if not tent.occupied:
			return tent.index
	return -1
