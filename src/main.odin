package main

import "core:fmt"
import rl "vendor:raylib"

ScreenWidth :: 300
ScreenHeight :: 300

main :: proc() {
	rl.SetConfigFlags(
		{.WINDOW_UNDECORATED, .WINDOW_TRANSPARENT, .WINDOW_TOPMOST, .WINDOW_ALWAYS_RUN},
	)
	// Initialize audio FIRST, before window
	rl.InitAudioDevice()
	defer rl.CloseAudioDevice()

	// Check if it initialized successfully
	if !rl.IsAudioDeviceReady() {
		fmt.eprintln("ERROR: Audio device failed to initialize!")
		return
	}

	rl.InitWindow(ScreenWidth, ScreenHeight, "Fogata")
	rl.SetTargetFPS(60)

	assets := load_assets()
	defer unload_assets(&assets)

	settings := default_settings()

	app := init_app(&settings, assets)
	defer destroy_app(&app)

	for !rl.WindowShouldClose() {
		dt := rl.GetFrameTime()
		update_app(&app, dt)

		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{0, 0, 0, 0})
		draw(&app)
		rl.EndDrawing()
	}
	rl.CloseWindow()
}

