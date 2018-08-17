# Create local repositories wrt to Conda installation

def _conda_local_repository(repository_ctx):
  if 'CONDA_PREFIX' not in repository_ctx.os.environ:
    fail("must run under conda ($CONDA_PREFIX undefined)")

  prefix = repository_ctx.os.environ['CONDA_PREFIX']
  path = "%s/%s" % (prefix, repository_ctx.attr.path) if repository_ctx.attr.path != "" else prefix
  files = repository_ctx.execute(["ls", path]).stdout.splitlines()

  for f in files:
    target = "{}/{}".format(path, f)
    repository_ctx.symlink(target, f)
  repository_ctx.file("BUILD", repository_ctx.attr.build_file_content,
                      executable=False)

conda_local_repository = repository_rule(
  implementation = _conda_local_repository,
  attrs = {
      "path": attr.string(mandatory=True),
      "build_file_content": attr.string(mandatory=True),
  },
  environ = [
      'CONDA_PREFIX',
  ])
"""Sets up local new local repository rooted at $CONDA_PREFIX
"""
