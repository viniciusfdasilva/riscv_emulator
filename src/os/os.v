
module main

import sh
import kernel

os_usermode   := '__user__'
os_kernelmode := '__kernel__'

fn boot(){ 
	kernel.start_kernel() 
	start_up()	
}

fn shutdown() { kernel.kill()    }

fn start_up(){
	for { sh.sh() }
}