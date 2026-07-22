#pragma once

#include "Native.h"
#include "Actor.h"
#include "ActorHandle.h"

class HeroSystem {
    void** _vftable;
    char _0x8[0x14];
    ActorHandle _hero_handle;

public:
    inline Actor* GetHero() {
        return GetActor(&_hero_handle);
    }
};

MSMRSCRIPTSDK_API HeroSystem* GetHeroSystem();

DECLARE_NATIVE(HeroSystem,
)
