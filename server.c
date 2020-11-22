#include <pthread.h>        // 引用 pthread 函式庫 負責線程
#include <unistd.h>         //負責sleep()

#include <stdlib.h>         //基本的Libraries
#include <stdio.h>          //基本io
#include <string.h>         //字串處理以及bzero清空

//#include <sys/types.h>
//#include <sys/socket.h>
#include <netinet/in.h>   //sockaddr_in會用到\ /*<netinet/in.h>在<arpa/inet.h>有被include所以不加也沒差*/
#include <arpa/inet.h>    //inet_addr用到

#define MAX_LEN 1024


void init_print_message(int client_scokfd); //print_message 的第一部份 負責處理使用者連進來的預處理ex:發送訊息告訴大家有新使用者加入
void processing_print_message(int client_scokfd);//對資料做處理並且發送
void close_print_message(int client_scokfd);//當連線退出時
void *print_message(void *argu);            //以線程開啟 傳送訊息由三個部分組成 使用者加入(init_print_message) 訊息處理(processing_print_message) 使用者離線(close_print_message)
 
void send_all_message(char *buf);   //對所有人傳送訊息
void now_Members();                         //傳送目前在線人員訊息給所有人有新人以及目前使用者
void message_add_id (char *buf,int client_scokfd);//將訊息加上編號

int all_User_fd[10]={0};//存進聊天室的人資訊
int User_fd_count=0;//目前幾個人

void *print_message(void *argu) {
    int client_scokfd = *(int *)argu;//將無狀態資料轉成整數
    init_print_message(client_scokfd);//預處理包括將sock存入陣列 以及發送訊息告訴大家目前使用者
    processing_print_message(client_scokfd);//資料處理
    close_print_message(client_scokfd);//當連線結束
    
    return NULL;
}
void init_print_message(int client_scokfd)
{
    printf("~~~~~~~~~~~~~~~~~~~~~\n");
    printf("開始\n");
    printf("進入的sock fd : %d\n",client_scokfd);
    printf("在all_User_fd的位置 : %d\n",User_fd_count);
    printf("目前使用者數量 : %d\n",User_fd_count+1);
    all_User_fd[User_fd_count]=client_scokfd;//存當前使用者
    User_fd_count++;    //使用者+1
    char return_sock_fd[20]={0};
    
    sprintf(return_sock_fd, "您的sock id為%d\n",client_scokfd);//告知sock id
    send(client_scokfd, return_sock_fd, sizeof(return_sock_fd), 0);//告知sock id
    
    now_Members();      //傳送所有在線使用者資料
    printf("~~~~~~~~~~~~~~~~~~~~~\n");
    
}
void processing_print_message(int client_scokfd)
{
    char buf[MAX_LEN]={0};//存回傳資料
    int recvSize;//存回傳資料大小
    while (recvSize=recv(client_scokfd, buf, sizeof(buf), 0)) {
        buf[recvSize]='\0';//傳過來的資料不會有\0
        message_add_id(buf,client_scokfd);//加上id
        printf("%s\n",buf);
        send_all_message(buf);//將訊息發送給所有人
        printf("---------------------\n");
        printf("資料內容\n");
        printf("資料大小 : %d\n",recvSize);
        printf("來源client_sockfd : %d\n",client_scokfd);
        printf("---------------------\n");
        bzero(buf, sizeof(buf));//好習慣要歸0
    }
}
void close_print_message(int client_scokfd){
    printf("=====================\n");//當關閉
    printf("關閉\n");
    int i;
    for (i=0; i<User_fd_count&&client_scokfd!=all_User_fd[i]; i++);//取得要刪除位置
    for (;i<User_fd_count; i++) {
        all_User_fd[i]=all_User_fd[i+1];//將要關閉的sockfd刪除(覆蓋掉)
    }
    User_fd_count--;//使用者減一
    close(client_scokfd);//關閉
    printf("關閉client_sockfd : %d\n",client_scokfd);
    printf("剩餘數量 : %d\n",User_fd_count);
    printf("=====================\n");
}
void message_add_id (char *buf,int client_scokfd){//將訊息加上編號
    char temp[MAX_LEN];
    bzero(temp, sizeof(temp));
    strcpy(temp, buf);
    sprintf(buf, "\n訊息事由%d發送 : %s\n",client_scokfd,temp);
    
}
void send_all_message(char *buf)
{
    /*
     警告使用指標sizeof會有問題只抓到8個字元或者單一字元
     所以我用strlen
     */
    int i;
    for (i=0; i<User_fd_count; i++) {
        send(all_User_fd[i],buf, strlen(buf), 0);
    }
}
void now_Members()
{
    sleep(1);//避免封包沾黏 導致訊息消失
    char buf[MAX_LEN],temp[MAX_LEN];//存要傳過去的資料
    int i;
    bzero(buf, sizeof(buf));
    sprintf(buf, "目前人數為 : %d 有",User_fd_count);
    for (i=0; i<User_fd_count; i++) {
        strcpy(temp, buf);
        sprintf(buf, "%s %d",temp,all_User_fd[i]);
    }
    buf[strlen(buf)]='\n';
    printf("#####################\n");
    printf("%s\n",buf);
    printf("#####################\n");
    for (i=0; i<User_fd_count; i++) {
        send(all_User_fd[i], buf, strlen(buf), 0);
    }
   
}


int main() {     // 主程式開始
    pthread_t message_thread;     // 宣告執行緒
    
    struct sockaddr_in server,client;//存一些socket資料
    
    /*
     程式設計師不應操作sockaddr，sockaddr是給作業系統用的
     程式設計師應使用sockaddr_in來表示地址，sockaddr_in區分了地址和埠，使用更方便。
     */
    
    int sockfd;//存socket table第幾個位置(數字)
    
    bzero(&server,sizeof(server));//把sockaddr_in的server清空
    //要用到<string.h>
    
    //設定ip地址,port
    server.sin_family = AF_INET;//AF是設定addr所以是AF不是PF 但其實沒差
    server.sin_addr.s_addr = inet_addr("0.0.0.0");
    server.sin_port = htons(5678);
    //設定ip地址,port
    sockfd = socket(PF_INET,SOCK_STREAM,0);
    /*
     domain為位址家族(PF_INET)
     type指定通訊的方式(例如 TCP(SOCK_STREAM) 或是
     UDP(SOCK_DGRAM))
     protocol通為通訊代碼，通常設0，可以直接根據type自動設定。SOCK_STREAM 且系列为 AF_INET ，則協議自動為TCP
     ex:tcp 用 IPPROTO_TCP  6
     */
    bind(sockfd,(struct sockaddr*)&server,sizeof(server));//綁定sockfd和設定sockaddr_in server
    listen(sockfd,5);//告訴系統設定好了 以及做大連線數量
    system("lsof -i:5678");
    int addrlen=sizeof(client);//取得sockaddr_in大小
    int client_scokfd;//存新連線fd
    while (client_scokfd=accept(sockfd,(struct sockaddr_in*) &client, &addrlen)) {
        pthread_create(&message_thread, NULL, &print_message, (void *)&client_scokfd);//執行緒 print_george
        /*第一個放pthread_t(存線程狀態資料) */
    }
    return 0;
}
