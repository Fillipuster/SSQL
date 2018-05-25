FData = {instances = {}};
FData.__index = FData;

function FData:Create(name)
   local fd = {};
   setmetatable(fd, FData);
   fd.name = tostring(name);
   fd.data = {};

   table.insert(FData.instances, fd);

   return fd;
end

function FData:Find(name, dontCreate)
	for _,fd in pairs(FData.instances) do
		if (name == fd:GetName()) then
			return fd;
		end
	end

	return dontCreate and nil or FData:Create(name);
end

function FData:GetName()
	return self.name;
end

function FData:SetName(name)
	self.name = tostring(name);
end

function FData:GetData()
	return self.data;
end

function FData:SetData(data, dontSave)
	self.data = data;
	if (!dontSave) then
		self:Save();
	end
end

function FData:Save()
	SSQL.SaveFloatData(self:GetName());
end

function FData:ToJSON()
	if (type(self.data) == "table") then
		for k,v in pairs(self.data) do
			if (type(v) == "function") then
				self.data[k] = nil;
			end
		end
	end

	return util.TableToJSON({json = self.data});
end

function FData:FromJSON(json)
	if (type(json) == "string") then
		local tab = util.JSONToTable(json);
		if (tab && tab.json) then
			self.data = tab.json;
		end
	end
end

function FData:Remove()
	for i,fd in pairs(FData.instances) do
		if (fd == self) then
			fd[i] = nil;
			self = nil;
		end
	end
end