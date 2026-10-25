here's an example to use lua as library and to turn off demo

LIBRARY MODE
getgenv().NEXUS_NO_DEMO = true
local Library = loadstring(...)()

local Window  = Library:CreateWindow({ Title = "My App" })	  
local Tab     = Window:AddTab("General", "layout-dashboard", "Optional description")	  
local Section = Tab:AddSection("Behaviour")  
Section:AddToggle({ Name = "Enabled", Flag = "enabled", Callback = print })
	  

check the library source for examples
