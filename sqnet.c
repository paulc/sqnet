
#include <stdio.h>
#include "sqnet.h"

static SQInteger _anet_tcpConnect(HSQUIRRELVM v) {
    char err[ANET_ERR_LEN];
    int fd;
    SQInteger port;
    const SQChar *addr;
    sq_getinteger(v,-1,&port);
    sq_getstring(v,-2,&addr);
	printf("Connect\n");
    if ((fd = anetTcpConnect(err,(char *)addr,port)) == ANET_ERR) {
        return sq_throwerror(v,_SC(err));
    }
	anetWrite(fd,"Hello\n",6);
    return 0;
}

#define _DECL_FUNC(name,nparams,pmask) {_SC(#name),_anet_##name,nparams,pmask}
static SQRegFunction anet_funcs[]={
    _DECL_FUNC(tcpConnect,3,_SC(".si")),
    {0,0}
};
#undef _DECL_FUNC


SQInteger register_sqnet(HSQUIRRELVM v) {
    int i = 0;
	printf("Register\n");
    while(anet_funcs[i].name!=0) {
        sq_pushstring(v,anet_funcs[i].name,-1);
        sq_newclosure(v,anet_funcs[i].f,0);
        sq_setparamscheck(v,anet_funcs[i].nparamscheck,anet_funcs[i].typemask);
        sq_setnativeclosurename(v,-1,anet_funcs[i].name);
        sq_newslot(v,-3,SQFalse);
        i++;
    }
    return 1;
}
