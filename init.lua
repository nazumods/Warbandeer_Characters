-- luacheck: globals LibNAddOn LibNUI WarbandeerApi
local ns = LibNAddOn(...)

function ns:MigrateDB()
  if ns.db.version == 6 then return end
  local db = ns.db
  if not db.characters then db.characters = {} end
  if not db.numCharacters then
    local n = 0
    for _ in pairs(db.characters) do n = n + 1 end
    db.numCharacters = n
  end
  for _,c in pairs(db.characters) do
    if not c.basic then
      c.basic = {
        level = c.level,
        specialization = {
          primary = c.specialization,
          active = c.specializationActive,
          role = c.role,
        },
        professions = {
          primary = c.prof1,
          secondary = c.prof2,
          fishing = c.fishing,
          cooking = c.cooking,
        },
      }
    end
    if not c.basic.level then c.basic.level = 1 end
    if not c.instances then
      c.instances = { locks = c.locks or {} }
    end
    c.level = nil
    c.locks = nil
    c.specialization = nil
    c.specializationActive = nil
    c.role = nil
    c.prof1 = nil
    c.prof2 = nil
    c.fishing = nil
    c.cooking = nil
  end
  db.version = 6
end
