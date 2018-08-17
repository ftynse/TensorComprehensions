workspace(name = "tc")

load("//:tools.bzl", "conda_local_repository")

git_repository(
    name = "com_github_google_glog",
    commit = "e6e2e1372aeb3f6ac6ca5f4a3d72bad8dce3c724",
    remote = "https://github.com/google/glog.git"
)

http_archive(
    name = "com_google_protobuf",
    urls = [
        "https://mirror.bazel.build/github.com/google/protobuf/archive/v3.6.0.tar.gz",
        "https://github.com/google/protobuf/archive/v3.6.0.tar.gz",
    ],
    sha256 = "50a5753995b3142627ac55cfd496cebc418a2e575ca0236e29033c67bd5665f4",
    strip_prefix = "protobuf-3.6.0",
)

http_archive(
    name = "com_google_protobuf_cc",
    urls = [
        "https://mirror.bazel.build/github.com/google/protobuf/archive/v3.6.0.tar.gz",
        "https://github.com/google/protobuf/archive/v3.6.0.tar.gz",
    ],
    sha256 = "50a5753995b3142627ac55cfd496cebc418a2e575ca0236e29033c67bd5665f4",
    strip_prefix = "protobuf-3.6.0",
)

http_archive(
    name = "com_github_gflags_gflags",
    urls = [
        "https://mirror.bazel.build/github.com/gflags/gflags/archive/v2.2.1.tar.gz",
        "https://github.com/gflags/gflags/archive/v2.2.1.tar.gz",
    ],
    sha256 = "ae27cdbcd6a2f935baa78e4f21f675649271634c092b1be01469440495609d0e",
    strip_prefix = "gflags-2.2.1",
)

git_repository(
    name = "com_github_google_googletest",
    commit = "82670da613af6b5a427e7cc9980ba8977afcab8a",
    remote = "https://github.com/google/googletest.git"
)

#load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

new_git_repository(
    name = "com_github_dmlc_dlpack",
    commit = "10892ac964f1af7c81aae145cd3fab78bbccd297",
    remote = "https://github.com/dmlc/dlpack",
    build_file = "dlpack.BUILD"
)

new_git_repository(
    name = "com_github_nicolasvasilache_isl",
    commit = "96fef8767ee8823d0316e040c827c78b28802ce9",
    remote = "https://github.com/nicolasvasilache/isl.git",
    build_file = "isl.BUILD"
)

# FIXME query conda path instead
conda_local_repository(
    name = "conda_aten",
    path = "lib/python3.6/site-packages/torch/lib",
    build_file_content = """
cc_library(
    name = "aten_headers",
    srcs = ["libATen.so"],
    hdrs = glob(["include/ATen/*.h"]),
    strip_include_prefix = "include",
    visibility = ["//visibility:public"]
)
    """
)

conda_local_repository(
    name = "conda_llvm",
    path = "",
    build_file_content = """
cc_library(
    name = "conda_llvm_lib",
    srcs = ["lib/libLLVM.so"],
    hdrs = glob(["include/llvm/**",
                 "include/llvm-c/**"]),
    strip_include_prefix = "include",
    visibility = ["//visibility:public"]
)
    """
)

conda_local_repository(
    name = "conda_clang",
    path = "",
    build_file_content = """
cc_library(
    name = "conda_clang_lib",
    srcs = ["lib/libclang.so"],
    hdrs = glob(["include/clang/**"]),
    strip_include_prefix = "include",
    visibility = ["//visibility:public"]
)
  """
)

conda_local_repository(
    name = "conda_halide",
    path = "",
    build_file_content = """
cc_library(
    name = "conda_halide_lib",
    srcs = ["lib/libHalide.so"],
    hdrs = glob(["include/Halide/*.h"]),
    strip_include_prefix = "include/Halide",
    visibility = ["//visibility:public"]
)
    """
)
