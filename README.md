# *execRequire*

Put this in your workspace and run it with:

```lua
local execRequire = dofile("execRequire.luau")
```

u can also check if it has already been loaded with:
```lua
local execRequireLoaded = getgenv().EXEC_REQUIRE_LOADED
```


## Docs

### Globals

Variables:

### `EXEC_REQUIRE_LOADED`

A boolean indicating if it has been loaded or not, this exists because `require` is already a function in the environment.

`EXEC_REQUIRE_LOADED: boolean`

Methods:

### `require`

Requires a file or `ModuleScript`.

Falls back on roblox's require if it cannot find a module in the workspace.

`require(module: string | ModuleScript | number): any`