extends Node2D

var top = 267
var top_vel = 0
var bottom = 281
var bottom_vel = 0
var grav = 1400
var top_lock = false
var bottom_lock = false
var top_buf = []
var over = true
var bottom_buf = []
var top_dist = 3
var bottom_dist = 4
var speed = 1.2
var count = 0
var score = 0
var coins = []
var coins_areas = []
var bottom_buf_areas = []
var top_buf_areas = []
var high_score = 0
@onready var shark = preload("res://shark.tscn")
@onready var coin = preload("res://coin.tscn")
@onready var score_num = $ScoreNumber
@onready var pirate_top = $PirateTop
@onready var pirate_bottom = $PirateBottom
@onready var over_disp = $GameOver
@onready var inst_top = $InstructionsTop
@onready var inst_bot = $InstructionsBottom
@onready var start_disp = $GameStart

func reset() -> void:
	for i in top_buf:
		i.queue_free()
	top_buf = []
	top_buf_areas = []
	for i in bottom_buf:
		i.queue_free()
	bottom_buf = []
	bottom_buf_areas = []
	for i in coins:
		i.queue_free()
	coins = []
	coins_areas = []
	top_vel = 0
	bottom_vel = 0
	top_lock = false
	bottom_lock = false
	over = false
	top_dist = 3
	bottom_dist = 4
	speed = 1.2
	count = 0
	score = 0
	pirate_top.position = Vector2(194, 225)
	pirate_bottom.position = Vector2(194, 422)
	over_disp.hide()

func _process(delta: float) -> void:
	if not over:
		if Input.is_action_just_pressed("top_up") and not top_lock:
			top_vel = 650
			top_lock = true
		else:
			pirate_top.play("default")
			top_vel -= grav*delta
		pirate_top.position.y -= top_vel*delta
		if pirate_top.position.y > 225:
			pirate_top.position.y = 225
		if pirate_top.position.y > 220:
			top_lock = false
		
		if Input.is_action_just_pressed("bottom_down") and not bottom_lock:
			bottom_vel = 650
			bottom_lock = true
		else:
			pirate_bottom.play("default")
			bottom_vel -= grav*delta
		pirate_bottom.position.y += bottom_vel*delta
		if pirate_bottom.position.y < 422:
			pirate_bottom.position.y = 422
		if pirate_bottom.position.y < 427:
			bottom_lock = false
		
		if count > 3:
			inst_top.hide()
			inst_bot.hide()
			
		if speed < 2:
			if count < 5:
				count += delta
			else:
				speed += delta/175
		else:
			speed += delta/1500
		
		top_dist -= delta
		bottom_dist -= delta
		
		score += delta*10
		score_num.text = str(floor(score))
		if score > high_score: high_score = score
		
		if top_dist <= 0:
			if randf() < 0.9:
				var n_shark = shark.instantiate()
				n_shark.position = Vector2(1200,267)
				var n_shark_body = n_shark.get_node("Body")
				n_shark_body.collision_layer = 0b100
				add_child(n_shark)
				top_buf.append(n_shark)
				top_buf_areas.append(n_shark_body)
				top_dist = (randi_range(20,35)/10)/speed
			else:
				var n_coin = coin.instantiate()
				n_coin.play("default")
				n_coin.position = Vector2(1200,225)
				var n_coin_body = n_coin.get_node("Body")
				n_coin_body.collision_layer = 0b100
				add_child(n_coin)
				coins.append(n_coin)
				coins_areas.append(n_coin_body)
				top_dist = (randi_range(10,20)/10)/speed
		
		if bottom_dist <= 0:
			if randf() < 0.9:
				var n_shark = shark.instantiate()
				n_shark.position = Vector2(1200,381)
				n_shark.rotation = PI
				var n_shark_body = n_shark.get_node("Body")
				n_shark_body.collision_layer = 0b1000
				add_child(n_shark)
				bottom_buf.append(n_shark)
				bottom_buf_areas.append(n_shark_body)
				bottom_dist = (randi_range(20,35)/10)/(speed*1.08)
			else:
				var n_coin = coin.instantiate()
				n_coin.play("default")
				n_coin.position = Vector2(1200,423)
				var n_coin_body = n_coin.get_node("Body")
				n_coin_body.collision_layer = 0b1000
				add_child(n_coin)
				coins.append(n_coin)
				coins_areas.append(n_coin_body)
				bottom_dist = (randi_range(10,20)/10)/(speed*1.08)

		
		for i in coins:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				coins_areas.erase(i.get_node("Body"))
				i.queue_free()
				coins.erase(i)
		
		for i in top_buf:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				top_buf_areas.erase(i.get_node("Body"))
				i.queue_free()
				top_buf.erase(i)
		
		for i in bottom_buf:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				bottom_buf_areas.erase(i.get_node("Body"))
				i.queue_free()
				bottom_buf.erase(i)

	else:
		pirate_top.pause()
		pirate_bottom.pause()

func _on_body_area_entered(area: Area2D) -> void:
	if area in top_buf_areas or area in bottom_buf_areas:
		over = true
		over_disp.show()
	elif area in coins_areas:
		score += 100
		area.get_parent().queue_free()
		coins.erase(area.get_parent())
		coins_areas.erase(area)

func _on_again_pressed() -> void:
	reset()

func _on_start_pressed() -> void:
	over = false
	start_disp.hide()
