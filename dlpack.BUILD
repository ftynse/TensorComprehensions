cc_library(
    name = "dlpack",
    srcs = ["contrib/mock_main.cc"],
    hdrs = glob(["include/dlpack/*.h",
                 "contrib/dlpack/*.h"]),
    copts = ["-Iexternal/com_github_dmlc_dlpack/include",
             "-Iexternal/com_github_dmlc_dlpack/contrib"],
    visibility = ["//visibility:public"],
)
