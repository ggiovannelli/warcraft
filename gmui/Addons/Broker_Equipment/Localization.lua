local _, L = ...

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

--[==========[
local locale = GetLocale()
if(locale == 'deDE') then
	
elseif(locale == 'esES') then
	
elseif(locale == 'esMX') then
	
elseif(locale == 'frFR') then
	
elseif(locale == 'itIT') then
	
elseif(locale == 'koKR') then
	
elseif(locale == 'ptBR') then
	
elseif(locale == 'ruRU') then
	
elseif(locale == 'zhCN') then
	
elseif(locale == 'zhTW') then
	
end
--]==========]
