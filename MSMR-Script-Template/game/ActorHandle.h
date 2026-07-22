#pragma once

#include <cstdint>

class ActorHandle {
private:
    uint32_t handle = 0;

public:
    bool operator==(ActorHandle& other) { return handle == other.handle; }
};
