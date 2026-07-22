#include "HeroSystem.h"

#include <string>
#include "../utils.h"

HeroSystem* GetHeroSystem() {
    // position-dependent =\

    const std::string module_name = utils::get_game_executable();
    const HMODULE handle = GetModuleHandleA(module_name.c_str());
    const uintptr_t base = (uintptr_t)handle;
    return (HeroSystem*)(base + 0x5D9DD00); // 4.630.0.0
}
