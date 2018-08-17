
# Lang library
cc_library(
    name = "tc_lang",
    srcs = ["tc/lang/parser.cc", "tc/lang/lexer.cc", "tc/lang/tc_format.cc"],
    hdrs = glob(["tc/lang/*.h", "tc/utils/*.h"]),
)

# "Version" library TODO: static only
genrule(
    name = "config_version_cc",
    srcs = ["tc/version/version.cc.in"],
    outs = ["tc/version/version.cc"],
    cmd = "TARGET=`realpath $@` TC_V_PATH=`realpath $<`; TC_V_DIR=`dirname $$TC_V_PATH`; cd $$TC_V_DIR; cat version.cc.in | sed -e \"s/@GIT_DESCRIPTION@/\"`git rev-parse HEAD`\"/\" > $$TARGET"
)

cc_library(
    name = "tc_version",
    srcs = ["tc/version/version.cc"],
    hdrs = ["tc/version/version.h"],
    data = [":config_version_cc"],
    includes = ["tc/version"],
)

# isl and interface
cc_library(
    name = "tc_isl",
    hdrs = ["isl_interface/include/isl/cpp.h"],
    strip_include_prefix = "isl_interface/include",
    deps = ["@com_github_nicolasvasilache_isl//:isl"],
)

# Core library
cc_library(
    name = "tc_core",
    srcs = glob([
        "tc/core/*.cc",
        "tc/core/polyhedral/*.cc",
        "tc/core/cpu/*.cc",
        "tc/core/polyhedral/cpu/*.cc"]),
    hdrs = glob([
        "tc/core/*.h",
        "tc/core/polyhedral/*.h",
        "tc/utils/*.h",
        "tc/core/utils/*.h",
        "tc/external/*.h",
        "tc/external/detail/*.h",
        "tc/core/polyhedral/cpu/*.h",
        "tc/core/cpu/*.h"]),
    deps = [":tc_lang",
            ":tc_version",
            ":tc_isl",
            "//tc/proto:mapping_options_cc_proto",
            "//tc/proto:compcache_cc_proto",
            "@com_github_google_glog//:glog",
            "@com_github_dmlc_dlpack//:dlpack",
            "@conda_llvm//:conda_llvm_lib",
            "@conda_halide//:conda_halide_lib"],
    visibility = ["//visibility:public"],
)

# Core tests
cc_binary(
    name = "test_core",
    srcs = glob([
        "test/test_core.cc",
        "tc/library/*.h"]),
    deps = [":tc_core",
            "@com_github_google_googletest//:gtest"],
)

# Aten library
cc_library(
    name = "tc_aten",
    srcs = ["tc/aten/aten_compiler.cc"],
    hdrs = glob(["tc/aten/*.h"]),
    deps = [":tc_core", "@conda_aten//:aten_headers"],
    visibility = ["//visibility:public"],
)

# Core test with LLVM and ATen
cc_binary(
    name = "test_mapper_llvm",
    srcs = ["test/test_mapper_llvm.cc",
            "test/test_harness_aten.h"],
    deps = [":tc_aten",
            "@com_github_google_googletest//:gtest",
            ],
)
