extends Area2D

signal hit_player   # ⚡ player'a çarpınca haber verecek sinyal

@export var speed: float = 300.0

func _physics_process(delta):
	position.y += speed * delta

func _on_body_entered(body):
	if body.name == "player":
		hit_player.emit()   # ⚡ artık sahneyi değil, sinyali tetikliyor
