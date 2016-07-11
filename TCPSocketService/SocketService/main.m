//
//  main.m
//  SocketService
//
//  Created by Xionghaizi on 16/6/7.
//  Copyright © 2016年 Xionghaizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //        1
        //创建socket对象
        int err;
        //AF_INET(又称PF_INET)是IPv4网络协议的套接字类型,AF_INET6则是IPv6的
        //流式Socket（SOCK_STREAM）区别数据报式Socket（SOCK_DGRAM）
        int fd=socket(AF_INET, SOCK_STREAM  , 0);
        BOOL success=(fd!=-1);
        //        1
        //   2
        
        if (success) {
            NSLog(@"socket success");
            
//            struct sockaddr_in
//            {
//                short sin_family;/*Address family一般来说AF_INET（地址族）PF_INET（协议族）*/
//                unsigned short sin_port;/*Port number(必须要采用网络数据格式,普通数字可以用htons()函数转换成网络数据格式的数字)*/
//                struct in_addr sin_addr;/*IP address in network byte order（Internet address）sin_addr存储IP地址，使用in_addr这个数据结构*/
//                unsigned char sin_zero[8];/*Same size as struct sockaddr没有实际意义,只是为了　跟SOCKADDR结构在内存中对齐*/
//            };
            
            struct sockaddr_in addr;
            memset(&addr, 0, sizeof(addr));
            addr.sin_len=sizeof(addr);
            addr.sin_family=AF_INET;
            //            =======================================================================
            addr.sin_port=htons(1024);
            //        ============================================================================
            addr.sin_addr.s_addr=INADDR_ANY;
            //bind(sockid, local addr, addrlen)
            err=bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            success=(err==0);
        }
        //   2
        //        ============================================================================
        if (success) {
            NSLog(@"bind(绑定) success");
            err=listen(fd, 5);//开始监听
            success=(err==0);
        }
        //    ============================================================================
        //3
        if (success) {
            NSLog(@"listen success");
            while (true) {
                
                struct sockaddr_in peeraddr;
                int peerfd;
                socklen_t addrLen;
                addrLen=sizeof(peeraddr);
                NSLog(@"prepare accept");
                peerfd=accept(fd, (struct sockaddr *)&peeraddr, &addrLen);
                success=(peerfd!=-1);
                //    ============================================================================
                if (success) {
                    NSLog(@"accept success,remote address:%s,port:%d",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
                    char buf[1024];
                    ssize_t count;
                    size_t len=sizeof(buf);
                    do {
                        count=recv(peerfd, buf, len, 0);
                        NSString* str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",str);
                    } while (strcmp(buf, "exit")!=0);
                }
                //    ============================================================================
                close(peerfd);
            } 
        }  
        //3     
    }
    return 0;
}
