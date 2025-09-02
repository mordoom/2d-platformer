extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"

class_name GameManager

@onready var hud = $HUD
@onready var player_ref = $Player

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")

var player_scene = References.player_scene
var player_initial_position = GameConstants.PLAYER_INITIAL_POSITION
var death_timer: Timer

var camera: Camera2D

var initial_level: PackedScene = References.initial_level
var starting_map = initial_level.resource_path
var current_level: Node

const cell_size = GameConstants.CELL_SIZE
const starting_offset = GameConstants.STARTING_OFFSET

const SAVE_PATH = "user://example_save_data.sav"
var custom_run: bool

func _ready() -> void:
    init()

    SignalBus.connect("character_died", on_character_died_handler)
    SignalBus.connect("on_campfire_rested", on_campfire_rested_handler)
    SignalBus.connect("on_bottle_rum_collected", on_bottle_rum_collected)

func init():
    MetSys.reset_state()
    set_player(player_ref)


    if FileAccess.file_exists(SAVE_PATH):
        # If save data exists, load it using MetSys SaveManager.
        var save_manager := SaveManager.new()
        save_manager.load_from_text(SAVE_PATH)

        # Assign loaded values.
        # collectibles = save_manager.get_value("collectible_count")
        # generated_rooms.assign(save_manager.get_value("generated_rooms"))
        # events.assign(save_manager.get_value("events"))
        # player.abilities.assign(save_manager.get_value("abilities"))
        GameState.rum_bottles.assign(save_manager.get_value("rum_bottles"))
        player.rum_bottles = GameState.rum_bottles.size()
        player.max_rum_bottles = GameState.rum_bottles.size()
        if GameState.perma_dead_enemies.is_empty():
            var loaded_dead_enemies = save_manager.get_value("dead_enemies")
            GameState.perma_dead_enemies.assign(loaded_dead_enemies if loaded_dead_enemies else [])
        
        if not custom_run:
            var loaded_starting_map: String = save_manager.get_value("current_room")
            if not loaded_starting_map.is_empty(): # Some compatibility problem.
                starting_map = loaded_starting_map
    else:
        # If no data exists, set empty one.
        MetSys.set_save_data()
    
    hud.init()

    # Initialize room when it changes.
    room_loaded.connect(init_room, CONNECT_DEFERRED)
    # Load the starting room.
    load_room(starting_map)

    var start := map.get_node_or_null(^"SavePoint")
    if start and not custom_run:
        player.position = start.position
    
    # Add module for room transitions.
    add_module("RoomTransitions.gd")
    # You can enable alternate transition effect by using this module instead.
    # add_module("ScrollingRoomTransitions.gd")
    
    # Reset position tracking (feature specific to this project).
    await get_tree().physics_frame
    reset_map_starting_coords.call_deferred()
    
    # Make sure minimap is at correct position (required for themes to work correctly).
    %Minimap.set_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_MINSIZE, 8)

func init_room():
    MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
    player.on_enter()
    
    # Initializes MetSys.get_current_coords(), so you can use it from the beginning.
    if MetSys.last_player_position.x == Vector2i.MAX.x:
        MetSys.set_player_position(player.position)

func reset_map_starting_coords():
    # $UI/MapWindow.reset_starting_coords()
    pass

func on_character_died_handler(character: Node):
    if character.is_in_group("Player"):
        SignalBus.emit_signal("game_over")
        start_death_timer()
        GameState.reset_enemies()
    else:
        GameState.add_dead_enemy(character)

func start_death_timer():
    death_timer = Timer.new()
    death_timer.wait_time = GameConstants.DEATH_TIME
    death_timer.one_shot = true
    death_timer.timeout.connect(reload)
    add_child(death_timer)
    death_timer.start()

func reload() -> void:
    get_tree().reload_current_scene()

func _physics_process(_delta: float) -> void:
    pass

func on_campfire_rested_handler(_area: Area2D):
    # Make Game save the data.
    save_game()
    # Starting coords for the delta vector feature.
    reset_map_starting_coords()
    player.set_health(GameConstants.DEFAULT_HEALTH)
    player.rum_bottles = player.max_rum_bottles
    GameState.reset_enemies()

func on_bottle_rum_collected(area: Area2D):
    player.add_rum_bottle()
    GameState.rum_bottle_collected(area)

func save_game():
    var save_manager := SaveManager.new()
    # save_manager.set_value("collectible_count", collectibles)
    # save_manager.set_value("generated_rooms", generated_rooms)
    # save_manager.set_value("events", events)
    # save_manager.set_value("abilities", player.abilities)
    save_manager.set_value("rum_bottles", GameState.rum_bottles)
    save_manager.set_value("dead_enemies", GameState.perma_dead_enemies)
    save_manager.set_value("current_room", MetSys.get_current_room_name())
    save_manager.save_as_text(SAVE_PATH)
