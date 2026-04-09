#define SALT1 "ndkandroidsalt"
#define SALT2 "psybncportable"
#define CODE1 73
#define CODE2 79
#define SA1 3
#define SA2 5

unsigned char slt1[15];
unsigned char slt2[15];

int makesalt(void)
{
    memcpy(slt1,SALT1,sizeof(SALT1));
    memcpy(slt2,SALT2,sizeof(SALT2));
    return 0x0;
}
