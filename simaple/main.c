#include "example.h"
#include <string.h>

// 这是一个单行注释，描述一个简单的函数
void hello_world(void) {
    printf("Hello, World!\n"); // 这行代码打印了 "Hello, World!" 字符串
}

/*
 * 这是一个多行注释，描述 format_string 函数
 * 该函数将传入的字符串格式化后返回
 */
char* format_string(const char* str) {
    static char buffer[100];  // 这是一个静态缓冲区

    // 这里使用 snprintf 来格式化字符串
    snprintf(buffer, sizeof(buffer), "Formatted: %s", str);

    // 返回格式化后的字符串
    return buffer;
}

int main() {
    // 调用 hello_world 函数，打印一行信息
    hello_world();

    // 进行字符串格式化
    const char* input = "example string";
    char* formatted = format_string(input);

    // 打印格式化后的字符串
    printf("%s\n", formatted); // 输出 "Formatted: example string"

    return 0;
}
