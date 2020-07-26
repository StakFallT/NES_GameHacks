-- $800C: 192: LDX #$00
-- $800E: 194: JSR F2261	loadbgpal
-- $8011: 693: JSR F2247	Set_PPU_SprPal_Addr
-- $8014: 721: LDX #$10
-- $8016: 723: JSR F226D	loadsprpal
-- $8019: 982: JSR F0052	LoadBackground
-- $A278: ???: RTS

CycleBP_1 = 723

Addr_1 = 0x8014
Addr_2 = 0x8016
Addr_3 = 0xA278
-- Addr_4 =
-- Addr_5 =
-- Addr_6 =
-- Addr_7 =
-- Addr_8 =
-- Addr_9 =
-- Addr_10 =
-- Addr_11 =
-- Addr_12 =

function Break_CycleCounter()
	CycleNum = CycleBP_1
	-- ObjCtr = memory.getregister("y")
	CycleCount = debugger.getcyclescount()

	-- if ObjCtr > 0x16 then
	if CycleCount >= CycleNum then
		gui.text(1, 10, string.format("%02X",CycleCount))
		emu.pause() -- or debugger.hitbreakpoint()
	end
end

function Break_Addr()
		gui.text(1, 10, string.format("Address %02X about to execute!",memory.getregister("pc")), "red")
		emu.pause() -- or debugger.hitbreakpoint()
end

memory.registerexecute(Addr_1, Break_Addr)
memory.registerexecute(Addr_2, Break_Addr)
memory.registerexecute(Addr_3, Break_Addr)



-- Functions related to on-screen display of information for debugging
function Display_PC()
	gui.text(1,8, "Test", "blue")
	gui.text(1,9, string.format("%02X",memory.getregister("pc")),"blue")
end

--gui.register(Display_PC)


emu.speedmode("normal")

while true do
	gui.text(1,8, "Test", "blue")
	gui.text(1,9, string.format("%02X",memory.getregister("pc")),"blue")

	-- Execute instructions for FCEUX
	emu.frameadvance() -- This essentially tells FCEUX to keep running
end