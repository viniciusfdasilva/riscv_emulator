
module main

import vm

struct Alu{
	pub mut:
		a u8
		b u8
		s u8
}

fn (alu Alu) sum() { alu.s = alu.a + alu.b; }
fn (alu Alu) sub() { alu.s = alu.a - alu.b; }
fn (alu Alu) mul() { alu.s = alu.a * alu.b; }
fn (alu Alu) div() { alu.s = alu.a / alu.b; }

fn (alu Alu) or()  { alu.s = alu.a |  alu.b  }
fn (alu Alu) and() { alu.s = alu.a &  alu.b  }
fn (alu Alu) xor() { alu.s = alu.a ^  alu.b  }
fn (alu Alu) sll() { alu.s = alu.a << alu.b  }
fn (alu Alu) sra() { alu.s = alu.a >> alu.b  }
fn (alu Alu) slt() { alu.s = alu.a <  alu.b ? 1 : 0}
fn (alu Alu) slt() { alu.s = alu.a >  alu.b ? 1 : 0}
fn (alu Alu) beq() { alu.s = alu.a == alu.b ? 1 : 0}

struct CPU{
	pub:
		num_of_registers := 32

	pub mut:
		pc u32
		registers[num_of_registers]u8
		alu Alu
		cpu_control = none
}


fn (cpu CPU) start_cpu()
{
	cpu.pc := 0
	
	while(true)
	{
		u32 instruction := cpu.fetch()
		cpu.decode(instruction)
		cpu.run()
	}
}

fn (cpu CPU) fetch()
{
	u32 instruction := vm.RAM[cpu.pc];
	cpu.pc += 4

	return instruction 
}

fn (cpu CPU) decode(u32 instruction)
{

}

fn (cpu CPU) run(u32 instruction)
{

}