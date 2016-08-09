-- linq.lua - LINQ (Language Integrated Query) for Lua 5.2+
-- Licensed under the BSD3 License
-- Copyright © GryphonSoft Technologies 2016
-- Written by Brisingr Aerowing

local class = require '30log'

local LinqArray = class("LinqArray")

function LinqArray:init(items)
    if items then
        self:addRange(items)
    end
end
 
function LinqArray:add(item)
    table.insert(self, item)
end
 
function LinqArray:addRange(items)
    for k,v in ipairs(items) do
        self:add(v)
    end
end
 
function LinqArray:where(func)
    local results = LinqArray()
	local tmp = 1
    for k, v in ipairs(self) do
        if func(v, tmp) then
            results:add(v)
        end
		tmp = tmp + 1
    end
    
    return results
end
 
function LinqArray:select(func)
    local results = LinqArray()
    for k, v in ipairs(self) do
        results:add(func(v))
    end
    
    return results
end
 
function LinqArray:selectMany(func)
    local results = LinqArray()
    local selectResults = self:select(func)
    
    for _,item in ipairs(selectResults) do
        results:addRange(item)
    end
    
    return results
end
 
function LinqArray:count(func)
    
	if func then
		local r = 0
		for _, i in ipairs(self) do
			if func(i) then
				r = r + 1
			end
		end
		return r
	else
		return # self
	end
end
 
function LinqArray:first() return self[1] end
 
function LinqArray:distinct(objHashFunc)
    local results = LinqArray()
    local valueExists = {}
    
    if objHashFunc then
        for k, v in ipairs(self) do
            if not valueExists[objHashFunc(v)] then
                results:add(v)
                valueExists[objHashFunc(v)] = true
            end
        end
    else
        for k, v in ipairs(self) do
            if not valueExists[v] then
                results:add(v)
                valueExists[v] = true
            end
        end
    end
    
    return results
end
 
function LinqArray:toDictionary(keyFunc, valueFunc)
    local results = {}
    for k, v in ipairs(self) do
        results[keyFunc(v)] = valueFunc(v)
    end
    
    return results
end
 
function LinqArray:sum(func)
    local sum = 0
    
    if func then
        for k, v in ipairs(self) do
            sum = sum + func(v)
        end
    else
        for k, v in ipairs(self) do
            sum = sum + v
        end
    end
    
    return sum
end
 
function LinqArray:avg(func)
    return self:sum(func) / self:count()
end
 
function LinqArray:any(func)
    local results = self
    if func then
        results = results:where(func)
    end
    return results:count() > 0
end
 
function LinqArray:minOrMax(selector, cond)
    local curResult = nil
    local curVal
    
    for _,i in ipairs(self) do
        if selector then
            curVal = selector(i)
        else
            curVal = i
        end
                
        if not curResult then
            curResult = curVal
        elseif cond(curVal, curResult) then
            curResult = curVal
        end
    end
    
    return curResult
end
 
function LinqArray:min(selector)
    return self:minOrMax(selector, function(a,b) return a < b end)
end
 
function LinqArray:max(selector)
    return self:minOrMax(selector, function(a,b) return a > b end)
end
 
function LinqArray:removeWhere(func)
    local i = 1
    while i <= self:count() do
        if func(self[i]) then
            table.remove(self, i)
        else
            i = i + 1
        end
    end
end

function LinqArray:all(func)

for _, i in ipairs(self) do
	if not func(i) then
		return false
	end
end

return true

end

function LinqArray:concat(other)
	if type(other) ~= "table" then
		error("non-table passed to concat")
	end
	
	local result = LinqArray()
	
	result.addRange(self)
	result.addRange(other)
	
	return result
end

function LinqArray:take(num)
	if num > self:count() then error("argument too large") end
	if num <= 0 then return LinqArray() end
	local tmp = 0
	local result = LinqArray()
	for _, i in ipairs(self) do
		result.add(i)
		tmp = tmp + 1
		if tmp >= num then break end
	end
	return result
end

function LinqArray:takeWhile(func)
	if not func then error("func cannot be nil") end
	local tmp = 1
	local result = LinqArray()
	for _, i = ipairs(self) do
		if not func(i, tmp) then
			break
		end
		result.add(i)
		tmp = tmp + 1
	end
	return result
end

return LinqArray