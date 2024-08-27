desktop_file = i18n.merge_file(
  input: '@0@.desktop.in'.format(app_id),
  output: '@0@.desktop'.format(app_id),
  type: 'desktop',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'applications')
)

desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
  test('Validate desktop file', desktop_utils, args: [desktop_file])
endif

appstream_file = i18n.merge_file(
  input: '@0@.metainfo.xml.in'.format(app_id),
  output: '@0@.metainfo.xml'.format(app_id),
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('datadir'), 'metainfo')
)

appstreamcli = find_program('appstreamcli', required: false)
if appstreamcli.found()
  test('Validate appstream file', appstreamcli, args: ['validate', appstream_file])
endif

blueprints = custom_target('blueprints',
  input: files(
    'ui/main-window.blp',
  ),
  output: '.',
  command: [find_program('blueprint-compiler'), 'batch-compile', '@OUTPUT@', '@CURRENT_SOURCE_DIR@', '@INPUT@'],
)

resource_files = files('@0@.gresource.xml'.format(app_id))
resources = gnome.compile_resources(
  'passwd-gui-resources',
  resource_files,
  dependencies: blueprints,
  c_name: 'passwd_gu_i'
)

subdir('icons')
