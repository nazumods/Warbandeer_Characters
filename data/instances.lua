local _, ns = ...

ns:registerCommand("refresh", "locks", function(self)
  self:refreshLocks()
  self.Print("instance locks refreshed.")
end)

ns:registerCommand("dump", "locks", function(self)
  if ns.currentData.locks then
    ns.Print("Instance locks:")
    for id,i in pairs(ns.currentData.locks) do
      for d,l in pairs(i) do
        print(l.name, id, d, l.progress.."/"..l.total)
      end
    end
  else
    ns.Print("No instance locks found.")
  end
end)

---@type Broker
ns.Instances = ns:RegisterBroker("instances")
ns.Instances.fields = {
  locks = {
    resetOn = ns.RESET_WEEKLY,
    get = function()
      local locks = {}
      local time = GetServerTime()
      local numLocks = GetNumSavedInstances()
      for i=1,numLocks do 
        local name, _, resetSeconds, difficultyId, locked, extended, _, isRaid,
          _, _, numEncounters, encounterProgress, _, instanceID = GetSavedInstanceInfo(i)
        if locked then
          if not locks[instanceID] then locks[instanceID] = {} end
          locks[instanceID][difficultyId] = {
            name = name,
            total = numEncounters,
            progress = encounterProgress,
            reset = time + resetSeconds,
            extended = extended,
            isRaid = isRaid,
          }
        end
      end
      return locks
    end,
    event = "INSTANCE_LOCK_STOP",
  },
}
