vapi_sources = files(
  'config.vapi',
)

passwd_gu_i_sources = [
  vapi_sources,
  blueprints,
  resources
] + files(
  'main.vala',
  'application.vala',
  'main-window.vala',
)

passwd_gu_i_vala_args = [
  '--target-glib', '2.76',
  '--vapidir', meson.current_source_dir(),
  '--gresources', resource_files,
  '--gresourcesdir=data/'
]

passwd_gu_i_c_args = [
  '-include', 'config.h',
]

executable(
  'passwd-gui',
  passwd_gu_i_sources,
  include_directories: config_h_dir,
  vala_args: passwd_gu_i_vala_args,
  c_args: passwd_gu_i_c_args,
  dependencies: passwd_gu_i_dependencies,
  install: true,
)
