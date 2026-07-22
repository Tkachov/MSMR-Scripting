#pragma once

#include "Native.h"

struct Vector3 {
    float x, y, z;

    Vector3(): x(0), y(0), z(0) {}
    Vector3(float x, float y, float z): x(x), y(y), z(z) {}

    Vector3 operator+(const Vector3& other) const {
        return Vector3(x + other.x, y + other.y, z + other.z);
    }

    Vector3 operator-(const Vector3& other) const {
        return Vector3(x - other.x, y - other.y, z - other.z);
    }

    Vector3 operator*(float scalar) const {
        return Vector3(x * scalar, y * scalar, z * scalar);
    }

    Vector3& operator+=(const Vector3& other) {
        x += other.x;
        y += other.y;
        z += other.z;
        return *this;
    }

    Vector3& operator-=(const Vector3& other) {
        x -= other.x;
        y -= other.y;
        z -= other.z;
        return *this;
    }
};

inline Vector3 operator*(float scalar, const Vector3& v) {
    return v * scalar;
}

struct Transform {
    char _0x0[0x30];
    Vector3 position;

    inline Vector3& GetPosition() {
        return position;
    }
};
