# *execRequire*

Put this in your workspace and run it with:

```lua
local execRequire = dofile("execRequire.luau")
```

u can also check if it has already been loaded with:
```lua
local execRequireLoaded = getgenv().EXEC_REQUIRE_LOADED
or
local execRequireLoaded = EXEC_REQUIRE_LOADED
```

## Docs

### `EXEC_REQUIRE_LOADED`

`EXEC_REQUIRE_LOADED: boolean`

A boolean indicating if it has been loaded or not, this exists because `require` is already a function in the environment.

---

### `require`

`require(module: string | ModuleScript | number): any`

Requires a file or `ModuleScript`.

Falls back on roblox's require if it cannot find a module in the workspace.

⚠ WARNING: This function is VERY verbose, always call with `pcall` if you are unsure.

❕ NOTE: Any files required with this function will have their thread identity reset. Its a good idea to call `setthreadidentity` on the top of your file before requiring it. As far as i know this is undocumented behavior.