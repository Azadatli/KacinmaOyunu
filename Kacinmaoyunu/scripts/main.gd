extends Node2D

@export var ball_scene: PackedScene

var game_over: bool = false
var score: float = 0.0
var current_ball_speed: float = 250.0   # topların başlangıç hızı

@onready var score_label: Label = $HUD/ScoreLabel
@onready var game_over_label: Label = $HUD/GameOverLabel
@onready var spawn_timer: Timer = $SpawnTimer
@onready var player = $player

func _ready():
	randomize()  # rastgele spawn için
	_update_score_label()

func _process(delta):
	if game_over:
		return
	
	# Skor zamanla artsın
	score += delta * 10.0   # istersen çarpanı değiştir
	_update_score_label()


func _update_score_label():
	score_label.text = "Skor: " + str(int(score))


func _on_spawn_timer_timeout():
	# Top (mob) oluşturma
	var ball = ball_scene.instantiate()
	
	# Ekranın yatayında rastgele konum
	ball.position = Vector2(randi_range(80, 1070), -60)
	
	# Hızını ayarla (zorluk burada artacak)
	ball.speed = current_ball_speed
	
	# Player'a çarpınca tetiklenecek sinyali bağla
	ball.hit_player.connect(_on_ball_hit_player)
	
	add_child(ball)
	
	# Her yeni topta hızı biraz arttır → zamanla zorlaşma
	current_ball_speed += 5.0
	# SpawnTimer süresini de hafif kısalttıkça daha sık top gelir
	spawn_timer.wait_time = max(0.4, spawn_timer.wait_time - 0.02)


func _on_ball_hit_player():
	if game_over:
		return
	
	game_over = true
	
	# Top düşmesini durdur
	spawn_timer.stop()
	
	# Oyuncu hareket etmesin (player.gd'de can_move kullanıyorsan ona göre)
	if player.has_method("set_can_move"):
		player.set_can_move(false)
	
	# Game over yazısını göster
	game_over_label.visible = true


func _unhandled_input(event):
	# Game over olmuşsa, Enter/Space'e basınca sahneyi yeniden yükle
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
