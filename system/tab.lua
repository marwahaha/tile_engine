local tab = require("class"):new({
	layer = {}
})

local function add(self,item,i)
	i = i or #self + 1
	table.insert(self,i,item)
end

function tab:addLayer(name , i)
	if i == "top" then return self:addLayer(name) end
	if i == "bottom" then return self:addLayer(name,#self.layer + 1) end
	self.layer[name] = {add = add}
	_G[self.name][name] = self.layer[name]
	i = i or 1
	table.insert(self.layer,i,self.layer[name])
end

function tab:load()
	self:addLayer("main")
	self.layer.main.tab = _G[self.name]
	function self.layer.main:dofunc(f,...)
		if self.tab[f] then
			self.tab[f](...)
		end
	end
	self:addLayer("ui")
end

function tab:dofunc(f,...)
	for i , layer in ipairs(self.layer) do
		if layer.dofunc then
			layer:dofunc(f,...)
		else
			for i , item in ipairs(layer) do
				if item.dofunc then
					item:dofunc(f,...)
				elseif type(item[f]) == "function" then
					item[f](f)
					print(f)
				end
			end
		end
	end
end

package.preload["tab"] = function() return tab end

return tab