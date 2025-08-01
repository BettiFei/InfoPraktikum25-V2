extends Node2D


func _ready() -> void:
	$Control/ScoreNumber.text = str(Globals.score)
	$Control/GradeNumber.text = Globals.grade
	$Control/ComboNumber.text = str(Globals.combo)
	$Control/PerfectNumber.text = str(Globals.perfect)
	$Control/GoodNumber.text = str(Globals.good)
	$Control/OkayNumber.text = str(Globals.okay)
	$Control/MissedNumber.text = str(Globals.missed)


func _on_replay_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://scenes/game.tscn") != OK:
		print("error restarting the game")


func _on_menu_button_pressed() -> void:
	if get_tree().change_scene_to_file("res://scenes/menu.tscn") != OK:
		print("error exiting to menu")
