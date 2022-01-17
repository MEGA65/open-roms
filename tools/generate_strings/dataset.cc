
#include "dataset.h"

#include "dictencoder.h"

#include <algorithm>
#include <iomanip>
#include <sstream>


bool DataSet::isCompressionLvl2(const StringEntryList &list) const
{
    return (GLOBAL_ConfigOptions["COMPRESSION_LVL_2"] && list.type == ListType::STRINGS_BASIC);
}

void DataSet::addStrings(const StringEntryList &stringList)
{
    // Import the new list of strings

    stringEntryLists.push_back(stringList);
    stringEncodedLists.emplace_back();

    // Clear strings not relevant for the current configuration
   
    while (1)
    {
        if (isRelevant(stringEntryLists.back().list.back())) break;

        stringEntryLists.back().list.pop_back();
        if (stringEntryLists.back().list.empty())
        {
            ERROR(std::string("no valid strings in layout '") + layoutName() + "', list'" + stringEntryLists.back().name + "'");
        }
    }
   
    // Clear the output content - make sure it is not valid anymore

    outFileContent.clear();
}

void DataSet::process()
{
    std::cout << "processing file '" << CMD_cnfFile << "', layout '" << layoutName() << "'" << std::endl;

    generateConfigDepStrings();
    validateLists();
    encodeStringsDict();
    calculateFrequencies();
    encodeStringsFreq();   
    prepareOutput();
}

const std::string &DataSet::getOutput()
{
    if (outFileContent.empty())
    {
        process();
    }

    return outFileContent;
}

void DataSet::generateConfigDepStrings()
{
    // Generate string to show the build features
   
    std::string featureStr;
    std::string featureStrM65 = "\r";

    // Tape support features
   
    if (GLOBAL_ConfigOptions["TAPE_NORMAL"] && GLOBAL_ConfigOptions["TAPE_TURBO"])
    {
        featureStr    += "TAPE LOAD NORMAL TURBO\r";
        featureStrM65 += "TAPE     : LOAD NORMAL TURBO\r";
    }
    else if (GLOBAL_ConfigOptions["TAPE_NORMAL"])
    {
        featureStr    += "TAPE LOAD NORMAL\r";
        featureStrM65 += "TAPE     : LOAD NORMAL\r";
    }
    else if (GLOBAL_ConfigOptions["TAPE_TURBO"])
    {
        featureStr    += "TAPE LOAD TURBO\r";
        featureStrM65 += "TAPE     : LOAD TURBO\r";
    }
   
    // IEC support features
   
    if (GLOBAL_ConfigOptions["IEC"])
    {
        featureStr    += "IEC";
        featureStrM65 += "IEC      :";
       
        bool extendedIEC = false;
       
        if (GLOBAL_ConfigOptions["IEC_BURST_CIA1"])
        {
            featureStr    += " BURST1";
            extendedIEC    = true;
        }
        if (GLOBAL_ConfigOptions["IEC_BURST_CIA2"])
        {
            featureStr    += " BURST2";
            extendedIEC    = true;
        }
        if (GLOBAL_ConfigOptions["IEC_BURST_MEGA65"])
        {
            featureStr    += " BURST";
            featureStrM65 += " BURST";
            extendedIEC    = true;
        }
       
        if (GLOBAL_ConfigOptions["IEC_DOLPHINDOS"])
        {
            featureStr    += " DOLPHIN";
            featureStrM65 += " DOLPHIN";
            extendedIEC    = true;
        }
       
        if (GLOBAL_ConfigOptions["IEC_JIFFYDOS"])
        {
            featureStr    += " JIFFY";
            featureStrM65 += " JIFFY";
            extendedIEC    = true;
        }
       
        if (!extendedIEC)
        {
            featureStr    += " NORMAL ONLY";
            featureStrM65 += " NORMAL ONLY";
        }

        featureStr    += "\r";
        featureStrM65 += "\r";
    }
    else
    {
        featureStrM65 += "IEC      : -\r";
    }

    // RS-232 support features
   
    if (GLOBAL_ConfigOptions["RS232_ACIA"])   featureStr += "ACIA 6551\r";
    if (GLOBAL_ConfigOptions["RS232_UP2400"]) featureStr += "UP2400\r";
    if (GLOBAL_ConfigOptions["RS232_UP9600"]) featureStr += "UP9600\r";
   
    featureStrM65 += "RS-232   : -\r";

    // CBDOS features

    featureStrM65 += "\rSD CARD  : ";

    // Keyboard support features
   
    if (GLOBAL_ConfigOptions["KEYBOARD_C128"]) featureStr += "KBD 128\r";

    // Add strings to appropriate list
   
    for (auto &stringEntryList : stringEntryLists)
    {
        if (stringEntryList.name != std::string("misc")) continue;

        // List found

        if (GLOBAL_ConfigOptions["SHOW_FEATURES"] || GLOBAL_ConfigOptions["MB_M65"])
        {
            StringEntry newEntry1 = { true, true, true, true, true, "STR_PAL",      "PAL\r"    };
            StringEntry newEntry2 = { true, true, true, true, true, "STR_NTSC",     "NTSC\r"   };

            stringEntryList.list.push_back(newEntry1);
            stringEntryList.list.push_back(newEntry2);
        }

        if (GLOBAL_ConfigOptions["SHOW_FEATURES"])
        {
            StringEntry newEntry = { true, true, true, true, true, "STR_FEATURES", featureStr };
            stringEntryList.list.push_back(newEntry);
        }

        if (GLOBAL_ConfigOptions["MB_M65"])
        {
            StringEntry newEntry = { false, true, true, false, false, "STR_SI_FEATURES", featureStrM65 };
            stringEntryList.list.push_back(newEntry);
        }

        if (!GLOBAL_ConfigOptions["BRAND_CUSTOM_BUILD"] || GLOBAL_ConfigOptions["MB_M65"])
        {
            StringEntry newEntry = { true, true, true, true, true, "STR_PRE_REV", "RELEASE " };
            stringEntryList.list.push_back(newEntry);
        }

        break;
    }
}

