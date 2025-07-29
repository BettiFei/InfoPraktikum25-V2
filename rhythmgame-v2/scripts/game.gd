extends Node2D

var score = 0
var combo = 0

var max_combo = 0
var perfect = 0
var good = 0
var okay = 0
var missed = 0

#func _ready() -> void:
	#print("height: ", get_viewport_rect().end.x)
	#print("width: ", get_viewport_rect().end.y)

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
