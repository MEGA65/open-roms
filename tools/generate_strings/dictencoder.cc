

#include "dictencoder.h"

#include <algorithm>
#include <sstream>


void DictEncoder::addString(const std::string &inString, StringEncoded *outPtr)
{
    // Store the pointer to encoding

    encodings.push_back(outPtr);

    // Check if string is already present in the dictionary

    auto pos = std::find(dictionary.begin(), dictionary.end(), inString);

    // Create initial encoding

    if (pos != dictionary.end())
    {
        encodings.back()->push_back(pos - dictionary.begin());
    }
    else
    {
        if (dictionary.size() > 255)
        {
            ERROR("max 255 strings allowed for dictionary compression");
        }

        dictionary.push_back(inString);
        encodings.back()->push_back(dictionary.size() - 1);
    }
}

void DictEncoder::extractWords(std::vector<std::string> &candidateList)
{
    for (const auto &dictionaryEntry : dictionary)
    {
        // Split the dictionary entry into words
       
        std::istringstream entryStream(dictionaryEntry);
        while (entryStream)
        {
            std::string word_1;
            entryStream >> word_1;

            if (word_1.empty()) continue;
           
            // Create possible variants with spaces

            std::string word_2 = " " + word_1;
            std::string word_3 = word_1 + " ";
            std::string word_4 = word_2 + " ";

            // If necessary, add the word to candidate list
           
            auto addToList = [&dictionaryEntry, &candidateList](std::string &word)
            {
                // Before dding, make sure the word variant exists in the string,
                // is not already on the list, and is long enough it makes sense to try

                if (word.size() < 1) return;
                if (dictionaryEntry.find(word) == std::string::npos) return;
                if (std::find(candidateList.begin(), candidateList.end(), word) != candidateList.end()) return;

                candidateList.push_back(word);
            };
           
            addToList(word_1);
            addToList(word_2);
            addToList(word_3);
            addToList(word_4);
        }
    }
}

int32_t DictEncoder::evaluateCandidate(std::string &candidate)
{
    // XXX it looks like this is not 100% right - debug the algorithm if dictionary compression is reintroduced

    // Build the score - find how much bytes can be spared by extracting this particular candidate
    // Limited size of the dictionary is taken into consideration
   
    int32_t  score      = -(candidate.size() + 1);
    uint32_t targetSize = dictionary.size() + 1;

    // First check for situation when the candidate equals the currently existing dictionary entry

    for (const auto &dictionaryEntry : dictionary)
    {   
        if (dictionaryEntry == candidate)
        {
            // Candidate equals the string

            score += candidate.size() + 1;
            targetSize--;
            continue;
        }
    }

    // Now check the remaining cases

    for (const auto &dictionaryEntry : dictionary)
    {   
        if (dictionaryEntry == candidate) continue; // already handled

        // Find all the occurences of the candidate in the current string

        std::vector<uint8_t> occurences;
        for (auto iter = dictionaryEntry.begin(); iter < (dictionaryEntry.end() - candidate.size() + 1); iter++)
        {
            if (candidate != std::string(iter, iter + candidate.size())) continue;
           
            occurences.push_back(iter - dictionaryEntry.begin());
            iter += candidate.size() - 1; // to make sure we have no occurence overlapping
        }
       
        if (occurences.empty()) continue;
       
        // Now summarize what we are going to gain when doing replacement
       
        if (occurences[0] != 0)
        {
            // For the substring before the first occurence we need to create a separate entry
            // in the dictionary - unless it is already there, it brings some additional cost

            std::string otherStr = std::string(dictionaryEntry.begin(), dictionaryEntry.end() + occurences[0]);

            if (std::find(dictionary.begin(), dictionary.end(), otherStr) != dictionary.end())
            {
                // This extra string is already in the dictionary - that gives extra saving
                score += otherStr.size() - 1;
            }
            else
            {
                // This extra string is not in the dictionary, it has to be added
                score -= 2;
                targetSize++;
            }
        }
       
        for (auto iter = occurences.begin(); iter < occurences.end(); iter++)
        {
            // With a replacement, we should gain some bytes
            score += candidate.size() - 1;

            // If the occurence ends with the last byte of dictionary string - nothing more to do
            if (*iter + candidate.size() == dictionaryEntry.size()) break;

            // If next occurence starts immediately after this one - next iteration
            if (iter + 1 != occurences.end() && (*(iter + 1) - *iter) == (uint8_t) candidate.size()) continue;

            // For the substring between this occurence and the next one (or the end of the string)
            // we need to create a separate entry in the dictionary - unless it is already there,
            // it brings some additional cost

            std::string otherStr;
            if (iter + 1 == occurences.end())
            {
                otherStr = std::string(dictionaryEntry.begin() + *iter + candidate.size(),
                                       dictionaryEntry.end());
            }
            else
            {
                otherStr = std::string(dictionaryEntry.begin() + *iter + candidate.size(),
                                       dictionaryEntry.begin() + *(iter + 1));
            }

            if (std::find(dictionary.begin(), dictionary.end(), otherStr) != dictionary.end())
            {
                // This extra string is already in the dictionary - that gives extra saving
                score += otherStr.size() - 1;
            }
            else
            {
                // This extra string is not in the dictionary, it has to be added
                score -= 2;
                targetSize++;
            }           
        }
       
        // We crossed the maximum number of strings (leave one free for the work buffer),
        // do not consider this candidate
       
        if (targetSize > 254) return -1;
    }
   
    return score;
}

