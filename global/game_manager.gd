extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"

class_name GameManager

@onready var hud: CanvasLayer = $HUD
@onready var player_ref: CharacterBody2D = $Player
@onready var camera: Camera2D = $Player/Camera2D

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")

var player_scene: PackedScene = References.player_scene
var player_initial_position: Vector2 = GameConstants.PLAYER_INITIAL_POSITION
var death_timer: Timer

var initial_level: PackedScene = References.initial_level
var starting_map: String = initial_level.resource_path
var current_level: Node

const cell_size: int = GameConstants.CELL_SIZE
const starting_offset: int = GameConstants.STARTING_OFFSET

const SAVE_PATH: String = "user://example_save_data.sav"
var custom_run: bool

func _ready() -> void:
    init()

    SignalBus.connect("character_died", on_character_died_handler)
    SignalBus.connect("on_campfire_rested", on_campfire_rested_handler)
    SignalBus.connect("on_bottle_rum_collected", on_bottle_rum_collected)
    SignalBus.connect("on_pistol_collected", on_pistol_collected)
    SignalBus.connect("on_health_changed", on_health_changed)

func init() -> void:
    MetSys.reset_state()
    set_player(player_ref)


    if FileAccess.file_exists(SAVE_PATH):
        load_game(SAVE_PATH)
    else:
        # If no data exists, set empty one.
        MetSys.set_save_data()
        save_game()
    
    hud.init()

    # Initialize room when it changes.
    room_loaded.connect(init_room, CONNECT_DEFERRED)
    # Load the starting room.
    load_room(starting_map)

    var start: Node = map.get_node_or_null(^"SavePoint")
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
    # %Minimap.set_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_MINSIZE, 8)

func load_game(path: String) -> void:
    var save_manager: SaveManager = SaveManager.new()
    save_manager.load_from_text(path)

    GameState.items.assign(save_manager.get_value("items"))
    var max_rum_bottles = save_manager.get_value("max_rum_bottles")
    player.rum_bottles = max_rum_bottles
    player.max_rum_bottles = max_rum_bottles
    player.money = save_manager.get_value("money", 0)

    var max_ammo = save_manager.get_value("max_ammo")
    player.ammo = max_ammo
    player.max_ammo = max_ammo

    if GameState.perma_dead_enemies.is_empty():
        var loaded_dead_enemies: Array = save_manager.get_value("dead_enemies")
        GameState.perma_dead_enemies.assign(loaded_dead_enemies if loaded_dead_enemies else [])
    
    if not custom_run:
        var loaded_starting_map: String = save_manager.get_value("current_room")
        if not loaded_starting_map.is_empty(): # Some compatibility problem.
            starting_map = loaded_starting_map


func init_room() -> void:
    MetSys.get_current_room_instance().adjust_camera_limits(camera)
    player.on_enter()
    
    # Initializes MetSys.get_current_coords(), so you can use it from the beginning.
    if MetSys.last_player_position.x == Vector2i.MAX.x:
        MetSys.set_player_position(player.position)
    
    if GameState.dead_body:
        if GameState.dead_body.scene == MetSys.get_current_room_name():
            GameState.create_body()

func reset_map_starting_coords() -> void:
    # $UI/MapWindow.reset_starting_coords()
    pass

func on_character_died_handler(character: Node2D) -> void:
    if character.is_in_group("Player"):
        SignalBus.emit_signal("game_over")
        start_death_timer()
        GameState.store_dead_body(player)
        player.money = 0
        GameState.reset_enemies()
        update_save()
    elif character is Enemy:
        if character.perma_death:
            GameState.add_perma_dead_enemy(character)
            update_save()
        else:
            GameState.add_dead_enemy(character)

func start_death_timer() -> void:
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

func on_campfire_rested_handler(_area: Area2D) -> void:
    save_game()
    # Starting coords for the delta vector feature.
    reset_map_starting_coords()
    player.set_health(player.health_component.max_health)
    player.rum_bottles = player.max_rum_bottles
    player.ammo = player.max_ammo
    GameState.reset_enemies()

func on_bottle_rum_collected(area: Area2D, _amount: int) -> void:
    player.add_rum_bottle()
    GameState.item_collected(area)
    update_save()

func on_pistol_collected(area: Area2D, _amount: int) -> void:
    player.add_ammo()
    GameState.item_collected(area)
    update_save()

func on_health_changed(_node: Node, amount: int) -> void:
    if (amount < 0):
        camera.get_node("ShakerComponent2D").play_shake()

func update_save() -> void:
    var save_manager: SaveManager = SaveManager.new()
    save_manager.load_from_text(SAVE_PATH)
    save_manager.set_value("money", player.money)
    save_manager.set_value("dead_body", GameState.dead_body)
    save_manager.set_value("items", GameState.items)
    save_manager.set_value("dead_enemies", GameState.perma_dead_enemies)
    save_manager.set_value("max_ammo", player.max_ammo)
    save_manager.set_value("max_rum_bottles", player.max_rum_bottles)
    save_manager.save_as_text(SAVE_PATH)


func save_game() -> void:
    var save_manager: SaveManager = SaveManager.new()
    save_manager.set_value("money", player.money)
    save_manager.set_value("items", GameState.items)
    save_manager.set_value("dead_enemies", GameState.perma_dead_enemies)
    save_manager.set_value("current_room", MetSys.get_current_room_name())
    save_manager.set_value("dead_body", GameState.dead_body)
    save_manager.set_value("max_ammo", player.max_ammo)
    save_manager.set_value("max_rum_bottles", player.max_rum_bottles)
    save_manager.save_as_text(SAVE_PATH)
