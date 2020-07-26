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

-- CoreBeingUsed = "NesHawk"
-- PalAddrStart = 0x3F00
-- PalMemDomainString = "PPU Bus"

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
		gui.text(1, 10, string.format("Address %02X about to execute!",emu.getregister("pc")), "red")
		emu.pause() -- or debugger.hitbreakpoint()
end

if (CoreBeingUsed ~= "NesHawk") then
	event.onmemoryexecute(Break_Addr, Addr_1)
	event.onmemoryexecute(Break_Addr, Addr_2)
	event.onmemoryexecute(Break_Addr, Addr_3)
end



-- Functions related to on-screen display of information for debugging
function Display_PC()
	-- gui.text(1,8, "Test", "blue")
	gui.text(1,9, string.format("%02X",emu.getregister("PC")),"blue")
end

--gui.register(Display_PC)


-- emu.speedmode("normal")
-- client.ispaused
-- client.pause
-- client.speedmode
-- client.topgglepause
-- client.unpause

function Display_Registers()
	AvailRegisters = emu.getregisters()
	Y_Coord = 28

	-- gui.text(1,11, AvailRegisters)
	for k, v in pairs(AvailRegisters) do
		gui.text(1, Y_Coord, k..":"..v, "blue")
		Y_Coord = Y_Coord +15
	end
end

Dump_MemoryDomainList = true

function Display_PaletteData(CoreBeingUsed, PalAddrStart, PalMemDomainString)
	-- if (Dump_MemoryDomainList == true) then
	-- 	console.log("CoreBeingUsed: "..CoreBeingUsed)
	-- 	console.log("PalAddrStart: "..string.format("%04X",PalAddrStart))
	-- 	console.log("PalMemDomainString: "..PalMemDomainString)
	-- 	Dump_MemoryDomainList = false
	-- end

	if CoreBeingUsed == "NesHawk" then
		gui.text(1, 390, "Core: NesHawk", "green")

		gui.text(1, 420, "$3F00", "green")
		gui.text(1, 435, "$3F10", "green")
	else
		gui.text(1, 405, "Core: QuickNes", "green")

		gui.text(1, 420, "$0000", "green")
		gui.text(1, 435, "$0010", "green")
	end

	PalData = memory.readbyterange(PalAddrStart, 32, PalMemDomainString)

	X_Coord = 60
	Y_Coord = 420

	Counter = 0
	-- for k, v in pairs(PalData) do
	ElementCount = table.maxn(PalData)
	for Index = 0,ElementCount,1 do
		gui.text(X_Coord, Y_Coord, string.format("%02X",PalData[Index]),"green")
		X_Coord = X_Coord + 30
		Counter = Counter + 1
		if Counter == 16 then
			Y_Coord = Y_Coord + 15
			X_Coord = 60
		end
	end
end

function setContains(set, key)
    return set[key] ~= nil
end

while true do
	-- gui.text(1,8, "Test", "blue")
	gui.text(1,9, string.format("%04X",emu.getregister("PC")),"blue")

	Display_Registers()
	-- for k in pairs (MemDomains) do
    -- 	MemDomains [k] = nil
	-- end
	MemDomains = {}
	MemDomains = memory.getmemorydomainlist()

	-- Available PPU / Pal domain string names:
	-- 	"PPU Bus"	-- Used by NesHawk
	--	"PALRAM"	-- Used by QuickNes

	if (setContains(MemDomains, "PPU Bus") == true) then
		Display_PaletteData("NesHawk", 0x3F00, "PPU Bus")
	--elseif (setContains(MemDomains, "PALRAM") == true) then
	else
		Display_PaletteData("QuickNes", 0x0000, "PALRAM")
	end

	-- Display_PaletteData()


	emu.frameadvance()

end