void DictEncoder::cleanupDictionary()
{
    // Get rid of dictionary entries which are not needed anymore
   
    bool isClean = false;
   
    while (!isClean)
    {
        isClean = true;
       
        for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
        {
            if (!iter->empty()) continue;
           
            // Found an empty string in the dictionary - remove it and adapt encoding
           
            isClean = false;
            uint8_t obsoleteStrIdx = iter - dictionary.begin();
           
            dictionary.erase(iter);
           
            for (auto &encoding : encodings) for (auto &byte : *encoding)
            {
                if (byte >= obsoleteStrIdx) byte--;
            }
           
            break;
        }
    }
}

bool DictEncoder::optimizeSplit()
{
    // XXX - The code here is not the best one - redesign and algorithm improvements
    // (like - consider optimizing as a game and apply alpha-beta scheme to select the best
    // candidate, incorporate frequency encoding into candidate evaluation) could result in
    // a slightly better compression. But currently we have very few strings, and the dictionary
    // compression is disabled by default - so right now this is not worth the effort.
   
    if (dictionary.size() >= 255) return false; // up to 255 entries in the dictionary are possible
   
    // First select words, which can potentially be extracted to new substrings
   
    std::vector<std::string> candidateList;
    extractWords(candidateList);

    // XXX possible future improvement: find a couple of largest common substrings and add them as candidates too
   
    // Now find the best word to be extracted
   
    auto bestCandidate         = candidateList.end();
    int32_t bestCandidateScore = 0;
   
    for (auto iter = candidateList.begin(); iter < candidateList.end(); iter++)
    {
        int32_t candidateScore = evaluateCandidate(*iter);

        if (candidateScore > bestCandidateScore)
        {
            bestCandidate      = iter;
            bestCandidateScore = candidateScore;
        }
    }
   
    // Only allow for replacements that brings some size benefit
   
    if (bestCandidateScore < 1) return false;
   
    // Extract the best candidate to a separate string
   
    // First add our selected candidate to the dictionary and replace all strings which are equal to it
   
    auto    &selectedStr   = *bestCandidate;
    uint8_t selectedStrIdx = dictionary.size();
   
    dictionary.push_back(selectedStr);

    for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
    {
        uint8_t currentStrIdx = iter - dictionary.begin();
       
        if (*iter != selectedStr || selectedStrIdx == currentStrIdx) continue;
       
        // Replace the current string with the new one
       
        for (auto &encoding : encodings) for (auto &byte : *encoding)
        {
            if (byte == currentStrIdx) byte = selectedStrIdx;
        }
       
        // Mark obsolete dictionary entry as free for removal
       
        iter->clear();
    }

    cleanupDictionary();

    // Now handle normal cases, when the string needs to be split
    // XXX - this is not time-effective, optimize this in the future

    bool optimizeAgain = true;
    bool nexIteration  = true;
    while (nexIteration)
    {
        nexIteration = false;

        for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
        {
            auto    &currentStr     = *iter;
            uint8_t currentStrIdx   = iter - dictionary.begin();   
            auto    selectedStrIter = std::find(dictionary.begin(), dictionary.end(), selectedStr);
            selectedStrIdx          = selectedStrIter - dictionary.begin();

            if (currentStrIdx == selectedStrIdx) continue;
   
            // Check if the current string contains the selected string
           
            auto pos = currentStr.find(selectedStr);
            if (pos == std::string::npos) continue;
               
            nexIteration  = true;
            optimizeAgain = true;
   
            // Prepare replacement sequence for 'selectedStrIdx'
               
            std::vector<uint8_t> replacement;
           
            if (pos == 0)
            {
                // The current dictionary string starts with our selected substring
               
                replacement.push_back(selectedStrIdx);
                currentStr = currentStr.substr(selectedStr.size(), currentStr.size() - selectedStr.size());
               
                if (!currentStr.empty())
                {
                    // Check if the remaining string is present somewhere else in the dictionary; if so, reuse it
               
                    uint8_t pos2 = currentStrIdx;
                    for (auto iter2 = dictionary.begin(); iter2 < dictionary.end(); iter2++)
                    {
                        if (iter2 == iter) continue;
                        if (currentStr == *iter2)
                        {
                            dictionary[pos2].clear();
                            pos2 = iter2 - dictionary.begin();
                            break;
                        }
                    }
                   
                    replacement.push_back(pos2);
                }
            }
            else
            {
                // The current dictionary string does not start with our selected substring
               
                std::string newStr = currentStr.substr(0, pos);
                currentStr         = currentStr.substr(pos, currentStr.size() - pos);
               
                // Check if the newStr is present somewhere else in the dictionary; if so, reuse it
               
                bool    found = false;
                uint8_t pos2  = 0;
                for (auto iter2 = dictionary.begin(); iter2 < dictionary.end(); iter2++)
                {
                    if (*iter2 == newStr)
                    {
                        found = true;
                        pos2  = iter2 - dictionary.begin();

                        break;
                    }
                }
           
                if (found)
                {
                    replacement.push_back(pos2);                   
                }
                else
                {
                    dictionary.push_back(newStr);
                    replacement.push_back(dictionary.size() - 1);                   
                }

                replacement.push_back(currentStrIdx);
            }

            // Now replace all the occurences of 'selectedStrIdx' with a 'replacement' vector

            for (auto &encoding : encodings)
            {
                for (uint8_t idx = 0; idx < encoding->size(); idx++)
                {
                    if ((*encoding)[idx] != currentStrIdx) continue;
                   
                    // Perform replacement
                   
                    encoding->erase(encoding->begin() + idx);
                   
                    for (const auto replacementIdx : replacement)
                    {
                        encoding->insert(encoding->begin() + idx, replacementIdx);
                        idx++;
                    }
                   
                    idx--;
                }
            }
           
            cleanupDictionary();
        }
    }

    return optimizeAgain;
}

