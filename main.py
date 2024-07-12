import random

number_of_bits = input('Type the number of bits\n')

instruction = ''

rand = random.Random(100)
rand.seed(100)

bits = ['0','1']

bit_instruction = []
i = 0

while i < number_of_bits:
    
    instruction += bits[rand.randint() % 2]
    i += 1

intervals_list = input('Type intervals\n').split(" ")

intervals = list(map(eval, intervals_list))

for interval in intervals:

    bit_instruction.append(instruction[31-interval[0], 31-(interval[1]+1)])