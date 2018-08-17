# isl

genrule(
    name = "isl_config_h",
    outs = ["isl_config.h"],
    cmd = """
cat >$@ <<EOF
#define HAVE___ATTRIBUTE__ 
#define HAVE_DECL_FFS 1
#define HAVE_DECL_STRCASECMP 1
#define HAVE_DECL_STRNCASECMP 1
#define HAVE_DECL_SNPRINTF 1
#define USE_GMP_FOR_MP
#include <isl_config_post.h>                             
EOF
    """
)

genrule(
    name = "gitversion_h",
    outs = ["gitversion.h"],
    cmd = """
cat >$@ <<EOF
#define GIT_HEAD_ID ""
EOF
    """
)

genrule(
    name = "stdint_h",
    outs = ["isl/stdint.h"],
    cmd = """
cat >$@ <<EOF
#include <stdint.h>
EOF
    """
)

cc_library(
    name = "isl_gen_includes",
    hdrs = ["isl_config.h",
            "gitversion.h",
            "isl/stdint.h"],
    includes = ["."],
)

cc_library(
    name = "isl",
    srcs = [
    "basis_reduction_tab.c",
    "isl_aff.c",
    "isl_aff_map.c",
    "isl_affine_hull.c",
    "isl_arg.c",
    "isl_ast_build.c",
    "isl_ast_build_expr.c",
    "isl_ast.c",
    "isl_ast_codegen.c",
    "isl_ast_graft.c",
    "isl_bernstein.c",
    "isl_blk.c",
    "isl_bound.c",
    "isl_box.c",
    "isl_coalesce.c",
    "isl_constraint.c",
    "isl_convex_hull.c",
    "isl_ctx.c",
    "isl_deprecated.c",
    "isl_dim_map.c",
    "isl_equalities.c",
    "isl_factorization.c",
    "isl_farkas.c",
    "isl_ffs.c",
    "isl_flow.c",
    "isl_fold.c",
    "isl_hash.c",
    "isl_id.c",
    "isl_id_to_ast_expr.c",
    "isl_id_to_id.c",
    "isl_id_to_pw_aff.c",
    "isl_ilp.c",
    "isl_input.c",
    "isl_local.c",
    "isl_local_space.c",
    "isl_lp.c",
    "isl_map.c",
    "isl_map_list.c",
    "isl_map_simplify.c",
    "isl_map_subtract.c",
    "isl_map_to_basic_set.c",
    "isl_mat.c",
    "isl_morph.c",
    "isl_obj.c",
    "isl_options.c",
    "isl_output.c",
    "isl_point.c",
    "isl_polynomial.c",
    "isl_printer.c",
    "isl_range.c",
    "isl_reordering.c",
    "isl_sample.c",
    "isl_scan.c",
    "isl_schedule.c",
    "isl_schedule_band.c",
    "isl_schedule_node.c",
    "isl_schedule_read.c",
    "isl_schedule_tree.c",
    "isl_scheduler.c",
    "isl_schedule_constraints.c",
    "isl_seq.c",
    "isl_set_list.c",
    "isl_sort.c",
    "isl_space.c",
    "isl_stream.c",
    "isl_stride.c",
    "isl_system.c",
    "isl_tab.c",
    "isl_tab_pip.c",
    "isl_tarjan.c",
    "isl_transitive_closure.c",
    "isl_union_map.c",
    "isl_val.c",
    "isl_vec.c",
    "isl_version.c",
    "isl_vertices.c",
    "print.c",
    "isl_gmp.c",
    "isl_val_gmp.c"],
    hdrs = glob(["include/isl/*h",
                 "*.h",
                 "*templ*.c",
                 "include/isl/*templ*.c",
                 "*_to_*.c",
                 "*_from_*.c",
                 "extract_key.c",
                 "isl_multi_no_explicit_domain.c",
                 "isl_pw_eval.c",
                 "isl_union_single.c",
                 "isl_multi_dims.c",
                 "isl_union_eval.c",
                 "isl_union_neg.c",
                 "isl_pw_hash.c",
                 "isl_pw_union_opt.c",
                 "isl_pw_eval.c",
                 "isl_pw_hash.c",
                 "isl_pw_union_opt.c",
                 "isl_union_single.c",
                 "isl_union_neg.c",
                 "isl_multi_no_explicit_domain.c",
                 "isl_multi_apply_set.c",
                 "isl_multi_cmp.c",
                 "isl_multi_dims.c",
                 "isl_multi_floor.c",
                 "isl_multi_gist.c",
                 "isl_pw_union_opt.c",
                 "isl_union_multi.c",
                 "isl_union_neg.c",
                 "isl_multi_explicit_domain.c",
                 "isl_multi_pw_aff_explicit_domain.c",
                 "isl_multi_apply_set.c",
                 "isl_multi_coalesce.c",
                 "isl_multi_dims.c",
                 "isl_multi_gist.c",
                 "isl_multi_hash.c",
                 "isl_multi_align_set.c",
                 "isl_multi_intersect.c",
                 "isl_multi_explicit_domain.c",
                 "isl_multi_union_pw_aff_explicit_domain.c",
                 "isl_multi_apply_set.c",
                 "isl_multi_apply_union_set.c",
                 "isl_multi_coalesce.c",
                 "isl_multi_floor.c",
                 "isl_multi_gist.c",
                 "isl_multi_align_set.c",
                 "isl_multi_align_union_set.c",
                 "isl_multi_intersect.c",
                 "isl_pw_eval.c",
                 "isl_union_single.c",
                 "isl_union_eval.c",
                 "isl_multi_no_explicit_domain.c",
                 "isl_pw_eval.c",
                 "isl_union_single.c",
                 "isl_union_eval.c",
                 "isl_union_neg.c",
                 "isl_multi_no_explicit_domain.c",
                 "isl_multi_dims.c",
                 "*inl.c"]),
    includes = [".", "include"],
#    copts = ["-Iexternal/com_github_nicolasvasilache_isl/include -Iexternal/com_github_nicolasvasilache_isl/",
# "-I$(GENDIR)/external/com_github_nicolasvasilache_isl"
#    ],
    linkopts = ["-lgmp"],
    deps = [":isl_gen_includes"],
    visibility = ["//visibility:public"]
)

