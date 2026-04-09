LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := psybnc
LOCAL_CFLAGS := -DHAVE_CONFIG -DHAVE_CONFIG_H -DANDROID -DIPV6 -std=gnu89
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../.. \
    $(LOCAL_PATH)/../../src \
    $(LOCAL_PATH)/../../src/c-ares
LOCAL_SRC_FILES := \
    ../../src/psybnc.c \
    ../../src/match.c \
    ../../src/p_client.c \
    ../../src/p_crypt.c \
    ../../src/p_dcc.c \
    ../../src/p_hash.c \
    ../../src/p_idea.c \
    ../../src/p_inifunc.c \
    ../../src/p_link.c \
    ../../src/p_log.c \
    ../../src/p_memory.c \
    ../../src/p_network.c \
    ../../src/p_parse.c \
    ../../src/p_peer.c \
    ../../src/p_server.c \
    ../../src/p_socket.c \
    ../../src/p_string.c \
    ../../src/p_sysmsg.c \
    ../../src/p_userfile.c \
    ../../src/p_uchannel.c \
    ../../src/p_script.c \
    ../../src/p_topology.c \
    ../../src/p_intnet.c \
    ../../src/p_blowfish.c \
    ../../src/p_translate.c \
    ../../src/snprintf.c \
    ../../src/p_dns.c \
    ../../src/c-ares/ares__close_sockets.c \
    ../../src/c-ares/ares__get_hostent.c \
    ../../src/c-ares/ares__read_line.c \
    ../../src/c-ares/ares__timeval.c \
    ../../src/c-ares/ares_cancel.c \
    ../../src/c-ares/ares_data.c \
    ../../src/c-ares/ares_destroy.c \
    ../../src/c-ares/ares_expand_name.c \
    ../../src/c-ares/ares_expand_string.c \
    ../../src/c-ares/ares_fds.c \
    ../../src/c-ares/ares_free_hostent.c \
    ../../src/c-ares/ares_free_string.c \
    ../../src/c-ares/ares_gethostbyaddr.c \
    ../../src/c-ares/ares_gethostbyname.c \
    ../../src/c-ares/ares_getnameinfo.c \
    ../../src/c-ares/ares_getsock.c \
    ../../src/c-ares/ares_init.c \
    ../../src/c-ares/ares_library_init.c \
    ../../src/c-ares/ares_llist.c \
    ../../src/c-ares/ares_mkquery.c \
    ../../src/c-ares/ares_nowarn.c \
    ../../src/c-ares/ares_options.c \
    ../../src/c-ares/ares_parse_a_reply.c \
    ../../src/c-ares/ares_parse_aaaa_reply.c \
    ../../src/c-ares/ares_parse_mx_reply.c \
    ../../src/c-ares/ares_parse_ns_reply.c \
    ../../src/c-ares/ares_parse_ptr_reply.c \
    ../../src/c-ares/ares_parse_srv_reply.c \
    ../../src/c-ares/ares_parse_txt_reply.c \
    ../../src/c-ares/ares_process.c \
    ../../src/c-ares/ares_query.c \
    ../../src/c-ares/ares_search.c \
    ../../src/c-ares/ares_send.c \
    ../../src/c-ares/ares_strcasecmp.c \
    ../../src/c-ares/ares_strdup.c \
    ../../src/c-ares/ares_strerror.c \
    ../../src/c-ares/ares_timeout.c \
    ../../src/c-ares/ares_version.c \
    ../../src/c-ares/ares_writev.c \
    ../../src/c-ares/bitncmp.c \
    ../../src/c-ares/inet_net_pton.c \
    ../../src/c-ares/inet_ntop.c
LOCAL_LDLIBS := -llog -lm

include $(BUILD_EXECUTABLE)
