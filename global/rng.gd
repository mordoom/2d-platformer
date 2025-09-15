class_name RngManager
extends Node

var rng = RandomNumberGenerator.new()

func generate_random_pitch(min_val: float = 0.5, max_val: float = 2.0):
    return rng.randf_range(min_val, max_val)