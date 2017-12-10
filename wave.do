onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Turquoise -label clock /mips_multiciclo/clock
add wave -noupdate -color Green -label STATE /mips_multiciclo/control_path/cs
add wave -noupdate -label pc /mips_multiciclo/data_path/pc
add wave -noupdate -label address /mips_multiciclo/data_path/Address
add wave -noupdate -label instruction /mips_multiciclo/control_path/flg.instruction
add wave -noupdate -label data_in /mips_multiciclo/data_path/data_in
add wave -noupdate -color White -label ALUop /mips_multiciclo/control_path/decodedInstruction
add wave -noupdate -label op1 /mips_multiciclo/data_path/ALUoperand1
add wave -noupdate -label op2 /mips_multiciclo/data_path/ALUoperand2
add wave -noupdate -label ALUout /mips_multiciclo/data_path/ALUout
add wave -noupdate -label result /mips_multiciclo/data_path/result
add wave -noupdate -label address /mips_multiciclo/Address
add wave -noupdate -color Yellow -label a0 /mips_multiciclo/data_path/Register_file/reg(4)
add wave -noupdate -color {Dark Green} -label i /mips_multiciclo/data_path/Register_file/reg(9)
add wave -noupdate -color {Dark Green} -label j /mips_multiciclo/data_path/Register_file/reg(11)
add wave -noupdate -color {Dark Green} -label array /mips_multiciclo/data_path/Register_file/reg(17)
add wave -noupdate -color {Dark Green} -label SIZE /mips_multiciclo/data_path/Register_file/reg(18)
add wave -noupdate -color {Slate Blue} -label eleito /mips_multiciclo/data_path/Register_file/reg(19)
add wave -noupdate -color Goldenrod -label {array[j]} /mips_multiciclo/data_path/Register_file/reg(20)
add wave -noupdate -color Wheat -label order /mips_multiciclo/data_path/Register_file/reg(22)
add wave -noupdate -color Wheat -label SignedData /mips_multiciclo/data_path/Register_file/reg(23)
add wave -noupdate -color {Medium Spring Green} -label size /mips_multiciclo/RAM/memoryArray(41)
add wave -noupdate -color Blue -label array0 /mips_multiciclo/RAM/memoryArray(42)
add wave -noupdate -color Blue -label array1 /mips_multiciclo/RAM/memoryArray(43)
add wave -noupdate -color Blue -label array2 /mips_multiciclo/RAM/memoryArray(44)
add wave -noupdate -color Blue -label array3 /mips_multiciclo/RAM/memoryArray(45)
add wave -noupdate -color Blue -label array4 /mips_multiciclo/RAM/memoryArray(46)
add wave -noupdate -color Blue -label array5 /mips_multiciclo/RAM/memoryArray(47)
add wave -noupdate -color Gold -label sd0 /mips_multiciclo/RAM/memoryArray(48)
add wave -noupdate -color Gold -label sd1 /mips_multiciclo/RAM/memoryArray(49)
add wave -noupdate -color Gold -label sd2 /mips_multiciclo/RAM/memoryArray(50)
add wave -noupdate -color Gold -label sd3 /mips_multiciclo/RAM/memoryArray(51)
add wave -noupdate -color Coral -label order0 /mips_multiciclo/RAM/memoryArray(52)
add wave -noupdate -color Coral -label order1 /mips_multiciclo/RAM/memoryArray(53)
add wave -noupdate -color Coral -label order2 /mips_multiciclo/RAM/memoryArray(54)
add wave -noupdate -color Coral -label order3 /mips_multiciclo/RAM/memoryArray(55)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {23935 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {48151 ns} {48219 ns}
