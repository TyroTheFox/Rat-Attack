extends Area3D
class_name HitBox

## 3D Area thats used to 'deal damage'

@export var damage : float = 10
@export var damageType: DamageVariables.damage_types = 0

signal landed_hit(hurtbox: HurtBox, damage: float, damageType: DamageVariables.damage_types)

func _init():
	collision_layer = DamageVariables.default_hitbox_layer
	collision_mask = DamageVariables.default_hitbox_mask

func _ready():
	if !is_connected("area_entered", self._on_area_entered):
		self.connect("area_entered", self._on_area_entered)

func _on_area_entered(hurtbox: HurtBox):
	if hurtbox == null:
		return
	
	if !(hurtbox is HurtBox):
		return
	
	landed_hit.emit(hurtbox as HurtBox, damage, damageType)
