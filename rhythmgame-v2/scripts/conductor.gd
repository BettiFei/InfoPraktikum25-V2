extends AudioStreamPlayer

# song-specific variables (change for each song):
@export var bpm := 100
@export var measures := 4

# tracking the beat and song position:
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure = 1

# determining how close to the beat an event is:
var closest = 0
var time_off_beat = 0.0

func _ready() -> void:
	sec_per_beat = 60.0 / bpm

func _physics_process(delta: float) -> void:
	# calculating exact song position, accounting for latency and sound hardware vs. system clock drifting apart:
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
		report_beat()
	
	#print(closest_beat(1.0))

func report_beat():
	# reporting most recent beat and measure that were passed:
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		Globals.beat.emit(song_position_in_beats)
		Globals.measure.emit(measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	# granting game time to spawn notes before music starts:
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

func play_from_beat (beat, offset):
	# for convenience; start game from any beat, e.g., for level design:
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset
	measure = beat % measures

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func _on_start_timer_timeout() -> void:
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		# calculating delay until AudioStreamPlayer is able to start playing:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	report_beat()
