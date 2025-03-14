#include <iostream>

using namespace std;

void kiir(int s)
{
    cout << s << endl;
}

int main()
{
    int a = -50, b = -6, c = 6, d = -3, e = -25, f = 25, g = -47;
    int s;
    s = c/6;
    kiir(s);
    
    s = a - s;
    kiir(s);

    s = b / s;
    kiir(s);

    s = a + s;
    kiir(s);

    s = 1 - s;
    kiir(s);

    s = s - (g % 48);
    kiir(s);
    
    s = s - (d % 42);
    kiir(s);

    s = s + (((c * f) + e) / g);
    kiir(s);

    return 0;
}