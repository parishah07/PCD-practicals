#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <sstream>
#include <cctype>

using namespace std;

struct TAC {
    string op;
    string arg1;
    string arg2;
    string result;

    void print() const {
        if (op.empty()) { 
            cout << result << " = " << arg1 << endl;
        } else {
            cout << result << " = " << arg1 << " " << op << " " << arg2 << endl;
        }
    }
};

bool isNumber(const string& s) {
    if (s.empty()) return false;
    for (char const &c : s) {
        if (isdigit(c) == 0 && c != '-') return false;
    }
    return true;
}


vector<TAC> optimizeCode(const vector<TAC>& instructions) {
    vector<TAC> optimized_instructions;
    map<string, int> constants; 

    for (const auto& inst : instructions) {
        TAC current_inst = inst;
        string arg1_val_str = current_inst.arg1;
        string arg2_val_str = current_inst.arg2;

      
        if (constants.count(current_inst.arg1)) {
            arg1_val_str = to_string(constants[current_inst.arg1]);
        }
        if (constants.count(current_inst.arg2)) {
            arg2_val_str = to_string(constants[current_inst.arg2]);
        }

        if (!current_inst.op.empty() && isNumber(arg1_val_str) && isNumber(arg2_val_str)) {
            int val1 = stoi(arg1_val_str);
            int val2 = stoi(arg2_val_str);
            int result_val = 0;

            if (current_inst.op == "+") result_val = val1 + val2;
            else if (current_inst.op == "-") result_val = val1 - val2;
            else if (current_inst.op == "*") result_val = val1 * val2;
            else if (current_inst.op == "/") {
                if (val2 == 0) {
                    optimized_instructions.push_back(current_inst);
                    continue;
                }
                result_val = val1 / val2;
            }

            TAC new_inst = {"", to_string(result_val), "", current_inst.result};
            optimized_instructions.push_back(new_inst);
           
            constants[current_inst.result] = result_val;
            cout << "        // Optimized: Folded " << current_inst.arg1 << " " << current_inst.op << " " << current_inst.arg2 << " -> " << result_val << endl;
       
   
        } else if (current_inst.op.empty() && isNumber(arg1_val_str)) {
            
            constants[current_inst.result] = stoi(arg1_val_str);
            optimized_instructions.push_back(current_inst);

        } else {
            
            current_inst.arg1 = arg1_val_str;
            current_inst.arg2 = arg2_val_str;
            optimized_instructions.push_back(current_inst);
        }
    }
    return optimized_instructions;
}

int main() {
    
    vector<TAC> instructions = {
        {"", "10", "", "a"},        // a = 10
        {"", "5", "", "b"},         // b = 5
        {"+", "a", "b", "t1"},      // t1 = a + b
        {"*", "t1", "2", "c"},      // c = t1 * 2
        {"+", "c", "d", "e"}        // e = c + d 
    };

    cout << "--- Original Code ---" << endl;
    for (const auto& inst : instructions) {
        inst.print();
    }
    cout << endl;

    cout << "--- Optimizing... ---" << endl;
    vector<TAC> optimized = optimizeCode(instructions);
    cout << endl;

    cout << "--- Optimized Code ---" << endl;
    for (const auto& inst : optimized) {
        inst.print();
    }

    return 0;
}
