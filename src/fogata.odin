package main

import animations "animations"
import "core:fmt"
import sprites "sprites"
import rl "vendor:raylib"

FogataState :: enum {
	Idle,
	Work,
	ShortBreak,
	LongBreak,
}

App :: struct {
	state:            FogataState,
	paused:           bool,
	pomodoro:         Pomodoro,
	animation_player: animations.AnimationPlayer,
	sprite:           sprites.SpriteSheet,
	sound_manager:    SoundManager,
	settings:         ^Settings,
}

init_app :: proc(settings: ^Settings, assets: Assets) -> App {
	sprite := sprites.SpriteSheet {
		atlas          = assets.atlas,
		scale          = 3.0,
		frame_width    = 64,
		frame_height   = 64,
		frames_per_row = 4,
	}
	pomodoro := Pomodoro {
		seconds_remaining   = 0,
		current_cycle       = 0,
		pomodoros_completed = 0,
	}
	sound_manager := SoundManager {
		campfire_music      = assets.work_sound,
		crickets_music      = assets.cricket_sound,
		campfire_volume     = 10.0,
		crickets_volume     = 2.0,
		fire_start_sfx      = assets.keystroke_sound,
		fire_extinguish_sfx = assets.keystroke_sound,
	}
	return App {
		animation_player = animations.AnimationPlayer {
			current_frame = 0,
			frame_timer = 0,
			finished = false,
			animation = animations.Animation {
				start_frame = 0,
				fps = 1,
				frame_count = 4,
				loop = true,
			},
		},
		state = .Idle,
		paused = false,
		settings = settings,
		pomodoro = pomodoro,
		sprite = sprite,
		sound_manager = sound_manager,
	}
}

destroy_app :: proc(app: ^App) {
	sprites.destroy_sprite(&app.sprite)
}

transition_to :: proc(app: ^App, target_state: FogataState) {
	player := &app.animation_player
	old_state := app.state
	switch target_state {

	case .Work:
		app.state = .Work
		set_seconds(&app.pomodoro, app.settings.work_duration)
		toggle_campfire(&app.sound_manager)
		if old_state == .Idle {
			animations.play_animation(
				player,
				animations.Animation{start_frame = 0, fps = 0.2, frame_count = 4, loop = false},
			)
		} else {
			animations.play_animation(
				player,
				animations.Animation{start_frame = 0, fps = 0.2, frame_count = 4, loop = false},
			)
		}
	case .ShortBreak:
		app.state = .ShortBreak
		set_seconds(&app.pomodoro, app.settings.short_break_duration)
		toggle_campfire(&app.sound_manager)
		animations.play_animation(
			player,
			animations.Animation{start_frame = 0, fps = 0.2, frame_count = 4, loop = false},
		)
	case .LongBreak:
		app.state = .LongBreak
		set_seconds(&app.pomodoro, app.settings.long_break_duration)
		toggle_campfire(&app.sound_manager)
		animations.play_animation(
			player,
			animations.Animation{start_frame = 0, fps = 0.2, frame_count = 4, loop = false},
		)
	case .Idle:
		app.state = .Idle
		animations.play_animation(
			player,
			animations.Animation{start_frame = 0, fps = 0.2, frame_count = 4, loop = false},
		)
	}
}

update_app :: proc(app: ^App, dt: f32) {
	if app.paused do return

	update_sound_manager(&app.sound_manager)

	player := &app.animation_player

	switch app.state {
	case .Idle:

	case .Work:
		if player.finished {
			animations.play_animation(
				player,
				animations.Animation{start_frame = 0, fps = 2, frame_count = 4, loop = true},
			)
		}

	case .ShortBreak, .LongBreak:
		if player.finished {
			animations.play_animation(
				player,
				animations.Animation{start_frame = 0, fps = 2, frame_count = 4, loop = true},
			)
		}
	}
	update_pomodoro(&app.pomodoro, dt, app)
	animations.update_animation_player(player, dt)

	if rl.IsMouseButtonPressed(.LEFT) {
		transition_to(app, .Work)
	}
	if rl.IsMouseButtonPressed(.RIGHT) {
		transition_to(app, .ShortBreak)
	}
}

draw :: proc(app: ^App) {
	dest_size := rl.Vector2 {
		f32(app.sprite.frame_width) * app.sprite.scale,
		f32(app.sprite.frame_height) * app.sprite.scale,
	}
	screen_center := rl.Vector2{(ScreenWidth / 2 - dest_size.x / 2), 20}

	frame := animations.get_absolute_frame(&app.animation_player)
	sprites.draw_sprite_frame_at(&app.sprite, frame, screen_center)
	draw_time_text(&app.pomodoro, 30)
}

