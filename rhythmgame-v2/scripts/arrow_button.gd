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
				elif good:
					get_parent().increment_score(2)
					current_note.destroy(2)
				elif okay:
					get_parent().increment_score(1)
					current_note.destroy(1)
				_reset()
			else:
				get_parent().increment_score(0)
		
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

func _on_perfect_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = false


# good area:
func _on_good_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = true

func _on_good_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = false


# okay area:
func _on_okay_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = true

func _on_okay_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = false


# -- RESET --

func _on_push_timer_timeout() -> void:
	frame -= 1

func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false
