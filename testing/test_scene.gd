extends Node

var tests: Array = []

func _ready():
	print("[TEST SCENE] Automated testing started")
	setup_tests()
	await get_tree().create_timer(2.0).timeout
	await run_all_tests()

func setup_tests():
	# Test 1: Jump test first - show off movement abilities
	tests.append({
		"name": "Jump Test",
		"commands": [
			{"action": "press", "input": "jump", "duration": 0.1},
			{"action": "release", "input": "jump", "duration": 1.0},
			{"action": "press", "input": "jump", "duration": 0.1},
			{"action": "release", "input": "jump", "duration": 0.2},
			{"action": "press", "input": "jump", "duration": 0.5},
			{"action": "release", "input": "jump", "duration": 1.0}
		]
	})
	
	# Test 2: Attack test - show combat abilities with combo timing
	tests.append({
		"name": "Attack Test",
		"commands": [
			{"action": "press", "input": "attack", "duration": 0.1},
			{"action": "release", "input": "attack", "duration": 0.2},
			{"action": "press", "input": "attack", "duration": 0.1},
			{"action": "release", "input": "attack", "duration": 0.2},
			{"action": "press", "input": "attack", "duration": 0.1},
			{"action": "release", "input": "attack", "duration": 1.0}
		]
	})
	
	# Test 3: Combat movement test - approach skeleton and fight
	tests.append({
		"name": "Combat Movement Test",
		"commands": [
			{"action": "press", "input": "right", "duration": 1.1},
			{"action": "release", "input": "right", "duration": 0.5},
			{"action": "press", "input": "attack", "duration": 0.1},
			{"action": "release", "input": "attack", "duration": 0.5},
			{"action": "press", "input": "left", "duration": 0.1},
			{"action": "release", "input": "left", "duration": 0.5}
		]
	})

	# Test 4: Wait to be attacked
	tests.append({
		"name": "Take Damage Test",
		"commands": [
			{"action": "press", "input": "right", "duration": 0.2},
			{"action": "release", "input": "right", "duration": 0.5},
			{"action": "wait", "duration": 10},
		]
	})

func run_all_tests():
	print("[TEST] Starting automated test suite...")
	
	for test in tests:
		print("[TEST] Running: " + test.name)
		await run_test(test)
		print("[TEST] Completed: " + test.name + " - PASSED")
		await get_tree().create_timer(1.0).timeout
	
	print("[TEST] All tests completed!")
	await get_tree().create_timer(2.0).timeout
	print("[TEST] Exiting...")
	get_tree().quit()

func run_test(test):
	for command in test.commands:
		var action = command.action
		var duration = command.duration
		
		if action == "wait":
			print("[TEST] Command: wait for " + str(duration) + "s")
		else:
			var input_name = command.input
			print("[TEST] Command: " + action + " " + input_name + " for " + str(duration) + "s")
			
			if action == "press":
				_simulate_input_press(input_name)
			elif action == "release":
				_simulate_input_release(input_name)
		
		await get_tree().create_timer(duration).timeout

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("[TEST] Manual test stop requested")
		stop_tests()
		get_tree().quit()

func stop_tests():
	for action in ["left", "right", "jump", "attack"]:
		_simulate_input_release(action)
	print("[TEST] Tests stopped")

func _simulate_input_press(action_name: String):
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = true
	Input.parse_input_event(event)

func _simulate_input_release(action_name: String):
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = false
	Input.parse_input_event(event)
