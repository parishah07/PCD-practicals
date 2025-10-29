#include <iostream>
#include <string>
#include <sstream>
#include <cctype>
using namespace std;

string replaceVariable(const string &body, const string &var, int offset, int step) {
    string result;
    for (size_t i = 0; i < body.size();) {
        if (body.compare(i, var.size(), var) == 0) {
            bool leftOK = (i == 0) || !isalnum(body[i - 1]);
            bool rightOK = (i + var.size() == body.size()) || !isalnum(body[i + var.size()]);
            if (leftOK && rightOK) {
                if (offset == 0)
                    result += "(" + var + ")";
                else
                    result += "(" + var + "+" + to_string(offset * step) + ")";
                i += var.size();
                continue;
            }
        }
        result += body[i++];
    }
    return result;
}

void unrollLoop(const string &var, int start, int end, int step, int factor, const string &body) {
    cout << "\n=== Optimized Loop (Unroll Factor = " << factor << ") ===\n";
    cout << "for (int " << var << " = " << start << "; " << var << " < " << end
         << "; " << var << " += " << factor * step << ") {\n";

    for (int k = 0; k < factor; k++) {
        cout << "    // Unrolled iteration +" << k << "\n";
        cout << "    " << replaceVariable(body, var, k, step) << "\n";
    }
    cout << "}\n";

    int remainder = (end - start) % (factor * step);
    if (remainder > 0) {
        int newStart = end - remainder;
        cout << "\n// Handle remaining iterations\n";
        cout << "for (int " << var << " = " << newStart << "; " << var << " < " << end
             << "; " << var << " += " << step << ") {\n";
        cout << "    " << body << "\n";
        cout << "}\n";
    }
}

int main() {
    string var, body;
    int start, end, step, factor;

    cout << "=== Loop Unrolling Optimization ===\n";
    cout << "Enter loop variable (e.g., i): ";
    cin >> var;
    cout << "Enter start, end, and step values (e.g., 0 8 1): ";
    cin >> start >> end >> step;
    cout << "Enter unroll factor (e.g., 2): ";
    cin >> factor;
    cin.ignore();
    cout << "Enter loop body (e.g., sum=sum+i;): ";
    getline(cin, body);

    cout << "\n=== Original Loop ===\n";
    cout << "for (int " << var << " = " << start << "; " << var << " < " << end
         << "; " << var << " += " << step << ") {\n";
    cout << "    " << body << "\n";
    cout << "}\n";

    unrollLoop(var, start, end, step, factor, body);
    return 0;
}
