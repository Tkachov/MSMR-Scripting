#pragma once

#include <Windows.h>

namespace scan {
	struct Pattern {
		char* pattern;
		char* mask;
		int len;

		bool operator<(const Pattern& other) const {
			if (len != other.len) {
				return len < other.len;
			}

			for (int i = 0; i < len; i++) {
				if (pattern[i] != other.pattern[i]) {
					return pattern[i] < other.pattern[i];
				}
			}

			for (int i = 0; i < len; i++) {
				if (mask[i] != other.mask[i]) {
					return mask[i] < other.mask[i];
				}
			}

			return false;
		}
	};
	
	Pattern parse(const char* pattern);

	struct ScanResult {
		bool found;
		uintptr_t loc;
		char* store;
	};

	namespace internal {
		ScanResult scan_module(const char* module_name, Pattern pattern);
		inline ScanResult scan_module(const char* module_name, const char* pattern) {
			return scan_module(module_name, parse(pattern));
		}
	}
}
