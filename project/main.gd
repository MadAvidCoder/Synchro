extends Node2D

var top = 267
var top_vel = 0
var bottom = 281
var bottom_vel = 0
var grav = 1700
var top_lock = false
var bottom_lock = false
var top_buf = []
var over = true
var bottom_buf = []
var top_dist = 5
var bottom_dist = 6
var speed = 1.2
var count = 0
var score = 0
var coins = []
var coins_areas = []
var bottom_buf_areas = []
var top_buf_areas = []
var high_score = 0
var seagulls = []
var seagulls_areas = []
var shield_timer = 0
var shields = []
var shields_areas = []
@onready var shark = preload("res://shark.tscn")
@onready var coin = preload("res://coin.tscn")
@onready var seagull = preload("res://seagull.tscn")
@onready var shield = preload("res://shield.tscn")
@onready var big_shield = $Shield
@onready var score_num = $ScoreNumber
@onready var pirate_top = $PirateTop
@onready var pirate_bottom = $PirateBottom
@onready var over_disp = $GameOver
@onready var inst_top = $InstructionsTop
@onready var inst_bot = $InstructionsBottom
@onready var start_disp = $GameStart
@onready var high_score_num = $HighScoreNumber

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
	for i in shields:
		i.queue_free()
	shields = []
	shields_areas = []
	top_vel = 0
	bottom_vel = 0
	top_lock = false
	bottom_lock = false
	over = false
	top_dist = 3
	bottom_dist = 4
	shield_timer = 0
	speed = 1.2
	count = 0
	score = 0
	pirate_top.position = Vector2(194, 225)
	pirate_bottom.position = Vector2(194, 422)
	over_disp.hide()

func _process(delta: float) -> void:
	if not over:
		if Input.is_action_just_pressed("top_up") and not top_lock:
			top_vel = 820
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
			bottom_vel = 820
			bottom_lock = true
		else:
			pirate_bottom.play("default")
			bottom_vel -= grav*delta
		pirate_bottom.position.y += bottom_vel*delta
		if pirate_bottom.position.y < 422:
			pirate_bottom.position.y = 422
		if pirate_bottom.position.y < 427:
			bottom_lock = false
		
		if count > 4:
			inst_top.hide()
			inst_bot.hide()
			
		if speed < 2:
			if count < 7:
				count += delta
			else:
				speed += delta/175
		else:
			speed += delta/1000
		
		top_dist -= delta
		bottom_dist -= delta
		shield_timer -= delta
		
		if shield_timer <= 0:
			big_shield.stop()
			big_shield.hide()
		elif shield_timer <= 1.5:
			big_shield.play("default")
		
		score += delta*10
		score_num.text = str(floor(score))
		if score > high_score: high_score = score
		high_score_num.text = str(floor(high_score))
		
		if top_dist <= 0:
			var rand = randf()
			if rand < 0.71:
				var n_shark = shark.instantiate()
				n_shark.position = Vector2(1200,267)
				var n_shark_body = n_shark.get_node("Body")
				n_shark_body.collision_layer = 0b100
				add_child(n_shark)
				top_buf.append(n_shark)
				top_buf_areas.append(n_shark_body)
				top_dist = (randi_range(20,35)/10)/speed
			elif rand < 0.83:
				var n_gull = seagull.instantiate()
				n_gull.play("default")
				n_gull.position = Vector2(1200,61)
				var n_gull_body = n_gull.get_node("Body")
				n_gull_body.collision_layer = 0b100
				add_child(n_gull)
				seagulls.append(n_gull)
				seagulls_areas.append(n_gull_body)
				top_dist = (randi_range(15,30)/10)/(speed*1.08)
			elif rand < 0.92 and shield_timer <= 0 and len(shields) == 0:
				var n_shield = shield.instantiate()
				n_shield.position = Vector2(1200,225)
				var n_shield_body = n_shield.get_node("Body")
				n_shield_body.collision_layer = 0b100
				add_child(n_shield)
				shields.append(n_shield)
				shields_areas.append(n_shield_body)
				top_dist = (randi_range(10,20)/10)/speed
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
			var rand = randf()
			if rand < 0.74:
				var n_shark = shark.instantiate()
				n_shark.position = Vector2(1200,381)
				n_shark.rotation = PI
				var n_shark_body = n_shark.get_node("Body")
				n_shark_body.collision_layer = 0b1000
				add_child(n_shark)
				bottom_buf.append(n_shark)
				bottom_buf_areas.append(n_shark_body)
				bottom_dist = (randi_range(20,35)/10)/(speed*1.08)
			elif rand < 0.83:
				var n_gull = seagull.instantiate()
				n_gull.play("default")
				n_gull.position = Vector2(1200,587)
				n_gull.flip_v = true
				var n_gull_body = n_gull.get_node("Body")
				n_gull_body.collision_layer = 0b1000
				add_child(n_gull)
				seagulls.append(n_gull)
				seagulls_areas.append(n_gull_body)
				bottom_dist = (randi_range(15,30)/10)/(speed*1.08)
			elif rand < 0.92 and shield_timer <= 0 and len(shields) == 0:
				var n_shield = shield.instantiate()
				n_shield.position = Vector2(1200,423)
				n_shield.flip_v = true
				var n_shield_body = n_shield.get_node("Body")
				n_shield_body.collision_layer = 0b1000
				add_child(n_shield)
				shields.append(n_shield)
				shields_areas.append(n_shield_body)
				bottom_dist = (randi_range(10,20)/10)/(speed*1.08)
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
		
		for i in shields:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				shields_areas.erase(i.get_node("Body"))
				i.queue_free()
				coins.erase(i)
		
		for i in coins:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				coins_areas.erase(i.get_node("Body"))
				i.queue_free()
				coins.erase(i)
		
		for i in seagulls:
			i.position.x -= delta*400*speed
			if i.position.x <= -60:
				seagulls_areas.erase(i.get_node("Body"))
				i.queue_free()
				seagulls.erase(i)
		
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
		for i in seagulls:
			i.pause()
		for i in coins:
			i.pause()

func _on_body_area_entered(area: Area2D) -> void:
	if (area in top_buf_areas or area in bottom_buf_areas or area in seagulls_areas):
		if shield_timer <= -0.05:
			shield_timer = 0
		else:
			over = true
			over_disp.show()
	elif area in coins_areas:
		score += 100
		area.get_parent().queue_free()
		coins.erase(area.get_parent())
		coins_areas.erase(area)
	elif area in shields_areas:
		area.get_parent().queue_free()
		shields.erase(area.get_parent())
		shields_areas.erase(area)
		shield_timer = 4
		big_shield.stop()
		big_shield.frame = 0
		big_shield.show()

func _on_again_pressed() -> void:
	reset()

func _on_start_pressed() -> void:
	over = false
	start_disp.hide()
