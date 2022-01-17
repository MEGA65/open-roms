
#ifndef DATASET_H
#define DATASET_H

#include "global.h"


// Main class to encode strings based on character frequency
class DataSet
{
public:

    void addStrings(const StringEntryList &stringList);

    const std::string &getOutput();

private:

    void process();

    void generateConfigDepStrings();
    void validateLists();
    void calculateFrequencies();
    void encodeStringsDict();
    void encodeStringsFreq();

    void encodeByFreq(const std::string &plain, StringEncoded &encoded) const;

    void prepareOutput();
    void prepareOutput_1n_3n(std::ostringstream &stream);
    void prepareOutput_labels(std::ostringstream &stream,
                              const StringEntryList &stringEntryList,
                              const StringEncodedList &stringEncodedList);
    void prepareOutput_packed(std::ostringstream &stream,
                              const StringEntryList &stringEntryList,
                              const StringEncodedList &stringEncodedList);

    void putCharEncoding(std::ostringstream &stream, uint8_t idx, char character, bool is3n);

    bool isCompressionLvl2(const StringEntryList &list) const;

    virtual bool isRelevant(const StringEntry &entry) const = 0;
    virtual std::string layoutName() const = 0;

    std::vector<StringEntryList>          stringEntryLists;
    std::vector<StringEncodedList>        stringEncodedLists;

    std::vector<char>                     as1n; // list of bytes to be encoded as 1 nibble
    std::vector<char>                     as3n; // list of bytes to be encoded as 3 nibbles

    uint8_t                               tk__packed_as_3n    = 0;
    uint8_t                               tk__max_keyword_len = 0;

    size_t                                maxAliasLen          = 0;
    std::string                           outFileContent;
};


class DataSetSTD : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledSTD; }
    std::string layoutName() const { return "STD"; }
};

class DataSetCRT : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledCRT; }
    std::string layoutName() const { return "CRT"; }
};

class DataSetM65 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledM65; }
    std::string layoutName() const { return "M65"; }
};

class DataSetU64 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledU64; }
    std::string layoutName() const { return "STD"; } // XXX to be changed for 'U64' once the layout is finished
};

class DataSetX16 : public DataSet
{
    bool isRelevant(const StringEntry &entry) const { return entry.enabledX16; }
    std::string layoutName() const { return "X16"; }
};


#endif // DATASET_H
