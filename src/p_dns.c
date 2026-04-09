#define P_DNS

#include <p_global.h>
#include <ares.h>
#include <netdb.h>
#include <sys/socket.h>
#if defined(ANDROID) || defined(__ANDROID__)
#include <sys/system_properties.h>
#endif

static ares_channel resolver;

#if defined(ANDROID) || defined(__ANDROID__)
static int p_dns_configure_android_servers(void)
{
    char value[PROP_VALUE_MAX];
    char servers[256];
    int rc;
    int length;
    int first;
    int i;
    const char *fallback;
    static const char *properties[] = { "net.dns1", "net.dns2", "net.dns3", "net.dns4" };

    servers[0]=0;
    first=1;
    for(i=0;i<4;i++)
    {
        value[0]=0;
        length=__system_property_get(properties[i], value);
        if(length<=0 || value[0]==0)
            continue;
        if(!first)
            ap_snprintf(servers,sizeof(servers),"%s,%s",servers,value);
        else
            strmncpy(servers,value,sizeof(servers));
        first=0;
    }
    if(servers[0]==0)
    {
        fallback=getenv("PSYBNC_DNS_SERVERS");
        if(fallback!=NULL && *fallback!=0)
            strmncpy(servers,(char *)fallback,sizeof(servers));
    }
    if(servers[0]==0)
        strmncpy(servers,"1.1.1.1,8.8.8.8",sizeof(servers));
    rc=ares_set_servers_csv(resolver,servers);
    if(rc!=ARES_SUCCESS)
    {
        p_log(LOG_WARNING,-1,"Failed to configure Android DNS servers '%s': %s",servers,ares_strerror(rc));
        return 0;
    }
    p_log(LOG_INFO,-1,"Android DNS servers configured: %s",servers);
    return 1;
}
#endif

/**
 * Initialize the DNS resolver for use. If this function fails the BNC will not be able to function
 * properly.
 */
int p_dns_init()
{
    int ret;

    if ((ret = ares_init(&resolver)) != ARES_SUCCESS)
    {
        p_log(LOG_ERROR, -1, "Failed to initialize ares resolver: %s", ares_strerror(ret));
        return 0;
    }
#if defined(ANDROID) || defined(__ANDROID__)
    p_dns_configure_android_servers();
#endif

    p_log(LOG_INFO, -1, "Asynchronous resolver initialized: c-ares %s", ares_version(NULL));
    return 1;
}

/**
 * Fill the 'readers' and 'writers' file-descriptor sets with the DNS resolver's reader and writer sockets. 
 * These will be the sockets that are either sending a query, or are receiving a response. Returns a value
 * representing the number of active file descriptors or 0 if the DNS resolver is not executing a query.
 *
 * This function should be called before calling and assumes that the fdsets have been properly initialized
 * with something like FD_ZERO()
 */
int p_dns_fds(fd_set *read_fds, fd_set *write_fds)
{
    pcontext;
    return ares_fds(resolver, read_fds, write_fds);
}

/**
 * Tell the DNS resolver that the select() has finished and it can check if any of its sockets had any data
 * on it.
 *
 * This function should be called after calling p_dns_fds() and select(). It ignores any file descriptors that
 * do not belong to it (e.g. IRC connections).
 */
void p_dns_process(fd_set *read_fds, fd_set *write_fds)
{
    pcontext;
    ares_process(resolver, read_fds, write_fds);
}

void p_dns_gethostbyname(char *hostname, int af, dns_host_callback callback, void *arg)
{
    pcontext;
    {
        struct addrinfo hints;
        struct addrinfo *result;
        struct hostent hostent_data;
        char *addr_list[2];
        char *aliases[1];
        unsigned char addrbuf[sizeof(struct in6_addr)];
        int status;

        memset(&hints,0,sizeof(hints));
        hints.ai_socktype=SOCK_STREAM;
        hints.ai_family=af;
        result=NULL;
        status=getaddrinfo(hostname,NULL,&hints,&result);
        if(status!=0 || result==NULL)
        {
            p_log(LOG_WARNING,-1,"System DNS failed for '%s': %s",hostname,gai_strerror(status));
            callback(arg,ARES_ENOTFOUND,0,NULL);
            if(result!=NULL)
                freeaddrinfo(result);
            return;
        }
        p_log(LOG_INFO,-1,"System DNS resolved '%s' using getaddrinfo",hostname);
        memset(&hostent_data,0,sizeof(hostent_data));
        memset(addrbuf,0,sizeof(addrbuf));
        aliases[0]=NULL;
        addr_list[0]=(char *)addrbuf;
        addr_list[1]=NULL;
        hostent_data.h_name=hostname;
        hostent_data.h_aliases=aliases;
        hostent_data.h_addrtype=result->ai_family;
        if(result->ai_family==AF_INET6)
        {
            hostent_data.h_length=sizeof(struct in6_addr);
            memcpy(addrbuf,&((struct sockaddr_in6 *)result->ai_addr)->sin6_addr,sizeof(struct in6_addr));
        } else {
            hostent_data.h_length=sizeof(struct in_addr);
            memcpy(addrbuf,&((struct sockaddr_in *)result->ai_addr)->sin_addr,sizeof(struct in_addr));
        }
        hostent_data.h_addr_list=addr_list;
        callback(arg,ARES_SUCCESS,0,&hostent_data);
        freeaddrinfo(result);
        return;
    }
}

void p_dns_gethostbyaddr(const void *address, int addrlen, int family, dns_host_callback callback, void *arg)
{
    pcontext;
    {
        struct sockaddr_storage storage;
        struct hostent hostent_data;
        char hostname[NI_MAXHOST];
        char *aliases[1];
        int status;

        memset(&storage,0,sizeof(storage));
        memset(&hostent_data,0,sizeof(hostent_data));
        memset(hostname,0,sizeof(hostname));
        aliases[0]=NULL;
        if(family==AF_INET6)
        {
            struct sockaddr_in6 *addr6=(struct sockaddr_in6 *)&storage;
            addr6->sin6_family=AF_INET6;
            memcpy(&addr6->sin6_addr,address,sizeof(struct in6_addr));
            status=getnameinfo((struct sockaddr *)addr6,sizeof(*addr6),hostname,sizeof(hostname),NULL,0,NI_NAMEREQD);
        } else {
            struct sockaddr_in *addr4=(struct sockaddr_in *)&storage;
            addr4->sin_family=AF_INET;
            memcpy(&addr4->sin_addr,address,sizeof(struct in_addr));
            status=getnameinfo((struct sockaddr *)addr4,sizeof(*addr4),hostname,sizeof(hostname),NULL,0,NI_NAMEREQD);
        }
        if(status!=0)
        {
            callback(arg,ARES_ENOTFOUND,0,NULL);
            return;
        }
        hostent_data.h_name=hostname;
        hostent_data.h_aliases=aliases;
        hostent_data.h_addrtype=family;
        hostent_data.h_length=addrlen;
        callback(arg,ARES_SUCCESS,0,&hostent_data);
        return;
    }
}

int p_dns_success(int status)
{
    return (status == ARES_SUCCESS);
}

const char *p_dns_strerror(int status)
{
    pcontext;
    return ares_strerror(status);
}
