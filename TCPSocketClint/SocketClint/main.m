//
//  main.m
//  SocketClint
//
//  Created by Xionghaizi on 16/6/7.
//  Copyright © 2016年 Xionghaizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import <arpa/inet.h>
int main(int argc, const char * argv[])
{
    @autoreleasepool {
        //        1
        int err;
        int fd=socket(AF_INET, SOCK_STREAM, 0);
        BOOL success=(fd!=-1);
        struct sockaddr_in addr;
        //        1
        //   2a
        if (success) {
            NSLog(@"socket success");
            memset(&addr, 0, sizeof(addr));
            addr.sin_len=sizeof(addr);
            addr.sin_family=AF_INET;
            addr.sin_addr.s_addr=INADDR_ANY;
            err=bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            success=(err==0);
        }
        //   2
        //3
        if (success) {
            //============================================================================
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len=sizeof(peeraddr);
            peeraddr.sin_family=AF_INET;
            peeraddr.sin_port=htons(1024);
            //            peeraddr.sin_addr.s_addr=INADDR_ANY;
            peeraddr.sin_addr.s_addr=inet_addr("192.168.0.5");
            //            这个地址是服务器的地址，
            socklen_t addrLen;
            addrLen =sizeof(peeraddr);
            NSLog(@"connecting");
            err=connect(fd, (struct sockaddr *)&peeraddr, addrLen);
            success=(err==0);
            if (success) {
                //                struct sockaddr_in addr;
                err =getsockname(fd, (struct sockaddr *)&addr, &addrLen);
                success=(err==0);
                //============================================================================
                //============================================================================
                if (success) {
                    NSLog(@"connect success,local address:%s,port:%d",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));
                    char buf[1024];
                    do {
                        printf("input message:");
                        scanf("%s",buf);
                        send(fd, buf, 1024, 0);
                    } while (strcmp(buf, "exit")!=0);
                }
            }
            else{
                NSLog(@"connect failed");
            }
        }
        //    ============================================================================
        //3
    }
    return 0;
}
