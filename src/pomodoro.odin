package main

import "core:fmt"
import rl "vendor:raylib"

Pomodoro :: struct {
	seconds_remaining:   f32,
	current_cycle:       int,
	pomodoros_completed: int,
}

update_pomodoro :: proc(timer: ^Pomodoro, dt: f32, app: ^App) {
	current_state := app.state
	if current_state == .Idle do return

	timer.seconds_remaining -= dt
	if timer.seconds_remaining <= 0 {
		if current_state == .Work {
			timer.pomodoros_completed += 1
			timer.current_cycle += 1
			if timer.current_cycle >= app.settings.pomodoros_until_long_break {
				timer.current_cycle = 0
				transition_to(app, .LongBreak)
			} else {
				transition_to(app, .ShortBreak)
			}
		} else {
			transition_to(app, .Work)
		}

	}
}

set_seconds :: proc(timer: ^Pomodoro, seconds: f32) {
	timer.seconds_remaining = seconds
}


get_time_display :: proc(timer: ^Pomodoro) -> cstring {
	total_seconds := int(timer.seconds_remaining)
	minutes := total_seconds / 60
	seconds := total_seconds % 60
	text := fmt.ctprintf("%02d:%02d", minutes, seconds)
	return text
}

draw_time_text :: proc(timer: ^Pomodoro, font_size: i32) {
	time_str := get_time_display(timer)
	text_width := rl.MeasureText(time_str, font_size)
	screen_x := rl.GetScreenWidth() / 2
	x := screen_x - text_width / 2
	rl.DrawText(time_str, x, 210, font_size, rl.WHITE)
}

