
#ifndef DICTENCODER_H
#define DICTENCODER_H

#include "global.h"


// This class encapsulates the optional dictionary encoding of selected string lists
class DictEncoder
{
public:

    void addString(const std::string &inString, StringEncoded *outPtr);

    void process(StringEntryList &outDictionary);

private:

    bool optimizeSplit();
    bool optimizeJoin();
    void optimizeOrder();

    void cleanupDictionary();

    void extractWords(std::vector<std::string> &candidateList);
    int32_t evaluateCandidate(std::string &candidate);

    std::vector<StringEncoded *> encodings;
    std::vector<std::string>     dictionary;
};


#endif // DICTENCODER_H
