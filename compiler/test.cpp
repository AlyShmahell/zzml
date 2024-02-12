#include <iostream>
#include <string>
#include <regex>

#include <utility>

std::pair<std::string, std::string> process(std::sregex_iterator &next, std::sregex_iterator &end){
    std::smatch match = *next;
    std::string name = match[1]; 
    std::string value = match[2]; 
    std::cout<<match[1]<<" "<<match[2]<<" "<<match[3]<<std::endl;
    ++next;
    return std::make_pair(name, value);
}


int main() {
    std::string tag = "< prosody pitch= '-20%' rate ='80%' volume='90%' >";

    // Your regex pattern
    std::regex pattern(R"(\s*([^=\s<>]+)\s*((?:=)\s*("[^"]*"|'[^']*'|[^>\s]+))?)");

    // Iterator for matching
    std::sregex_iterator next(tag.begin(), tag.end(), pattern);
    std::sregex_iterator end;

    std::pair<std::string, std::string> t = process(next, end);
    std::cout<<"tag: "<< t.first <<std::endl;
    while (next != end) {
        
        std::pair<std::string, std::string> param = process(next, end);
        std::cout << "Name: " << param.first << std::endl;
        std::cout << "Value: " << param.second << std::endl;
    }

    return 0;
}
