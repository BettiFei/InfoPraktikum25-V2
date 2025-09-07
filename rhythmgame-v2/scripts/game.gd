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
	$Conductor.play_with_beat_offset(8)
	#$Conductor.play_from_beat(269, 8)
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
	if song_position_in_beats > 36: #verse 1
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 67: #bridge 1
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 100: #refrain 1, part 1
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 132: #refrain 1, part 2
		spawn_1_beat = 2
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 165: #verse 2
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 195: #bridge 2
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 229: #refrain 2, part 1
		spawn_1_beat = 2
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 260: #refrain 2, part 2
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 293: #bridge 3
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 324: #refrain 3, part 1
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 354: #refrain 3, part 2
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 2
	if song_position_in_beats > 388: #outro
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 397: #song over
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
		
	# saving scores for end of game overview:
	if song_position_in_beats > 400:
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
	$Control/ScoreLabel.text = str(score)
	if combo > 0:
		$Control/ComboLabel.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Control/ComboLabel.text = ""

func reset_combo():
	combo = 0
	$Control/ComboLabel.text = ""
