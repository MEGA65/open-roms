//
// Common parts of utilities written in C++
// for providing uniform user experience
//

#include <iostream>
#include <string>
#include <cstdint>


#if defined(WIN32) || defined(_WIN32)
    #define DIR_SEPARATOR "\\"
#else
    #define DIR_SEPARATOR "/"
#endif


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


class DualStream
{
public:
    DualStream(std::ostream& str1, std::ostream& str2) : str1(str1), str2(str2) {}

    template<class T> DualStream &operator<<(const T& x)
    {
        str1 << x;
        str2 << x;

        return *this;
    }

private:
    std::ostream& str1;
    std::ostream& str2;
};
