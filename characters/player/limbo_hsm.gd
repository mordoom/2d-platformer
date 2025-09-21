extends LimboHSM

@onready var idle_state: LimboState = $Idle
@onready var move_state: LimboState = $Move
@onready var run_attack_state: LimboState = $RunAttack
@onready var roll_state: LimboState = $Roll
@onready var attack_state: LimboState = $GroundAttack
@onready var jump_state: LimboState = $Jump
@onready var jump_attack_state: LimboState = $JumpAttack
@onready var air_state: LimboState = $Air
@onready var climbing_state: LimboState = $Climbing
@onready var swinging_state: LimboState = $Swinging
@onready var hit_state: LimboState = $Hit
@onready var dead_state: LimboState = $Dead
@onready var shoot_state: LimboState = $Shoot
@onready var deflect_state: LimboState = $Deflect
@onready var heal_state: LimboState = $Heal

func _ready():
    _init_state_machine()

func _init_state_machine() -> void:
    add_transition(idle_state, move_state, &"movement_started")
    add_transition(move_state, idle_state, EVENT_FINISHED)

    add_transition(idle_state, heal_state, &"healing_started")
    add_transition(heal_state, idle_state, EVENT_FINISHED)

    add_transition(move_state, roll_state, &"roll_started")
    add_transition(roll_state, move_state, EVENT_FINISHED)

    add_transition(idle_state, attack_state, &"ground_attack_started")
    add_transition(attack_state, idle_state, EVENT_FINISHED)

    add_transition(idle_state, deflect_state, &"deflect_started")
    add_transition(deflect_state, idle_state, EVENT_FINISHED)

    add_transition(idle_state, shoot_state, &"shoot_started")
    add_transition(shoot_state, idle_state, EVENT_FINISHED)

    add_transition(move_state, run_attack_state, &"run_attack_started")
    add_transition(run_attack_state, move_state, EVENT_FINISHED)

    add_transition(idle_state, jump_state, &"jump_started")
    add_transition(move_state, jump_state, &"jump_started")
    add_transition(jump_state, idle_state, EVENT_FINISHED)

    add_transition(idle_state, air_state, &"fall_started")
    add_transition(move_state, air_state, &"fall_started")
    add_transition(air_state, idle_state, EVENT_FINISHED)

    add_transition(air_state, jump_attack_state, &"jump_attack_started")
    add_transition(air_state, jump_state, &"jump_started")
    add_transition(jump_state, jump_attack_state, &"jump_attack_started")
    add_transition(jump_attack_state, idle_state, EVENT_FINISHED)

    add_transition(idle_state, climbing_state, &"climb_started")
    add_transition(jump_state, climbing_state, &"climb_started")
    add_transition(air_state, climbing_state, &"climb_started")
    add_transition(climbing_state, jump_state, &"jump_started")
    add_transition(climbing_state, idle_state, EVENT_FINISHED)

    add_transition(jump_state, swinging_state, &"swing_started")
    add_transition(air_state, swinging_state, &"swing_started")
    add_transition(swinging_state, jump_state, &"jump_started")
    add_transition(swinging_state, air_state, &"fall_started")
    add_transition(swinging_state, idle_state, EVENT_FINISHED)

    add_transition(ANYSTATE, hit_state, &"hit_started")
    add_transition(hit_state, idle_state, EVENT_FINISHED)

    add_transition(ANYSTATE, dead_state, &"death_started")

    initialize(owner)
    set_active(true)