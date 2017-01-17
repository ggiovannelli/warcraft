
-- rFilter_Zork: buff
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

-----------------------------
-- Buff Config
-----------------------------

if L.C.playerClass == "DRUID" then 
	
	-- guardian ----------------------------------------------------------------------------------------
	---- Guardiano di Elune
	local button = rFilter:CreateBuff(213680,"player",38,{"CENTER",0,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Marchio di Ursol
	local button = rFilter:CreateBuff(192083,"player",38,{"CENTER",42,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Vello di Ferro
	local button = rFilter:CreateBuff(192081,"player",38,{"CENTER",84,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end
	
	---- Frenzied regeneration
	local button = rFilter:CreateBuff(22842,"player",38,{"CENTER",126,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Pelledura
	local button = rFilter:CreateBuff(22812,"player",38,{"CENTER",168,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Istinto di Sopravvivenza
	local button = rFilter:CreateBuff(61336,"player",38,{"CENTER",210,-305},"[spec:3][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end
	
	
	
	-- balance ----------------------------------------------------------------------------------------
	---- Rejuvenation
	local button = rFilter:CreateBuff(774,"player",38,{"CENTER",0,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end	
	
	---- 
	local button = rFilter:CreateBuff(191034,"player",38,{"CENTER",42,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Pelledura
	local button = rFilter:CreateBuff(164545,"player",38,{"CENTER",84,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Guardiano di Elune
	local button = rFilter:CreateBuff(164547,"player",38,{"CENTER",126,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	---- Owling Frenzied
	local button = rFilter:CreateBuff(157228,"player",38,{"CENTER",168,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	
end


if L.C.playerClass == "DEATHKNIGHT" then 


	-- blood ----------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(188290,"player",38,{"CENTER",0,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(195181,"player",38,{"CENTER",42,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end
	
	-- frost ----------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(196770,"player",38,{"CENTER",0,-305},"[spec:2][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end
	
	
end

if L.C.playerClass == "WARRIOR" then


	-- spec 3 -------------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(132404,"player",38,{"CENTER",0,-305},"[spec:3][combat]show;hide",{0,1},true,nil) --SB
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(190456,"player",38,{"CENTER",42,-305},"[spec:3][combat]show;hide",{0,1},true,nil) --IP
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(184362,"player",38,{"CENTER",84,-305},"[spec:3][combat]show;hide",{0,1},true,nil) --enrage
	if button then table.insert(L.buffs,button) end

end

if L.C.playerClass == "HUNTER" then


	-- beast master -------------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(193530,"player",38,{"CENTER",0,-305},"[spec:1][combat]show;hide",{0,1},true,nil) 
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(186265,"player",38,{"CENTER",42,-305},"[spec:1][combat]show;hide",{0,1},true,nil) --enrage
	if button then table.insert(L.buffs,button) end
	
	local button = rFilter:CreateBuff(217200,"pet",38,{"CENTER",84,-305},"[spec:1][combat]show;hide",{0,1},true,nil) --enrage
	if button then table.insert(L.buffs,button) end

	
end

if L.C.playerClass == "PRIEST" then

	-- shadow -------------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(194249,"player",38,{"CENTER",0,-305},"[spec:3][combat]show;hide",{0,1},true,nil) 
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(10060,"player",38,{"CENTER",42,-305},"[spec:1][combat]show;hide",{0,1},true,nil)
	if button then table.insert(L.buffs,button) end

end

if L.C.playerClass == "MAGE" then 

	-- fire -------------------------------------------------------------------------------------------
	local button = rFilter:CreateBuff(48108,"player",38,{"CENTER",0,-305},"[spec:2][combat]show;hide",{0,1},true,nil) -- serie bollente
	if button then table.insert(L.buffs,button) end

	local button = rFilter:CreateBuff(48107,"player",38,{"CENTER",0,-305},"[spec:2][combat]show;hide",{0,1},true,nil) -- riscaldamento
	if button then table.insert(L.buffs,button) end

end