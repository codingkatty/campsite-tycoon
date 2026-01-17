extends CharacterBody2D

@onready var agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D
var SPEED =  20
var targ: Vector2
var place_in_queue = 0
var moving_to_first = false

func _ready():
	pass

func _process(delta):
	if position.distance_to(Vector2(59, -2)) < 0.5:
		play_anim("idle")
		position = Vector2(59, -2)
		moving_to_first = false

	if moving_to_first:
		play_anim("side_walk")
		sprite.flip_h = true
		position = position.move_toward(Vector2(59, -2), delta * SPEED)
		return
	
	if position.distance_to(targ) > 0.5 and not moving_to_first:
		var curLoc = global_transform.origin
		var nextLoc = agent.get_next_path_position()
		var newVel = (nextLoc - curLoc).normalized() * SPEED
		velocity = newVel
		move_and_slide()
		var next_pos = agent.get_next_path_position()
		var direction = (next_pos - position).normalized()
		
		if direction.x < 0:
			play_anim("side_walk")
			sprite.flip_h = true
		elif direction.x > 0:
			play_anim("side_walk")
			sprite.flip_h = false
		elif direction.y < 0:
			play_anim("back_walk")
		elif direction.y > 0:
			play_anim("front_walk")
	else:
		play_anim("idle")
		sprite.flip_h = false

func updateTargetPosition(target):
	targ = target
	agent.set_target_position(target)

func play_anim(anim):
	if sprite.animation != anim:
		sprite.play(anim)
