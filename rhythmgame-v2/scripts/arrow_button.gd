extends AnimatedSprite2D

var perfect = false
var good = false
var okay = false
var current_note = null

@export var input = ""


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(input):
		if event.is_action_pressed(input, false):
			if current_note != null:
				if perfect:
					get_parent().increment_score(3)
					current_note.destroy(3)
					#print("input detected, perfect")
				elif good:
					get_parent().increment_score(2)
					current_note.destroy(2)
					#print("input detected, good")
				elif okay:
					get_parent().increment_score(1)
					current_note.destroy(1)
					#print("input detected, okay")
				_reset()
			else:
				get_parent().increment_score(0)
				#print("no input detected, miss")
		
		# changing animation frame to light up:
		if event.is_action_pressed(input):
			frame += 1
		elif event.is_action_released(input):
			$PushTimer.start()


# -- SETTING PROOF VARIABLE DEPENDING ON LOCATION OF FALLING NOTE --

# perfect area:
func _on_perfect_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = true
		#print("note entered perfect area -> perfect = " + str(perfect))

func _on_perfect_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = false
		#print("note exited perfect area -> perfect = " + str(perfect))


# good area:
func _on_good_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = true
		#print("note entered good area -> good = " + str(good))

func _on_good_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = false
		#print("note exited good area -> good = " + str(good))


# okay area:
func _on_okay_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = true
		current_note = area
		#print("note entered okay area -> okay = " + str(okay))

func _on_okay_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = false
		current_note = null
		#print("note exited okay area -> okay = " + str(okay))


# -- RESET --

func _on_push_timer_timeout() -> void:
	frame -= 1

func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false
