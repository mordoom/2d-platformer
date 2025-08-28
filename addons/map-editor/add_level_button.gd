@tool
extends Button

func _ready():
    pressed.connect(test)

func test():
    print_debug("yay")