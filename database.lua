local _, ns = ...
local gsub = string.gsub
local Player = ns.wow.Player

ns:registerCommand("list", "", function(self)
  ns.Print("Characters:")
  for n,_ in pairs(ns.db.characters) do
    print(n)
  end
  ns.Print("done")
end, "List all characters")

ns:registerCommand("delete", "", function(self, args)
  ns.db.characters[args] = nil
  ns.db.numCharacters = ns.db.numCharacters - 1
  ns.Print(args .. " deleted.")
end, "Delete a character")

---@class Character
---@field name string
---@field classId string
---@field classKey string
---@field race string
---@field raceId string
---@field raceIdx integer
---@field isAlliance boolean
---@field realm string
---@field IsLegionTimerunner boolean

function ns:onLogin()
  self.currentPlayer = Player:GetName()
  local c = self.db.characters[self.currentPlayer]
  if not c then
    -- initialize new character
    c = {}
    self.db.characters[self.currentPlayer] = c
    self.db.numCharacters = self.db.numCharacters + 1
    c.name = self.currentPlayer
    c.classId = Player:GetClassId()
    c.className = Player:GetClassName()
    c.classKey = gsub(c.className, " ", "")
    local raceFile, raceId = Player:GetRace()
    c.race = raceFile
    c.raceId = raceId
    local raceIndex, isAlliance = ns.NormalizeRaceId(raceId)
    c.raceIdx = raceIndex
    c.isAlliance = isAlliance
    c.realm = GetRealmName()
  end
  self.currentData = c
  c.IsLegionTimerunner = PlayerIsTimerunning() and C_TimerunningUI.GetActiveTimerunningSeasonID() == 2

  self:InitBrokers()
end
