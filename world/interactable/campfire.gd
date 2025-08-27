extends Interactable

@onready var label = $Label

func _ready():
    label.visible = false
    label.text = "press: " + InputHelper.serialize_inputs_for_action("interact")

func interact():
    SignalBus.emit_signal("on_campfire_rested", self)

func show_prompt():
    label.visible = true

func hide_prompt():
    label.visible = false