bool DictEncoder::optimizeJoin()
{
    // Try to optimize by joining two substrings
   
    // XXX - possible future improvement
   
    return false;
}

void DictEncoder::optimizeOrder()
{
    // XXX - it would be better to do this after the dictionary is compressed

    // Try to optimize order of strings in the dictionary for fastest display
    // - put the shorter substrings first
    // - for strings with roughly the same length put more frequently used first
   
    typedef struct Entry
    {
        uint32_t    penalty;
        std::string word;
    } Entry;
   
    // Create copy of the dictionary with optimization info
   
    std::vector<Entry> optimizedOrder;
    for (auto iter = dictionary.begin(); iter < dictionary.end(); iter++)
    {
        const auto &dictionaryStr = *iter;
   
        uint8_t  sizePenalty = dictionaryStr.size() / 3;
        uint16_t freqPenalty = 65535;
       
        // Calculate penalty for low occurence frequency
       
        for (auto &encoding : encodings)
        {
            for (auto &byte : *encoding)
            {
                if (byte == (iter - dictionary.begin())) freqPenalty--;
            }
        }

        // Create new entry
       
        Entry newEntry;
        newEntry.word    = dictionaryStr;
        newEntry.penalty = sizePenalty * 65536 + freqPenalty;

        optimizedOrder.push_back(newEntry);
    }
   

    // Determine ordering - sort from smallest penalty to largest
   
    std::sort(optimizedOrder.begin(), optimizedOrder.end(),
              [](const Entry &e1, const Entry &e2) { return e1.penalty < e2.penalty; });

    // Create helper table for reordering
   
    std::vector<uint8_t> reorderTable;
   
    for (uint8_t idx1 = 0; idx1 < dictionary.size(); idx1++)
    {
        uint8_t idx2 = 0;
        while (dictionary[idx1] != optimizedOrder[idx2].word) idx2++;
       
        reorderTable.push_back(idx2);       
    }

    // Perform the reordering
   
    for (auto &encoding : encodings) for (auto &byte : *encoding)
    {
        byte = reorderTable[byte];
    }
   
    for (uint8_t idx = 0; idx < dictionary.size(); idx++) dictionary[idx] = optimizedOrder[idx].word;
}

void DictEncoder::process(StringEntryList &outDictionary)
{
    if (dictionary.empty()) return;
    // Optimize as long as it brings any improvement

    while (optimizeSplit() || optimizeJoin()) ;
    optimizeOrder();

    // Export the dictionary to external format

    outDictionary.type = ListType::DICTIONARY;
    outDictionary.name = "DICTIONARY";

    for (const auto &dictionaryStr : dictionary)
    {
        StringEntry newEntry = { true, true, true, true, true, "", dictionaryStr };
        outDictionary.list.push_back(newEntry);
    }

    // Adapt the encoding to external format (0 = end of string)

    for (auto &encoding : encodings)
    {
        for (auto &byte : *encoding) byte++;
        encoding->push_back(0);
    }
}
