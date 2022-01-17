//
// Common parts of utilities written in C++
// for providing uniform user experience
//


#ifndef COMMON_H
#define COMMON_H

#include <iostream>
#include <string>
#include <cstdint>


#if defined(WIN32) || defined(_WIN32)
    #define DIR_SEPARATOR "\\"
#else
    #define DIR_SEPARATOR "/"
#endif


void ERROR();
void ERROR(const std::string &message);

void printBannerLineTop();
void printBannerLineBottom();


class DualStream
{
public:
    DualStream(std::ostream& str1, std::ostream& str2);

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


#endif // COMMON_H
