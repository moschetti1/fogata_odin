package utils

import "core:math"

noise_1d :: proc(x: f32) -> f32 {
	// Simple perlin-like noise using sine waves
	n := math.sin(x) * 43758.5453123
	return (n - math.floor(n)) * 2.0 - 1.0 // returns -1 to 1
}

