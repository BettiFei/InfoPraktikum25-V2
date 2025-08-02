extends Node2D


func _on_start_button_down() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($VolumeSlider.value))
	if get_tree().change_scene_to_file("res://scenes/game.tscn") != OK:
		print("error changing scene to game")


func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_test_button_pressed() -> void:
	$TestButton/AudioStreamPlayer.play()
	$TestButton/GPUParticles2D.emitting = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