void DataSet::validateLists()
{
    for (const auto &stringEntryList : stringEntryLists)
    {
        for (const auto &stringEntry : stringEntryList.list)
        {
            // Check for maximum allowed string length
            if (stringEntry.string.length() > 255) ERROR("string cannot be longer than 255 characters");

            // Check mor maximum keyword length
            if (stringEntryList.type == ListType::KEYWORDS)
            {
                if (stringEntry.string.length() > 16) ERROR("keyword cannot be longer than 16 characters");
                tk__max_keyword_len = std::max(tk__max_keyword_len, (uint8_t) stringEntry.string.length());
            }

            // Update maximum alias length too
            maxAliasLen = std::max(maxAliasLen, stringEntry.alias.length());

            for (const auto &character : stringEntry.string)
            {
                if ((unsigned char) character >= 0x80)
                {
                    ERROR(std::string("character above 0x80 in string '") + stringEntry.string + "'");
                }
            }           
        }
    }
}

void DataSet::encodeStringsDict()
{
    DictEncoder dictEncoder;

    // Add strings for dictionary compresssion

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList = stringEntryLists[idx];
        auto &stringEncodedList     = stringEncodedLists[idx];

        // Skip lists not to be encoded using the dictionary
        if (!isCompressionLvl2(stringEntryList)) continue;

        stringEncodedList.resize(stringEntryList.list.size());
        for (uint8_t idxEntry = 0; idxEntry < stringEntryList.list.size(); idxEntry++)
        {
            dictEncoder.addString(stringEntryList.list[idxEntry].string,
                                  &stringEncodedList[idxEntry]);
        }
    }

    // Perform the compression

    StringEntryList dictionary;
    dictEncoder.process(dictionary);

    // Add new lists

    stringEntryLists.push_back(dictionary);
    stringEncodedLists.emplace_back();
}

