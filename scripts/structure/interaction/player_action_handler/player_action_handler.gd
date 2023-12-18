extends Node
class_name Player_Action_Handler

var action_list = {}

var _state_chart: StateChart

func init(owned_player: Player):
	var action_nodes = get_children()
	
	for node in action_nodes:
		var node_children = node.get_children()
		
		if node_children.size() > 0:
			action_list[node.name] = node_children[0]
			action_list[node.name].init(owned_player)

func _input(event):
	for key in action_list:
		if event.is_action_pressed(key):
			action_list[key].activate(event.get_action_strength(key))
		
		if event.is_action_released(key):
			action_list[key].release()
