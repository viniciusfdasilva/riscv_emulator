module main

import vm
import readline

mut kernel := none

fn start_kernel(){
	kernel = Kernel{}
}

fn kill(){
	kernel = none
}

struct Kernel{

	pub mut:
		stdin  := []u8{};
		stdout := []u8{};

		input_device  := 'keyboard'
		output_device := 'screen'
}


fn (mut kernel Kernel) read()
{

	mut input := none

	match kernel.input_device {
		'keyboard' {
			
			mut r := readline.Readline{}
			input = r.read_line('')!
		}
	}

	kernel.stdin = input.bytes()
}

fn (mut kernel Kernel) exit() { exit(0) }

fn (mut kernel Kernel) write()
{
	kernel.stdout = output

	match kernel.output_device {

		'screen' { print(stdout.bytestr()) }
	}
}