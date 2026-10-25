<img width="961" height="769" alt="image" src="https://github.com/user-attachments/assets/03ce4a42-fc1f-483b-b5df-5a275fafbe78" />




here's an example to use lua as library and to turn off demo

getgenv().NEXUS_NO_DEMO = true
local Library = loadstring(...)()
local Window  = Library:CreateWindow({ Title = "My App" })	  
local Tab     = Window:AddTab("General", "layout-dashboard", "Optional description")	  
local Section = Tab:AddSection("Behaviour")  
Section:AddToggle({ Name = "Enabled", Flag = "enabled", Callback = print })
	  

check the library source for examples
