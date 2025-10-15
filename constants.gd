extends Node

class_name GameConstants

# Player Constants
const PLAYER_SPEED: float = 300.0
const PLAYER_INITIAL_POSITION: Vector2 = Vector2(80, 200)
const PLAYER_GRAVITY_MULT: float = 1.4
const LADDER_SPEED: float = 150.0
const JUMP_VELOCITY: float = -500.0
const DOUBLE_JUMP_VELOCITY: float = -300.0
const COYOTE_TIME: float = 0.1

# Enemy Constants - Skeleton
const SKELETON_PATROL_SPEED: float = 50.0
const SKELETON_CHASE_SPEED: float = 120.0
const SKELETON_MIN_SHOOT_DISTANCE: float = 150
const SKELETON_MIN_CHASE_DISTANCE: float = 30.0
const SKELETON_MAX_CHASE_DISTANCE: float = 500.0
const SKELETON_IDLE_TIME: float = 3.0

const CANNONBALL_DAMAGE: int = 15

# Combat Constants
const SWORD_DAMAGE: int = 10
const DEFAULT_HEALTH: int = 50
const KNOCKBACK_SPEED: float = 20.0

# Animation and Effects
const DEATH_TIME: float = 3.0

# Performance Constants
const RAYCAST_CACHE_DURATION: float = 0.33 # Update raycasts 3 times per second

# World Constants
const CELL_SIZE: int = 16
const STARTING_OFFSET: int = 2 * CELL_SIZE

# Component Name Constants
class ComponentNames:
    const INTERACTION = "InteractionComponent"
    const COLLECTION = "CollectionComponent"
    const CLIMBABLE = "ClimbableComponent"
    const BUTTON_PROMPT = "ButtonPromptComponent"

class BlackboardVars:
    const dir_var = "dir"
    const can_riposte_var = "can_riposte"
    const current_speed_var = "current_speed"
    const roll_force_var = "roll_force"
    const action_pressed_var = "action_pressed"
    const can_move_var = "can_move"
    const has_double_jumped_var = "has_double_jumped"
    const climbing_var = "climbing"
    const climbable_above_var = "climbable_above"
    const climbable_below_var = "climbable_below"
    const swingable_above_var = "swingable_above"
    const knockback_force_var = "knockback_force"