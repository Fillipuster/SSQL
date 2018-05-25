PData = {instances = {}};
PData.__index = PData;

function PData:Create(ply)
   local pd = {};
   setmetatable(pd, PData);
   pd.player = ply;
   pd.data = {};

   table.insert(PData.instances, pd);

   return pd;
end

function PData:Find(ply, dontCreate)
	for _,pd in pairs(PData.instances) do
		if (ply == pd:GetPlayer()) then
			return pd;
		end
	end

	return dontCreate and nil or PData:Create(ply);
end

function PData:GetPlayer()
	return self.player;
end

function PData:SetPlayer(ply)
	self.player = ply;
end

function PData:GetData(name)
	return self.data[name];
end

function PData:SetData(name, data, dontSave)
	self.data[name] = data;
	if (!dontSave) then
		self:Save();
	end
end

function PData:GetAllData()
	return self.data;
end

function PData:SetAllData(data, dontSave)
	if (type(data) == "table") then
		self.data = data;
		if (!dontSave) then
			self:Save();
		end
	end
end

function PData:Save()
	SSQL.SavePlayerData(self:GetPlayer());
end

function PData:ToJSON()
	for k,v in pairs(self.data) do
		if (type(v) == "function") then
			self.data[k] = nil;
		end
	end

	return util.TableToJSON(self.data);
end

function PData:FromJSON(json)
	if (type(json) == "string") then
		local tab = util.JSONToTable(json);
		if (tab) then
			self.data = tab;
		end
	end
end

function PData:Remove()
	for i,pd in pairs(PData.instances) do
		if (pd == self) then
			pd[i] = nil;
			self = nil;
		end
	end
end