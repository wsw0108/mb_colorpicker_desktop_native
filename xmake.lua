add_rules("mode.debug", "mode.release")

set_languages("cxx17")
set_warnings("all", "all")
-- set_warnings("all", "error")

if is_plat("windows", "mingw") then
target("ColorPicker")
    set_kind("binary")
    add_files("src/*.cxx", "src/Windows/*.cxx")
    on_load("xxd")
    add_includedirs("src", "src/Windows")
    -- add_rules("platform.windows")
    -- add_rules("win.sdk.application")
    -- add_rules("win.sdk.mfc.static_app")
    add_defines("OS_WINDOWS", "UNICODE", "RELEASE")
    -- add_cxxflags("/Zi")
    add_links("kernel32", "user32", "gdi32", "ole32")
    if is_plat("mingw") then
        add_links("gdiplus", "windowscodecs")
    end
end

if is_plat("macosx") then
target("ColorPicker")
    set_kind("binary")
    add_files("src/*.cxx", "src/macOS/*.cxx", {cxflags = "-x objective-c++"})
    on_load("xxdmac")
    add_includedirs("src", "src/macOS")
    add_defines("OS_MACOS", "RELEASE")
    add_cxflags("-mmacosx-version-min=10.11")
    -- add_cxflags("-x objective-c++")
    add_frameworks("AppKit", "IOKit")
end
