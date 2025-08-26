class_name SkeletonTest
extends GdUnitTestSuite

var skeleton_scene = References.skeleton_scene
var player_scene = References.player_scene

func test_skeleton_state_transitions():
	var runner = scene_runner("res://test/TestScene.tscn")
	
	# Instantiate skeleton on the platform
	var skeleton = skeleton_scene.instantiate()
	runner.invoke("add_child", skeleton)
	skeleton.global_position = Vector2(400, 300)
	
	await await_millis(100)
	
	var state_machine = skeleton.get_node("CharacterStateMachine")
	
	# Initially skeleton should be in patrol state
	assert_str(state_machine.current_state.name.to_lower()).is_equal("patrol")
	
	# Add player to trigger pursue state
	var player = player_scene.instantiate()
	runner.invoke("add_child", player)
	player.global_position = Vector2(550, 300)
	
	# Give the skeleton some time to detect the player and switch to pursue
	await await_millis(500)
	
	# Skeleton should now be in pursue state
	assert_str(state_machine.current_state.name.to_lower()).is_equal("pursue")
	
	# Wait to trigger attack state
	await await_millis(700)
	assert_str(state_machine.current_state.name.to_lower()).is_equal("attack")
	
	# Move player far away to trigger patrol state again
	player.global_position = Vector2(-1000, 300)
	await await_millis(1500)
	
	assert_str(state_machine.current_state.name.to_lower()).is_equal("patrol")

func test_skeleton_kills_player():
	var runner = scene_runner("res://test/TestScene.tscn")
	
	# Instantiate skeleton and player
	var skeleton = skeleton_scene.instantiate()
	runner.invoke("add_child", skeleton)
	skeleton.global_position = Vector2(400, 300)
	
	var player = player_scene.instantiate()
	runner.invoke("add_child", player)
	player.global_position = Vector2(360, 300)
	
	await await_millis(1000)
	
	# Wait for skeleton to attack and kill player
	await assert_signal(SignalBus).wait_until(5000).is_emitted("character_died", [player])
