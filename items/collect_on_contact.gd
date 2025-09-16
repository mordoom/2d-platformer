extends Area2D

@export var collection_component: CollectionComponent

func _on_body_entered(body: Node2D) -> void:
    if body is Player:
        collection_component.collect()
