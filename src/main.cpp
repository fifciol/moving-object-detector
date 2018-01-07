#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <math.h>
#include "opencv2/opencv.hpp"


int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("wrong number of parameters\n");
        return -1;
    }

    FILE *pFile = fopen(argv[1], "r");
    if (pFile == NULL)
    {
        printf("cannot open file for reading\n");
        return -1;
    }

    char c;
    char **path;
    int charCount = 0;
    int lineCount = 0;


    while (!feof(pFile))
    {
        c = fgetc(pFile);
        if(c == '\n')
        {
            lineCount++;
        }
    }

    printf("%d\n", lineCount);
    fseek(pFile, 0, SEEK_SET);

    path = (char**)malloc(sizeof(char*) * lineCount);

    for (size_t i=0; i<lineCount; ++i)
    {
        do
        {
            c = fgetc(pFile);
            charCount++;
        }
        while (c != '\n');

        path[i] = (char*)malloc(sizeof(char) * charCount);

        fseek(pFile, -charCount, SEEK_CUR);

        for (size_t j=0; j<charCount; ++j)
        {
            path[i][j] = fgetc(pFile);
        }
        path[i][charCount-1] = '\0';

        charCount = 0;
    }

    for (size_t i=0; i<lineCount; ++i)
    {
        printf("%s\n", path[i]); 
    }
           
    fclose(pFile);

    cv::VideoCapture cap(path[0]);
    cv::namedWindow("Avi", 1);

    while (1)
    {
        cv::Mat frame;
        cap >> frame;
        cv::imshow("Avi", frame);
        cv::waitKey(1);
    }
    //VideoDisplay videoDisplay("", "Liquid Lens Auto Focus");

    //videoDisplay.start();
    //videoDisplay.exit();

    return 0;
}
