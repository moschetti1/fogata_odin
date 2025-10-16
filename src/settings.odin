package main

import "core:encoding/json"
import "core:fmt"
import "core:os"

Settings :: struct {
	work_duration:              f32,
	short_break_duration:       f32,
	long_break_duration:        f32,
	transition_duration:        f32,
	pomodoros_until_long_break: int,
	enabled_keystrokes:         bool,
	enabled_crickets:           bool,
	master_volume:              f32,
}

default_settings :: proc() -> Settings {
	return Settings {
		work_duration = 25 * 60,
		short_break_duration = 5 * 60,
		long_break_duration = 15 * 60,
		transition_duration = 2.0,
		enabled_keystrokes = true,
		enabled_crickets = true,
		master_volume = 0.7,
	}
}

save_settings :: proc(settings: ^Settings, filepath: string) -> bool {
	data, err := json.marshal(settings^)
	if err != nil {
		fmt.eprintln("Failed to marshal settings:", err)
		return false
	}
	defer delete(data)
	ok := os.write_entire_file(filepath, data)
	return ok
}

load_settings :: proc(filepath: string) -> (Settings, bool) {
	data, ok := os.read_entire_file(filepath)
	if !ok {
		return default_settings(), false
	}
	defer delete(data)
	settings: Settings

	err := json.unmarshal(data, &settings)
	if err != nil {
		fmt.eprintln("Failed to unmarshal settings:", err)
		return default_settings(), false
	}
	return settings, true
}

