#include "Native.h"
#include "Actor.h"
#include "HeroSystem.h"
#include "../logging.h"

#define INIT_NATIVE(s) \
    DEBUG(#s); \
    Native::Initializers::s::Init(); \
    DEBUG("------");

void Native::Init() {
    INIT_NATIVE(HeroSystem);
    INIT_NATIVE(Actor);
}