void DataSet::calculateFrequencies()
{
    as1n.clear();
    as3n.clear();
   
    std::map<char, uint16_t> freqMapGeneral;  // general character frequency map
    std::map<char, uint16_t> freqMapKeywords; // frequency map for keywords

    // Calculate frequencies of characters in the strings

    for (const auto &stringEntryList : stringEntryLists)
    {
        // Skip lists encoded by the dictionary
        if (isCompressionLvl2(stringEntryList)) continue;

        for (const auto &stringEntry : stringEntryList.list)
        {
            if (!isRelevant(stringEntry)) continue;

            for (const auto &character : stringEntry.string)
            {               
                freqMapGeneral[character]++;
                if (stringEntryList.type == ListType::KEYWORDS) freqMapKeywords[character]++;
            }
        }
    }

    // Sort characters by frequency

    std::vector<char> freqVector1;

    for (auto iter = freqMapGeneral.begin(); iter != freqMapGeneral.end(); ++iter)
    {
        freqVector1.push_back(iter->first);
    }

    std::sort(freqVector1.begin(), freqVector1.end(), [&freqMapGeneral](char e1, char e2)
              { return freqMapGeneral[e2] < freqMapGeneral[e1]; });

    // Check if minimal amount of characters needed, below 15 is not supported by the 6502 side code

    if (freqVector1.size() < 15) ERROR(std::string("not enough distinct characters in layout '") + layoutName() + "', at least 15 needed");

    // Extract 14 most frequent characters to be encoded as 1 nibble
   
    for (uint8_t idx = 0; idx < 14; idx++)
    {
        as1n.push_back(freqVector1[idx]);
    }
   
    // Now sort them by frequency in keywords, in descending order - this will speed up the tokenizer a little
   
    std::sort(as1n.begin(), as1n.end(), [&freqMapKeywords](char e1, char e2) { return freqMapKeywords[e2] > freqMapKeywords[e1]; });

    // Extract characters to be encoded as 3 nibbles, which actually exist in keywords

    std::vector<char> freqVector2;

    tk__packed_as_3n = 0;
    for (uint8_t idx = 14; idx < freqVector1.size(); idx++)
    {
        const auto &character = freqVector1[idx];
       
        if (freqMapKeywords[character] > 0)
        {
            as3n.push_back(character);
            tk__packed_as_3n++;
        }
        else
        {
            freqVector2.push_back(character);
        }
    }
    tk__packed_as_3n = std::max(tk__packed_as_3n, (uint8_t) 1);

    // Again, sort them by frequency in keywords, in descending order - this will speed up the tokenizer a little
   
    std::sort(as3n.begin(), as3n.end(), [&freqMapKeywords](char e1, char e2) { return freqMapKeywords[e2] > freqMapKeywords[e1]; });

    // Finally extract the remaining characters to be encoded as 3 nibbles

    for (const auto &character : freqVector2)
    {
        as3n.push_back(character);
    }
}

void DataSet::encodeByFreq(const std::string &plain, StringEncoded &encoded) const
{
    bool fullByte = true;

    auto push1n = [&](uint8_t val) // push 1 nibble - encoded character or 0xF mark
    {
        if (fullByte)
        {
            encoded.push_back(val);
            fullByte = false;
        }
        else
        {
            encoded.back() += val * 0x10;
            fullByte = true;
        }
    };

    auto push2n = [&](uint8_t val) // push the remaining nibbles for 3-niobble encoded characters
    {
        if (fullByte)
        {
            encoded.push_back(val);
        }
        else
        {
            // Encode byte in a way to be easily decoded by 6502
            encoded.back() += (val / 0x10) * 0x10;
            encoded.push_back(val % 0x10);           
        }
    };

    // Encode every single character by frequency, put them in the output vector

    for (const char &character : plain)
    {
        auto iterEncoding1 = std::find(as1n.begin(), as1n.end(), character);
        if (iterEncoding1 != as1n.end())
        {
            push1n(std::distance(as1n.begin(), iterEncoding1) + 1);
        }
        else
        {
            push1n(0x0F);

            auto iterEncoding3 = std::find(as3n.begin(), as3n.end(), character);
            if (iterEncoding3 == as3n.end())
            {
                ERROR("internal error in 'encodeByFreq'");
            }
            push2n(std::distance(as3n.begin(), iterEncoding3) + 1);
        }
    }

    // Make sure the last byte of encoded stream is 0

    if (encoded.size() == 0 || encoded.back() != 0) encoded.push_back(0);
}

