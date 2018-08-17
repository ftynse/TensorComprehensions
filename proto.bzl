# Adapted from TensorFlow (http://github.com/tensorflow/tensorflow)

load("@protobuf_archive//:protobuf.bzl", "proto_gen")

# Appends a suffix to a list of deps.
def tf_deps(deps, suffix):
  tf_deps = []

  # If the package name is in shorthand form (ie: does not contain a ':'),
  # expand it to the full name.
  for dep in deps:
    tf_dep = dep

    if not ":" in dep:
      dep_pieces = dep.split("/")
      tf_dep += ":" + dep_pieces[len(dep_pieces) - 1]

    tf_deps += [tf_dep + suffix]

  return tf_deps

def _proto_cc_hdrs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".pb.h" for s in srcs]
  if use_grpc_plugin:
    ret += [s[:-len(".proto")] + ".grpc.pb.h" for s in srcs]
  return ret

def _proto_cc_srcs(srcs, use_grpc_plugin=False):
  ret = [s[:-len(".proto")] + ".pb.cc" for s in srcs]
  if use_grpc_plugin:
    ret += [s[:-len(".proto")] + ".grpc.pb.cc" for s in srcs]
  return ret

# Re-defined protocol buffer rule to allow building "header only" protocol
# buffers, to avoid duplicate registrations. Also allows non-iterable cc_libs
# containing select() statements.
def cc_proto_library(
    name,
    srcs=[],
    deps=[],
    cc_libs=[],
    include=None,
    protoc="@protobuf_archive//:protoc",
    internal_bootstrap_hack=False,
    use_grpc_plugin=False,
    use_grpc_namespace=False,
    default_header=False,
    **kargs):
  """Bazel rule to create a C++ protobuf library from proto source files.

  Args:
    name: the name of the cc_proto_library.
    srcs: the .proto files of the cc_proto_library.
    deps: a list of dependency labels; must be cc_proto_library.
    cc_libs: a list of other cc_library targets depended by the generated
        cc_library.
    include: a string indicating the include path of the .proto files.
    protoc: the label of the protocol compiler to generate the sources.
    internal_bootstrap_hack: a flag indicate the cc_proto_library is used only
        for bootstraping. When it is set to True, no files will be generated.
        The rule will simply be a provider for .proto files, so that other
        cc_proto_library can depend on it.
    use_grpc_plugin: a flag to indicate whether to call the grpc C++ plugin
        when processing the proto files.
    default_header: Controls the naming of generated rules. If True, the `name`
        rule will be header-only, and an _impl rule will contain the
        implementation. Otherwise the header-only rule (name + "_headers_only")
        must be referred to explicitly.
    **kargs: other keyword arguments that are passed to cc_library.
  """

  includes = []
  if include != None:
    includes = [include]

  if internal_bootstrap_hack:
    # For pre-checked-in generated files, we add the internal_bootstrap_hack
    # which will skip the codegen action.
    proto_gen(
        name=name + "_genproto",
        srcs=srcs,
        deps=[s + "_genproto" for s in deps],
        includes=includes,
        protoc=protoc,
        visibility=["//visibility:public"],
    )
    # An empty cc_library to make rule dependency consistent.
    native.cc_library(
        name=name,
        **kargs)
    return

  grpc_cpp_plugin = None
  plugin_options = []
  if use_grpc_plugin:
    grpc_cpp_plugin = "//external:grpc_cpp_plugin"
    if use_grpc_namespace:
      plugin_options = ["services_namespace=grpc"]

  gen_srcs = _proto_cc_srcs(srcs, use_grpc_plugin)
  gen_hdrs = _proto_cc_hdrs(srcs, use_grpc_plugin)
  outs = gen_srcs + gen_hdrs

  proto_gen(
      name=name + "_genproto",
      srcs=srcs,
      deps=[s + "_genproto" for s in deps],
      includes=includes,
      protoc=protoc,
      plugin=grpc_cpp_plugin,
      plugin_language="grpc",
      plugin_options=plugin_options,
      gen_cc=1,
      outs=outs,
      visibility=["//visibility:public"],
  )

  if use_grpc_plugin:
    cc_libs += select({
        "//tensorflow:linux_s390x": ["//external:grpc_lib_unsecure"],
        "//conditions:default": ["//external:grpc_lib"],
    })

  if default_header:
    header_only_name = name
    impl_name = name + "_impl"
  else:
    header_only_name = name + "_headers_only"
    impl_name = name

  native.cc_library(
      name=impl_name,
      srcs=gen_srcs,
      hdrs=gen_hdrs,
      deps=cc_libs + deps + ["@protobuf_archive//:protobuf"],
      includes=includes,
      **kargs)
  native.cc_library(
      name=header_only_name,
      deps=["@protobuf_archive//:protobuf", "@protobuf_archive//:cc_wkt_protos"],
      hdrs=gen_hdrs,
      **kargs)

def proto_library_cc(name, srcs = [], has_services = None,
                        protodeps = [],
                        visibility = [], testonly = 0,
                        cc_libs = [],
                        cc_stubby_versions = None,
                        cc_grpc_version = None,
                        j2objc_api_version = 1,
                        cc_api_version = 2,
                        dart_api_version = 2,
                        java_api_version = 2, py_api_version = 2,
                        js_api_version = 2, js_codegen = "jspb",
                        default_header = False):
  js_codegen = js_codegen  # unused argument
  js_api_version = js_api_version  # unused argument
  native.filegroup(
      name = name + "_proto_srcs",
      srcs = srcs + tf_deps(protodeps, "_proto_srcs"),
      testonly = testonly,
      visibility = visibility,
  )

  use_grpc_plugin = None
  if cc_grpc_version:
    use_grpc_plugin = True

  cc_deps = tf_deps(protodeps, "_cc")
  cc_name = name + "_cc"
  if not srcs:
    # This is a collection of sub-libraries. Build header-only and impl
    # libraries containing all the sources.
    proto_gen(
        name = cc_name + "_genproto",
        deps = [s + "_genproto" for s in cc_deps],
        protoc = "@protobuf_archive//:protoc",
        visibility=["//visibility:public"],
    )
    native.cc_library(
        name = cc_name,
        deps = cc_deps + ["@protobuf_archive//:protobuf_headers"],
        testonly = testonly,
        visibility = visibility,
    )
    native.cc_library(
        name = cc_name + "_impl",
        deps = [s + "_impl" for s in cc_deps] + ["@protobuf_archive//:cc_wkt_protos"],
    )

    return

  cc_proto_library(
      name = cc_name,
      srcs = srcs,
      deps = cc_deps + ["@protobuf_archive//:cc_wkt_protos"],
      cc_libs = cc_libs,
#      + if_static(
#          ["@protobuf_archive//:protobuf"],
#          ["@protobuf_archive//:protobuf_headers"]
#      ),
      copts = [
          "-Wno-unknown-warning-option",
          "-Wno-unused-but-set-variable",
          "-Wno-sign-compare",
      ],
      protoc = "@protobuf_archive//:protoc",
      use_grpc_plugin = use_grpc_plugin,
      testonly = testonly,
      visibility = visibility,
      default_header = default_header,
  )

def tc_protos():
#  proto_library_cc(
#      "mapping_options_proto",
#      ["//tc/proto:mapping_options.proto"],
#      visibility = ["//visibility:public"])
  proto_library_cc(
      "compcache_proto",
      ["//tc/proto:compcache.proto", "//tc/proto:mapping_options.proto"],
      visibility = ["//visibility:public"],
      )
