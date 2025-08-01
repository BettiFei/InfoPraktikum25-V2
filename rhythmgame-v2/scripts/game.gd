extends Node2D

# variables for tracking score & combo:
var score = 0
var combo = 0

var max_combo = 0
var perfect = 0
var good = 0
var okay = 0
var missed = 0

# BPM Variable wieso? gibt es schon im Conductor als Export?
var bpm = 115

# variables for tracking song position:
var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

# how many notes are spawned on which beat per measure:
var spawn_1_beat = 0
var spawn_2_beat = 0
var spawn_3_beat = 1
var spawn_4_beat = 0

# variables for spawning notes:
var lane = 0
var rand = 0
var note = load("res://scenes/note.tscn")
var instance

func _ready() -> void:
	#print("height: ", get_viewport_rect().end.x)
	#print("width: ", get_viewport_rect().end.y)
	randomize()
	#$Conductor.play_with_beat_offset(8)
	$Conductor.play_from_beat(350, 8)
	Globals.beat.connect(_on_Conductor_beat)
	Globals.measure.connect(_on_Conductor_measure)


func _input(event):
	if event.is_action("escape"):
		if get_tree().change_scene_to_file("res://scenes/menu.tscn") != OK:
			print("error changing scene to menu")


func _on_Conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)


func _on_Conductor_beat(position):
	song_position_in_beats = position
	
	# changing note spawn behaviour according to beat:
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	
	# song over, don't spawn any new notes:
	if song_position_in_beats > 364:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
		
	# saving scores for end of game overview:
	if song_position_in_beats > 371:
		Globals.set_score(score)
		Globals.combo = max_combo
		Globals.perfect = perfect
		Globals.good = good
		Globals.okay = okay
		Globals.missed = missed
		if get_tree().change_scene_to_file("res://scenes/end.tscn") != OK:
			print("error changing scene to end")


func _spawn_notes(to_spawn):
	if to_spawn > 0:
		lane = randi() % 3
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		instance = note.instantiate()
		instance.initialize(lane)
		add_child(instance)


func increment_score(by):
	# by wird von ArrowButton übergeben, je nachdem welche Area (perfect/good/okay) getroffen wurde
	if by > 0:
		combo += 1
	else:
		combo = 0
		
	if by == 3:
		perfect += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
		
	score += by * combo
	$ScoreLabel.text = str(score)
	if combo > 0:
		$ComboLabel.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$ComboLabel.text = ""

func reset_combo():
	combo = 0
	$ComboLabel.text = ""
