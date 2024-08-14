local GCDEBUG = false

GuildCheck = LibStub("AceAddon-3.0"):NewAddon("GuildCheck", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GuildCheck")
local LG = "LibGuild-1.0"
local guildcheckLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("GuildCheck", {
            type = "launcher",
	        text = "GuildCheck",
            tocname = "GuildCheck",
            icon = "Interface\\AddOns\\GuildCheck\\GuildCheck.tga",
            OnClick = function(self, button)
        if (button == "LeftButton") then
		      GuildCheckGui:Show(true)
	    elseif (button == "RightButton") then
		   InterfaceOptionsFrame_OpenToCategory("GuildCheck") 
                end
            end,
            OnTooltipShow = function(tooltip)
                tooltip:AddLine('Guild Check')
                tooltip:AddLine('|cffffff00Left click for Gui Display')
                tooltip:AddLine('|cffffff00Right Click for Interface Panel')
            end,
        })

local icon = LibStub("LibDBIcon-1.0")
        
GuildCheck.version = C_AddOns.GetAddOnMetadata("GuildCheck", "Version")

--[===[@debug@
GuildCheck.version = "v2.35"
--@end-debug@]===]

StaticPopupDialogs["GUILDCHECK_DELETEGUILD"] = {
  text = L["It seems that your last character has left this guild.\nDo you want to delete the data that GuildCheck has saved for this guild?"],
  button1 = L["Yes"],
  button2 = L["No"],
  OnAccept = function()
		GuildCheck:DeleteGuild()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 0
}

StaticPopupDialogs["GUILDCHECK_CONVERTDATA"] = {
  text = L["Your GuildCheck Data needs a conversion! This process is not reversible.\nYou can choose 'No' and backup your SavedVariables folder.\nGuildCheck won't work as long as you don't convert the data.\n\nDo you want to convert the data now?"],
  button1 = L["Yes"],
  button2 = L["No"],
  OnAccept = function()
		GuildCheck:ConvertData()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 0
}

local options = {
	name = "GuildCheck",
	handler = GuildCheck,
	type = "group",
	args = {
		gui = {
			type = "toggle",
			name = L["Use GUI"],
			desc = L["Defines whether the changes are diplayed in the chat or in the GUI on login."],
			get = "IsShowGui",
			set = "ToggleShowGui",
			order = 10,
			width = "full"
		},
		useGuildLog = {
			type = "toggle",
			name = L["Use Guild Log"],
			desc = L["Use Data from the Guild Log to show who has invited, promoted, demoted or kicked players.\n\n|cffff0000The output can lag a bit.|r"],
			get = "IsUseGuildLog",
			set = "ToggleUseGuildLog",
			order = 20,
			width = "full"
		},
		hideNoChanges = {
			type = "toggle",
			name = L["Output/Display only on changes"],
			desc = L["Show Text/GUI only if changes occurred."],
			get = "IsHideNoChanges",
			set = "ToggleHideNoChanges",
			order = 30,
			width = "full"
		},
        useChannel = {
			type = "toggle",
			name = L["Change Output Channel to Whisper"],
			desc = L["Defines whether the changes are diplayed in the default Chat or Whisper to Player."],
			get = "IsUseChannel",
			set = "ToggleUseChannel",
			order = 40,
			width = "full"
		},
        minimap = {
			type = "toggle",
			name = L["Minimap Button"],
			desc = L["Hides Minimap Button."],
			get = "IsShowMinimap",
			set = "ToggleShowMinimap",
			order = 50,
			width = "full"
		},
		delay = {
			type = "range",
			name = L["Delay"],
			desc = L["Defines the seconds after login until the changes are reported."],
			min = 5,
			max = 60,
			step = 1,
			get = "GetDelay",
			set = "SetDelay",
			order = 60,
			width = "full"
		},
		display = {
			name = L["Display"],
			desc = L["Defines what kind of changes will be shown."],
			type = "group",
			args = {
				join = {
					type = "toggle",
					name = L["Members join"],
					desc = L["Show if someone has joined the guild."],
					get = "IsShowMembersJoin",
					set = "ToggleShowMembersJoin",
					order = 10
				},
				left = {
					type = "toggle",
					name = L["Members leave"],
					desc = L["Show if someone has left the guild."],
					get = "IsShowMembersLeave",
					set = "ToggleShowMembersLeave",
					order = 20
				},
				rank = {
					type = "toggle",
					name = L["Rank"],
					desc = L["Show Promotes/Demotes"],
					get = "IsShowRank",
					set = "ToggleShowRank",
					order = 30
				},
				level = {
					type = "toggle",
					name = L["Level"],
					desc = L["Show Level Ups"],
					get = "IsShowLevel",
					set = "ToggleShowLevel",
					order = 40
				},
				note = {
					type = "toggle",
					name = L["Note"],
					desc = L["Show Note Changes"],
					get = "IsShowNote",
					set = "ToggleShowNote",
					order = 50
				},
				officernote = {
					type = "toggle",
					name = L["Officernote"],
					desc = L["Show Officernote Changes"],
					get = "IsShowOfficernote",
					set = "ToggleShowOfficernote",
					order = 60
				},
			}
		},
		show = {
			type = "execute",
			name = L["Show GUI"],
			desc = L["Shows a frame where you can display and copy changes."],
			func = "ShowGui",
			order = 70
		},
		offline = {
			type = "execute",
			name = L["Show Offline Changes"],
			desc = L["Shows changes since last session."],
			func = function()
				GuildCheck:ShowChanges(false)
			end,
			order = 80
		},
		online = {
			type = "execute",
			name = L["Show Online Changes"],
			desc = L["Shows changes during this session."],
			func = function()
				GuildCheck:ShowChanges(true)
			end,
			order = 90
		},
		config = {
			type = "execute",
			name = L["Open Config"],
			desc = L["Opens a graphical configuration."],
			func = function()
				InterfaceOptionsFrame_OpenToCategory(GuildCheck.optionsFrame)
			end,
			guiHidden = true,
			order = 100
		}
	}
}

local optionsDefaults = {
	profile = {
		gui = true,
        minimap = {
			hide = false,
        },
		delay = 5,
		useGuildLog = true,
		hideNoChanges = false,
        useChannel = false,
		showMembersJoin = true,
		showMembersLeave = true,
		showRank = true,
		showLevel = true,
		showNote = true,
		showOfficernote = true
	},
	realm = {
		guildChars = {},
		guildData = {}
	},
	global = {
		GuildCheckVersion = GuildCheck.version
	}
}

local changes = {
	offline = {
		count = 0,
		chars = {}
	},
	online = {
		count = 0,
		chars = {}
	}
}

function GuildCheck:OnInitialize()
	self:Debug("OnInitialize()")
	if self:NeedConversion() then
		self.converting = true
		self:ConvertData()
		--StaticPopup_Show("GUILDCHECK_CONVERTDATA")
	else
		self:Init()
	end
end

function GuildCheck:Init()
	self.db = LibStub("AceDB-3.0"):New("GCDB", optionsDefaults, "Default")
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("GuildCheck", options, {"egc", "guildcheck"})
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("GuildCheck", "GuildCheck")
    
    -- LDB Minimap Icon --
    
    icon:Register("GuildCheck", guildcheckLDB, self.db.profile.minimap)
    self:RegisterChatCommand("guildcheck", "ToggleShowMinimap")
    
      -- About panel--
    
    if (LibStub:GetLibrary("LibAboutPanel", true)) then
	    LibStub("LibAboutPanel").new("GuildCheck", "GuildCheck")
    else
		self:Print("Lib AboutPanel not loaded.")
    end
    
	self.faction, _ = UnitFactionGroup("player")
    
end

function GuildCheck:OnEnable()
	self:Debug("OnEnable()")
	
	if IsInGuild() and not self.converting then
		if self:IsUseGuildLog() then
			self:RegisterEvent("GUILD_EVENT_LOG_UPDATE")
		end
		LibStub(LG):RegisterCallback("Update", function() GuildCheck:ScanGuild() end)
		LibStub(LG):RegisterCallback("Joined", function() GuildCheck:JoinedGuild() end)
		LibStub(LG):RegisterCallback("Left", function() GuildCheck:LeftGuild() end)
	elseif not self.converting then
		self:RemovePlayerFromGuilds()
	end
end

function GuildCheck:OnDisable()
	self:Debug("OnDisable()")
	
	self:UnregisterEvent("GUILD_EVENT_LOG_UPDATE")
	LibStub(LG):UnregisterAll()
end

function GuildCheck:IsShowGui()
	self:Debug("IsShowGui()")
	return self.db.profile.gui
end

function GuildCheck:ToggleShowGui(info)
	self:Debug("ToggleShowGui()")
	self.db.profile.gui = not self.db.profile.gui
	return self.db.profile.gui
end

function GuildCheck:IsUseGuildLog()
	self:Debug("IsUseGuildLog()")
	return self.db.profile.useGuildLog
end

function GuildCheck:ToggleUseGuildLog(info)
	self:Debug("ToggleUseGuildLog()")
	self.db.profile.useGuildLog = not self.db.profile.useGuildLog
	return self.db.profile.useGuildLog
end

function GuildCheck:IsHideNoChanges()
	self:Debug("IsHideNoChanges()")
	return self.db.profile.hideNoChanges
end

function GuildCheck:ToggleHideNoChanges(info)
	self:Debug("ToggleHideNoChanges()")
	self.db.profile.hideNoChanges = not self.db.profile.hideNoChanges
	return self.db.profile.hideNoChanges
end

function GuildCheck:IsUseChannel()
	self:Debug("IsUseChannel()")
	return self.db.profile.useChannel
end

function GuildCheck:ToggleUseChannel()
	self:Debug("ToggleUseChannel()")
	self.db.profile.useChannel = not self.db.profile.useChannel
	return self.db.profile.useChannel
end

function GuildCheck:IsShowMinimap()
	self:Debug("IsShowMinimap()")
	return self.db.profile.minimap.hide
end

function GuildCheck:ToggleShowMinimap()
    self:Debug("ToggleShowMinimap()")
	self.db.profile.minimap.hide = not self.db.profile.minimap.hide
	if self.db.profile.minimap.hide then
		icon:Hide("GuildCheck")
	else
		icon:Show("GuildCheck")
	end
end

function GuildCheck:GetDelay()
	self:Debug("GetDelay()")
	return self.db.profile.delay
end

function GuildCheck:SetDelay(info, newValue)
	self:Debug("SetDelay()")
	self.db.profile.delay = newValue
end

function GuildCheck:IsShowMembersJoin()
	self:Debug("IsShowMembersJoin()")
	return self.db.profile.showMembersJoin
end

function GuildCheck:ToggleShowMembersJoin(info)
	self:Debug("ToggleShowMembersJoin()")
	self.db.profile.showMembersJoin = not self.db.profile.showMembersJoin
	return self.db.profile.showMembersJoin
end

function GuildCheck:IsShowMembersLeave()
	self:Debug("IsShowMembersLeave()")
	return self.db.profile.showMembersLeave
end

function GuildCheck:ToggleShowMembersLeave(info)
	self:Debug("ToggleShowMembersLeave()")
	self.db.profile.showMembersLeave = not self.db.profile.showMembersLeave
	return self.db.profile.showMembersLeave
end

function GuildCheck:IsShowRank()
	self:Debug("IsShowRank()")
	return self.db.profile.showRank
end

function GuildCheck:ToggleShowRank(info)
	self:Debug("ToggleShowRank()")
	self.db.profile.showRank = not self.db.profile.showRank
	return self.db.profile.showRank
end

function GuildCheck:IsShowLevel()
	self:Debug("IsShowLevel()")
	return self.db.profile.showLevel
end

function GuildCheck:ToggleShowLevel(info)
	self:Debug("ToggleShowLevel()")
	self.db.profile.showLevel = not self.db.profile.showLevel
	return self.db.profile.showLevel
end

function GuildCheck:IsShowNote()
	self:Debug("IsShowNote()")
	return self.db.profile.showNote
end

function GuildCheck:ToggleShowNote(info)
	self:Debug("ToggleShowNote()")
	self.db.profile.showNote = not self.db.profile.showNote
	return self.db.profile.showNote
end

function GuildCheck:IsShowOfficernote()
	self:Debug("IsShowOfficernote()")
	return self.db.profile.showOfficernote
end

function GuildCheck:ToggleShowOfficernote(info)
	self:Debug("ToggleShowOfficernote()")
	self.db.profile.showOfficernote = not self.db.profile.showOfficernote
	return self.db.profile.showOfficernote
end

function GuildCheck:GUILD_EVENT_LOG_UPDATE()
	self:Debug("GUILD_EVENT_LOG_UPDATE()")
	
	local target, delay
	
	if not self.firstScanLog then
		target = changes.offline
		delay = self:GetDelay() - (time() - self.firstScanTime)
		if delay < 5 then
			delay = 5
		end
		self.firstScanLog = true
	else
		target = changes.online
	end
	
	for name, changes in pairs(target.chars) do
		for i, change in pairs(changes) do
			if change.type == "join" and not change.officer then
				local retOk, _, officer = self:GetOfficer("join", name)
				if retOk then
					change.officer = officer
				else
					change.officer = UNKNOWN
				end
			elseif change.type == "leave" and not change.officer then
				local retOk, type, officer = self:GetOfficer("leave", name)
				if retOk then
					change.officer = officer
				elseif type == "remove" then
					change.officer = UNKNOWN
				else
					change.officer = nil
				end
			elseif change.type == "rank" and not change.officer then
				local retOk, _, officer, isPromoted = self:GetOfficer("rank", name, change.new)
				if retOk then
					change.officer = officer
					if isPromoted then
						change.type = "promote"
					else
						change.type = "demote"
					end
				else
					change.officer = UNKNOWN
				end
			end
		end
	end
	
	if delay then
		if changes.offline.count > 0 or not self:IsHideNoChanges() then
			self:Debug("Delay: " .. self:GetDelay())
			self:ScheduleTimer("ShowChanges", tonumber(delay))
		end
	end
end

function GuildCheck:GetOfficer(type, name, rank)
	for i = GetNumGuildEvents(), 1, -1 do
		local evtype, player1, player2, evrank, year, month, day, hour = GetGuildEventInfo(i);
		if type == "join" and evtype == "invite" and player2 == name then
			return true, "join", player1
		elseif type == "leave" and evtype == "remove" and player2 == name then
			return true, "remove", player1
		elseif type == "leave" and evtype == "quit" and player1 == name then
			return false, "quit"
		elseif type == "rank" and evtype == "promote" and player2 == name and evrank == rank then
			return true, "promote", player1, true
		elseif type == "rank" and evtype == "demote" and player2 == name and evrank == rank then
			return true, "demote", player1, false
		end
	end
	
	return false
end

function GuildCheck:ShowGui(online)
	self:Debug("ShowGui()")
	if not self.gui then
		self:CreateGui()
	end
	self:SetGuiText(online)
	self.gui:Show()
end

function GuildCheck:ShowChanges(online)
	self:Debug("ShowChanges(" .. tostring(online) .. ")")
	if self:IsShowGui() then
		self:ShowGui(online)
	else
		local target
		if online then
			target = changes.online
		else
			target = changes.offline
		end
		
		self:Out(string.format("GuildCheck (%s):", self.version))
		for name, data in pairs(target.chars) do
			self:Out(string.format("  %s:", name))
			for i, change in pairs(data) do
				if change.type == "join" then
					if change.officer then
						self:Out(string.format("    %s", string.format(L["has joined the guild (invited by %s)"], change.officer)))
					else
						self:Out(string.format("    %s", L["has joined the guild"]))
					end
					self:Out(string.format("    %s: %s", L["Rank"], change.rank))
					self:Out(string.format("    %s: %s", L["Level"], change.level))
					self:Out(string.format("    %s: %s", L["Class"], change.class))
					if change.note then
						self:Out(string.format("    %s: %s", L["Note"], change.note))
					end
					if change.onote then
						self:Out(string.format("    %s: %s", L["Officernote"], change.onote))
					end
				elseif change.type == "leave" then
					if change.officer then
						self:Out(string.format("    %s", string.format(L["was removed by %s"], change.officer)))
					else
						self:Out(string.format("    %s", L["has left the guild"]))
					end
					self:Out(string.format("    %s: %s", L["Rank"], change.rank))
					self:Out(string.format("    %s: %s", L["Level"], change.level))
					self:Out(string.format("    %s: %s", L["Class"], change.class))
					if change.note then
						self:Out(string.format("    %s: %s", L["Note"], change.note))
					end
					if change.onote then
						self:Out(string.format("    %s: %s", L["Officernote"], change.onote))
					end
				elseif change.type == "promote" then
					self:Out(string.format("    %s", string.format(L["was promoted by %s"], change.officer)))
					self:Out(string.format("    %s: %s => %s", L["Rank"], change.old, change.new))
				elseif change.type == "demote" then
					self:Out(string.format("    %s", string.format(L["was demoted by %s"], change.officer)))
					self:Out(string.format("    %s: %s => %s", L["Rank"], change.old, change.new))
				else
					local strtext, old, new
					if change.type == "rank" then
						strtext = L["Rank"]
					elseif change.type == "level" then
						strtext = L["Level"]
					elseif change.type == "class" then
						strtext = L["Class"]
					elseif change.type == "note" then
						strtext = L["Note"]
					elseif change.type == "onote" then
						strtext = L["Officernote"]
					end
					if change.type == "class" then
						old = change.old
						new = change.new
					else
						old = change.old or ""
						new = change.new or ""
					end
					self:Out(string.format("    %s: %s => %s", strtext, old, new))
				end
			end
		end
		
		if target.count > 1 then
			self:Out(string.format(L["Total: %d changes"], target.count))
		elseif target.count == 1 then
			self:Out(L["Total: 1 change"])
		else
			self:Out(L["no changes found"])
		end
	end
end

function GuildCheck:ScanGuild()
	self:Debug("ScanGuild()")
	if IsInGuild() and not self.scanning then
		self.scanning = true
		self.updatetime = time()
         
         if not self.guild then self.guild = GetGuildInfo("player") end
           if not self.guild then
            self:Debug("ScanGuild():No Guild String, bailing...")
            return
         end
         if not self.guildstring then
             self.guildstring = self.faction .. ":" .. self.guild
         end
		if not self.db.realm.guildChars[self.guildstring] then
			self.db.realm.guildChars[self.guildstring] = {}
		end
		self:AddPlayerToGuild()
		
		if not self.db.realm.guildData[self.guildstring] then
			self.db.realm.guildData[self.guildstring] = {}
			for name in LibStub(LG):GetIterator("NAME", true) do
				local member = {
					rank		= LibStub(LG):GetRank(name),
					level		= LibStub(LG):GetLevel(name),
					class		= self:ConvertEnglishClass(select(2, LibStub(LG):GetClass(name))),
					note		= LibStub(LG):GetNote(name),
					update	= self.updatetime
				}
				if C_GuildInfo.CanViewOfficerNote() then
					member.onote = LibStub(LG):GetOfficerNote(name)
				end
				self.db.realm.guildData[self.guildstring][name] = member
			end
			self:Out("GuildCheck: " .. L["Initial scan done."])
			
		else
			for name in LibStub(LG):GetIterator("NAME", true) do
				if not self.db.realm.guildData[self.guildstring][name] then
					self:AddMember(name)
				else
					local member = self.db.realm.guildData[self.guildstring][name]
					local rank = LibStub(LG):GetRank(name)
					local level = LibStub(LG):GetLevel(name)
					local class = self:ConvertEnglishClass(select(2, LibStub(LG):GetClass(name)))
					local note = LibStub(LG):GetNote(name)
					local onote = LibStub(LG):GetOfficerNote(name)
					if member.rank ~= rank then
						self:AddChange("Rank", name, rank)
						member.rank = rank
					end
					if member.level ~= level then
						self:AddChange("Level", name, level)
						member.level = level
					end
					if member.class ~= class then
						self:AddChange("Class", name, class)
						member.class = class
					end
					if member.note ~= note then
						self:AddChange("Note", name, note)
						member.note = note
					end
					if C_GuildInfo.CanViewOfficerNote() and member.onote ~= onote then
						self:AddChange("Officernote", name, onote)
						member.onote = onote
					end
					
					member.update = self.updatetime
				end
			end
			
			for name, data in pairs(self.db.realm.guildData[self.guildstring]) do
				if data.update ~= self.updatetime then
					self:RemoveMember(name)
				end
			end
			
		end
		
		self.scanning = false
		
		if not self.firstscan then
			self.firstScanTime = time()
			if not self:IsUseGuildLog() and (changes.offline.count > 0 or not self:IsHideNoChanges()) then
				self:Debug("Delay: " .. self:GetDelay())
				self:ScheduleTimer("ShowChanges", tonumber(self:GetDelay()))
			end
			self.firstscan = true
		end
		
		if self:IsUseGuildLog() then
			QueryGuildEventLog()
		end
	end
end

function GuildCheck:AddPlayerToGuild()
	self:Debug("AddPlayerToGuild()")
	local name = UnitName("player")
	for i, player in pairs(self.db.realm.guildChars[self.guildstring]) do
		if player == name then
			return true
		end
	end
	table.insert(self.db.realm.guildChars[self.guildstring], name)
	return true
end

function GuildCheck:RemovePlayerFromGuilds()
	self:Debug("RemovePlayerFromGuilds()")
	local found = false
	local player = UnitName("player")
	for guildstring, chars in pairs(self.db.realm.guildChars) do
		if string.match(guildstring, "^" .. self.faction .. ":") then
			for i, name in pairs(chars) do
				if player == name then
					table.remove(self.db.realm.guildChars[guildstring], i)
					if #self.db.realm.guildChars[guildstring] == 0 then
						StaticPopup_Show("GUILDCHECK_DELETEGUILD")
					end
					found = true
					
					break
				end
			end
		end
		if found then
			break
		end
	end
end

function GuildCheck:AddMember(name)
	self:Debug("AddMember(" .. name .. ")")
	if self.guildstring then
		
		self:AddChange("add", name)
		local member = {
			rank		= LibStub(LG):GetRank(name),
			level		= LibStub(LG):GetLevel(name),
			class		= self:ConvertEnglishClass(select(2, LibStub(LG):GetClass(name))),
			note		= LibStub(LG):GetNote(name),
			update	= self.updatetime
		}
		if C_GuildInfo.CanViewOfficerNote() then
			member.onote = LibStub(LG):GetOfficerNote(name)
		end
		self.db.realm.guildData[self.guildstring][name] = member
		
	end
end

function GuildCheck:RemoveMember(name)
	self:Debug("RemoveMember(" .. name .. ")")
	if self.guildstring then
		
		self:AddChange("remove", name)
		self.db.realm.guildData[self.guildstring][name] = nil
		
	end
end

function GuildCheck:AddChange(change, name, newValue)
	self:Debug("AddChange(" .. change .. ", " .. name .. ", " .. tostring(newValue) .. ")")
	local target
	if not self.firstscan then
		target = changes.offline
	else
		target = changes.online
	end
	
	if change == "add" then
		if self:IsShowMembersJoin() then
			local member = {
				type = "join",
				time = time(),
				rank = LibStub(LG):GetRank(name),
				level = LibStub(LG):GetLevel(name),
				class = self:ConvertEnglishClass(select(2, LibStub(LG):GetClass(name))),
				note = LibStub(LG):GetNote(name),
			}
			if C_GuildInfo.CanViewOfficerNote() then
				member.onote = LibStub(LG):GetOfficerNote(name)
			end
			target.chars[name] = {
				member
			}
		end
		
	elseif change == "remove" then
		if self:IsShowMembersLeave() then
			local member = self.db.realm.guildData[self.guildstring][name]
			local showmember = {
				type = "leave",
				time = time(),
				rank = member.rank,
				level = member.level,
				class = member.class,
				note = member.note,
				onote = member.onote
			}
			if C_GuildInfo.CanViewOfficerNote() then
				showmember.onote = member.onote
			end
			target.chars[name] = {
				showmember
			}
		end
		
	elseif C_GuildInfo.CanViewOfficerNote() and change == "Officernote" then
		if self:IsShowOfficernote() then
			local member = self.db.realm.guildData[self.guildstring][name]
			if not target.chars[name] then
				target.chars[name] = {}
			end
			table.insert(target.chars[name], {
				type = "onote",
				time = time(),
				old = member.onote,
				new = newValue
			})
		end
		
	else
		local show
		if change == "Rank" then
			show = self:IsShowRank()
		elseif change == "Level" then
			show = self:IsShowLevel()
		elseif change == "Note" then
			show = self:IsShowNote()
		else
			show = true
		end
		
		if show then
			local member = self.db.realm.guildData[self.guildstring][name]
			if not target.chars[name] then
				target.chars[name] = {}
			end
			if change == "Class" then
				newValue = newValue
			end
			table.insert(target.chars[name], {
				type = string.lower(change),
				time = time(),
				old = member[string.lower(change)],
				new = newValue
			})
		end
		
	end
	
	target.count = target.count + 1
end
         

function GuildCheck:Out(msg)
	self:Debug("Out()")
    if self.db.profile.useChannel == true then
    ChatThrottleLib:SendChatMessage("ALERT", "GuildCheck", msg, "WHISPER", nil, GetUnitName("player"))
    elseif self.db.profile.useChannel ~= true then
	DEFAULT_CHAT_FRAME:AddMessage(msg, 0, 1, 0)
    end 
end


function GuildCheck:JoinedGuild()
	self:Debug("JoinedGuild()")
	self.scanning = true
	
	self.updatetime = time()
	self.guild = LibStub(LG):GetGuildName()
	self.guildstring = self.faction .. ":" .. self.guild
	
	if not self.db.realm.guildChars[self.guildstring] then
		self.db.realm.guildChars[self.guildstring] = {}
	end
	self:AddPlayerToGuild()
		
	if not self.db.realm.guildData[self.guildstring] then
		self.db.realm.guildData[self.guildstring] = {}
		for name in LibStub(LG):GetIterator("NAME", true) do
			local member = {
				rank		= LibStub(LG):GetRank(name),
				level		= LibStub(LG):GetLevel(name),
				class		= self:ConvertEnglishClass(select(2, LibStub(LG):GetClass(name))),
				note		= LibStub(LG):GetNote(name),
				update	= self.updatetime
			}
			if C_GuildInfo.CanViewOfficerNote() then
				member.onote = LibStub(LG):GetOfficerNote(name)
			end
			self.db.realm.guildData[self.guildstring][name] = member
		end
		self:Out("GuildCheck: " .. L["Initial scan done."])
	end
	
	self.scanning = false
end

function GuildCheck:LeftGuild()
	self:Debug("LeftGuild()")
	if self.db.realm.guildChars[self.guildstring] then
		for i, name in pairs(self.db.realm.guildChars[self.guildstring]) do
			if name == UnitName("player") then
				table.remove(self.db.realm.guildChars[self.guildstring], i)
				break
			end
		end
--check this code for why it randomly pops up--		
		if #self.db.realm.guildChars[self.guildstring] == 0 then
			StaticPopup_Show("GUILDCHECK_DELETEGUILD");
		end
	end
end

function GuildCheck:DeleteGuild()
	self:Debug("DeleteGuild()")
	self.db.realm.guildChars[self.guildstring] = nil
	self.db.realm.guildData[self.guildstring] = nil
	self:Out("GuildCheck: " .. string.format(L["The guild '%s' has been deleted."], self.guild))
	
	self.guild = nil
	self.guildstring = nil
end

function GuildCheck:Debug(msg)
	if GCDEBUG then
		DEFAULT_CHAT_FRAME:AddMessage("GC: " .. msg, 1, 0, 0)
	end
end

function GuildCheck:CreateGui()
	self.gui = CreateFrame("Frame", "GuildCheckGui", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	self.gui:SetPoint("CENTER", "UIParent", "CENTER")
	self.gui:SetClampedToScreen(true)
	self.gui:SetWidth(350)
	self.gui:SetHeight(400)
	self.gui:EnableMouse(true)
	self.gui:SetMovable(true)
	self.gui:SetFrameStrata("HIGH")
	self.gui:RegisterForDrag("LeftButton")
	self.gui:SetScript("OnDragStart", function()
		GuildCheckGui:StartMoving();
	end)
	self.gui:SetScript("OnDragStop", function()
		GuildCheckGui:StopMovingOrSizing();
	end)
  	
	self.gui:SetBackdrop({
		bgFile = [[Interface\TutorialFrame\TutorialFrameBackground]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		tile = true,
		tileSize = 32,
		edgeSize = 16,
		insets = {left = 5, top = 5, right = 5, bottom = 5}
	})
	self.gui:SetBackdropColor(0,0,0,1)
	
	self.gui.bg = CreateFrame("Frame", "GuildCheckGuiBg", self.gui, BackdropTemplateMixin and "BackdropTemplate" or nil)
	self.gui.bg:SetWidth(320)
	self.gui.bg:SetHeight(340)
	self.gui.bg:SetPoint("TOPLEFT", self.gui, "TOPLEFT", 5, -25)
	self.gui.bg:SetBackdrop({
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		tile = true,
		edgeSize = 16,
		tileSize = 16,
		insets = {left = 5, top = 5, right = 5, bottom = 5}
	})
	
    
	self.gui.title = self.gui:CreateFontString(nil, "BACKGROUND", "GameFontGreen")
	self.gui.title:SetWidth(180)
	self.gui.title:SetHeight(12)
	self.gui.title:SetPoint("TOP", self.gui, "TOP", 0, -10)
	self.gui.title:SetText("GuildCheck (" .. self.version .. ")")
	
	self.gui.scroll = CreateFrame("ScrollFrame", "GuildCheckGuiScrollBar", self.gui, "UIPanelScrollFrameTemplate")
	self.gui.scroll:SetWidth(305)
	self.gui.scroll:SetHeight(320)
	self.gui.scroll:SetPoint("TOPLEFT", self.gui, "TOPLEFT", 15, -35)
	
	self.gui.box = CreateFrame("EditBox", "GuildCheckGuiBox", self.gui.scroll)
	self.gui.box:SetMultiLine(true)
	self.gui.box:SetWidth(300)
	self.gui.box:SetHeight(310)
	self.gui.box:SetFocus(false)
	--self.gui.box:SetNonSpaceWrap(true)
	self.gui.box:SetFontObject(GameFontNormal)
	self.gui.box:SetScript("OnTextChanged", function()
	end)

	self.gui.box:SetScript("OnEscapePressed", function(self) 
		GuildCheckGui:Hide() 		     
		 end)
		
	
	self.gui.scroll:SetScrollChild(self.gui.box)
	
	self.gui.offline = CreateFrame("Button", "GuildCheckGuiOnline", self.gui, "UIPanelButtonTemplate")
	self.gui.offline:SetText(L["Offline"])
	self.gui.offline:SetWidth(60)
	self.gui.offline:SetHeight(25)
	self.gui.offline:SetPoint("TOPLEFT", self.gui, "TOPLEFT", 50, -365)
	self.gui.offline:SetScript("OnClick", function(self)
		GuildCheck:SetGuiText(false)
	end)
	
	self.gui.online = CreateFrame("Button", "GuildCheckGuiOffline", self.gui, "UIPanelButtonTemplate")
	self.gui.online:SetText(L["Online"])
	self.gui.online:SetWidth(60)
	self.gui.online:SetHeight(25)
	self.gui.online:SetPoint("TOPLEFT", self.gui, "TOPLEFT", 130, -365)
	self.gui.online:SetScript("OnClick", function(self)
		GuildCheck:SetGuiText(true)
	end)
	
	self.gui.exit = CreateFrame("Button", "GuildCheckGuiExit", self.gui, "UIPanelButtonTemplate")
	self.gui.exit:SetText(L["Exit"])
	self.gui.exit:SetWidth(80)
	self.gui.exit:SetHeight(25)
	self.gui.exit:SetPoint("TOPLEFT", self.gui, "TOPLEFT", 240, -365)
	self.gui.exit:SetScript("OnClick", function(self)
		GuildCheckGui:Hide()
	end)
end

function GuildCheck:SetGuiText(online)
	local target
	if online then
		target = changes.online
	else
		target = changes.offline
	end
	
	local text = "GuildCheck (" .. self.version .. "):\n"
	
	for name, data in pairs(target.chars) do
		text = text .. "  " .. name .. ":\n"
		for i, change in pairs(data) do
			if change.type == "join" then
				if change.officer then
					text = text .. "    " .. string.format(L["has joined the guild (invited by %s)"], change.officer) .. "\n"
				else
					text = text .. "    " .. L["has joined the guild"] .. "\n"
				end
				text = text .. "    " .. L["Rank"] .. ": " .. change.rank .. "\n"
				text = text .. "    " .. L["Level"] .. ": " .. change.level .. "\n"
				text = text .. "    " .. L["Class"] .. ": " .. change.class .. "\n"
				if change.note then
					text = text .. "    " .. L["Note"] .. ": " .. change.note .. "\n"
				end
				if change.onote then
					text = text .. "    " .. L["Officernote"] .. ": " .. change.onote .. "\n"
				end
			elseif change.type == "leave" then
				if change.officer then
					text = text .. "    " .. string.format(L["was removed by %s"], change.officer) .. "\n"
				else
					text = text .. "    " .. L["has left the guild"] .. "\n"
				end
				text = text .. "    " .. L["Rank"] .. ": " .. change.rank .. "\n"
				text = text .. "    " .. L["Level"] .. ": " .. change.level .. "\n"
				text = text .. "    " .. L["Class"] .. ": " .. change.class .. "\n"
				if change.note then
					text = text .. "    " .. L["Note"] .. ": " .. change.note .. "\n"
				end
				if change.onote then
					text = text .. "    " .. L["Officernote"] .. ": " .. change.onote .. "\n"
				end
			elseif change.type == "promote" then
				text = text .. "    " .. string.format(L["was promoted by %s"], change.officer) .. "\n"
				text = text .. "    " .. L["Rank"] .. ": " .. change.old .. " => " .. change.new .. "\n"
			elseif change.type == "demote" then
				text = text .. "    " .. string.format(L["was demoted by %s"], change.officer) .. "\n"
				text = text .. "    " .. L["Rank"] .. ": " .. change.old .. " => " .. change.new .. "\n"
			else
				local strtext, old, new
				if change.type == "rank" then
					strtext = L["Rank"]
				elseif change.type == "level" then
					strtext = L["Level"]
				elseif change.type == "class" then
					strtext = L["Class"]
				elseif change.type == "note" then
					strtext = L["Note"]
				elseif change.type == "onote" then
					strtext = L["Officernote"]
				end
				if change.type == "class" then
					old = change.old
					new = change.new
				else
					old = change.old or ""
					new = change.new or ""
				end
				text = text .. "    " .. strtext .. ": " .. old .. " => " .. new .. "\n"
			end
		end
	end
	
	if target.count > 1 then
		text = text .. string.format(L["Total: %d changes"], target.count)
	elseif target.count == 1 then
		text = text .. L["Total: 1 change"]
	else
		text = text .. L["no changes found"]
	end
	
	self.gui.box:SetFocus()
	self.gui.box:SetText(text)
	if online then
		self.gui.online:Disable()
		self.gui.offline:Enable()
	else
		self.gui.offline:Disable()
		self.gui.online:Enable()
	end
end

       

function GuildCheck:ConvertEnglishClass(class)
	return string.upper(string.sub(class, 1, 1)) .. string.lower(string.sub(class, 2))
end

function GuildCheck:NeedConversion()
	if not GCDB then
		return false
	end
	
	if GCDB and GCDB.realms then
		return true
	end
	
	if not GCDB.global or not GCDB.global.GuildCheckVersion or GCDB.global.GuildCheckVersion < self.version then
		return true
	end
	
	return false
end

function GuildCheck:ConvertData()
	local conversion = false
	
	if GCDB.realms and not GCDB.realm then
		GCDB.global = {
			GuildCheckVersion = "v2.35"
		}
		GCDB.realm = {}
		for realm, data in pairs(GCDB.realms) do
			local realmName = string.sub(string.match(realm, "^(.+) - .+$"), 1, -3)
			if not GCDB.realm[realmName] then
				GCDB.realm[realmName] = {
					guildChars = {},
					guildData = {}
				}
			end
			for guildstring, chars in pairs(data.guildChars) do
				GCDB.realm[realmName].guildChars[guildstring] = {}
				for i, charName in pairs(chars) do
					table.insert(GCDB.realm[realmName].guildChars[guildstring], char)
				end
			end
			for guildstring, chars in pairs(data.guildData) do
				GCDB.realm[realmName].guildData[guildstring] = {}
				for charName, charData in pairs(chars) do
					GCDB.realm[realmName].guildData[guildstring][charName] = {
						class = charData.class,
						level = charData.level,
						rank = charData.rank,
						note = charData.note,
						onote = charData.onote,
						update = charData.update
					}
				end
			end
		end
		GCDB.realms = nil
		
		conversion = true
	end
	
	if not GCDB.global or not GCDB.global.GuildCheckVersion then
		GCDB.global = {
			GuildCheckVersion = "v2.35"
		}
	end
	
	GCDB.global.GuildCheckVersion = self.version
	
	if conversion then
		self:Out(string.format(L["Data upgraded to version %s!"], self.version))
	end

	self.converting = false
	self:Init()
	self:OnEnable()

end

