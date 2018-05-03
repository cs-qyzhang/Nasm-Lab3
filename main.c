#include <stdio.h>
#include <stdlib.h>
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

extern int ptrShop1;
extern int ptrShop2;

struct Goods *shop1, *shop2;
const char bossName[] = "qyzhang";
const char password[] = "1q2w3e4r";

#define GOODSNUM    30
#define GOODSLENGTH 32
#define FALSE       0
#define TRUE        1

char fileName[] = "data.dat";

int  Login(void);
int  ReadData(const char *);
int  ShowMenu(int);
void ShowTitle(void);
void ShowInfo(int, int);
void NoFound(void);
int  Find(void);
void Change(int, int);
void CaculateProfitRate(void);
void CaculateRanking(void);

extern int  FindGoods(char *name);
extern void CalcuProfit(void);
extern void ChangeGoods(struct Goods *, int shop, int pos);

int main(void)
{
    shop1 = (struct Goods *)ptrShop1;
    shop2 = (struct Goods *)ptrShop2;

    if (ReadData(fileName) == FALSE)
    {
        printf("文件读入错误！请检查文件！\n");
        return 0;
    }

    int isLogin;
    isLogin = Login();
    int select;
    int pos;
    int shop;
    int i;

    while (TRUE)
    {
        select = ShowMenu(isLogin);
        if (select == -1)
            continue;
        switch (select)
        {
        case 1: //查询商品信息
            pos = Find();
            if (pos == -1)
            {
                NoFound();
                break;
            }
            ShowTitle();
            ShowInfo(1, pos);
            ShowInfo(2, pos);
            printf("按任意键继续");
            getchar();
            putchar('\n');
            break;
        case 2: //修改商品信息
            printf("请输入要修改的商品所在的商店序号:");
            scanf("%d", &shop);
            getchar();
            if (shop != 1 && shop != 2)
            {
                printf("错误的输入！目前只有两个商店：1,2！\n");
                break;
            }
            printf("请先查找要修改的商品\n");
            pos = Find();
            if (pos == -1)
            {
                NoFound();
                break;
            }
            Change(shop, pos);
            break;
        case 3: //计算平均利润率
            CaculateProfitRate();
            printf("成功！按任意键继续。");
            getchar();
            putchar('\n');
            break;
        case 4: //计算平均利润率排名
            CaculateRanking();
            printf("成功！按任意键继续。");
            getchar();
            putchar('\n');
            break;
        case 5: //输出全部商品信息
            ShowTitle();
            for (i = 0; i < GOODSNUM; i++)
                ShowInfo(1, i);
            for (i = 0; i < GOODSNUM; i++)
                ShowInfo(2, i);
            printf("按任意键继续。");
            getchar();
            putchar('\n');
            break;
        case 6: //程序退出
            return 0;
            break;
        }
    }
}

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
        fscanf(fp, "%s%d%d%d%d", p->goodsName, &(p->inPrice),
            &(p->outPrice), &(p->quantity), &(p->sold));
        p++;
    }

    fscanf(fp, "%s", buf);
    p = shop2;
    for (goodsRead = 0; goodsRead < GOODSNUM; goodsRead++)
    {
        fscanf(fp, "%s%d%d%d%d", p->goodsName, &(p->inPrice),
            &(p->outPrice), &(p->quantity), &(p->sold));
        p++;
    }
    return TRUE;
}

int ShowMenu(int isLogin)
{
    int select;
    if (isLogin == TRUE)
    {
        printf("--------------------Menu--------------------\n");
        printf("  1.查找并显示商品信息\n");
        printf("  2.修改商品信息\n");
        printf("  3.计算商品利润率\n");
        printf("  4.计算商品利润率排名\n");
        printf("  5.显示所有商品信息\n");
        printf("  6.退出系统\n");
        printf("--------------------Menu--------------------\n");
        printf("  请选择操作以继续(1-6):");
        scanf("%d", &select);
        getchar();
        if (select < 1 || select > 6)
        {
            printf("错误的输入！按任意键继续。\n");
            getchar();
            putchar('\n');
            return -1;
        }
        return select;
    }
    else
    {
        printf("--------------------Menu--------------------\n");
        printf("  1.查找并显示商品信息\n");
        printf("  2.退出系统\n");
        printf("--------------------Menu--------------------\n");
        printf("  请选择操作以继续(1-2):");
        scanf("%d", &select);
        getchar();
        if (select == 1)
            return 1;
        else if(select == 2)
            return 6;
        else
        {
            printf("错误的输入！按任意键继续。\n");
            getchar();
            putchar('\n');
            return -1;
        }
    }
}

void ShowTitle()
{
    printf("%13s%13s%13s%13s%13s%13s%13s\n", "商店", "商品名",
        "进货价", "销售价", "进货总数", "销售总数", "利润率");
    return;
}

void ShowInfo(int shop, int pos)
{
    struct Goods *p;
    if (shop == 1)
    {
        p = shop1;
        printf("%10s", "Shop1");
    }
    else
    {
        p = shop2;
        printf("%10s", "Shop2");
    }
    
    p += pos;
    printf("%10s%10d%10d%10d%10d%10d\n", p->goodsName, p->inPrice, p->outPrice,
        p->quantity, p->sold, p->profitRate);
    return;
}

void NoFound()
{
    printf("未找到商品！按任意建继续。");
    getchar();
    putchar('\n');
    return;
}

int Find()
{
    char name[12];
    printf("请输入要查找的商品名称：");
    scanf("%s", name);
    getchar();
    int pos;
    pos = FindGoods(name);
    return pos;
}

void Change(int shop, int pos)
{
    struct Goods *p, *prev;
    if (shop == 1)
        prev = shop1;
    else
        prev = shop2;
    prev += pos;
    p = (struct Goods *)malloc(sizeof(struct Goods));
    printf("请输入修改的信息：\n");
    printf("%10s%10d < ", "进货价：", prev->inPrice);
    scanf("%d", &(p->inPrice));
    printf("%10s%10d < ", "销售价：", prev->outPrice);
    scanf("%d", &(p->outPrice));
    printf("%10s%8d < ", "进货数量：", prev->quantity);
    scanf("%d", &(p->quantity));
    printf("%10s%8d < ", "已售数量：", prev->sold);
    scanf("%d", &(p->sold));
    ChangeGoods(p, pos, shop);
    return;
}

void CaculateProfitRate()
{

}

void CaculateRanking()
{

}

int Login()
{
    int isLogin = TRUE;
    printf("是否登录？（Y/N）");
    char c = getchar();
    getchar();
    if (c == 'y' || c == 'Y')
    {
        char buf[12];
        printf("请输入用户名：");
        scanf("%s", buf);
        getchar();
        if (strcmp(buf, bossName) != 0)
            isLogin = FALSE;
        printf("请输入密码：");
        scanf("%s", buf);
        getchar();
        if (isLogin == TRUE && strcmp(buf, password) == 0)
        {
            printf("登录成功！\n");
            return TRUE;
        }
        else
        {
            printf("登录失败！以顾客身份登录！\n");
            return FALSE;
        }
    }
    else
        return FALSE;
}

