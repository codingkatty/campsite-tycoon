extends RichTextLabel

@onready var parent_container = get_parent().get_parent()
@onready var effect = preload("res://assets/cash-effect.tscn")

func _ready() -> void:
	Utils.update_coins.connect(refresh_coins)
	refresh_coins()

func refresh_coins(list_coins = []) -> void:
	text = str(Utils.coins)
	if get_node("%coin") != null:
		for i in list_coins:
			get_node("%coin").spawn_coin_effect(i)
			await get_tree().create_timer(0.05).timeout

func spawn_coin_effect(effect_text) -> void:
	var new_effect = effect.instantiate()
	new_effect.position += Vector2(randi_range(-10, 10), randi_range(-10, 10))
	new_effect.get_node("text").text = effect_text
	parent_container.add_child(new_effect)
