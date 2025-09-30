extends Node2D

var show_rum_tut := true

func _on_bottle_of_rum_body_entered(body: Node2D) -> void:
    if body is Player && show_rum_tut:
        Dialogic.start_timeline("rum tutorial")
        show_rum_tut = false
