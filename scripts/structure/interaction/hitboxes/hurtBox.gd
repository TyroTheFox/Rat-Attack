extends Area3D
class_name HurtBox

## 3D Area that 'receives damage'

signal box_hit(hitbox: HitBox)

func _init():
	collision_layer = DamageVariables.default_hitbox_layer
	collision_mask = DamageVariables.default_hitbox_mask

func _ready():
	if !is_connected("area_entered", self._on_area_entered):
		self.connect("area_entered", self._on_area_entered)

func _on_area_entered(hitbox: HitBox):
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage()
		box_hit.emit(hitbox as HitBox)
