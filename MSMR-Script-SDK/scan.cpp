#include "scan.h"
#include "logging.h"

#include <Windows.h>
#include <Psapi.h>
#include <stdio.h>
#include <map>

namespace scan {
	std::map<Pattern, ScanResult> ScanCache = {};

	Pattern parse(const char* pattern) {
		int pattern_len = (strlen(pattern) + 1) / 3;
		char* pattern_bytes = new char[pattern_len];
		char* mask = new char[pattern_len];

		for (int i = 0; i < strlen(pattern); ++i) {
			if (pattern[i] == ' ') {
				continue;
			}
			
			if (pattern[i] == '?') {
				mask[(i + 1) / 3] = '?';
			} else if (pattern[i] == '*') {
				mask[(i + 1) / 3] = '*';
			} else {
				mask[(i + 1) / 3] = 'x';

				char byte = (char)strtol(&pattern[i], 0, 16) & 0xFF;
				pattern_bytes[(i + 1) / 3] = byte;
			}

			i += 2;
		}

		return Pattern{ pattern_bytes, mask, pattern_len };
	}

	ScanResult internal::scan_module(const char* module_name, Pattern pattern) {
		if (ScanCache.contains(pattern)) {
			DEBUG("Cached pattern found.");
			return ScanCache[pattern];
		}

		HMODULE handle = GetModuleHandleA(module_name);
		MODULEINFO info{};
		if (!GetModuleInformation(GetCurrentProcess(), handle, &info, sizeof(info))) {
			return ScanResult{ false, NULL, nullptr };
		}

		uintptr_t base = (uintptr_t)handle;

		char store[4] = { 0 };
		uintptr_t loc = 0;

		for (unsigned int i = 0; i < info.SizeOfImage - pattern.len; i++) {
			bool found = true;
			int store_used = 0;

			for (int j = 0; j < pattern.len; j++) {
				if (pattern.mask[j] == '*') {
					if (store_used < sizeof(store)) {
						store[store_used++] = *(char*)(base + i + j);
					}
					continue;
				}

				if (pattern.mask[j] != '?' && pattern.pattern[j] != *(char*)(base + i + j)) {
					found = false;
					break;
				}
			}

			if (found) {
				loc = base + i;
				break;
			}
		}

		ScanResult result = ScanResult{ loc != NULL, loc, store };
		ScanCache.insert(std::pair(pattern, result));

		return result;
	}
}
