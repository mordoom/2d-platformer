class_name GdUnitExampleTest
extends GdUnitTestSuite

var skeleton_scene = preload("res://enemies/skeleton/skeleton2.tscn")

func test_player():
	var runner = scene_runner("res://Main.tscn")
	await await_millis(1000)
	await simulate_input_press("right", 1300)
	await simulate_input_press("up", 500)
	await simulate_input_press("down", 1000)
	await await_millis(1000)

	#jump over the gap	
	await simulate_input_press("right", 800)
	simulate_input_press("right", 1700)
	await simulate_input_press("jump", 200)
	await simulate_input_press("jump", 1000)

	await simulate_input_press("right", 500)
	await simulate_input_press("right", 300)
	await simulate_input_press("attack", 200)
	await simulate_input_press("attack", 200)
	simulate_input_press("attack", 200)

	# the player should have killed the first skeleton
	var tree = runner.invoke("get_tree_string")
	var skeleton = runner.invoke("get_node", "StartingArea/Skeleton")
	assert(skeleton != null)
	await assert_signal(SignalBus).wait_until(2000).is_emitted("character_died", [skeleton])

	# run to the next scene
	await simulate_input_press("right", 3000)
	
	# run to previous scene
	await simulate_input_press("left", 2000)
	
	# and then to next scene again
	await simulate_input_press("right", 2000)

	# wait until the next scene's skeleton kills the player
	var player = runner.invoke("find_child", "Player")
	await assert_signal(SignalBus).wait_until(10000).is_emitted("character_died", [player])
	await assert_signal(SignalBus).wait_until(1000).is_emitted("game_over")

func spawn_skeleton(player, runner):
	var new_skeleton = skeleton_scene.instantiate()
	runner.invoke("add_child", new_skeleton)
	new_skeleton.global_position = player.global_position
	new_skeleton.position.x -= 100

func simulate_input_press(action_name: String, duration: int):
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = true
	Input.parse_input_event(event)

	await await_millis(duration)
	simulate_input_release(action_name)

func simulate_input_release(action_name: String):
	var event = InputEventAction.new()
	event.action = action_name
	event.pressed = false
	Input.parse_input_event(event)
