#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <vector>
#include <algorithm>


class CMU{
private:
    std::unordered_map<std::string, std::string> dictionary_;
public:
    CMU(const std::string& dictionaryFile) {
        std::ifstream file(dictionaryFile);
        if (!file.is_open()) {
            std::cerr << "Error: Unable to open dictionary file." << std::endl;
            return;
        }
        std::string line;
        while (std::getline(file, line)) {
            if (line.empty() || line[0] == ';') {
                continue;
            }
            std::istringstream iss(line);
            std::string word, phonemes, phoneme;
            iss >> word;
            while (iss >> phoneme)
            {
                if (phonemes!="")
                        phonemes += " ";
                    phonemes += phoneme;
            }
            dictionary_[word] = phonemes;
        }

        file.close();
    }
    std::vector<std::string> operator() (const std::string& text) const{
        std::string word;
        std::istringstream iss(text);
        std::vector<std::string> phonemes;
        while (iss >> word) {
            std::transform(word.begin(), word.end(), word.begin(), ::toupper);
            auto it = dictionary_.find(word);
            if (it != dictionary_.end()) {
                phonemes.push_back(it->second);
            } else {
                phonemes.push_back(word);
            }
        }
        return phonemes;
    }
};

int main() {
    CMU processor("vendor/cmu/cmudict-0.7b");
    std::string inputText = "hello algorithm";
    std::vector<std::string> phonemes = processor(inputText);
    for (const std::string& phoneme : phonemes) {
        std::cout << phoneme << " ";
    }
    std::cout << std::endl;
    return 0;
}
