extends Node

signal item_selected(data)
signal reset_crnt()

# modes: main, build, manage
var mode = "main"
var tent_data = []

var tenti = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tent_index() -> int:
	tenti += 1
	return tenti