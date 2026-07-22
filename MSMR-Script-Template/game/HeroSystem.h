#pragma once

#include "Native.h"
#include "Actor.h"
#include "ActorHandle.h"

class HeroSystem {
    void** vftable;
    char _0x8[0x14];
    ActorHandle hero_handle;

public:
    inline Actor* GetHero() {
        return GetActor(&hero_handle);
    }
};

MSMRSCRIPTSDK_API HeroSystem* GetHeroSystem();

DECLARE_NATIVE(HeroSystem,
)
