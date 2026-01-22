extends Node

signal item_selected(data)
signal reset_crnt()
signal tent_selected(tent_index)
signal payout()
signal update_coins(list_coins)

# modes: main, build, manage
var mode = "main"
var tent_data = []

var tenti = 0

var crnt_day = "day"
var coins = 100

var names = ["Aaron", "Bella", "Carlos", "Diana", "Ethan", "Frank", "George", "Hannah", "Ivan", "Jessica", "Kenny", "Liam", "Mohammed", "Nick", "Olivia", "Peter", "Quinn", "Rowley", "Samantha", "Thomas", "Vanessa", "William", "Xavier", "Yong Xiang", "Zoe", "Mia", "Maya", "Emily", "Sarah", "Sofia", "Amber", "James", "Lily", "Muskan", "Roshni", "Shiva", "Milo"]
var jobs = ["doctor", "scientist", "lawyer", "artist", "programmer", "athelete", "teacher", "nurse", "racer", "researcher", "baker", "chef", "singer", "cashier", "swimmer", "art teacher", "sailor", "therapist", "bodyguard", "embalmer", "police", "idol", "street dancer", "radio host", "cleaner"]
var origin = ["Sunland", "Funnicity", "Mystic Falls", "Rangoat", "Fungus Land", "the Mainland", "Tinland", "Mars", "Atlantis", "Karthumis", "MolXity", "Quandora", "Lunar Mountains"]
var story = ["They ran away from their home and ran to the nearest gas station. It exploded as well but they ran and sailed to this island", "They escaped from their workplace and hopped on the nearest boat, ending up here", "Their city was destroyed by the meteor and they swam here, apparently", "There was a scary looking creature that offered them a kayak. They came here, somehow", "They went to the nearest convenience store, stole a boat, and came to this island", "They ate only beans for 3 days and somehow sailed to this island", "Their manager fired them right before the meteor came, and right as the meteor knocked down the building, they came out of it unharmed", "They somehow found the cure for cancer but the meteor took it", "They saw an alien and knocked it out It let out a scary scream and they ran away here", "They have been on a cruise. Said cruise was destroyed and they floated here", "They held on to their room door as the tsunami brought them here"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Utils.payout.connect(pay_coins)

func pay_coins() -> void:
	var tent_coins: int
	var list_coins: Array = []
	for tent in tent_data:
		tent_coins += tent.price
		list_coins.append("+" + str(tent.price))

	coins += tent_coins
	emit_signal("update_coins", list_coins)

func random_name() -> String:
	return names[randi() % names.size()]

func generate_story() -> Array[String]:
	var job = jobs[randi() % jobs.size()]
	var origin = origin[randi() % origin.size()]
	var story = story[randi() % story.size()]
	return [job, origin, story]

func get_tent_index() -> int:
	tenti += 1
	return tenti