#include <fstream>
#include <iostream>

// Program to parse output of vice monitor script tests
// Outputs a list of tests and information from failing tests


int main()
{
    std::ifstream file("output");
    std::string line;
    bool in_compare = false;
    bool failed = false;

    while (getline(file, line)) {
        if (line.starts_with("ERROR -- Wrong syntax:")) {
            getline(file, line);
            if (line.starts_with("  print \"TEST: ")) {
                std::cout << line.substr(9, line.size() - 10) << std::endl;
            } else if (line.starts_with("  print \"COMPARE")) {
                getline(file, line);
                in_compare = true;
            } else if (line.starts_with("  print \"CHECK")) {
                std::string cmp = line.substr(15, line.size() - 16);
                std::string reg = cmp.substr(0, 1);
                std::string op = cmp.substr(1, 2);
                int value = std::stoi(cmp.substr(3, line.size() - 3));
                if (op == "==") {
                    getline(file, line);
                    getline(file, line);
                    getline(file, line);
                    if (reg == "A") {
                        int A_val = std::stoi(line.substr(7, 2), 0, 16);
                        if (A_val != value) {
                            std::cout << "FAIL: A != " << value << " (was " << A_val << ")" << std::endl;
                            failed = true;
                        }
                    }
                } else {
                    std::cout << "ERROR: Unknown operator for check" << std::endl;
                    failed = true;
                }
            } else if (line.starts_with("  print \"END")) {
                in_compare = false;
            }
        } else if (in_compare) {
            std::cout << "\033[31mFAIL:\033[0m " << line << std::endl;
            failed = true;
        }
    }
     
    if (failed) {
        std::cout << "Some tests \033[31mFAIL\033[0m " << std::endl;
        return 1;
    } else {
        std::cout << "All tests \033[32mPASS\033[0m " << std::endl;
        return 0;
    }
}
