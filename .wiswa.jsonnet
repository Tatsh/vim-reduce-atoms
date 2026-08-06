{
  uses_user_defaults: true,
  project_name: 'vim-reduce-atoms',
  version: '0.0.1',
  description: 'Vim plugin to reduce Portage atoms to category/package while keeping USE flags.',
  keywords: ['gentoo', 'portage', 'vim', 'vim plugin'],
  license: 'MIT',
  authors: [
    {
      'family-names': 'Udvare',
      'given-names': 'Andrew',
      email: 'audvare@gmail.com',
      name: 'Andrew Udvare',
    },
  ],
  project_type: 'other',
  github+: {
    funding+: {
      ko_fi: 'tatsh2',
      liberapay: 'tatsh2',
      patreon: 'tatsh2',
    },
  },
  want_codeql: false,
  want_docs: false,
  want_tests: false,
  prettierignore+: [
    '*.vim',
  ],
}
