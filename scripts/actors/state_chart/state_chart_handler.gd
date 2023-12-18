extends Node
class_name State_Chart_Handler

var state_chart: StateChart
## The Game Entity that the State Chart belongs to
var entity

func init(owned_entity):
	entity = owned_entity
	assert(entity != null)

	state_chart = get_child(0)

func send_chart_event(event_name) -> void:
	state_chart.send_event(event_name)

func set_chart_property(property_name: String, value) -> void:
	state_chart.set_expression_property(property_name, value)
