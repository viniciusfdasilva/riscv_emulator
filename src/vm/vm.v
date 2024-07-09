module main

import cpu


mut hardware := Hardware{ram: RAM{}, cpu: Cpu{}}

struct Hardware
{
	pub mut:
		ram RAM;
		cpu cpu.CPU;
}


struct RAM 
{
	pub:
		mem_size_in_mb := 100
	
	pub mut:
		memory[mem_size_in_mb]u32
		current_memory_addess u32
}



fn load_instructions(asm_instructions[string])
{
	for mut instruction in asm_instructions {

	}
}

fn start_assembler()
{
	mut instructions := {"ADD s0, s1, s2", "ADDI s0, s1, s2", "MUL s2, s3, s3"}
}

fn start_vm()
{
	// Load asm instructions, converts to machine instructions and save in memory
	start_assembler() 
	// Get in memory, decode and run instructions
	cpu.start_cpu() 
}