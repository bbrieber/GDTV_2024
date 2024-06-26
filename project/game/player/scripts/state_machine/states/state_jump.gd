class_name State_Jump extends StateMovementBase


@export var jump_head_cast_left: HeadRay
@export var jump_head_cast_right : HeadRay


#@export var jump_height : float = 64
#@export var jump_time_to_descend : float = 0.3

#@export var jump_time_to_peak : float = 0.4

#@export var jump_stop_factor : float = 2

var jump_velocity : float
var jump_gravity : float 

var jump_factor :float = 1

func enter(_msg :Dictionary= {}) -> void:
	jump_velocity  = (2*player.player_movement_config.jump_height) / player.player_movement_config.jump_time_to_peak
	jump_gravity  = (-2*player.player_movement_config.jump_height) / (player.player_movement_config.jump_time_to_peak *player.player_movement_config.jump_time_to_peak)

	start_jump(jump_velocity)
	
func start_jump(m_jump_velocity:float,m_jump_factor: int =1)->void:
	player.player_skin.play_animation(PlayerSkin.ANIMATION_STATE.JUMP)
	state_started.emit()
	#print("JUMP")
	jump_factor = m_jump_factor
	player.velocity.y = - m_jump_velocity
	
func exit() -> void:
	state_exit.emit()
	pass



	

	
func physics_update(ownerBody: CharacterBody2D,delta: float) -> void:
	var direction:Vector2 = player.input_processor.direction
	if player.input_processor.should_stop_jump:
		jump_factor = player.player_movement_config.jump_stop_factor
	
	var head_bounce_offset :int= jump_head_cast_left.get_jump_shift() + jump_head_cast_right.get_jump_shift()
	if head_bounce_offset != 0:
		print("Head bounce")
		ownerBody.position.x += head_bounce_offset
	
	update_locomotion(direction.x,delta)





func _get_gravity() -> float:
	return jump_gravity * jump_factor

			
