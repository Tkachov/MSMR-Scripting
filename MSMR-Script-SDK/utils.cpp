#include "utils.h"

#include <Windows.h>
#include <string>

namespace utils {
	std::string get_game_executable() {
		static std::string executable;
		if (executable.empty()) {
			char buffer[MAX_PATH];
			GetModuleFileNameA(NULL, buffer, MAX_PATH);
			std::string::size_type pos = std::string(buffer).find_last_of("\\/");
			executable = std::string(buffer).substr(pos + 1);
		}
		return executable;
	}
}
