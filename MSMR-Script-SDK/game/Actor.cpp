#include "Actor.h"

SCAN_NATIVE(Actor, GetActor, "44 8B 01 41 8B D0 C1 EA 14 81 E2 FF 07 00 00 74 ?? 41 81 E0 FF FF 0F 00 4B 8D 0C ?? 48 C1 E1 06 48 03 0D ?? ?? ?? ?? 44 3B 05 ?? ?? ?? ?? 73 ?? 0F B7 41 ?? 3B D0 74 ?? 33 C9 48 8B C1")

Actor* GetActor(ActorHandle* handle) {
    return Native::Actor::GetActor(handle);
}
