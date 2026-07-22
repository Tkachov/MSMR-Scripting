#pragma once

#include "Native.h"
#include "ActorHandle.h"
#include "Transform.h"

class Actor {
    Transform* transform;
    char _0x8[176];

public:
    inline Vector3& GetPosition() {
        if (transform)
            return transform->GetPosition();

        static Vector3 invalid = Vector3 { -1e6, -1e6, -1e6 };
        return invalid;
    }

    inline Transform* GetTransform() {
        return transform;
    }
};

DECLARE_NATIVE_FUNC(Actor, GetActor, ::Actor*, (ActorHandle*))

DECLARE_NATIVE(Actor,
    MEMBER(GetActor)
)

MSMRSCRIPTSDK_API Actor* GetActor(ActorHandle* handle);
