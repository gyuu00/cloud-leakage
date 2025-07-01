#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void win() {
    system("curl http://169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI");
}

void handler() {
    char buf[64];
    puts("Welcome to Lambda Leakage.");
    puts("Send your payload:");
    gets(buf);  // BOF 취약점
    puts("Goodbye.");
}

int main() {
    handler();
    return 0;
}
