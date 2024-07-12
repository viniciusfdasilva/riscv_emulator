
import os
__global t = []string{}

__global is_finish      = false
__global is_cpu_started = false
__global is_os_booted   = false
__global threads = []thread{}

fn start_cpu(){

	mut pc := 0

	if !is_cpu_started { println("STARTING CPU...") }

	for{
		if t.len != 0 && is_finish {

			println("LOADING INSTRUCTIONS...")
			mut c := t.pop()
		}else if t.len == 0 && is_finish{
			is_finish = false
		}
	}
}

fn sh(){

	mut pc := 0

	if !is_os_booted { println("BOOTING OPERATING SYSTEM...") }

	println("=================================================================")
	println("                          WELCOME TO VINUX                       ")
	println("=================================================================")
	for{
		
		mut str := os.input('# ')
		
		if str == 'EXIT' {
			exit(0)		
		} else if str != 'END' {
			t << str
		}else{
			is_finish = true
		}
	}
}


fn main(){

	mut first := false
	
	for {
		is_cpu_started = true
		threads << spawn start_cpu()
		is_os_booted   = true
		threads << spawn sh()
		threads.wait()
	}
}
