//
// Common parts of utilities written in C++
// for providing uniform user experience
//

#include "common.h"

#include <ostream>


const std::string BANNER_LINE = "//-------------------------------------------------------------------------------------------";


void ERROR()
{
    exit(-1);
}

void ERROR(const std::string &message)
{
    std::cout << "\n" << "ERROR: " << message << "\n\n";
    exit(-1);
}

void printBannerLineTop()
{
    std::cout << "\n\n\n" << BANNER_LINE << "\n";
}

void printBannerLineBottom()
{
    std::cout << BANNER_LINE << "\n\n";
}


DualStream::DualStream(std::ostream& str1, std::ostream& str2) : str1(str1), str2(str2)
{
}
