extends Node

class_name GameConstants

# Player Constants
const PLAYER_SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const DOUBLE_JUMP_VELOCITY: float = -300.0
const COYOTE_TIME: float = 0.1

# Enemy Constants - Skeleton
const SKELETON_PATROL_SPEED: float = 50.0
const SKELETON_CHASE_SPEED: float = 120.0
const SKELETON_MIN_CHASE_DISTANCE: float = 30.0
const SKELETON_MAX_CHASE_DISTANCE: float = 500.0
const SKELETON_IDLE_TIME: float = 3.0

# Combat Constants
const SWORD_DAMAGE: int = 10
const DEFAULT_HEALTH: int = 30
const KNOCKBACK_SPEED: float = 30.0

# Animation and Effects
const DEATH_TIME: float = 3.0

# Performance Constants
const RAYCAST_CACHE_DURATION: float = 0.1 # Update raycasts 10 times per second