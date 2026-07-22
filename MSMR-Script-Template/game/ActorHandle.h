#pragma once

#include <cstdint>

class ActorHandle {
private:
    uint32_t _handle = 0;

public:
    bool operator==(ActorHandle& other) { return _handle == other._handle; }
};
