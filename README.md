
# 🌀 Lithe-DrugSystem Setup Guide 🌀

Thank you for downloading **lithe-drugsystem**! This guide will help you set up the necessary items for your **FiveM** resource. Follow the instructions below to get everything up and running.

---

## 📄 Introduction

To use the complete resource, you need to configure the items in **ox_inventory**. This involves editing specific files and adding the appropriate code snippets.

---

## 🛠️ Setup Instructions

### Step 1: Edit `modules/items/client.lua`

Add the following code to `modules/items/client.lua` to set up the item interactions:

```lua
Item('banana_kush', function(data, slot)
    TriggerEvent("drugsystem:smokeeffect")
end)

Item('joint', function(data, slot)
    TriggerEvent("drugsystem:smokeeffect")
end)

Item('lsd_paper', function(data, slot)
    TriggerEvent("drugsystem:pilleffect")
end)

Item('heroin', function(data, slot)
    TriggerEvent("drugsystem:smokeeffect")
end)

Item('meth', function(data, slot)
    TriggerEvent("drugsystem:pilleffect")
end)

Item('lean', function(data, slot)
    TriggerEvent("drugsystem:drinkeffect")
end)

Item('illegal_joint', function(data, slot)
    TriggerEvent("drugsystem:smokeeffect")
end)

```
### Add the following item definitions to `data/items.lua `
```lua
['banana_kush'] = {
    label = 'Banana Kush',
    description = "With this stuff you'll have a crazyyy high",
    weight = 10,
    stack = true,
    close = true,
    consume = 0,
},

['joint'] = {
    label = 'Regwood Kush',
    description = "With this stuff you'll have a crazyyy high",
    weight = 10,
    stack = true,
    close = true,
    consume = 0,
},

['illegal_joint'] = {
    label = 'Regwood Kush Illegal',
    description = "With this stuff you'll have a crazyyy high (But you can get arrested)",
    weight = 10,
    stack = true,
    close = true,
    consume = 0,
},

['lsd_paper'] = {
    label = 'LSD Blotters',
    description = "With this stuff you'll have a crazyyy high",
    weight = 10,
    stack = true,
    close = true,
    consume = 0,
},

['heroin'] = {
    label = 'Heroin tablets',
    description = "With this stuff you'll have a crazyyy high",
    weight = 15,
    stack = true,
    close = true,
    consume = 0,
},

['meth'] = {
    label = 'Methamphetamine tablets',
    description = "With this stuff you'll have a crazyyy high",
    weight = 15,
    stack = true,
    close = true,
    consume = 0,
},

['lean'] = {
    label = 'Lean in cup',
    description = "With this stuff you'll have a crazyyy high",
    weight = 20,
    stack = true,
    close = true,
    consume = 0,
},
```
