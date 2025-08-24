#!/bin/bash

# Automated test runner for Godot 2D Platformer
# This script runs the game with automated input testing

echo "Starting automated test suite..."
echo "================================"

# Run Godot with the test scene
godot --headless --path "/mnt/c/Users/alexm/Documents/godot/2d-platformer" "res://testing/TestScene.tscn"

echo "================================"
echo "Test suite completed!"