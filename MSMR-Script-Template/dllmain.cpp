#include "game/Actor.h"
#include "game/HeroSystem.h"
#include "game/Transform.h"

#include <Windows.h>
#include <thread>


BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    return TRUE;
}

extern "C" __declspec(dllexport) void script_enable() {
    std::thread subthread = std::thread([]() {
        while (true) {
            bool forward = false;
            bool back = false;
            bool left = false;
            bool right = false;
            bool up = false;
            bool down = false;
            bool any_pressed = false;

            do {
                Sleep(100);

                forward = (GetAsyncKeyState(VK_NUMPAD8) & 0x1);
                back = (GetAsyncKeyState(VK_NUMPAD2) & 0x1);
                left = (GetAsyncKeyState(VK_NUMPAD4) & 0x1);
                right = (GetAsyncKeyState(VK_NUMPAD6) & 0x1);
                up = (GetAsyncKeyState(VK_NUMPAD9) & 0x1);
                down = (GetAsyncKeyState(VK_NUMPAD3) & 0x1);
                any_pressed = (forward || back || left || right || up || down);
            } while (!any_pressed);

            HeroSystem* system = GetHeroSystem();
            if (!system) {
                printf("no system\n");
                continue;
            }

            Actor* hero = system->GetHero();
            if (!hero) {
                printf("no hero\n");
                continue;
            }

            Transform* transform = hero->GetTransform();
            if (!transform) {
                printf("no transform\n");
                continue;
            }

            Vector3& position = transform->GetPosition();
            if (forward) position.x += 10.f;
            if (back) position.x -= 10.f;
            if (left) position.z += 10.f;
            if (right) position.z -= 10.f;
            if (up) position.y += 10.f;
            if (down) position.y -= 10.f;
        }
    });
    subthread.detach();
}
