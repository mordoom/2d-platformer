class_name GdUnitExampleTest
extends GdUnitTestSuite

var skeleton_scene = preload("res://enemies/skeleton/skeleton2.tscn")

func test_player():
    var runner = scene_runner("res://test/TestScene.tscn")
    await await_millis(1000)
    await simulate_input_press("jump", 300)
    await simulate_input_press("jump", 300)
    await simulate_input_press("right", 1500)
    await simulate_input_press("attack", 200)
    await simulate_input_press("attack", 200)
    simulate_input_press("attack", 200)

    # the player should have killed the first skeleton
    var skeleton = runner.invoke("find_child", "Skeleton")
    await assert_signal(SignalBus).wait_until(2000).is_emitted("character_died", [skeleton])
    await await_millis(1000)

    var new_skeleton = skeleton_scene.instantiate()
    runner.invoke("add_child", new_skeleton)
    var player = runner.invoke("find_child", "Player")
    new_skeleton.global_position = player.global_position
    new_skeleton.position.x -= 100

    # wait until the new skeleton kills the player
    await assert_signal(SignalBus).wait_until(5000).is_emitted("character_died", [player])
    await assert_signal(SignalBus).wait_until(1000).is_emitted("game_over")

    
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