void DataSet::encodeStringsFreq()
{
    // Encode every relevant string from every list - by character frequency

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList = stringEntryLists[idx];
        auto &stringEncodedList = stringEncodedLists[idx];

        // Skip lists encoded by the dictionary
        if (isCompressionLvl2(stringEntryList)) continue;

        // Perform frequency encoding of the list

        for (const auto &stringEntry : stringEntryList.list)
        {
            stringEncodedList.emplace_back();
            auto &stringEncoded = stringEncodedList.back();

            if (isRelevant(stringEntry))
            {
                encodeByFreq(stringEntry.string, stringEncoded);
            }
        }
    }
}

void DataSet::putCharEncoding(std::ostringstream &stream, uint8_t idx, char character, bool is3n)
{
    stream << "\t!byte $" << std::uppercase << std::hex <<
              std::setfill('0') << std::setw(2) << +character <<
              "    ; " << std::setfill(is3n ? '0' : ' ') << std::setw(2) << +idx;

    std::string petscii;

    if (character == 0x20)
    {
        petscii = " = SPACE";
    }
    else if (character == 0x27)
    {
        petscii = " = APOSTROPHE";
    }
    else if (character == 0x0D)
    {
        petscii = " = RETURN";
    }
    else if (character > ' ' && character < 'a')
    {
        petscii = std::string(" = '") + character + "'";
    }

    stream << petscii << std::endl;
}

void DataSet::prepareOutput_1n_3n(std::ostringstream &stream)
{
    uint8_t idx;

    // Export all nibble-encoded characters

    stream << std::endl << "!macro PUT_PACKED_AS_1N { ; characters encoded as 1 nibble" << std::endl << std::endl;
   
    idx = 0;
    for (const auto& encoding : as1n)
    {
        putCharEncoding(stream, ++idx, encoding, false);
    }
   
    stream << "}" << std::endl;

    // Export all byte-encoded characters

    stream << std::endl << "!macro PUT_PACKED_AS_3N { ; characters encoded as 3 nibbles" << std::endl << std::endl;

    idx = 0;
    for (const auto& encoding : as3n)
    {
        if (idx == tk__packed_as_3n) stream << std::endl <<
            "\t; Characters below are not used by any BASIC keyword" << std::endl << std::endl;

        putCharEncoding(stream, ++idx, encoding, true);
    }

    stream << "}" << std::endl;
}

void DataSet::prepareOutput_labels(std::ostringstream &stream,
                                   const StringEntryList &stringEntryList,
                                   const StringEncodedList &stringEncodedList)
{
    // For the dictionary we do not have any labels
    if (stringEntryList.type == ListType::DICTIONARY) return;

    stream << std::endl;
    for (uint8_t idx = 0; idx < stringEncodedList.size(); idx++)
    {
        const auto &stringEntry   = stringEntryList.list[idx];
        const auto &stringEncoded = stringEncodedList[idx];

        if (!stringEncoded.empty())
        {
            stream << "!set IDX__" << stringEntry.alias <<
                      std::string(maxAliasLen - stringEntry.alias.length(), ' ') << " = $" <<
                      std::uppercase << std::hex << std::setfill('0') << std::setw(2) << +idx << std::endl;
        }
    }
}

