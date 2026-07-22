#pragma once

#include <MinHook.h>
#include "logging.h"

#define MAKE_HOOK(r, n, p, c) \
	typedef r (*n) p; \
	n n ## _Call = nullptr; \
	r n ## _Fn p c \
	hooking::Hook<n> n ## _Hook( &n ## _Fn, &n ## _Call ); \

#define INSTALL_AND_ENABLE(n, a, fm, sm) \
	if (!n ## _Hook.install(reinterpret_cast<void**>(a)) || !n ## _Hook.enable()) { \
		fm; \
	} \
	else { \
		sm; \
	}

#define INSTALL_HOOK(n, a) \
	INSTALL_AND_ENABLE( \
		n, \
		a, \
		FATAL("Failed to install/enable hook for " #n), \
		DEBUG("Installed hook for " #n) \
	); \

namespace hooking {
	template<typename T>
	class Hook {
		void* _target = nullptr;
		void* _detour = nullptr;
		T* _original = nullptr;

	public:
		Hook() {}

		template<typename T>
		Hook(void* detour, T* original) {
			_detour = detour;
			_original = original;
		}

		bool install(void* target) {
			_target = target;
			const MH_STATUS status = MH_CreateHook(_target, _detour, reinterpret_cast<void**>(_original));
			return (status == MH_OK);
		}

		bool enable() {
			return MH_EnableHook(_target) == MH_OK;
		}

		bool disable() {
			return MH_DisableHook(_target) == MH_OK;
		}
	};
}
