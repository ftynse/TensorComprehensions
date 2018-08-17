
# Protos
proto_library(
    name = "mapping_options_proto",
    srcs = ["//tc/proto:mapping_options.proto"],
#    proto_source_root = "tc/proto"
)

proto_library(
    name = "compcache_proto",
    srcs = ["//tc/proto:compcache.proto"],
    deps = ["mapping_options_proto"],
#    proto_source_root = "tc/proto"
)

cc_proto_library(
    name = "mapping_options_cc_proto",
    deps = [":mapping_options_proto"],
    visibility = ["//visibility:public"],
)

cc_proto_library(
    name = "compcache_cc_proto",
    deps = [":compcache_proto"],
    visibility = ["//visibility:public"],
)