void DataSet::prepareOutput_packed(std::ostringstream &stream,
                                   const StringEntryList &stringEntryList,
                                   const StringEncodedList &stringEncodedList)
{
    if (isCompressionLvl2(stringEntryList))
    {
        stream << std::endl << "!macro PUT_PACKED_DICT_";
    }
    else
    {
        stream << std::endl << "!macro PUT_PACKED_FREQ_";           
    }

    stream << stringEntryList.name << " {" << std::endl << std::endl;

    enum LastStr { NONE, SKIPPED, WRITTEN } lastStr = LastStr::NONE;
    for (uint8_t idxString = 0; idxString < stringEncodedList.size(); idxString++)
    {
        const auto &stringEncoded = stringEncodedList[idxString];

        if (stringEncoded.empty())
        {
            if (stringEntryList.type == ListType::DICTIONARY) ERROR("internal error"); // should never happen

            if (lastStr == LastStr::WRITTEN) stream << std::endl;
            stream << "\t!byte $00    ; skipped " << stringEntryList.list[idxString].alias << std::endl;
            lastStr = LastStr::SKIPPED;
        }
        else
        {
            if (lastStr != LastStr::NONE) stream << std::endl;

            // Output the label - as a comment

            if (stringEntryList.type != ListType::DICTIONARY)
            {
                stream << "\t; IDX__" << stringEntryList.list[idxString].alias << std::endl;
            }

            // Output the source string - as a comment

            stream << "\t; '";
            for (auto &character : stringEntryList.list[idxString].string)
            {
                if (character >= 32 && character <= 132 && character != 39 && character != 34)
                {
                    stream << character;
                }
                else if (character == 13)
                {
                    stream << "<return>";
                }
                else
                {
                    stream << "_";
                }
            }
            stream << "'" << std::endl;

            // Output the encoding

            stream << "\t!byte ";

            bool first = true;
            for (const auto &charEncoded : stringEncoded)
            {
                if (first)
                {
                    first = false;
                }
                else
                {
                    stream << ", ";
                }

                stream << "$" << std::uppercase << std::hex << std::setfill('0') << std::setw(2) << +charEncoded;
            }

            stream << std::endl;
            lastStr = LastStr::WRITTEN;
        }
    }

    // For the token list - put the 'end of keywords' mark

    if (stringEntryList.type == ListType::KEYWORDS)
    {
        stream << std::endl << "\t; Marker - end of the keyword list" << std::endl;
        stream << "\t!byte $FF, $FF" << std::endl;
    }

    stream << "}" << std::endl;
}

void DataSet::prepareOutput()
{
    // Convert our encoded strings to a KickAssembler source

    std::ostringstream stream;

    // Export 1-nibble and 3-nibble encoding data

    prepareOutput_1n_3n(stream);

    // Export additional data for the tokenizer

    stream << std::endl << "!set TK__PACKED_AS_3N    = $" << std::hex << +tk__packed_as_3n <<
              std::endl << "!set TK__MAX_KEYWORD_LEN = "  << std::dec << +tk__max_keyword_len << std::endl;

    // Export encoded strings

    for (uint8_t idx = 0; idx < stringEntryLists.size(); idx++)
    {
        const auto &stringEntryList   = stringEntryLists[idx];
        const auto &stringEncodedList = stringEncodedLists[idx];

        if (stringEncodedList.empty()) continue;

        // Export labels for the current list

        prepareOutput_labels(stream, stringEntryList, stringEncodedList);

        // For the token list - put the number of tokens available

        if (stringEntryList.type == ListType::KEYWORDS)
        {
            stream << std::endl << "!set TK__MAXTOKEN_" << stringEntryList.name << " = " <<
                      std::dec << stringEncodedList.size() << std::endl;
        }

        // Export the packed data

        prepareOutput_packed(stream, stringEntryList, stringEncodedList);
    }

    // Finalize the file stream

    stream << std::endl;
    outFileContent = stream.str();
}
