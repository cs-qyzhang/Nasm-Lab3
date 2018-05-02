#include <stdio.h>
#include <string.h>

struct Goods
{
    char goodsName[12];
    int  inPrice;
    int  outPrice;
    int  quantity;
    int  sold;
    int  profitRate;
};

extern struct Goods * shop1;
extern struct Goods * shop2;

#define GOODSNUM    30
#define GOODSLENGTH 32
#define FALSE       0
#define TRUE        1

int ReadData(const char *fileName)
{
    FILE *fp;
    fp = fopen(fileName, "r");
    if (fp == NULL)
        return FALSE;
    
    struct Goods *p;
    int goodsRead;
    char buf[50];
    fscanf(fp, "%s", buf);
    p = shop1;
    for (goodsRead = 0; goodsRead < GOODSNUM; goodsRead++)
    {
        fscanf(fp, "%s%d%d%d%d", p->goodsName, &(p->inPrice), &(p->outPrice), &(p->quantity), &(p->sold));
        p++;
    }

    fscanf(fp, "%s", buf);
    p = shop2;
    for (goodsRead = 0; goodsRead < GOODSNUM; goodsRead++)
    {
        fscanf(fp, "%s%d%d%d%d", p->goodsName, &(p->inPrice), &(p->outPrice), &(p->quantity), &(p->sold));
        p++;
    }
    return TRUE;
}