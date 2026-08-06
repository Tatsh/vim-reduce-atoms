{
  uses_user_defaults: true,
  project_name: 'vim-reduce-atoms',
  version: '0.0.0',
  description: 'Vim plugin to reduce Portage atoms to category/package while keeping USE flags.',
  keywords: ['gentoo', 'package.use', 'portage', 'qatom', 'vim', 'vim-plugin'],
  license: 'MIT',
  project_type: 'other',
  want_codeql: false,
  want_docs: false,
  want_tests: false,
  prettierignore+: [
    '*.vim',
  ],
}
