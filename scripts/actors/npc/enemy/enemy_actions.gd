extends Node
class_name Enemy_Actions

@export var damage: int = 1

## Base Enemy Node
var enemy

func init(owned_enemy: Enemy):
	enemy = owned_enemy
